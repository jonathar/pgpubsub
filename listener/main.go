package main

import (
	"encoding/json"
	"fmt"
	"github.com/lib/pq"
	"os"
	"time"
)

type item struct {
	Value string `json:"value"`
}

func main() {
	connStr := "postgres://pgpubsub:secret@0.0.0.0:5432/pgpubsub?sslmode=disable"
	channelName := "items.value"

	listener := pq.NewListener(
		connStr,
		10*time.Second, // minReconnectInterval
		time.Minute,    //  maxReconnectInterval
		func(ev pq.ListenerEventType, err error) {
			if err != nil {
				fmt.Printf("Failed to start listener: %s\n", err)
				os.Exit(1)
			}
		},
	)

	err := listener.Listen(channelName)

	if err != nil {
		fmt.Printf("Failed to LISTEN to channel '%s': %s\n", channelName, err)
	}

	fmt.Println("Start processing notifications, waiting for events...")

	sync := time.Duration((10 * time.Second))
	idle := sync / 2

	for {
		waitForNotification(listener, idle)
	}
}

func waitForNotification(l *pq.Listener, timeout time.Duration) {
	select {
	case n := <-l.Notify:
		var t item
		err := json.Unmarshal([]byte(n.Extra), &t)

		if err != nil {
			fmt.Println("Failed to parse '%s': %s", n.Extra, err)
		} else {
			fmt.Printf("Received item.value: %s\n", t.Value)
		}

	case <-time.After(timeout):
		return
	}
}

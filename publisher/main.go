package main

import (
	"database/sql"
	"fmt"
	_ "github.com/lib/pq"
	"time"
)

func main() {
	connStr := "postgres://pgpubsub:secret@0.0.0.0:5432/pgpubsub?sslmode=disable"

	db, err := sql.Open("postgres", connStr)
	if err != nil {
		panic(err)
	}
	defer db.Close()

	q := "INSERT INTO pgpubsub.items (value) VALUES ($1)"
	for i := 0; i >= 0; i++ {
		_, err := db.Exec(q, fmt.Sprintf("This is message #%d", i))

		if err != nil {
			panic(err)
		}
		time.Sleep(2 * time.Second)
	}
}

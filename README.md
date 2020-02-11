# Pub / Sub Using PostgreSQL

This project is a brief demo showing the use of PostgreSQL's [LISTEN](https://www.postgresql.org/docs/12/sql-listen.html) / [NOTIFY](https://www.postgresql.org/docs/12/sql-notify.html) feature to implement Pub / Sub.

## Usage

### Prerequisites

* [make](https://www.gnu.org/software/make/)
* [docker-compose](https://docs.docker.com/compose/)
* [psql](https://www.postgresql.org/docs/12/app-psql.html)
* [go 1.13.5](https://golang.org/)

### Running

#### Start Postgres and build binaries
```
$> make up build
docker-compose build
db uses an image, skipping
docker-compose up -d
Creating network "pgqueue_default" with the default driver
Creating pgqueue_db_1 ... done
PGPASSWORD=secret psql -U pgqueue -d pgqueue -h localhost -q -f sql/up.sql
go build -o build/listener listener/main.go
go build -o build/publisher publisher/main.go
```

#### Start the listener in one terminal

```
$> make run-listener
go build -o build/listener listener/main.go
./build/listener
Start processing notifications, waiting for events...
```

#### Start the publisher in another terminal

```
$> make run-publisher
go build -o build/publisher publisher/main.go
./build/publisher
```

#### You should see in the terminal you rank `make run-listener` the following output

```
Received item.value: This is message #0
Received item.value: This is message #1
Received item.value: This is message #2
...
```

### Shutdown / Cleanup

```
$> make clean down
```

## Acknowledgement & Links

Inspiration taken from [PostgreSQL LISTEN/NOTIFY](https://tapoueh.org/blog/2018/07/postgresql-listen-notify/)

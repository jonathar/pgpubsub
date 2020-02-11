.PHONY: clean build build-listener build-publisher run-listener run-publisher psql pg-up pg-down docker-up docker-down up down

db_pass=secret
db_host=localhost
db_port=5432
db_user=pgpubsub
db_name=pgpubsub
sql_dir=sql


up: docker-up pg-up

down: pg-down docker-down

pg-up:
	PGPASSWORD=$(db_pass) psql -U $(db_user) -d $(db_name) -h $(db_host) -q -f $(sql_dir)/up.sql

docker-up:
	docker-compose build
	docker-compose up -d

docker-down:
	docker-compose down

pg-down:
	PGPASSWORD=$(db_pass) psql -U $(db_user) -d $(db_name) -h $(db_host) -q -f $(sql_dir)/down.sql
psql:
	psql postgres://$(db_user):$(db_pass)@$(db_host):$(db_port)

build: build-listener build-publisher

build-listener:
	go build -o build/listener listener/main.go

build-publisher:
	go build -o build/publisher publisher/main.go

clean:
	rm -rf build

run-listener: build-listener
	./build/listener

run-publisher: build-publisher
	./build/publisher

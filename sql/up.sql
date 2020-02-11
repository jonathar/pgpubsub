CREATE schema IF NOT EXISTS pgpubsub;

CREATE TABLE pgpubsub.items (
        value TEXT NOT NULL DEFAULT ''
);


BEGIN;

CREATE OR REPLACE FUNCTION pgpubsub.tg_notify_items ()
 returns TRIGGER
 language plpgsql
AS $$
declare
  channel text := TG_ARGV[0];
BEGIN
  PERFORM (
     WITH payload(value) AS
     (
       SELECT NEW.value
     )
     SELECT pg_notify(channel, row_to_json(payload)::text)
       FROM payload
  );
  RETURN NULL;
END;
$$;

CREATE TRIGGER notify_subscribers
         AFTER INSERT
            ON pgpubsub.items
      FOR EACH ROW
       EXECUTE PROCEDURE tg_notify_items('items.value');
COMMIT;

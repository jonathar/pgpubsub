DROP TRIGGER IF EXISTS notify_subscribers ON pgpubsub.items;
DROP TABLE IF EXISTS pgpubsub.items;
DROP FUNCTION IF EXISTS pgpubsub.tg_notify_items;
DROP SCHEMA IF EXISTS pgpubsub;

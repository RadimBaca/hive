-- Upgrade MetaStore schema from 2.2.0 to 2.3.0
--RUN '040-HIVE-16399.derby.sql';
CREATE INDEX TC_TXNID_INDEX ON TXN_COMPONENTS (TC_TXNID);

UPDATE "APP".VERSION SET SCHEMA_VERSION='2.3.0', VERSION_COMMENT='Hive release version 2.3.0' where VER_ID=1;

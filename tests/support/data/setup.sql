CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TABLE IF EXISTS acmplus;

CREATE TABLE acmplus (
    uuid uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    date TIMESTAMP WITH TIME ZONE NOT NULL,
    vx double precision,
    vy double precision,
    speed double precision,
    direction double precision,
    water_temp double precision,
    sent BOOLEAN default false,
    num_attempts SMALLINT default 0
);

CREATE OR REPLACE FUNCTION increment_num_attempts()
    RETURNS trigger AS
$BODY$
	BEGIN
		NEW.num_attempts := OLD.num_attempts + 1;
		RETURN NEW;
	END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER acmplus_increment_num_attemps_before_update
	BEFORE UPDATE
	ON acmplus
	FOR EACH ROW
	EXECUTE PROCEDURE increment_num_attempts();
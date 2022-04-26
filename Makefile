# Minimal script to install the SQL creation scripts ready for postinst script.

VERSION=dev

DATA_DIR=${DESTDIR}/usr/share/linz-postgresql-functions
FILES=sql/*.sql

#
# Uncoment these line to support testing via pg_regress
#

PG_CONFIG    = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
PG_REGRESS := $(dir $(PGXS))../../src/test/regress/pg_regress
REGRESS_OPTS = --inputdir=test \
  --load-language=plpgsql \
  --load-extension=postgis
REGRESS      = $(patsubst test/sql/%.sql,%,$(wildcard test/sql/*.sql))

include $(PGXS)

install:
	mkdir -p $(DATA_DIR)
	cp -r $(FILES) $(DATA_DIR)/

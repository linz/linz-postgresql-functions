# Minimal script to install the SQL creation scripts ready for postinst script.

VERSION=dev

datadir=${DESTDIR}/usr/share/linz-postgresql-functions

#
# Uncoment these line to support testing via pg_regress
#

PG_CONFIG    = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
PG_REGRESS := $(dir $(PGXS))../../src/test/regress/pg_regress

dummy:

# Need install to depend on something for debuild

install: dummy
	mkdir -p ${datadir}/sql
	cp  sql/*.sql ${datadir}/sql

uninstall:
	rm -rf ${datadir}

test: dummy
	${PG_REGRESS} \
	--inputdir=./ \
   --inputdir=test \
   --load-language=plpgsql \
   --dbname=regression base

clean:
	rm -f regression.diffs
	rm -f regression.out
	rm -rf results
	


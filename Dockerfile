FROM postgres:10.10

RUN set -ex \
	&& apt-get update && apt-get install -y --no-install-recommends --allow-downgrades \
		build-essential \
        ca-certificates \
        curl \
        libpq-dev \
        postgresql-server-dev-10 \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
	&& cd /usr/local/src/ \
    && curl -sSL -O https://astuteinternet.dl.sourceforge.net/project/pgstatsinfo/pg_statsinfo/10.0/pg_statsinfo-10.0.tar.gz \
    && curl -sSL -O https://raw.githubusercontent.com/takumaw/pg_statsinfo-10.0/master/pg_statsinfo-10.0-patch.diff \
    && tar xvf pg_statsinfo-10.0.tar.gz \
    && rm -rf pg_statsinfo-10.0.tar.gz \
    && cd pg_statsinfo-10.0 \
    && patch -u -p 1 < ../pg_statsinfo-10.0-patch.diff \
    && make USE_PGXS=1 \
    && make USE_PGXS=1 install

RUN set -ex \
    && cd /usr/local/src/ \
    && curl -sSL -O https://github.com/ossc-db/pg_store_plans/archive/1.2.tar.gz \
    && tar xvf 1.2.tar.gz \
    && rm -rf 1.2.tar.gz \
    && cd pg_store_plans-1.2 \
    && make USE_PGXS=1 \
    && make USE_PGXS=1 install

COPY docker-entrypoint-initdb.d/00-create-extension-pg_stat_statements.sql /docker-entrypoint-initdb.d/00-create-extension-pg_stat_statements.sql
COPY docker-entrypoint-initdb.d/01-create-extension-pg_store_plans.sql /docker-entrypoint-initdb.d/01-create-extension-pg_store_plans.sql

CMD ["postgres", "-c", "shared_preload_libraries=pg_statsinfo,pg_stat_statements,pg_store_plans"]

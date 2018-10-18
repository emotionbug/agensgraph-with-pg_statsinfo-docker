FROM postgres:9.6

RUN set -ex \
	&& apt-get update && apt-get install -y --no-install-recommends --allow-downgrades \
		build-essential \
        ca-certificates \
        curl \
        libpq-dev \
        postgresql-server-dev-9.6 \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
	&& cd /usr/local/src/ \
    && curl -O https://astuteinternet.dl.sourceforge.net/project/pgstatsinfo/pg_statsinfo/3.3.0/pg_statsinfo-3.3.0.tar.gz \
    && curl -O https://raw.githubusercontent.com/takumaw/pg_statsinfo-3.3.0/master/pg_statsinfo-3.3.0-patch.diff \
    && tar xvf pg_statsinfo-3.3.0.tar.gz \
    && rm -rf pg_statsinfo-3.3.0.tar.gz \
    && cd pg_statsinfo-3.3.0 \
    && patch -u -p 1 < ../pg_statsinfo-3.3.0-patch.diff \
    && make USE_PGXS=1 \
    && make install

CMD ["postgres", "-c", "shared_preload_libraries=pg_statsinfo"]

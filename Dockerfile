FROM postgres:9.6

RUN set -ex \
	&& apt-get update && apt-get install -y --no-install-recommends --allow-downgrades \
		build-essential \
        ca-certificates \
        curl \
        libpq-dev=9.6.* \
        libpq5=9.6.* \
        postgresql-server-dev-9.6 \
    && apt-mark hold \
        libpq-dev \
        libpq5 \
    && cd /usr/lib/x86_64-linux-gnu/ \
    && ln -s /usr/lib/postgresql/9.6/lib/libpgcommon.a \
    && ln -s /usr/lib/postgresql/9.6/lib/libpgport.a \
	&& rm -rf /var/lib/apt/lists/*

RUN set -ex \
	&& cd /usr/local/src/ \
    && curl -O https://astuteinternet.dl.sourceforge.net/project/pgstatsinfo/pg_statsinfo/3.3.0/pg_statsinfo-3.3.0.tar.gz \
    && tar xvf pg_statsinfo-3.3.0.tar.gz \
    && rm -rf pg_statsinfo-3.3.0.tar.gz \
    && cd pg_statsinfo-3.3.0 \
    && make USE_PGXS=1 \
    && make install

CMD ["postgres", "-c", "shared_preload_libraries=pg_statsinfo"]

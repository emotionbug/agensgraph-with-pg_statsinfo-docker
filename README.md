## Getting started

### Quick start

```shell
$ docker run --name agensgraph -e POSTGRES_PASSWORD=agensgraph -d emotionbug/agensgraph-with-pg_statsinfo:v2.1.3
# Username: postgres
# Password: agensgraph
```



### Advanced

- All environment arguments compatibility with postgresql, so you can read more deeply in the README of postgresql docker.
    - https://hub.docker.com/_/postgres

```shell
$ docker run -d \
    --name agensgraph \
    -e POSTGRES_PASSWORD=agensgraph \
    -e PGDATA=/var/lib/postgresql/data/pgdata \
    -v /custom/mount:/var/lib/postgresql/data \
    emotionbug/agensgraph-with-pg_statsinfo:v2.1.3
```

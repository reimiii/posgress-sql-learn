### postgressql
berhubung pake docker jadi nya `docker exec -it container psql --username=local --password`


buat ngeliat semua table `\l` di console

buat database `create database name_db`

tipe data number : [docs-nya](https://www.postgresql.org/docs/current/datatype-numeric.html)

atau docs untuk: semua [data-type](https://www.postgresql.org/docs/current/datatype.html)

melihat table `\dt` kalo pake query
`select * from pg_tables where schemaname = 'public'`

backup data di postgresql
```bash
docker exec -it db-postgres pg_dump --username=local --dbname=latihan --format=plain --file=/backup.sql --password

# restore
docker exec -it db-postgres psql --username=local --dbname=new_bak -f /backup.sql --password

```
### postgressql
berhubung pake docker jadi nya `docker exec -it container psql --username=local --password`


buat ngeliat semua table `\l` di console

buat database `create database name_db`

tipe data number : [docs-nya](https://www.postgresql.org/docs/current/datatype-numeric.html)

atau docs untuk: semua [data-type](https://www.postgresql.org/docs/current/datatype.html)

melihat table `\dt` kalo pake query
`select * from pg_tables where schemaname = 'public'`
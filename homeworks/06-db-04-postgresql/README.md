# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

## Решение
```bash
ayaz@netology-coursework:~/virt-homeworks/06-db-04-postgresql$ docker pull postgres:13
13: Pulling from library/postgres
461246efe0a7: Pull complete
8d6943e62c54: Pull complete
558c55f04e35: Pull complete
186be55594a7: Pull complete
f38240981157: Pull complete
e0699dc58a92: Pull complete
066f440c89a6: Pull complete
ce20e6e2a202: Pull complete
c9945c466321: Pull complete
8293214c5405: Pull complete
4cc4d9b2983a: Pull complete
d1f88faff4ea: Pull complete
d1121f582683: Pull complete
Digest: sha256:65d34474a7d8a5aa00795bf8a3b94aa7cdd7e8f7914dbeed474676da7734f2b2
Status: Downloaded newer image for postgres:13
docker.io/library/postgres:13
ayaz@netology-coursework:~/virt-homeworks/06-db-04-postgresql$ docker volume create vol_psql
vol_psql
docker run --rm --name psql-docker -e POSTGRES_PASSWORD=postgres -tid -p 5432:5432 -v vol_psql:/var/lib/postgresql/data postgres:13
bd8637697ee43a0111f4a12a9ca60fdc6b5e106cc88061441a25558da8ee49e4
ayaz@netology-coursework:~/virt-homeworks/06-db-04-postgresql$ psql -h 127.0.0.1 -U postgres
Password for user postgres:
psql (12.11 (Ubuntu 12.11-0ubuntu0.20.04.1), server 13.7 (Debian 13.7-1.pgdg110+1))
WARNING: psql major version 12, server major version 13.
         Some psql features might not work.
Type "help" for help.

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)

postgres=# \c postgres
psql (12.11 (Ubuntu 12.11-0ubuntu0.20.04.1), server 13.7 (Debian 13.7-1.pgdg110+1))
WARNING: psql major version 12, server major version 13.
         Some psql features might not work.
You are now connected to database "postgres" as user "postgres".

postgres=# \dtS
                    List of relations
   Schema   |          Name           | Type  |  Owner
------------+-------------------------+-------+----------
 pg_catalog | pg_aggregate            | table | postgres
 pg_catalog | pg_am                   | table | postgres
 pg_catalog | pg_amop                 | table | postgres
 pg_catalog | pg_amproc               | table | postgres
:

postgres=# \d pg_auth_members
           Table "pg_catalog.pg_auth_members"
    Column    |  Type   | Collation | Nullable | Default
--------------+---------+-----------+----------+---------
 roleid       | oid     |           | not null |
 member       | oid     |           | not null |
 grantor      | oid     |           | not null |
 admin_option | boolean |           | not null |
Indexes:
    "pg_auth_members_member_role_index" UNIQUE, btree (member, roleid), tablespace "pg_global"
    "pg_auth_members_role_member_index" UNIQUE, btree (roleid, member), tablespace "pg_global"
Tablespace: "pg_global"

postgres=# \q
ayaz@netology-coursework:~/virt-homeworks/06-db-04-postgresql$
```

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

## Решение
```bash
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
ayaz@netology-coursework:~/virt-homeworks/06-db-04-postgresql$ psql -h localhost -p 5432 -U postgres -f ./test_data/test_dump.sql test_database
Password for user postgres:
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE

postgres=# \c test_database
psql (12.11 (Ubuntu 12.11-0ubuntu0.20.04.1), server 13.7 (Debian 13.7-1.pgdg110+1))
WARNING: psql major version 12, server major version 13.
         Some psql features might not work.
You are now connected to database "test_database" as user "postgres".

test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE

test_database=# select avg_width from pg_stats where tablename='orders';
 avg_width
-----------
         4
        16
         4
(3 rows)

```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

## Решение
Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Да, можно было бы исключить "ручное" разбиение, необходимо было изночально определить тип на момент создания таблицы - partitioned table

```bash
test_database=# create table orders_new (
test_database(#         id integer NOT NULL,
test_database(#         title varchar(80) NOT NULL,
test_database(#         price integer) partition by range(price);
CREATE TABLE
test_database=# create table orders_less partition of orders_new for values from (0) to (499);
CREATE TABLE
test_database=# create table orders_more partition of orders_new for values from (499) to (99999);
CREATE TABLE
test_database=# insert into orders_new (id, title, price) select * from orders;
INSERT 0 8
test_database=# select * from orders_new
test_database-# ;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  2 | My little database   |   500
  6 | WAL never lies       |   900
  7 | Me and my bash-pet   |   499
  8 | Dbiezdmin            |   501
(8 rows)

test_database=# select * from orders_less;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
(4 rows)

test_database=# select * from orders_more;
 id |       title        | price
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  7 | Me and my bash-pet |   499
  8 | Dbiezdmin          |   501
(4 rows)
```

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

## Решение
```bash
root@bd8637697ee4:/# pg_dump -h localhost -p 5432 -U postgres -d test_database > /var/lib/postgresql/data/
```
Для обеспечения уникальности можно добавить индекс, либо UNIQUE свойство переменной.

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

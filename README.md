Задача 1
Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.
Приведите получившуюся команду или docker-compose манифест.

```
docker run -d -e POSTGRES_PASSWORD=pg1234 -v pg-data:/var/lib/postgresql/data -v pg-backup:/var/lib/postgresql/backup --name postgres postgres:12
```


Задача 2

В БД из задачи 1:
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:

- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:

- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

```
root@02d654e38949:/# psql -U postgres
psql (12.9 (Debian 12.9-1.pgdg110+1))
Type "help" for help.

postgres=# create database test_db;
CREATE DATABASE
postgres=# create user "test-admin-user";
CREATE ROLE
postgres=# create user "test-simple-user";
CREATE ROLE
postgres=# \c test_db
You are now connected to database "test_db" as user "postgres".
test_db=# create table orders(
    id int primary key generated always as identity,
    name text not null,
    price int
);
CREATE TABLE
test_db=# create table clients(
    id int primary key generated always as identity,
    name text not null,
    country text not null,
    order_id int references orders(id)
);
CREATE TABLE
test_db=# create index clients_country on clients (country);
CREATE INDEX
test_db=# grant all privileges on orders,clients to "test-admin-user";
grant select,insert,update,delete on orders,clients to "test-simple-user";
GRANT
GRANT
test_db=# \l+
                                                                   List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   |  Size   | Tablespace |                Desc
ription
-----------+----------+----------+------------+------------+-----------------------+---------+------------+--------------------
------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 7969 kB | pg_default | default administrat
ive connection database
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7825 kB | pg_default | unmodifiable empty
database
           |          |          |            |            | postgres=CTc/postgres |         |            |
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7825 kB | pg_default | default template fo
r new databases
           |          |          |            |            | postgres=CTc/postgres |         |            |
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 8097 kB | pg_default |
(4 rows)

test_db=# \l+
                                                                   List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   |  Size   | Tablespace |                Description
-----------+----------+----------+------------+------------+-----------------------+---------+------------+--------------------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 7969 kB | pg_default | default administrative connection database
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7825 kB | pg_default | unmodifiable empty database
           |          |          |            |            | postgres=CTc/postgres |         |            |
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7825 kB | pg_default | default template for new databases
           |          |          |            |            | postgres=CTc/postgres |         |            |
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 8097 kB | pg_default |
(4 rows)

test_db=# \d+ orders
                                             Table "public.orders"
 Column |  Type   | Collation | Nullable |           Default            | Storage  | Stats target | Description
--------+---------+-----------+----------+------------------------------+----------+--------------+-------------
 id     | integer |           | not null | generated always as identity | plain    |              |
 name   | text    |           | not null |                              | extended |              |
 price  | integer |           |          |                              | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)
Access method: heap

test_db=# \d+ clients
                                              Table "public.clients"
  Column  |  Type   | Collation | Nullable |           Default            | Storage  | Stats target | Description
----------+---------+-----------+----------+------------------------------+----------+--------------+-------------
 id       | integer |           | not null | generated always as identity | plain    |              |
 name     | text    |           | not null |                              | extended |              |
 country  | text    |           | not null |                              | extended |              |
 order_id | integer |           |          |                              | plain    |              |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "clients_country" btree (country)
Foreign-key constraints:
    "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)
Access method: heap

test_db=# \z
                                           Access privileges
 Schema |      Name      |   Type   |         Access privileges          | Column privileges | Policies
--------+----------------+----------+------------------------------------+-------------------+----------
 public | clients        | table    | postgres=arwdDxt/postgres         +|                   |
        |                |          | "test-admin-user"=arwdDxt/postgres+|                   |
        |                |          | "test-simple-user"=arwd/postgres   |                   |
 public | clients_id_seq | sequence |                                    |                   |
 public | orders         | table    | postgres=arwdDxt/postgres         +|                   |
        |                |          | "test-admin-user"=arwdDxt/postgres+|                   |
        |                |          | "test-simple-user"=arwd/postgres   |                   |
 public | orders_id_seq  | sequence |                                    |                   |
(4 rows)

test_db=# SELECT grantor, grantee, table_schema, table_name, privilege_type FROM information_schema.table_privileges WHERE grantee = 'test-admin-user';
 grantor  |     grantee     | table_schema | table_name | privilege_type
----------+-----------------+--------------+------------+----------------
 postgres | test-admin-user | public       | orders     | INSERT
 postgres | test-admin-user | public       | orders     | SELECT
 postgres | test-admin-user | public       | orders     | UPDATE
 postgres | test-admin-user | public       | orders     | DELETE
 postgres | test-admin-user | public       | orders     | TRUNCATE
 postgres | test-admin-user | public       | orders     | REFERENCES
 postgres | test-admin-user | public       | orders     | TRIGGER
 postgres | test-admin-user | public       | clients    | INSERT
 postgres | test-admin-user | public       | clients    | SELECT
 postgres | test-admin-user | public       | clients    | UPDATE
 postgres | test-admin-user | public       | clients    | DELETE
 postgres | test-admin-user | public       | clients    | TRUNCATE
 postgres | test-admin-user | public       | clients    | REFERENCES
 postgres | test-admin-user | public       | clients    | TRIGGER
(14 rows)

test_db=# SELECT grantor, grantee, table_schema, table_name, privilege_type FROM information_schema.table_privileges WHERE grantee = 'test-simple-user';
 grantor  |     grantee      | table_schema | table_name | privilege_type
----------+------------------+--------------+------------+----------------
 postgres | test-simple-user | public       | orders     | INSERT
 postgres | test-simple-user | public       | orders     | SELECT
 postgres | test-simple-user | public       | orders     | UPDATE
 postgres | test-simple-user | public       | orders     | DELETE
 postgres | test-simple-user | public       | clients    | INSERT
 postgres | test-simple-user | public       | clients    | SELECT
 postgres | test-simple-user | public       | clients    | UPDATE
 postgres | test-simple-user | public       | clients    | DELETE
(8 rows)

```


Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:
Таблица orders
Наименование	цена
Шоколад	10
Принтер	3000
Книга	500
Монитор	7000
Гитара	4000
Таблица clients
ФИО	Страна проживания
Иванов Иван Иванович	USA
Петров Петр Петрович	Canada
Иоганн Себастьян Бах	Japan
Ронни Джеймс Дио	Russia
Ritchie Blackmore	Russia
Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы
- приведите в ответе:
  -- запросы
  -- результаты их выполнения.

```
test_db=# insert into orders (name,price) values ('Шоколад',10),('Принтер',3000),('Книга',500),('Монитор',7000),('Гитара',4000);
INSERT 0 5
test_db=# insert into clients (name,country) values ('Иванов Иван Иванович','USA'),('Петров Петр Петрович','Canada'),('Иоганн Себастьян Бах','Japan'),('Ронни Джеймс Дио','Russia'),('Ritchie Blackmore','Russia');
INSERT 0 5
test_db=# select count(*) from clients;
 count
-------
     5
(1 row)

test_db=# select count(*) from orders;
 count
-------
     5
(1 row)

```

Задача 4
Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.
Используя foreign keys свяжите записи из таблиц, согласно таблице:
ФИО	Заказ
Иванов Иван Иванович	Книга
Петров Петр Петрович	Монитор
Иоганн Себастьян Бах	Гитара
Приведите SQL-запросы для выполнения данных операций.
Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
Подсказка - используйте директиву UPDATE.

```
test_db=# UPDATE clients SET order_id = 3 WHERE id = 1;
UPDATE 1
test_db=# UPDATE clients SET order_id = 4 WHERE id = 2;
UPDATE 1
test_db=# UPDATE clients SET order_id = 5 WHERE id = 3;
UPDATE 1
test_db=#
```


Задача 5
Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).
Приведите получившийся результат и объясните что значат полученные значения.
```
test_db=# EXPLAIN select * from clients where order_id is not null;
                        QUERY PLAN
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: (order_id IS NOT NULL)
(2 rows)
```




Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.

```
root@02d654e38949:/# cd /var/lib/postgresql/backup
root@02d654e38949:/var/lib/postgresql/backup# pg_dump -U postgres test_db > backup_test_db
root@02d654e38949:/var/lib/postgresql/backup# docker container stop postgres
bash: docker: command not found
root@02d654e38949:/var/lib/postgresql/backup# exit
exit
librenms@librenms:~/rebrain/rebrain-devops-task1$ docker container stop postgres
postgres
librenms@librenms:~/rebrain/rebrain-devops-task1$ docker container rm postgres
postgres
librenms@librenms:~/rebrain/rebrain-devops-task1$ docker volume rm pg-data
pg-data
librenms@librenms:~/rebrain/rebrain-devops-task1$ docker run -d -e POSTGRES_PASSWORD=pg1234 -v pg-data:/var/lib/postgresql/data -v pg-backup:/var/lib/postgresql/backup --name postgres postgres:12
4d53a7582adaafbc52d36ec26a59e31e3dfa45613b609a0d094d19353c1451c3
librenms@librenms:~/rebrain/rebrain-devops-task1$ docker exec -it postgres bash
root@4d53a7582ada:/# su - postgres
postgres@4d53a7582ada:~$ psql
psql (12.9 (Debian 12.9-1.pgdg110+1))
Type "help" for help.
postgres=# create database test_db;
CREATE DATABASE
postgres=#
\q
postgres@4d53a7582ada:~/backup$ psql test_db < backup_test_db
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
ALTER TABLE
CREATE TABLE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5
 setval
--------
      5
(1 row)

 setval
--------
      5
(1 row)

ALTER TABLE
ALTER TABLE
CREATE INDEX
ALTER TABLE
ERROR:  role "test-admin-user" does not exist
ERROR:  role "test-simple-user" does not exist
ERROR:  role "test-admin-user" does not exist
ERROR:  role "test-simple-user" does not exist
```

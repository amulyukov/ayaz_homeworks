# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

## Решение
```bash
ayaz@netology-coursework:~$ docker pull mysql:8
8: Pulling from library/mysql
824b15f81d65: Pull complete
c559dd1913db: Pull complete
e201c19614e6: Pull complete
f4247e8f6125: Pull complete
dc9fefd8cfb5: Pull complete
af3787edd16d: Pull complete
b6bb40f875d3: Pull complete
75f6b647ddb1: Pull complete
a09ca0f0cb24: Pull complete
9e223e3cd2fd: Pull complete
2b038d826c65: Pull complete
d33ac6052fc9: Pull complete
Digest: sha256:a840244706a5fdc3c704b15a3700bfda39fdc069262d7753fa09de2d9faf5f83
Status: Downloaded newer image for mysql:8
docker.io/library/mysql:8
ayaz@netology-coursework:~$ docker volume create mysql_vol
mysql_vol
ayaz@netology-coursework:~$ docker run --rm --name mysql_docker -e MYSQL_ROOT_PASSWORD=mysql -tid -p 3306:3306 -v mysql_vol:/etc/mysql mysql:8
3647439c9553813bbd1e1949d5a7a8ed98309fc71d77b0a5bc05ebef2d0b09ef
ayaz@netology-coursework:~$ sudo -i
[sudo] password for ayaz:
root@netology-coursework:~# cp /home/ayaz/virt-homeworks/06-db-03-mysql/test_data/test_dump.sql /var/lib/docker/volumes/mysql_vol/_data/
ayaz@netology-coursework:~$ docker exec -it mysql_docker bash
root@58e1dace4095:/# mysql -u root -p test_db < /etc/mysql/test_dump.sql
Enter password:
root@58e1dace4095:/# mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.29 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> \s
--------------
mysql  Ver 8.0.29 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          11
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.29 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 9 min 21 sec

Threads: 2  Questions: 42  Slow queries: 0  Opens: 137  Flush tables: 3  Open tables: 55  Queries per second avg: 0.074
--------------

mysql> use test_db
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed

mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)
mysql> select count(*) from orders where price >300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

## Решение
```bash
mysql> create user 'test'@'localhost'
    ->     identified with mysql_native_password by 'test-pass'
    ->     with max_queries_per_hour 100
    ->     password expire interval 180 day
    ->     failed_login_attempts 3
    ->     attribute '{"fname": "James","lname": "Pretty"}';
Query OK, 0 rows affected (0.05 sec)

mysql> grant select on test_db.* to 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.02 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.01 sec)

mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user = 'test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

## Решение
```bash
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> show table status where name = 'orders';
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time         | Check_time | Collation          | Checksum | Create_options | Comment |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| orders | InnoDB |      10 | Dynamic    |    5 |           3276 |       16384 |               0 |            0 |         0 |              6 | 2022-07-01 10:32:09 | 2022-06-30 13:56:07 | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
1 row in set (0.00 sec)

mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.09 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.08 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> show profiles;
+----------+------------+-----------------------------------------+
| Query_ID | Duration   | Query                                   |
+----------+------------+-----------------------------------------+
|       01 | 0.00094250 | show table status where name = 'orders' |
|       02 | 0.09207400 | ALTER TABLE orders ENGINE = MyISAM      |
|       03 | 0.09152650 | ALTER TABLE orders ENGINE = InnoDB      |
+----------+------------+-----------------------------------------+
3 rows in set, 1 warning (0.00 sec)
```

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

## Решения
```bash
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

innodb_flush_log_at_trx_commit = 2
innodb_file_per_table = 1
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 512M
innodb_log_file_size = 100M

# Custom config should go here
!includedir /etc/mysql/conf.d/
```

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

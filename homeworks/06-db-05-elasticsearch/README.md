# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

##Решение

Dockerfile

```
FROM centos:7

RUN yum -y install wget; yum clean all

COPY elasticsearch-8.3.2 /elasticsearch-8.3.2

RUN groupadd elasticsearch && \
        useradd -g elasticsearch elasticsearch 

RUN        mkdir /var/lib/logs && \
           chown elasticsearch:elasticsearch /var/lib/logs/ && \
           mkdir /var/lib/data && \
           chown elasticsearch:elasticsearch /var/lib/data

COPY elasticsearch.yml /elasticsearch-8.3.2/config

RUN chown -R elasticsearch:elasticsearch /elasticsearch-8.3.2/        

USER elasticsearch

EXPOSE 9200

CMD ["/elasticsearch-8.3.2/bin/elasticsearch"]
```

elastcisearch.yml

```
# ======================== Elasticsearch Configuration =========================
#
# NOTE: Elasticsearch comes with reasonable defaults for most settings.
#       Before you set out to tweak and tune the configuration, make sure you
#       understand what are you trying to accomplish and the consequences.
#
# The primary way of configuring a node is via this file. This template lists
# the most important settings you may want to configure for a production cluster.
#
# Please consult the documentation for further information on configuration options:
# https://www.elastic.co/guide/en/elasticsearch/reference/index.html
#
# ---------------------------------- Cluster -----------------------------------
#
# Use a descriptive name for your cluster:
#
cluster.name: netology_test
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
#
#node.name: node-1
#
# Add custom attributes to the node:
#
#node.attr.rack: r1
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
#
path.data: /var/lib/data
#
# Path to log files:
#
path.logs: /var/lib/logs
#Settings REPOSITORY PATH 
#for Image from TAR (est)
path.repo: /elasticsearch-8.3.2/snapshots
#
# ----------------------------------- Memory -----------------------------------
#
# Lock the memory on startup:
#
#bootstrap.memory_lock: true
#
# Make sure that the heap size is set to about half the memory available
# on the system and that the owner of the process is allowed to use this
# limit.
#
# Elasticsearch performs poorly when the system is swapping the memory.
#
# ---------------------------------- Network -----------------------------------
#
# By default Elasticsearch is only accessible on localhost. Set a different
# address here to expose this node on the network:
#
#network.host: 192.168.0.1
#
# By default Elasticsearch listens for HTTP traffic on the first free port it
# finds starting at 9200. Set a specific HTTP port here:
#
#http.port: 9200
#
# For more information, consult the network module documentation.
#
# --------------------------------- Discovery ----------------------------------
#
# Pass an initial list of hosts to perform discovery when this node is started:
# The default list of hosts is ["127.0.0.1", "[::1]"]
#
#discovery.seed_hosts: ["host1", "host2"]
#
# Bootstrap the cluster using an initial set of master-eligible nodes:
#
#cluster.initial_master_nodes: ["node-1", "node-2"]
#
# For more information, consult the discovery and cluster formation module documentation.
#
# --------------------------------- Readiness ----------------------------------
#
# Enable an unauthenticated TCP readiness endpoint on localhost
#
#readiness.port: 9399
#
# ---------------------------------- Various -----------------------------------
#
# Allow wildcard deletion of indices:
#
#action.destructive_requires_name: false
```

Команды для создания образа, пуша и запуска контейнера

```bash
ayaz@netology-coursework:~/06-db-05-elasticsearch$ docker build -t ayazmulyukov/elasticsearch:v8.3.2 .
Sending build context to Docker daemon   1.68GB
Step 1/10 : FROM centos:7
 ---> eeb6ee3f44bd
Step 2/10 : RUN yum -y install wget; yum clean all
 ---> Running in 2d2ad8c458c5
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
 * base: mirror.docker.ru
 * extras: mirror.sale-dedic.com
 * updates: mirror.sale-dedic.com
Resolving Dependencies
--> Running transaction check
---> Package wget.x86_64 0:1.14-18.el7_6.1 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package        Arch             Version                   Repository      Size
================================================================================
Installing:
 wget           x86_64           1.14-18.el7_6.1           base           547 k

Transaction Summary
================================================================================
Install  1 Package

Total download size: 547 k
Installed size: 2.0 M
Downloading packages:
warning: /var/cache/yum/x86_64/7/base/packages/wget-1.14-18.el7_6.1.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for wget-1.14-18.el7_6.1.x86_64.rpm is not installed
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-9.2009.0.el7.centos.x86_64 (@CentOS)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : wget-1.14-18.el7_6.1.x86_64                                  1/1
install-info: No such file or directory for /usr/share/info/wget.info.gz
  Verifying  : wget-1.14-18.el7_6.1.x86_64                                  1/1

Installed:
  wget.x86_64 0:1.14-18.el7_6.1

Complete!
Loaded plugins: fastestmirror, ovl
Cleaning repos: base extras updates
Cleaning up list of fastest mirrors
Removing intermediate container 2d2ad8c458c5
 ---> 636b847d704e
Step 3/10 : COPY elasticsearch-8.3.2 /elasticsearch-8.3.2
 ---> 1384131afcff
Step 4/10 : RUN groupadd elasticsearch &&         useradd -g elasticsearch elasticsearch
 ---> Running in cb45146888d2
Removing intermediate container cb45146888d2
 ---> 43d5c0ac194a
Step 5/10 : RUN        mkdir /var/lib/logs &&            chown elasticsearch:elasticsearch /var/lib/logs/ &&            mkdir /var/lib/data &&            chown elasticsearch:elasticsearch /var/lib/data
 ---> Running in a4e9321a460d
Removing intermediate container a4e9321a460d
 ---> ec65c51fa56c
Step 6/10 : COPY elasticsearch.yml /elasticsearch-8.3.2/config
 ---> 5eb0f45ba520
Step 7/10 : RUN chown -R elasticsearch:elasticsearch /elasticsearch-8.3.2/
 ---> Running in e2889a3934b6
Removing intermediate container e2889a3934b6
 ---> 238bef878845
Step 8/10 : USER elasticsearch
 ---> Running in eab39448ec56
Removing intermediate container eab39448ec56
 ---> 24652db5d64c
Step 9/10 : EXPOSE 9200
 ---> Running in ac96fe2045fa
Removing intermediate container ac96fe2045fa
 ---> 2a049362f126
Step 10/10 : CMD ["/elasticsearch-8.3.2/bin/elasticsearch"]
 ---> Running in 287c89945b24
Removing intermediate container 287c89945b24
 ---> 4a198e580ba2
Successfully built 4a198e580ba2
Successfully tagged ayazmulyukov/elasticsearch:v8.3.2

ayaz@netology-coursework:~/06-db-05-elasticsearch$ docker run --rm -ti --name elast -p 9200:9200 ayazmulyukov/elasticsearch:v8.3.2
[2022-07-25T09:39:10,983][INFO ][o.e.i.g.DatabaseNodeService] [723b6537b674] successfully loaded geoip database file [GeoLite2-Country.mmdb]



-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-> Elasticsearch security features have been automatically configured!
-> Authentication is enabled and cluster connections are encrypted.

->  Password for the elastic user (reset with `bin/elasticsearch-reset-password -u elastic`):
  GmpI3b5c-pohjl*JGF9i

->  HTTP CA certificate SHA-256 fingerprint:
  bc5bc8d76f5781a8791f40fa177cb2f0179fbeb087d6fd0376fa80c296372a0e

->  Configure Kibana to use this cluster:
* Run Kibana and click the configuration link in the terminal when Kibana starts.
* Copy the following enrollment token and paste it into Kibana in your browser (valid for the next 30 minutes):
  eyJ2ZXIiOiI4LjMuMiIsImFkciI6WyIxNzIuMTcuMC4yOjkyMDAiXSwiZmdyIjoiYmM1YmM4ZDc2ZjU3ODFhODc5MWY0MGZhMTc3Y2IyZjAxNzlmYmViMDg3ZDZmZDAzNzZmYTgwYzI5NjM3MmEwZSIsImtleSI6IlF5TzVOSUlCMXF2WElvTUpnS2tvOkYtYUh5NnlyUzYybTVGN0pKQXlOd0EifQ==

->  Configure other nodes to join this cluster:
* On this node:
  - Create an enrollment token with `bin/elasticsearch-create-enrollment-token -s node`.
  - Uncomment the transport.host setting at the end of config/elasticsearch.yml.
  - Restart Elasticsearch.
* On other nodes:
  - Start Elasticsearch with `bin/elasticsearch --enrollment-token <token>`, using the enrollment token that you generated.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
```

Состояние кластера:

```bash
[elasticsearch@4378098846b2 /]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic https://localhost:9200
Enter host password for user 'elastic':
{
  "name" : "4378098846b2",
  "cluster_name" : "netology_test",
  "cluster_uuid" : "tscPaMhsQ_eZu6_VW8F3zg",
  "version" : {
    "number" : "8.3.2",
    "build_type" : "tar",
    "build_hash" : "8b0b1f23fbebecc3c88e4464319dea8989f374fd",
    "build_date" : "2022-07-06T15:15:15.901688194Z",
    "build_snapshot" : false,
    "lucene_version" : "9.2.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

Ссылка на docker hub repo https://hub.docker.com/repository/docker/ayazmulyukov/elasticsearch


## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

##Решение

```bash
[elasticsearch@6ebcdfe2977c /]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic -X PUT https://localhost:9200/ind-1 -H 'Content-Type: application/json' -d '{ "settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 }}}'
Enter host password for user 'elastic':
[elasticsearch@6ebcdfe2977c /]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic -X PUT https://localhost:9200/ind-2 -H 'Content-Type: application/json' -d '{ "settings": { "index": { "number_of_shards": 2, "number_of_replicas": 1 }}}'
Enter host password for user 'elastic':
[elasticsearch@6ebcdfe2977c /]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic -X PUT https://localhost:9200/ind-3 -H 'Content-Type: application/json' -d '{ "settings": { "index": { "number_of_shards": 4, "number_of_replicas": 2 }}}'
Enter host password for user 'elastic':
[elasticsearch@6ebcdfe2977c /]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic https://localhost:9200/_cat/indices?v
Enter host password for user 'elastic':
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 vN0Qu3l6TOSNQeneEmCkSw   1   0          0            0       225b           225b
yellow open   ind-2 -XLzuiZjQayRYQVWDX9mzQ   2   1          0            0       450b           450b
yellow open   ind-3 IE3LFWCDThaC_Qhw_zDwuQ   4   2          0            0       900b           900b
[elasticsearch@6ebcdfe2977c /]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic https://localhost:9200/_cluster/health?pretty
Enter host password for user 'elastic':
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 9,
  "active_shards" : 9,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 47.368421052631575
}
[elasticsearch@6ebcdfe2977c /]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic -X DELETE https://localhost:9200/ind-1
Enter host password for user 'elastic':
{"acknowledged":true}
[elasticsearch@6ebcdfe2977c /]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic -X DELETE https://localhost:9200/ind-2
Enter host password for user 'elastic':
{"acknowledged":true}
[elasticsearch@6ebcdfe2977c /]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic -X DELETE https://localhost:9200/ind-3
Enter host password for user 'elastic':
{"acknowledged":true}
```

Кластер в состоянии yellow, т.к. репликам некуда лететь, нода одна.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

##Решение

В elasticsearch.yml была добавлена директива path.repo: /elasticsearch-8.3.2/snapshots

```bash
[elasticsearch@6ebcdfe2977c elasticsearch-8.3.2]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic -X PUT https://localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d '{ "type": "fs", "settings": { "location": "/elasticsearch-8.3.2/snapshots"}}'
Enter host password for user 'elastic':
{
  "acknowledged" : true
}
[elasticsearch@6ebcdfe2977c elasticsearch-8.3.2]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic -X PUT https://localhost:9200/test?pretty -H 'Content-Type: application/json' -d '{ "settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 }}}'cation/json
Enter host password for user 'elastic':
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
[elasticsearch@6ebcdfe2977c elasticsearch-8.3.2]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic https://localhost:9200/_cat/indices?v
Enter host password for user 'elastic':
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  Ncz746utQFiG-UcfvEypiw   1   0          0            0       225b           225b
[elasticsearch@6ebcdfe2977c elasticsearch-8.3.2]$ curl -X PUT --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic https://localhost:9200/_snapshot/netology_backup/test_backup?wait_for_completion=true
Enter host password for user 'elastic':
{"snapshot":{"snapshot":"test_backup","uuid":"p9UJQP5WTeKsdMihiDsONQ","repository":"netology_backup","version_id":8030299,"version":"8.3.2","indices":["test",".geoip_databases",".security-7"],"data_streams":[],"include_global_state":true,"state":"SUCCESS","start_time":"2022-07-25T13:40:12.529Z","start_time_in_millis":1658756412529,"end_time":"2022-07-25T13:40:14.349Z","end_time_in_millis":1658756414349,"duration_in_millis":1820,"failures":[],"shards":{"total":3,"failed":0,"successful":3},"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]},{"feature_name":"security","indices":[".security-7"]}]}}[elasticsearch@6ebcdfe2977c elasticsearch-8.3.2]$ ll snapshots/
total 36
-rw-r--r-- 1 elasticsearch elasticsearch  1096 Jul 25 13:40 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Jul 25 13:40 index.latest
drwxr-xr-x 5 elasticsearch elasticsearch  4096 Jul 25 13:40 indices
-rw-r--r-- 1 elasticsearch elasticsearch 18523 Jul 25 13:40 meta-p9UJQP5WTeKsdMihiDsONQ.dat
-rw-r--r-- 1 elasticsearch elasticsearch   387 Jul 25 13:40 snap-p9UJQP5WTeKsdMihiDsONQ.dat
[elasticsearch@6ebcdfe2977c elasticsearch-8.3.2]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic -X DELETE https://localhost:9200/test
Enter host password for user 'elastic':
[elasticsearch@6ebcdfe2977c elasticsearch-8.3.2]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic https://localhost:9200/_cat/indices?v
Enter host password for user 'elastic':
health status index uuid pri rep docs.count docs.deleted store.size pri.store.size                                                   
[elasticsearch@6ebcdfe2977c elasticsearch-8.3.2]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic -X PUT https://localhost:9200/test-2 -H 'Content-Type: application/json' -d '{ "settings": { "index": { "number_of_shards": 2, "number_of_replicas": 1 }}}'
Enter host password for user 'elastic':
[elasticsearch@6ebcdfe2977c elasticsearch-8.3.2]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic https://localhost:9200/_cat/indices?v   Enter host password for user 'elastic':
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   test-2 XO5CjNHXRt2KtP14z3cj6w   2   1          0            0       450b           450b
[elasticsearch@6ebcdfe2977c elasticsearch-8.3.2]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic -X POST https://localhost:9200/_snapshot              /netology_backup/test_backup/_restore
Enter host password for user 'elastic':
{"accepted":true}
[elasticsearch@6ebcdfe2977c elasticsearch-8.3.2]$ curl --cacert /elasticsearch-8.3.2/config/certs/http_ca.crt -u elastic https://localhost:9200/_cat/indices?v                 Enter host password for user 'elastic':
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   test-2 XO5CjNHXRt2KtP14z3cj6w   2   1          0            0       450b           450b
green  open   test   -NG5Zs5sR06T8tc_umerLA   1   0          0            0       225b           225b
```
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

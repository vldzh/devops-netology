Задача 1
Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
- Что такое Overlay Network?

```
- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?

В режиме global сервисы запускаются на всех хостаъ. В режиме replication -  только заданное количество экземпляров.

- Какой алгоритм выбора лидера используется в Docker Swarm кластере?

Для выбора лидера в Docker Swarm кластере используется алгоритм для решения задач консенсуса Raft

- Что такое Overlay Network?

Overlay Network - искуственная сеть, которую могут использовать контейнеры в разных хостах swarm-кластера. Запускается "поверх" обычной сети  обычно с использованием технологии vxlan, которая инкапсулирует layer 2 фреймы в layer 4 пакеты (UDP/IP)


```

Задача 2
Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
docker node ls
```
[centos@node01 ~]$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
x8utu5gudrrroh2xinkk5akxw *   node01.netology.yc   Ready     Active         Leader           20.10.10
tr3ee4uymlhfr2ayajx1979t2     node02.netology.yc   Ready     Active         Reachable        20.10.10
31eh0t0pw8qtgvoemzlu5xncj     node03.netology.yc   Ready     Active         Reachable        20.10.10
zlqmav4co43p5zz368a5dk4i4     node04.netology.yc   Ready     Active                          20.10.10
v6hv0v0qw08waiusk50htrd3f     node05.netology.yc   Ready     Active                          20.10.10
h0pdj042vysyutjd111gnkzm5     node06.netology.yc   Ready     Active                          20.10.10
```

Задача 3
Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
docker service ls

```
[centos@node01 ~]$ sudo docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
mv5fc6qupvsg   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
0jr5nrzgfj74   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
avoo37k30ck0   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                         
2hvc4dj1bp1t   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                      
04x3euomeobi   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
qr0jzwmtidsb   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0   
rv6gyuiab3jc   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0       
omqbo52pl4j7   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0                        
```

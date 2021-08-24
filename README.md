

1.На лекции мы познакомились с node_exporter. В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter:

поместите его в автозагрузку,
предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на systemctl cat cron),
удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.
```
vagrant@vagrant:~$ sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz
...
node_exporter-1.2.2.linux-amd64.tar.gz      100%[=========================================================================================>]   8.49M  6.93MB/s    in 1.2s
...
2021-08-24 11:47:28 (6.93 MB/s) - ‘node_exporter-1.2.2.linux-amd64.tar.gz’ saved [8898481/8898481]
vagrant@vagrant:~$ tar xvfz node_exporter-1.2.2.linux-amd64.tar.gz
node_exporter-1.2.2.linux-amd64/
node_exporter-1.2.2.linux-amd64/LICENSE
node_exporter-1.2.2.linux-amd64/NOTICE
node_exporter-1.2.2.linux-amd64/node_exporter
vagrant@vagrant:~$ sudo cp node_exporter-1.2.2.linux-amd64/node_exporter  /usr/sbin
vagrant@vagrant:~$  sudo useradd node_exporter -s /sbin/nologin
vagrant@vagrant:~$  sudo chown node_exporter:node_exporter /usr/sbin/node_exporter
```
Unit-файл для node_exporter:
```
vagrant@vagrant:~$ cat  /etc/systemd/system/node_exporter.servicerter.service
[Unit]
Description=Node exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
EnvironmentFile=-/etc/default/node_exporter
ExecStart=/usr/bin/node_exporter $OPTIONS

[Install]
WantedBy=multi-user.target
```
поместим его в автозагрузку,
systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается
```
vagrant@vagrant:~$ sudo systemctl enable node_exporter.service
Created symlink /etc/systemd/system/multi-user.target.wants/node_exporter.service → /etc/systemd/system/node_exporter.service.
vagrant@vagrant:~$  sudo systemctl start node_exporter.service
vagrant@vagrant:~$ sudo systemctl status node_exporter.service
● node_exporter.service - Node exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2021-08-24 11:56:50 UTC; 5s ago
   Main PID: 1687 (node_exporter)
      Tasks: 5 (limit: 1071)
     Memory: 2.2M
     CGroup: /system.slice/node_exporter.service
             └─1687 /usr/sbin/node_exporter

Aug 24 11:56:50 vagrant node_exporter[1687]: level=info ts=2021-08-24T11:56:50.326Z caller=node_exporter.go:115 collector=thermal_zone
Aug 24 11:56:50 vagrant node_exporter[1687]: level=info ts=2021-08-24T11:56:50.326Z caller=node_exporter.go:115 collector=time
Aug 24 11:56:50 vagrant node_exporter[1687]: level=info ts=2021-08-24T11:56:50.326Z caller=node_exporter.go:115 collector=timex
Aug 24 11:56:50 vagrant node_exporter[1687]: level=info ts=2021-08-24T11:56:50.327Z caller=node_exporter.go:115 collector=udp_queues
Aug 24 11:56:50 vagrant node_exporter[1687]: level=info ts=2021-08-24T11:56:50.327Z caller=node_exporter.go:115 collector=uname
Aug 24 11:56:50 vagrant node_exporter[1687]: level=info ts=2021-08-24T11:56:50.327Z caller=node_exporter.go:115 collector=vmstat
Aug 24 11:56:50 vagrant node_exporter[1687]: level=info ts=2021-08-24T11:56:50.327Z caller=node_exporter.go:115 collector=xfs
Aug 24 11:56:50 vagrant node_exporter[1687]: level=info ts=2021-08-24T11:56:50.327Z caller=node_exporter.go:115 collector=zfs
Aug 24 11:56:50 vagrant node_exporter[1687]: level=info ts=2021-08-24T11:56:50.327Z caller=node_exporter.go:199 msg="Listening on" address=:9100
Aug 24 11:56:50 vagrant node_exporter[1687]: level=info ts=2021-08-24T11:56:50.328Z caller=tls_config.go:191 msg="TLS is disabled." http2=false
vagrant@vagrant:~$ sudo systemctl stop node_exporter.service
vagrant@vagrant:~$ sudo systemctl status node_exporter.service
● node_exporter.service - Node exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: inactive (dead) since Tue 2021-08-24 11:58:08 UTC; 1s ago
    Process: 1687 ExecStart=/usr/sbin/node_exporter $OPTIONS (code=killed, signal=TERM)
   Main PID: 1687 (code=killed, signal=TERM)

Aug 24 11:56:50 vagrant node_exporter[1687]: level=info ts=2021-08-24T11:56:50.327Z caller=node_exporter.go:115 collector=udp_queues
Aug 24 11:56:50 vagrant node_exporter[1687]: level=info ts=2021-08-24T11:56:50.327Z caller=node_exporter.go:115 collector=uname
Aug 24 11:56:50 vagrant node_exporter[1687]: level=info ts=2021-08-24T11:56:50.327Z caller=node_exporter.go:115 collector=vmstat
Aug 24 11:56:50 vagrant node_exporter[1687]: level=info ts=2021-08-24T11:56:50.327Z caller=node_exporter.go:115 collector=xfs
Aug 24 11:56:50 vagrant node_exporter[1687]: level=info ts=2021-08-24T11:56:50.327Z caller=node_exporter.go:115 collector=zfs
Aug 24 11:56:50 vagrant node_exporter[1687]: level=info ts=2021-08-24T11:56:50.327Z caller=node_exporter.go:199 msg="Listening on" address=:9100
Aug 24 11:56:50 vagrant node_exporter[1687]: level=info ts=2021-08-24T11:56:50.328Z caller=tls_config.go:191 msg="TLS is disabled." http2=false
Aug 24 11:58:08 vagrant systemd[1]: Stopping Node exporter...
Aug 24 11:58:08 vagrant systemd[1]: node_exporter.service: Succeeded.
Aug 24 11:58:08 vagrant systemd[1]: Stopped Node exporter.
vagrant@vagrant:~$ sudo systemctl start node_exporter.service
vagrant@vagrant:~$ sudo systemctl status node_exporter.service
● node_exporter.service - Node exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2021-08-24 11:58:15 UTC; 1s ago
   Main PID: 1726 (node_exporter)
      Tasks: 4 (limit: 1071)
     Memory: 2.4M
     CGroup: /system.slice/node_exporter.service
             └─1726 /usr/sbin/node_exporter

Aug 24 11:58:15 vagrant node_exporter[1726]: level=info ts=2021-08-24T11:58:15.713Z caller=node_exporter.go:115 collector=thermal_zone
Aug 24 11:58:15 vagrant node_exporter[1726]: level=info ts=2021-08-24T11:58:15.713Z caller=node_exporter.go:115 collector=time
Aug 24 11:58:15 vagrant node_exporter[1726]: level=info ts=2021-08-24T11:58:15.713Z caller=node_exporter.go:115 collector=timex
Aug 24 11:58:15 vagrant node_exporter[1726]: level=info ts=2021-08-24T11:58:15.713Z caller=node_exporter.go:115 collector=udp_queues
Aug 24 11:58:15 vagrant node_exporter[1726]: level=info ts=2021-08-24T11:58:15.713Z caller=node_exporter.go:115 collector=uname
Aug 24 11:58:15 vagrant node_exporter[1726]: level=info ts=2021-08-24T11:58:15.713Z caller=node_exporter.go:115 collector=vmstat
Aug 24 11:58:15 vagrant node_exporter[1726]: level=info ts=2021-08-24T11:58:15.713Z caller=node_exporter.go:115 collector=xfs
Aug 24 11:58:15 vagrant node_exporter[1726]: level=info ts=2021-08-24T11:58:15.713Z caller=node_exporter.go:115 collector=zfs
Aug 24 11:58:15 vagrant node_exporter[1726]: level=info ts=2021-08-24T11:58:15.714Z caller=node_exporter.go:199 msg="Listening on" address=:9100
Aug 24 11:58:15 vagrant node_exporter[1726]: level=info ts=2021-08-24T11:58:15.714Z caller=tls_config.go:191 msg="TLS is disabled." http2=false

```

2. Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
```
rate(node_cpu_seconds_total{mode="system"}[1m])	The average amount of CPU time spent in system mode, per second, over the last minute (in seconds)
go_memstats_alloc_bytes Number of bytes allocated and still in use.
node_filesystem_avail_bytes			The filesystem space available to non-root users (in bytes)
rate(node_network_receive_bytes_total[1m])	The average network traffic received, per second, over the last minute (in bytes)
```


3.Установите в свою виртуальную машину Netdata. Воспользуйтесь готовыми пакетами для установки (sudo apt install -y netdata). После успешной установки:

в конфигурационном файле /etc/netdata/netdata.conf в секции [web] замените значение с localhost на bind to = 0.0.0.0,
добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте vagrant reload:
config.vm.network "forwarded_port", guest: 19999, host: 19999
После успешной перезагрузки в браузере на своем ПК (не в виртуальной машине) вы должны суметь зайти на localhost:19999. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.
```
[global]
        run as user = netdata
        web files owner = root
        web files group = root
        # Netdata is not designed to be exposed to potentially hostile
        # networks. See https://github.com/netdata/netdata/issues/164
        bind socket to IP = 0.0.0.0

дешборд с етриками заработал на localhost:19999

```

4. Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
```
Можно, например,
Vmware VSphere:
root@ovpn1:~# dmesg  | grep Virtual
[    0.000000] DMI: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/03/2018
root@ovpn1:~# dmesg  | grep Hyper
[    0.000000] Hypervisor detected: VMware

Oracle VirtualBox:
[    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[    0.000000] Hypervisor detected: KVM
```

5. Как настроен sysctl fs.nr_open на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (ulimit --help)?
```
root@ovpn1:~# sysctl fs.nr_open
fs.nr_open = 1048576

fs.nr_open

This denotes the maximum number of file-handles a process can
allocate. Default value is 1024*1024 (1048576) which should be
enough for most machines. Actual limit depends on RLIMIT_NOFILE
resource limit.


root@ovpn1:~# ulimit -n
1024
```

6. Запустите любой долгоживущий процесс (не ls, который отработает мгновенно, а, например, sleep 1h) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через nsenter. Для простоты работайте в данном задании под root (sudo -i). Под обычным пользователем требуются дополнительные опции (--map-root-user) и т.д.
```
root@ovpn1:~# ps -a | grep sleep
28268 pts/1    00:00:00 sleep
root@ovpn1:~# nsenter --target 28268 --pid --mount
root@ovpn1:/# ps -aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0   6288   832 pts/1    S+   21:17   0:00 sleep 1h
root         2  0.1  0.5  21508  5076 pts/3    S    21:22   0:00 -bash
root        17  0.0  0.3  38456  3576 pts/3    R+   21:22   0:00 ps -aux
```



7. Найдите информацию о том, что такое :(){ :|:& };:. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (это важно, поведение в других ОС не проверялось). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов dmesg расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?
```
:(){ :|:& };: определяет функцию под названием":", которая вызывает себя дважды при каждом вызове и не имеет возможности завершить себя.
Это fork-бомба — вредоносная или ошибочно написанная программа, бесконечно создающая свои копии (системным вызовом fork()), которые обычно также начинают создавать свои копии и т. д. Выполнение такой программы может вызывать большую нагрузку вычислительной системы или даже отказ в обслуживании вследствие нехватки системных ресурсов

dmesg
[57976.496440] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-3.scope

настройка механизма стабилизации производится в файле /usr/lib/systemd/system/user-.slice.d/10-defaults.conf,
например, ожно поменять 
TasksMax=33%
на 
TasksMax=infinity
```

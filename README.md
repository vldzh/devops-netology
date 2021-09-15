

1.Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
```
Windows:
ipconfig /all

Linux:
ifconfig -a
ip link show

```
2.Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
```
 CDP, LLDP
 lldpd — LLDP daemon .  lldpcli, lldpctl — control LLDP daemon
 
 lldpcli:
       show neighbors [ports ethX [,...]] [details | summary] [hidden]

             Display information about each neighbor known by lldpd(8) daemon. With summary, only
             a the name and the port description of each remote host will be displayed. On the
             other hand, with details, all available information will be displayed, giving a
             verbose view. When using hidden, also display remote ports hidden by the smart
             filter. When specifying one or several ports, the information displayed is limited
             to the given list of ports. 
```
3.Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.
```
пакет vlan
модуль 8021q 

vconfig add eth0 200 - создает логический интерфейс "eth0.200", привязанный к физическому интерфейсу "eth0", который будет обрабатывать пакеты с тегом 200.


/etc/sysconfig/network-scripts/ifcfg-enp1s0.192 
DEVICE=enp1s0.192
BOOTPROTO=none
ONBOOT=yes
IPADDR=192.168.1.1
PREFIX=24
NETWORK=192.168.1.0
VLAN=yes

/etc/network/interfaces
#Interface eth0 - untagged 
auto eth0
iface eth0 inet static
      address 192.168.10.10
      netmask 255.255.255.0
      gateway 192.168.10.1
      dns-nameservers 8.8.8.8
#Interface eth0.200 - tagged vlan 200
auto eth0.200
iface eth0.200 inet static
      address 192.168.8.10
      netmask 255.255.255.0

```
4.Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
```
Linux NIC Bonding имеет 7 режимов работы : 
Mode of operation; 0 for balance-rr, 1 for active-backup, 2 for balance-xor, 3 for broadcast, 4 for 802.3ad, 5 for balance-tlb, 6 for balance-alb (charp)
1. mode=0, mode=2, and mode=3 теоретически требует статической агрегации.
2. mode=4 нужно поддерживать 802.3ad.
3. mode=1, mode=5, and mode=6 не требуют никаких настроек на коммутаторе.
Балансировку поддерживают:
mode=0(balance-rr)
mode=2 (balance-xor) 
mode=4 (802.3ad)
mode=5 (balance-tlb)
mode=6 (balance-alb)

Больше всего опций балансировки  у  802.3ad:  

layer2
Канал для отправки пакета однозначно определяется комбинацией MAC-адресов источника и назначения по следующей формуле:
(source_MAC XOR destination_MAC) modulo slave_count

layer2+3
Канал для отправки пакета определяется по совокупности MAC- и IP-адресов источника и назначения по следующей формуле:
(((source_IP XOR dest_IP) AND 0xffff) XOR (source_MAC XOR destination_MAC)) modulo slave_count

layer3+4
Канал для отправки пакета определяется по совокупности IP-адресов и номеров портов источника и назначения:
((source_port XOR dest_port) XOR ((source_IP XOR dest_IP) AND 0xffff) modulo slave_count
Благодаря этому трафик определённого узла может распределяться между несколькими каналами, хотя пакеты одного и того же TCP-соединения или UDP-потока всегда передаются по одному и тому же каналу.





пример конфига
auto bond0
iface bond0 inet static
    address 10.10.10.10
    netmask 255.255.255.0
    slaves  eth0  eth1
    bond_mode balance-tlb
```
5.Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
```
IP-адресов в сети будет 2^(32 - 29)=8, из которых для хостов можно использовать 6.
подсетей - 2^(29-24) или просто 256/8 = 32 . 
примеры:  10.10.10.16/29  ,  10.10.10.128/29 ,  10.10.10.160/29

```
6.Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.
```
Частные IP-адреса допустимо взять из 100.64.0.0/10 . 
2^5< 40-50 < 2^6 , поэтому выберем маску с 6 конечными нулями в маске , представленной в двочном виде 11111111.11111111.11111111.11000000 =  255.255.255.192

```
7.Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
Как проверить ARP таблицу в Linux, Windows? 
```
Windows
arp -a
Linux
arp -n
```
Как очистить ARP кеш полностью?
```
Windows:
netsh interface IP delete arpcache
Linux:
ip –s –s neigh flush all
```
Как из ARP таблицы удалить только один нужный IP?
```
Windows:
arp  -d inet_addr [if_addr]
Linux:
arp  -d inet_addr
```

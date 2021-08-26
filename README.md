

1. Узнайте о sparse (разряженных) файлах.
```
Разреженные – это специальные файлы, которые с большей эффективностью используют файловую систему, они не позволяют ФС занимать свободное дисковое пространство носителя, когда разделы не заполнены. То есть, «пустое место» будет задействовано только при необходимости. Пустая информация в виде нулей, будет хранится в блоке метаданных ФС. Поэтому, разреженные файлы изначально занимают меньший объем носителя, чем их реальный объем.

Самым большим преимуществом разреженных файлов является то, что пользователь может создавать файлы большого размера, которые занимают очень мало места для хранения. Пространство для хранения выделяется автоматически по мере записи на него данных. Разреженные файлы большого объема создаются за относительно короткое время, поскольку файловой системе не требуется предварительно выделять дисковое пространство для записи нулей.

Преимущества ограничены лишь приложениями, которые их поддерживают. Если у программы нет возможности распознавать или использовать их, то она сохранит их в исходном – несжатом состоянии, что не даст никаких преимуществ. Также с ними нужно быть осторожными, поскольку разреженный файл размером всего несколько мегабайт может внезапно увеличиться до нескольких гигабайт, когда неподдерживающие приложения скопируют его в место назначения.
```
2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
```
Нет, не могут. Это связанно с тем что прав данных находятся в метаданных исходного файла  идентичны для файлов, являющиxся жесткой ссылкой на один объект.
```
3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:
```
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.provider :virtualbox do |vb|
    lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
    lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
    vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
    vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
  end
end
Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.
```
```
c:\vagrant>vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Destroying VM and associated drives...

c:\vagrant>vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'bento/ubuntu-20.04'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'bento/ubuntu-20.04' version '202107.28.0' is up to date...
==> default: Setting the name of the VM: vagrant_default_1629880597481_60349
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
Timed out while waiting for the machine to boot. This means that
Vagrant was unable to communicate with the guest machine within
the configured ("config.vm.boot_timeout" value) time period.

If you look above, you should be able to see the error(s) that
Vagrant had when attempting to connect to the machine. These errors
are usually good hints as to what may be wrong.

If you're using a custom box, make sure that networking is properly
working and you're able to connect to the machine. It is a common
problem that networking isn't setup properly in these boxes.
Verify that authentication configurations are also setup properly,
as well.

If the box appears to be booting properly, you may want to increase
the timeout ("config.vm.boot_timeout") value.


c:\vagrant>vagrant ssh
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

 System information disabled due to load higher than 2.0


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
vagrant@vagrant:~$
```

4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
```
vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk
sdc                    8:32   0  2.5G  0 disk
vagrant@vagrant:~$ sudo fdisk /dev/sdb

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x3e726396.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-5242879, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G

Created a new partition 1 of type 'Linux' and of size 2 GiB.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2):
First sector (4196352-5242879, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):

Created a new partition 2 of type 'Linux' and of size 511 MiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
└─sdb2                 8:18   0  511M  0 part
sdc                    8:32   0  2.5G  0 disk
```
5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.
```
vagrant@vagrant:~$ sudo sfdisk -d /dev/sdb > dump_part
vagrant@vagrant:~$ sudo sfdisk /dev/sdc < dump_part
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x3e726396.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x3e726396

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
└─sdb2                 8:18   0  511M  0 part
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
└─sdc2                 8:34   0  511M  0 part
```

6. Соберите mdadm RAID1 на паре разделов 2 Гб.
```
vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md1 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
vagrant@vagrant:~$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md1 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]

unused devices: <none>
```

7. Соберите mdadm RAID0 на второй паре маленьких разделов.
```
vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md2 --level=0 --raid-dev
ices=2 /dev/sdb2 /dev/sdc2
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md2 started.
vagrant@vagrant:~$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md2 : active raid0 sdc2[1] sdb2[0]
      1042432 blocks super 1.2 512k chunks

md1 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]

unused devices: <none>
```

8. Создайте 2 независимых PV на получившихся md-устройствах.
```
vagrant@vagrant:~$ sudo pvcreate /dev/md1
  Physical volume "/dev/md1" successfully created.
vagrant@vagrant:~$ sudo pvcreate /dev/md2
  Physical volume "/dev/md2" successfully created.
vagrant@vagrant:~$ sudo pvdisplay
  --- Physical volume ---
.........

  "/dev/md1" is a new physical volume of "<2.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/md1
  VG Name
  PV Size               <2.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               D9rX01-CpgM-NXHF-rHXl-GFjt-ctuH-BRdBMW

  "/dev/md2" is a new physical volume of "1018.00 MiB"
  --- NEW Physical volume ---
  PV Name               /dev/md2
  VG Name
  PV Size               1018.00 MiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               w3ekgf-9k2d-u591-2rbX-rhco-6ktv-KIrkj8

```

9. Создайте общую volume-group на этих двух PV.
```
vagrant@vagrant:~$ sudo vgcreate vg00 /dev/md1 /dev/md2
  Volume group "vg00" successfully created
vagrant@vagrant:~$ sudo vgdisplay
........
  --- Volume group ---
  VG Name               vg00
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               <2.99 GiB
  PE Size               4.00 MiB
  Total PE              765
  Alloc PE / Size       0 / 0
  Free  PE / Size       765 / <2.99 GiB
  VG UUID               AsNmBu-WkZ9-c75Y-QnUE-ldra-shGv-UztPm8
```

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
```
vagrant@vagrant:~$ sudo lvcreate --size 100M -n lv01 vg00 /dev/md2
  Logical volume "lv01" created.
vagrant@vagrant:~$ sudo lvdisplay
  --- Logical volume ---
.............

  --- Logical volume ---
  LV Path                /dev/vg00/lv01
  LV Name                lv01
  VG Name                vg00
  LV UUID                4TZMOv-uegE-WYWn-o0yx-2IXP-8NoN-S9xT3S
  LV Write Access        read/write
  LV Creation host, time vagrant, 2021-08-26 21:29:28 +0000
  LV Status              available
  # open                 0
  LV Size                100.00 MiB
  Current LE             25
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     4096
  Block device           253:2

```

11. Создайте mkfs.ext4 ФС на получившемся LV.
```
vagrant@vagrant:~$ sudo mkfs.ext4 /dev/vg00/lv01
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```

12.Смонтируйте этот раздел в любую директорию, например, /tmp/new.
```
vagrant@vagrant:~$ sudo mount /dev/vg00/lv01 /tmp/new
vagrant@vagrant:~$ mount
............
/dev/mapper/vg00-lv01 on /tmp/new type ext4 (rw,relatime,stripe=256)
vagrant@vagrant:~$  df -h
Filesystem                  Size  Used Avail Use% Mounted on
..............
/dev/mapper/vg00-lv01        93M   72K   86M   1% /tmp/new
```

13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.
```
vagrant@vagrant:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2021-08-26 21:36:10--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 20946369 (20M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz                  100%[==========================================================>]  19.98M  17.2MB/s    in 1.2s

2021-08-26 21:36:11 (17.2 MB/s) - ‘/tmp/new/test.gz’ saved [20946369/20946369]
```

14. Прикрепите вывод lsblk.
```
vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md1                9:1    0    2G  0 raid1
└─sdb2                 8:18   0  511M  0 part
  └─md2                9:2    0 1018M  0 raid0
    └─vg00-lv01      253:2    0  100M  0 lvm   /tmp/new
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md1                9:1    0    2G  0 raid1
└─sdc2                 8:34   0  511M  0 part
  └─md2                9:2    0 1018M  0 raid0
    └─vg00-lv01      253:2    0  100M  0 lvm   /tmp/new
```

15. Протестируйте целостность файла:
```
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```
```
vagrant@vagrant:~$ gzip -t /tmp/new/test.gz
vagrant@vagrant:~$ echo $?
0
```

16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
```
vagrant@vagrant:~$ sudo pvmove /dev/md2 /dev/md1
  /dev/md2: Moved: 68.00%
  /dev/md2: Moved: 100.00%
vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md1                9:1    0    2G  0 raid1
│   └─vg00-lv01      253:2    0  100M  0 lvm   /tmp/new
└─sdb2                 8:18   0  511M  0 part
  └─md2                9:2    0 1018M  0 raid0
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md1                9:1    0    2G  0 raid1
│   └─vg00-lv01      253:2    0  100M  0 lvm   /tmp/new
└─sdc2                 8:34   0  511M  0 part
  └─md2                9:2    0 1018M  0 raid0
```

17. Сделайте --fail на устройство в вашем RAID1 md.
```
vagrant@vagrant:~$ sudo mdadm /dev/md1 --fail /dev/sdb1
```

18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.
```
[28927.767966] md/raid1:md1: Disk failure on sdb1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.
```

19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:
```
root@vagrant:~# gzip -t /tmp/new/test.gz
r
oot@vagrant:~# echo $?
0
```
```
vagrant@vagrant:~$ gzip -t /tmp/new/test.gz
vagrant@vagrant:~$ echo $?
```
20. Погасите тестовый хост, vagrant destroy.
```
vagrant destroy
```

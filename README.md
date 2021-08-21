

1. Какой системный вызов делает команда cd? В прошлом ДЗ мы выяснили, что cd не является самостоятельной программой, это shell builtin, поэтому запустить strace непосредственно на cd не получится. Тем не менее, вы можете запустить strace на /bin/bash -c 'cd /tmp'. В этом случае вы увидите полный список системных вызовов, которые делает сам bash при старте. Вам нужно найти тот единственный, который относится именно к cd.
```
chdir("/tmp")

root@ovpn1:~# strace /bin/bash -c 'cd /tmp' 
...
chdir("/tmp")
...
```
2. Попробуйте использовать команду file на объекты разных типов на файловой системе. Например:
vagrant@netology1:~$ file /dev/tty
/dev/tty: character special (5/0)
vagrant@netology1:~$ file /dev/sda
/dev/sda: block special (8/0)
vagrant@netology1:~$ file /bin/bash
/bin/bash: ELF 64-bit LSB shared object, x86-64
Используя strace выясните, где находится база данных file на основании которой она делает свои догадки.
```
база данных file  /usr/lib/file/magic.mgc

root@ovpn1:~# strace file /dev/sda
...
stat("/etc/magic", {st_mode=S_IFREG|0644, st_size=111, ...}) = 0
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
...
...
root@ovpn1:~#  ls -la  /usr/share/misc/ | grep magic.mgc
lrwxrwxrwx   1 root root      24 May 12  2020 magic.mgc -> ../../lib/file/magic.mgc
...
```

3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).
```
-Найти процесс, уторый пишет в файл
$lsof | egrep "deleted|COMMAND"
COMMAND       PID    TID TASKCMD     USER   FD  TYPE  DEVICE    SIZE/OFF      NODE NAME
ora         25575   8194 oracle    oracle   33   REG   65,65  4294983680  31014933 /oradata/DATAPRE/file.dbf (deleted)

-Очистить содержимое удаленного файла через файловый дескриптор

$ file /proc/25575/fd/33
/proc/25575/fd/33: broken symbolic link to `/oradata/DATAPRE/file.dbf (deleted)'
$ echo > /proc/25575/fd/33

```

4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
```
Процессы зомби (также показанные как <defunct>), вообще не являются реальными процессами. Это просто записи в таблице процессов ядра. Это единственный ресурс, который они потребляют. Они не потребляют ни CPU, ни RAM. Единственная опасность наличия зомби - это нехватка места в таблице процессов (можно использовать, cat /proc/sys/kernel/threads-max, чтобы узнать, сколько записей разрешено в вашей системе).
```

5. В iovisor BCC есть утилита opensnoop:
root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
/usr/sbin/opensnoop-bpfcc
На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты? Воспользуйтесь пакетом bpfcc-tools для Ubuntu 20.04. Дополнительные сведения по установке.
```
vagrant@vagrant:~$ strace  -e openat opensnoop-bpfcc > out.txt 2>&1
vagrant@vagrant:~$ more out.txt
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libutil.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libm.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libexpat.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
openat(AT_FDCWD, "/usr/bin/pyvenv.cfg", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/pyvenv.cfg", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/localtime", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/python3.8", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
openat(AT_FDCWD, "/usr/lib/python3.8/encodings/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/codecs.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/python3.8/encodings", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
openat(AT_FDCWD, "/usr/lib/python3.8/encodings/__pycache__/aliases.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/python3.8/encodings/__pycache__/utf_8.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/python3.8/encodings/__pycache__/latin_1.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/io.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/abc.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/site.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/os.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/stat.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/_collections_abc.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/posixpath.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/genericpath.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/_sitebuiltins.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
```

6. Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.
```
uname({sysname="Linux", nodename="ovpn1", ...}) = 0
uname({sysname="Linux", nodename="ovpn1", ...}) = 0
write(1, "Linux ovpn1 4.15.0-112-generic #"..., 106Linux ovpn1 4.15.0-112-generic #113-Ubuntu SMP Thu Jul 9 23:41:39 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux

root@ovpn1:~# man uname  | grep /proc
root@ovpn1:~# man 2  uname  | grep /proc
       Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease,  version,  domain
```

7. Чем отличается последовательность команд через ; и через && в bash? Например:
root@netology1:~# test -d /tmp/some_dir; echo Hi
Hi
root@netology1:~# test -d /tmp/some_dir && echo Hi
root@netology1:~#
Есть ли смысл использовать в bash &&, если применить set -e?
```
command1 && command2
Команда2 выполняется тогда и только тогда, когда command1 возвращается нулевое состояние выхода ( true ). Другими словами, запустите command1 и, если это успешно, то запустите command 2.

command1 ; command2
Обе команды command1 и command2 будут выполняться независимо. Точка с запятой позволяет вводить много команд в одной строке.

set -e(errexit) означени прекращение выполнения ВСЕХ дальнейших команд и немедленный выход со скрипта, если текущая команда выполнилась с кодом выхода отличным от нуля. 
```

8. Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?
```
set -e
Указав параметр -e скрипт немедленно завершит работу, если любая команда выйдет с ошибкой. По-умолчанию, игнорируются любые неудачи и сценарий продолжет выполнятся.


set -o pipefail
Но -e не идеален. Bash возвращает только код ошибки последней команды в пайпе (конвейере). И параметр -e проверяет только его. Если нужно убедиться, что все команды в пайпах завершились успешно, нужно использовать -o pipefail.

set -u
Наверно самый полезный параметр - -u. Благодаря ему оболочка проверяет инициализацию переменных в скрипте. Если переменной не будет, скрипт немедленно завершиться. 

set -x
Параметр -x очень полезен при отладке. С помощью него bash печатает в стандартный вывод все команды перед их исполнением. Стоит учитывать, что все переменные будут уже доставлены, и с этим нужно быть аккуратнее, к примеру если используете пароли.
```

9. Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе. В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
```
root@ovpn1:~# ps -ax -o stat | sort | uniq -c | sort -rn
     68 I<
     59 S
     18 Ss
     10 Ssl
      6 I
      5 S+
      2 SN
      1 STAT
      1 S<sl
      1 S<s
      1 R+

R - Процесс выполняется в данный момент
S - Процесс ожидает выполнение (спит)
D - Процесс в полной (непрерываемой) спячке, например, ожидает ввода/вывода
Z - zombie или defunct процесс, т.е. процесс у которого нет родителя.
T - Процесс остановлен.
W - процесс в свопе
< - процесс в приоритетном режиме.
N - процесс в режиме низкого приоритета
L - real-time процесс, имеются страницы заблокированные в памяти.
```

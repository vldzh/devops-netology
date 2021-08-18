

1. Какого типа команда cd? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.

```
Встроенная в shell
Проверяем, где может находиться исполняемый файл (нигде):
root@ovpn1:/# whereis cd
cd:
узнаем тип команды:
root@ovpn1:/# type cd
cd is a shell builtin
```

2. Какая альтернатива без pipe команде grep <some_string> <some_file> | wc -l? man grep поможет в ответе на этот вопрос. Ознакомьтесь с документом о других подобных некорректных вариантах использования pipe.
```
grep <some_string> <some_file> -c

root@ovpn1:/# grep --help
Usage: grep [OPTION]... PATTERN [FILE]...
...
  -c, --count               print only a count of selected lines per FILE
...
```

3. Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?
```
systemd 

кoot@ovpn1:/# ps -p 1
  PID TTY          TIME CMD
    1 ?        00:04:29 systemd

```

4. Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?
```
ls 2> /dev/pts/x

```
5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.
```
Получится. Например sort < file1 > file1.sorted

root@ovpn1:~# sort < .profile > profile.txt
root@ovpn1:~# cat  profile.txt


    . ~/.bashrc
  fi
  if [ -f ~/.bashrc ]; then
# ~/.profile: executed by Bourne-compatible login shells.
fi
if [ "$BASH" ]; then
mesg n || true
```
6. Получится ли вывести находясь в графическом режиме данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?
```
Получится. 
если сделать из ssh-сессии: echo test > /dev/tty3
можно наблюдать выводимые данные в Ctrl-Alt-F3.
```
7. Выполните команду bash 5>&1. К чему она приведет? Что будет, если вы выполните echo netology > /proc/$$/fd/5? Почему так происходит?
```
bash 5>&1 Создаётся файловый дескриптор 5, перенаправляет его в stdout. 
echo netology > /proc/$$/fd/5 - выводится netology, т.к дескриптор перенаправляется в stdout.

root@ovpn1:~# bash 5>&1
root@ovpn1:~# echo netology > /proc/$$/fd/5
netology


```
8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от | на stdin команды справа. Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.
```
Получится.

root@ovpn1:~# cat test 5>&2 2>&1 1>&5
cat: test: No such file or directory

```
9. Что выведет команда  Как еще можно получить аналогичный по содержанию вывод?
```
Выведет начальные переменные окружения для текущего процесса (bash).
root@ovpn1:~# cat /proc/$$/environ
LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:LESSCLOSE=/usr/bin/lesspipe %s %sLANG=C.UTF-8SUDO_GID=1000USERNAME=rootSUDO_COMMAND=/bin/bashUSER=rootPWD=/rootHOME=/rootSUDO_USER=ovpnuserXDG_DATA_DIRS=/usr/local/share:/usr/share:/var/lib/snapd/desktopSUDO_UID=1000MAIL=/var/mail/rootSHELL=/bin/bashTERM=xtermSHLVL=1LOGNAME=rootPATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/binLESSOPEN=| /usr/bin/lesspipe %s_=/bin/bashOLDPWD=/

Похожий вывод можно получить при помощи ps e -p <pid> | more

root@ovpn1:~# ps -ef | grep bash
ovpnuser  1568  1165  0  2020 tty1     00:00:00 -bash
root      1927  1926  0  2020 tty1     00:00:00 -bash
root      4334 20923  0 18:34 pts/0    00:00:00 bash
root      4392  4334  0 18:52 pts/0    00:00:00 grep --color=auto bash
ovpnuser  7806  7805  0 Aug04 pts/0    00:00:00 -bash
root     20923 20922  0 Aug05 pts/0    00:00:01 -bash
root@ovpn1:~# ps e -p 4334 | more
  PID TTY      STAT   TIME COMMAND
 4334 pts/0    S      0:00 bash LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:m
i=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=0
1;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.
gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01
;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;3
1:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35
:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*
.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*
.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.av
i=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;
35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:
*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36: LESSCLOSE=/usr/bin/lesspipe %s %s LANG=C.UTF-8 SUDO_GID=1000 USERNAME=ro
ot SUDO_COMMAND=/bin/bash USER=root PWD=/root HOME=/root SUDO_USER=ovpnuser XDG_DATA_DIRS=/usr/local/share:/usr/share:/var/lib/snapd/de
sktop SUDO_UID=1000 MAIL=/var/mail/root SHELL=/bin/bash TERM=xterm SHLVL=1 LOGNAME=root PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/
usr/bin:/sbin:/bin:/snap/bin LESSOPEN=| /usr/bin/lesspipe %s _=/bin/bash OLDPWD=/

```
10. Используя man, опишите что доступно по адресам /proc/<PID>/cmdline, /proc/<PID>/exe.
```
/proc//cmdline - содержит аргументы командной строки, переданные при запуске процесса  в виде набора строк, разделенных нулевыми байтами ('\0')
/proc/$pid/exe - является символьной ссылкой на исполняемый бинарный файл. 
```
11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo.
```
SSE4_2

root@ovpn1:~# cat /proc/cpuinfo | grep sse
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl tsc_reliable nonstop_tsc cpuid pni pclmulqdq ssse3 cx16 sse4_1 sse4_2 x2apic popcnt aes xsave avx hypervisor lahf_lm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw xop fma4 ssbd vmmcall arat overflow_recov succor
root@ovpn1:~#

```
12. При открытии нового окна терминала и vagrant ssh создается новая сессия и выделяется pty. Это можно подтвердить командой tty, которая упоминалась в лекции 3.2. Однако:

vagrant@netology1:~$ ssh localhost 'tty'
not a tty
Почитайте, почему так происходит, и как изменить поведение.
```
Псевдотерминал не выделяется для удаленного запуска команды. 
Изменить поведение можно, использовав ключ -t :
ssh -t localhost 'tty'
```
13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись reptyr. Например, так можно перенести в screen процесс, который вы запустили по ошибке в обычной SSH-сессии.
```
-запустить процесс, напрмиер top
-suspend the process  Ctrl+Z
-bg
-disown %1
-screen
-найти PID  pgrep top
-Включить ptracing  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
-reptyr <pid>
-отключить ptracing with echo 1 | sudo tee /proc/sys/kernel/yama/ptrace_scope
```
14. sudo echo string > /root/new_file не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без sudo под вашим пользователем. Для решения данной проблемы можно использовать конструкцию echo string | sudo tee /root/new_file. Узнайте что делает команда tee и почему в отличие от sudo echo команда с sudo tee будет работать.
```
команда echo встроенная в shell, а shell запущен под Vagrant, а не root.
Команда tee внещняя, поэтому sudo работает
```

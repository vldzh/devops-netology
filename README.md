1. Установите средство виртуализации Oracle VirtualBox.
```
DONE. Version 6.1.26 r145957 (Qt5.6.2) installed
```
2. Установите средство автоматизации Hashicorp Vagrant.

```
c:\vagrant>vagrant  -v
Vagrant 2.2.18
```


3. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал. 
```
DONE
```
4. С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant:

Создайте директорию, в которой будут храниться конфигурационные файлы Vagrant. В ней выполните vagrant init. Замените содержимое Vagrantfile по умолчанию следующим:

 Vagrant.configure("2") do |config|
 	config.vm.box = "bento/ubuntu-20.04"
 end
Выполнение в этой директории vagrant up установит провайдер VirtualBox для Vagrant, скачает необходимый образ и запустит виртуальную машину.
vagrant suspend выключит виртуальную машину с сохранением ее состояния (т.е., при следующем vagrant up будут запущены все процессы внутри, которые работали на момент вызова suspend), vagrant halt выключит виртуальную машину штатным образом.
```
c:\vagrant>vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'bento/ubuntu-20.04'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'bento/ubuntu-20.04' version '202107.28.0' is up to date...
==> default: Setting the name of the VM: vagrant_default_1628696605423_78348
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: Warning: Connection reset. Retrying...
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
==> default: Mounting shared folders...
    default: /vagrant => C:/vagrant
```
5. Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?
```
vCPUs: 2, RAM: 1Gb
```
6. Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: документация. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?
```
изменить файл Vagrantfile
config.vm.provider "virtualbox" do |v|
  v.memory = 2048
  v.cpus = 4
```
7. Команда vagrant ssh из директории, в которой содержится Vagrantfile, позволит вам оказаться внутри виртуальной машины без каких-либо дополнительных настроек. Попрактикуйтесь в выполнении обсуждаемых команд в терминале Ubuntu.
```
DONE
```
8. Ознакомиться с разделами man bash, почитать о настройках самого bash:
какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?
что делает директива ignoreboth в bash?
```
HISTFILESIZE, line 879/4744
       HISTFILESIZE
              The  maximum  number  of  lines  contained in the history file.  When this variable is assigned a
              value, the history file is truncated, if necessary, to contain no more than that number of  lines
              by removing the oldest entries.  The history file is also truncated to this size after writing it
              when a shell exits.  If the value is 0, the history file is truncated to zero size.   Non-numeric
              values and numeric values less than zero inhibit truncation.  The shell sets the default value to
              the value of HISTSIZE after reading any startup files.


ignoreboth позволяет не сохранять в истории команды, начинающиеся
с пробела (ignorespace) и полностью совпадающие с сохраненными ранее в истории
(ignoredupes).
```
9. В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?
```
строка 267/4744
       { list; }
              list is simply executed in the current shell environment.  list must be terminated with a newline
              or  semicolon.   This is known as a group command.  The return status is the exit status of list.
              Note that unlike the metacharacters ( and ), { and } are reserved words and must  occur  where  a
              reserved  word is permitted to be recognized.  Since they do not cause a word break, they must be
              separated from list by whitespace or another shell metacharacter.
```
10. Основываясь на предыдущем вопросе, как создать однократным вызовом touch 100000 файлов? А получилось ли создать 300000?
touch 100000 файлов? А получилось ли создать 300000?
```
    Получилось создать 100000 файлов.     
    Создать 300000 файлов не получилось
    Вызывает сообщение: 
    -bash: /bin/touch: Argument list too long
    можно решить проблему, использовавав xargs
```
11. В man bash поищите по /\[\[. Что делает конструкция [[ -d /tmp ]]
```
конструкция [[ -d /tmp ]] проверяет является ли tmp директорией.
```
12. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:

bash is /tmp/new_path_directory/bash
bash is /usr/local/bin/bash
bash is /bin/bash
(прочие строки могут отличаться содержимым и порядком)
```
$ mkdir -p /tmp/new_path_directory/
$ touch /tmp/new_path_directory/bash
$ chmod +x /tmp/new_path_directory/bash
$ export PATH=/tmp/new_path_directory:$PATH
$ type -a bash
bash is /tmp/new_path_directory/bash
bash is /usr/bin/bash
bash is /bin/bash
```
13. Чем отличается планирование команд с помощью batch и at?
```
 at запускает команды на выполнение в указанное время, 
 batch  запускает задания в очереди только при снижении нагрузки на систему до  определенного значения 
```
14. Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.
```
DONE
```




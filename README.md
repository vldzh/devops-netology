1.Есть скрипт:
```
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```
Какое значение будет присвоено переменной c? Будет ошибка исполнения кода, т.к. происходит попытка сложить переменные различного типa
Как получить для переменной c значение 12? нужно преобразовать a в тип string a = str(a)
Как получить для переменной c значение 3? нужно преобразовать переменную b в тип integer b = int(b)


2.Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```
Убираем  break, добавляем в вывод полный путь к директории.
```
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(os.getcwd() + '/' + prepare_result)
```


3.Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

```
#!/usr/bin/env python3

import os
import sys

repo_path = sys.argv[1]
if repo_path[-1] != '/':
    repo_path += '/'
os.chdir(repo_path)
if os.path.exists(repo_path + '.git'):
   result_os = os.popen("git status").read()
   for result in result_os.split('\n'):
       if result.find('modified') != -1:
           prepare_result = result.replace('\tmodified:   ', '')
           print(os.getcwd() + '/' + prepare_result)
else:
    print('there is no repository in this directory')
```


4.Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.

```
#!/usr/bin/env python3

from socket import gethostbyname
import time

servers = {}

servers['drive.google.com'] = gethostbyname('drive.google.com')
servers['mail.google.com'] = gethostbyname('mail.google.com')
servers['google.com'] = gethostbyname('google.com')

while True:    
    for srv in servers.keys():
        last_ip = servers.get(srv)
        ip  = gethostbyname(srv)    
        if ip == last_ip:
            print(f'{srv} - {ip}')
        else:
            print(f'[ERROR] {srv} IP mismatch: {last_ip} - {ip}')
            servers[srv] = ip
    print()
    time.sleep( 5 )
```

1.Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
{ "info" : "Sample JSON output from our service\t",
    "elements" :[
        { "name" : "first",
        "type" : "server",
        "ip" : 7175 
        },
        { "name" : "second",
        "type" : "proxy",
        "ip : 71.78.22.43
        }
    ]
}
```
Нужно найти и исправить все ошибки, которые допускает наш сервис
ОТВЕТ:
```
{ "info" : "Sample JSON output from our service\\t", #####
    "elements" :[
        { 
          "name" : "first",
          "type" : "server",
          "ip" : 7175
        },
        {
          "name" : "second",
          "type" : "proxy",
          "ip" : "71.78.22.43" ####
    ]
}
```
2.В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

```
#!/usr/bin/env python3

from socket import gethostbyname
import time
import json
import yaml


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
    with open('./task2_list.json', 'w') as json_file:
        json.dump(servers, json_file)
    with open('./task2_list.yml', 'w') as yaml_file:
        yaml.dump(servers, yaml_file, default_flow_style=False)
    time.sleep( 5 )
```


outputs files:
```
drive.google.com: 142.251.36.46
google.com: 142.250.179.142
mail.google.com: 142.251.36.5
```
```
{"drive.google.com": "142.251.36.46", "mail.google.com": "142.251.36.5", "google.com": "142.250.179.142"}
```




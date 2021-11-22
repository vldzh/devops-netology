1. https://hub.docker.com/repository/docker/vladyezh/hw531


-создаем пустой каталог
```
librenms@librenms:~$ mkdir hw531
librenms@librenms:~$ cd hw531
librenms@librenms:~/hw531$
```
-создаем index.html 
```
index.html:
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
-создаем  Dockerfile в  каталог
```
Dockerfile:

FROM nginx:alpine

WORKDIR /usr/share/nginx/html

COPY . .
```

-создаем кастомный образ
```
librenms@librenms:~/hw531$ docker image build -t vladyezh/hw531:testing .
Sending build context to Docker daemon  3.072kB
Step 1/3 : FROM nginx:alpine
alpine: Pulling from library/nginx
97518928ae5f: Pull complete
a4e156412037: Pull complete
e0bae2ade5ec: Pull complete
3f3577460f48: Pull complete
e362c27513c3: Pull complete
a2402c2da473: Pull complete
Digest: sha256:12aa12ec4a8ca049537dd486044b966b0ba6cd8890c4c900ccb5e7e630e03df0
Status: Downloaded newer image for nginx:alpine
 ---> b46db85084b8
Step 2/3 : WORKDIR /usr/share/nginx/html
 ---> Running in 8dd61822a3a6
Removing intermediate container 8dd61822a3a6
 ---> c82b841e1fdb
Step 3/3 : COPY . .
 ---> b6cac78ba603
Successfully built b6cac78ba603
Successfully tagged vladyezh/hw531:testing
```

запускаем контейнер
```
librenms@librenms:~/hw531$ docker container run -d -p 8081:80 --name nginx-web1  vladyezh/hw531:testing
e27b9633521ec73fd9ad6a2608b080560d13f745aea34ab2e87ae456ad8935f4
```

проверяем работу
```
librenms@librenms:~/hw531$ curl localhost:8081
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
-логинимся на Docker Hub
```
librenms@librenms:~/hw531$ docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: vladyezh
Password:
WARNING! Your password will be stored unencrypted in /opt/librenms/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

-заливаем образ
```
To push the 'testing' image:

librenms@librenms:~/hw531$ docker image push   vladyezh/hw531:testing           The push refers to repository [docker.io/vladyezh/hw531]
af00f686aae2: Pushed
3d71b657b020: Mounted from library/nginx
eabae5075c43: Mounted from library/nginx
385374b911f2: Mounted from library/nginx
5af959103b90: Mounted from library/nginx
ad93babfd60c: Mounted from library/nginx
1a058d5342cc: Mounted from library/nginx
testing: digest: sha256:60f51c1c3fd157c2f725ca32896d45c4df1de0c9e073e0b5c57cfa241c4152f3 size: 1775


librenms@librenms:~/hw531$ docker image tag  vladyezh/hw531:testing   vladyezh/hw531
librenms@librenms:~/hw531$ docker image push   vladyezh/hw531                   Using default tag: latest
The push refers to repository [docker.io/vladyezh/hw531]
af00f686aae2: Layer already exists
3d71b657b020: Layer already exists
eabae5075c43: Layer already exists
385374b911f2: Layer already exists
5af959103b90: Layer already exists
ad93babfd60c: Layer already exists
1a058d5342cc: Layer already exists
latest: digest: sha256:60f51c1c3fd157c2f725ca32896d45c4df1de0c9e073e0b5c57cfa241c4152f3 size: 1775
```

1.Зарегистрируйте аккаунт на https://github.com/ (если вы предпочитаете другое хранилище для репозитория, можно использовать его).

DONE

2.Создайте публичный репозиторий, который будете использовать дальше на протяжении всего курса, желательное название devops-netology. Обязательно поставьте галочку Initialize this repository with a README. DONE

3.Склонируйте репозиторий, используя https протокол (git clone ...)

root@ovpn1:~# sudo git clone https://github.com/vldzh/devops-netology.git
Cloning into 'devops-netology'...
remote: Enumerating objects: 9, done.
remote: Counting objects: 100% (9/9), done.
remote: Compressing objects: 100% (5/5), done.
remote: Total 9 (delta 1), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (9/9), done.

4.Перейдите в каталог с клоном репозитория (cd devops-netology)
root@ovpn1:~# cd devops-netology/
root@ovpn1:~/devops-netology#


5.Произведите первоначальную настройку git, указав свое настоящее имя (пожалуста, используйте настоящие имена, нам так будет проще общаться) и email (git config --global user.name и git config --global user.email johndoe@example.com).
root@ovpn1:~/devops-netology# git config --global Vladislav.Ezhergin
root@ovpn1:~/devops-netology# git config --global user.email vladyezh@gmail.com


6.Выполните команду git status и запомните результат.
root@ovpn1:~/devops-netology# git status
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean


7.Отредактируйте файл README.md любым удобным способом, тем самым переведя файл в состояние Modified.
root@ovpn1:~/devops-netology# echo "tests" > README.md


8.Еще раз выполните git status и продолжайте проверять вывод этой команды после каждого последующего шага.
root@ovpn1:~/devops-netology# git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")



9.Давйте теперь посмотрим изменения в файле README.md выполнив команды git diff и git diff --staged.
root@ovpn1:~/devops-netology# git diff
diff --git a/README.md b/README.md
index b4960e0..2b29f27 100644
--- a/README.md
+++ b/README.md
@@ -1,11 +1 @@
--Менеджер и разработчики согласуют новый функционал
-
--Разработчик пишет код для нового функционала, сохраняет изменения в git  ( развернутый ранее DevOps-инженером)
-
--Развернутая ранее DevOps-инженером CI-среда производит авоматическую сборку и тестирование с помощью сценариев, разработанных отделом QA
-
--Изменения в коде подтверждаются
-
--Менеджер подтверждает  добавление функционала в "продакшн"
-
--Развернутая ранее DevOps-инженером среда CD  производит автоматическую установку изменений кода на серверах компании
+tests
root@ovpn1:~/devops-netology# git diff --staged
root@ovpn1:~/devops-netology#


10.Переведите файл в состояние staged (или как говорят просто добавьте файл в коммит) командой git add README.md.
root@ovpn1:~/devops-netology# git add README.md


11.И еще раз выполните команды git diff и git diff --staged. Поиграйте с изменениями и этими коммандами, чтобы четко понять что и когда они отображают.
root@ovpn1:~/devops-netology# git diff
root@ovpn1:~/devops-netology# git diff --staged
diff --git a/README.md b/README.md
index b4960e0..2b29f27 100644
--- a/README.md
+++ b/README.md
@@ -1,11 +1 @@
--Менеджер и разработчики согласуют новый функционал
-
--Разработчик пишет код для нового функционала, сохраняет изменения в git  ( развернутый ранее DevOps-инженером)
-
--Развернутая ранее DevOps-инженером CI-среда производит авоматическую сборку и тестирование с помощью сценариев, разработанных отделом QA
-
--Изменения в коде подтверждаются
-
--Менеджер подтверждает  добавление функционала в "продакшн"
-
--Развернутая ранее DevOps-инженером среда CD  производит автоматическую установку изменений кода на серверах компании
+tests




12.Теперь можно сделать коммит git commit -m 'First commit'.
root@ovpn1:~/devops-netology# git commit -m 'First commit'
[main fdae7e1] First commit
 1 file changed, 1 insertion(+), 11 deletions(-)
 rewrite README.md (100%)


13.И еще раз посмотреть выводы команд git status, git diff и git diff --staged.
root@ovpn1:~/devops-netology# git status
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean
root@ovpn1:~/devops-netology# git diff
root@ovpn1:~/devops-netology# git diff --staged



Создадим файлы .gitignore и второй коммит:

1.Создайте файл .gitignore (обратите внимание на точку в начале файла), проверьте его статус сразу после создания.
root@ovpn1:~/devops-netology# touch .gitignore
root@ovpn1:~/devops-netology# ls -la
total 16
drwxr-xr-x 3 root root 4096 Jul 28 16:31 .
drwx------ 4 root root 4096 Jul 28 16:21 ..
drwxr-xr-x 8 root root 4096 Jul 28 16:29 .git
-rw-r--r-- 1 root root    0 Jul 28 16:31 .gitignore
-rw-r--r-- 1 root root    6 Jul 28 16:26 README.md

2.Добавьте файл .gitignore в следующий коммит (git add...).
root@ovpn1:~/devops-netology# git add .gitignore
root@ovpn1:~/devops-netology# git status
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   .gitignore


3.На одном из следующих блоков мы будем изучать Terraform, давайте сразу же создадим соотвествующий каталог terraform и внутри этого каталога файл .gitignore по этому примеру: https://github.com/github/gitignore/blob/master/Terraform.gitignore.

4.В файле README.md опишите своими словами какие файлы будут проигнорированы в будущем благодаря добавленному .gitignore.
root@ovpn1:~/devops-netology/Terraform# vi ../README.md
root@ovpn1:~/devops-netology/Terraform# cat ../README.md
Будут проигнорированы:
1) локальные директории с именем  .terraform
2) файлы .tfstate и .tfstate.*
3) лог файлы crash.log
4) файлы с именем *.tfvars
5) файлы override, имена которых асооьвеьсвуют шаблонам override.tf override.tf.json *_override.tf *_override.tf.json
6) файлы .terraformrc и terraform.rc
root@ovpn1:~/devops-netology/Terraform#

5.Закоммитте все новые и измененные файлы. Комментарий к коммиту должен быть Added gitignore.
root@ovpn1:~/devops-netology# git add Terraform/
root@ovpn1:~/devops-netology# git status
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   .gitignore
        new file:   Terraform/.gitignore

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   README.md

root@ovpn1:~/devops-netology# git commit -m "Added gitignore"
[main fec6a77] Added gitignore
 2 files changed, 34 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 Terraform/.gitignore


Экспериментируем с удалением и перемещением файлов (третий и четвертый коммит).

1.Создайте файлы will_be_deleted.txt (с текстом will_be_deleted) и will_be_moved.txt (с текстом will_be_moved) и закоммите их с комментарием Prepare to delete and move.
root@ovpn1:~/devops-netology# echo "will_be_deleted" > will_be_deleted.txt
root@ovpn1:~/devops-netology# echo "will_be_moved" > will_be_moved.txt
root@ovpn1:~/devops-netology# ls -la
total 28
drwxr-xr-x 4 root root 4096 Jul 28 18:59 .
drwx------ 4 root root 4096 Jul 28 18:56 ..
drwxr-xr-x 8 root root 4096 Jul 28 18:58 .git
-rw-r--r-- 1 root root    0 Jul 28 16:31 .gitignore
-rw-r--r-- 1 root root  420 Jul 28 18:56 README.md
drwxr-xr-x 2 root root 4096 Jul 28 18:51 Terraform
-rw-r--r-- 1 root root   16 Jul 28 18:59 will_be_deleted.txt
-rw-r--r-- 1 root root   14 Jul 28 18:59 will_be_moved.txt
root@ovpn1:~/devops-netology# git add will_be_deleted.txt
root@ovpn1:~/devops-netology# git add will_be_moved.txt
root@ovpn1:~/devops-netology# git commit -m "Prepare to delete and move"
[main fdf31c9] Prepare to delete and move
 2 files changed, 2 insertions(+)
 create mode 100644 will_be_deleted.txt
 create mode 100644 will_be_moved.txt


2.В случае необходимости обратитесь к официальной документации: https://git-scm.com/book/ru/v2/Основы-Git-Запись-изменений-в-репозиторий , здесь подробно описано как выполнить последующие шаги.


3.Удалите файл will_be_deleted.txt с диска и из репозитория.
root@ovpn1:~/devops-netology# git rm will_be_deleted.txt
rm 'will_be_deleted.txt'
root@ovpn1:~/devops-netology# git status
On branch main
Your branch is ahead of 'origin/main' by 3 commits.
  (use "git push" to publish your local commits)

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        deleted:    will_be_deleted.txt

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   README.md



4.Переименуйте (переместите) файл will_be_moved.txt на диске и в репозитории, чтобы он стал называться has_been_moved.txt.
root@ovpn1:~/devops-netology# git mv  will_be_moved.txt has_been_moved.txt
root@ovpn1:~/devops-netology#  ls -la
total 24
drwxr-xr-x 4 root root 4096 Jul 28 19:09 .
drwx------ 4 root root 4096 Jul 28 18:56 ..
drwxr-xr-x 8 root root 4096 Jul 28 19:09 .git
-rw-r--r-- 1 root root    0 Jul 28 16:31 .gitignore
-rw-r--r-- 1 root root  420 Jul 28 18:56 README.md
drwxr-xr-x 2 root root 4096 Jul 28 18:51 Terraform
-rw-r--r-- 1 root root   14 Jul 28 19:08 has_been_moved.txt
root@ovpn1:~/devops-netology# git status
On branch main
Your branch is ahead of 'origin/main' by 3 commits.
  (use "git push" to publish your local commits)

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        renamed:    will_be_moved.txt -> has_been_moved.txt
        deleted:    will_be_deleted.txt

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   README.md





5.Закоммитте результат работы с комментарием Moved and deleted.
root@ovpn1:~/devops-netology# git commit -m "Moved and deleted"
[main c515289] Moved and deleted
 2 files changed, 1 deletion(-)
 rename will_be_moved.txt => has_been_moved.txt (100%)
 delete mode 100644 will_be_deleted.txt



Проверка изменений.

1.В результате предыдущих шагов в репозитории должно быть как минимум пять коммитов (если вы еще сделали какие-нибудь промежуточные – нет проблем):
Initial Commit – созданный гитхабом при инициализации репозитория.
First commit – созданный после изменения файла README.md.
Added gitignore – после добавления .gitignore.
Prepare to delete and move – после добавления двух временных файлов.
Moved and deleted – после удаления и перемещения временных файлов.
2.Проверьте это используя комманду git log (подробно о формате вывода этой команды мы поговорим на следующем занятии, но посмотреть что она отображает можно уже сейчас).
root@ovpn1:~/devops-netology# git log
commit c5152899938ee8fe1d7cd38921cbbebb09a3a016 (HEAD -> main)
Author: root <vladyezh@gmail.com>
Date:   Wed Jul 28 19:11:20 2021 +0000

    Moved and deleted

commit fdf31c99485f38bcb716fe80381d99f8c193dcda
Author: root <vladyezh@gmail.com>
Date:   Wed Jul 28 19:03:03 2021 +0000

    Prepare to delete and move

commit fec6a77766c9d92ce29c7e6bbac8a268a189c327
Author: root <vladyezh@gmail.com>
Date:   Wed Jul 28 18:58:24 2021 +0000

    Added gitignore

commit fdae7e151c32f15372f3df32a84e6a70ee282722
Author: root <vladyezh@gmail.com>
Date:   Wed Jul 28 16:28:48 2021 +0000

    First commit

commit a4ee496a96d25f4e8e0ac0eb1f6ba0239499e316 (origin/main, origin/HEAD)
Author: vldzh <vladyezh@gmail.com>
Date:   Sat Jul 17 00:16:53 2021 +0300

    Update README.md

commit 54ba6c6f587caf7a3ca52904c473cf6a311c5e61
Author: vldzh <vladyezh@gmail.com>
Date:   Sat Jul 17 00:16:30 2021 +0300

    Update README.md

commit f49bc1dc3f1f8292668accc60582f233da9285f9
Author: vldzh <vladyezh@gmail.com>


Отправка изменений в репозиторий.

Выполните команду git push, если git запросит логин и пароль – введите ваш логин и пароль от github.
root@ovpn1:~/devops-netology# git push
Username for 'https://github.com': vldzh
Password for 'https://vldzh@github.com':
remote: Invalid username or password.
fatal: Authentication failed for 'https://github.com/vldzh/devops-netology.git/'
root@ovpn1:~/devops-netology# git push
Username for 'https://github.com': vladyezh@gmail.com
Password for 'https://vladyezh@gmail.com@github.com':
Counting objects: 14, done.
Compressing objects: 100% (8/8), done.
Writing objects: 100% (14/14), 1.46 KiB | 497.00 KiB/s, done.
Total 14 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), done.
To https://github.com/vldzh/devops-netology.git
   a4ee496..c515289  main -> main

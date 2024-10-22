# Дипломный практикум в Yandex.Cloud
  * [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
     * [Создание облачной инфраструктуры](#создание-облачной-инфраструктуры)
     * [Создание Kubernetes кластера](#создание-kubernetes-кластера)
     * [Создание тестового приложения](#создание-тестового-приложения)
     * [Подготовка cистемы мониторинга и деплой приложения](#подготовка-cистемы-мониторинга-и-деплой-приложения)
     * [Установка и настройка CI/CD](#установка-и-настройка-cicd)
  * [Что необходимо для сдачи задания?](#что-необходимо-для-сдачи-задания)
  * [Как правильно задавать вопросы дипломному руководителю?](#как-правильно-задавать-вопросы-дипломному-руководителю)

**Перед началом работы над дипломным заданием изучите [Инструкция по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:


### Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

### Предварительная подготовка к установке и запуску Kubernetes кластера.
-узнаем ID облака:
```
vlad@ubuntu-test:~/netology$ yc resource-manager cloud list
+----------------------+----------------+----------------------+--------+
|          ID          |      NAME      |   ORGANIZATION ID    | LABELS |
+----------------------+----------------+----------------------+--------+
| b1gnent42f5ngd6p9ko6 | cloud-vladyezh | bpf2hhgetemutkk404bu |        |
+----------------------+----------------+----------------------+--------+
```
-узнаем ID папки:
```
vlad@ubuntu-test:~/netology$ yc resource-manager --cloud-id  b1gnent42f5ngd6p9ko6 folder list
+----------------------+------------------+--------+--------+
|          ID          |       NAME       | LABELS | STATUS |
+----------------------+------------------+--------+--------+
| b1gl1l40scqu0fljs2gg | default          |        | ACTIVE |
| b1g2ll8gqs3068utaas2 | netology-diploma |        | ACTIVE |
+----------------------+------------------+--------+--------+
```
-создаем админский сервисный аккаунт 
```
vlad@ubuntu-test:~/netology$ yc config set cloud-id b1gnent42f5ngd6p9ko6
vlad@ubuntu-test:~/netology$ yc config set folder-id b1g2ll8gqs3068utaas2
vlad@ubuntu-test:~/netology$ yc iam service-account create --name sa
done (1s)
id: ajehak8203gl8audi8o8
folder_id: b1g2ll8gqs3068utaas2
created_at: "2024-10-20T20:44:02.198686809Z"
name: sa


vlad@ubuntu-test:~/netology$ yc iam service-account list
vlad@ubuntu-test:~/netology$ yc iam service-account list
+----------------------+--------------+--------+---------------------+-----------------------+
|          ID          |     NAME     | LABELS |     CREATED AT      | LAST AUTHENTICATED AT |
+----------------------+--------------+--------+---------------------+-----------------------+
| ajehak8203gl8audi8o8 | sa           |        | 2024-10-20 20:44:02 |                       |
+----------------------+--------------+--------+---------------------+-----------------------+

```
-выдаем роль admin начальному сервисному аккаунту
```
vlad@ubuntu-test:~/netology$ yc resource-manager folder add-access-binding b1g2ll8gqs3068utaas2 \
  --role admin \
  --subject serviceAccount:ajehak8203gl8audi8o8
done (4s)
effective_deltas:
  - action: ADD
    access_binding:
      role_id: admin
      subject:
        id: ajehak8203gl8audi8o8
        type: serviceAccount
```

### 1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
Настроим  Terraform 

```
vlad@ubuntu-test:~/netology/devops-netology/diploma/step1.1$ cat  main.tf
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  service_account_key_file = "sa.json"
  cloud_id  = "b1gnent42f5ngd6p9ko6"
  folder_id = "b1g2ll8gqs3068utaas2"
  zone = "ru-central1-a"
}

// Create terraform SA
resource "yandex_iam_service_account" "terraform-sa" {
  folder_id = "b1g2ll8gqs3068utaas2"
  name      = "terraform-sa"
}

// Grant permissions to terraform  sa
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = "b1g2ll8gqs3068utaas2"
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.terraform-sa.id}"
}

// Create Static Access Keys for terraform SA
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.terraform-sa.id
  description        = "static access key for object storage"
}

// Create bucket for next steps
resource "yandex_storage_bucket" "netology-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "vladyezh-netology-bucket"
  max_size = 1073741824 # 1 Gb
  anonymous_access_flags {
    read = true
    list = false
  }

```
Проверим и примерим Terraform 

```
vlad@ubuntu-test:~/netology/devops-netology/diploma/step1.1$ terraform   plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_iam_service_account.terraform-sa will be created
  + resource "yandex_iam_service_account" "terraform-sa" {
      + created_at = (known after apply)
      + folder_id  = "b1g2ll8gqs3068utaas2"
      + id         = (known after apply)
      + name       = "terraform-sa"
    }

  # yandex_iam_service_account_static_access_key.sa-static-key will be created
  + resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
      + access_key                   = (known after apply)
      + created_at                   = (known after apply)
      + description                  = "static access key for object storage"
      + encrypted_secret_key         = (known after apply)
      + id                           = (known after apply)
      + key_fingerprint              = (known after apply)
      + output_to_lockbox_version_id = (known after apply)
      + secret_key                   = (sensitive value)
      + service_account_id           = (known after apply)
    }

  # yandex_resourcemanager_folder_iam_member.sa-editor will be created
  + resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
      + folder_id = "b1g2ll8gqs3068utaas2"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "editor"
    }

  # yandex_storage_bucket.netology-bucket will be created
  + resource "yandex_storage_bucket" "netology-bucket" {
      + access_key            = (known after apply)
      + bucket                = "vladyezh-netology-bucket"
      + bucket_domain_name    = (known after apply)
      + default_storage_class = (known after apply)
      + folder_id             = (known after apply)
      + force_destroy         = false
      + id                    = (known after apply)
      + max_size              = 1073741824
      + secret_key            = (sensitive value)
      + website_domain        = (known after apply)
      + website_endpoint      = (known after apply)

      + anonymous_access_flags {
          + list = false
          + read = true
        }

      + versioning (known after apply)
    }

Plan: 4 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
vlad@ubuntu-test:~/netology/devops-netology/diploma/step1.1$ terraform   apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_iam_service_account.terraform-sa will be created
  + resource "yandex_iam_service_account" "terraform-sa" {
      + created_at = (known after apply)
      + folder_id  = "b1g2ll8gqs3068utaas2"
      + id         = (known after apply)
      + name       = "terraform-sa"
    }

  # yandex_iam_service_account_static_access_key.sa-static-key will be created
  + resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
      + access_key                   = (known after apply)
      + created_at                   = (known after apply)
      + description                  = "static access key for object storage"
      + encrypted_secret_key         = (known after apply)
      + id                           = (known after apply)
      + key_fingerprint              = (known after apply)
      + output_to_lockbox_version_id = (known after apply)
      + secret_key                   = (sensitive value)
      + service_account_id           = (known after apply)
    }

  # yandex_resourcemanager_folder_iam_member.sa-editor will be created
  + resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
      + folder_id = "b1g2ll8gqs3068utaas2"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "editor"
    }

  # yandex_storage_bucket.netology-bucket will be created
  + resource "yandex_storage_bucket" "netology-bucket" {
      + access_key            = (known after apply)
      + bucket                = "vladyezh-netology-bucket"
      + bucket_domain_name    = (known after apply)
      + default_storage_class = (known after apply)
      + folder_id             = (known after apply)
      + force_destroy         = false
      + id                    = (known after apply)
      + max_size              = 1073741824
      + secret_key            = (sensitive value)
      + website_domain        = (known after apply)
      + website_endpoint      = (known after apply)

      + anonymous_access_flags {
          + list = false
          + read = true
        }

      + versioning (known after apply)
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_iam_service_account.terraform-sa: Creating...
yandex_iam_service_account.terraform-sa: Creation complete after 2s [id=ajetu32q16an3facijht]
yandex_resourcemanager_folder_iam_member.sa-editor: Creating...
yandex_iam_service_account_static_access_key.sa-static-key: Creating...
yandex_iam_service_account_static_access_key.sa-static-key: Creation complete after 1s [id=ajei70ltes14tuc1r3kp]
yandex_storage_bucket.netology-bucket: Creating...
yandex_resourcemanager_folder_iam_member.sa-editor: Creation complete after 2s [id=b1g2ll8gqs3068utaas2/editor/serviceAccount:ajetu32q16an3facijht]
yandex_storage_bucket.netology-bucket: Creation complete after 6s [id=vladyezh-netology-bucket]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```


### 2. Подготовьте [backend](https://www.terraform.io/docs/language/settings/backends/index.html) для Terraform:  а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)


-Создадим авторизованный ключ для сервисного аккаунта terrafofm-sa и сохраним его в файл 
```
vlad@ubuntu-test:~/netology/devops-netology/diploma/step1.2$ yc iam key create --service-account-name terraform-sa --output terraform-sa.json
id: ajetp72t59ku3cfq23ig
service_account_id: ajetu32q16an3facijht
created_at: "2024-10-22T19:33:03.144146332Z"
key_algorithm: RSA_2048
```
-Удалим начальный админисуий экуцнт м убудимся , что остался  только  terraform-sa
```
vlad@ubuntu-test:~/netology/devops-netology/diploma/step1.2$ yc iam service-account list
+----------------------+--------------+--------+---------------------+-----------------------+
|          ID          |     NAME     | LABELS |     CREATED AT      | LAST AUTHENTICATED AT |
+----------------------+--------------+--------+---------------------+-----------------------+
| ajetu32q16an3facijht | terraform-sa |        | 2024-10-22 19:08:28 | 2024-10-22 00:00:00   |
+----------------------+--------------+--------+---------------------+-----------------------+
```
Для  вутентфикации доступа к S3, настроим переменные окружения:
```
vlad@ubuntu-test:~/netology/devops-netology/diploma/step1.2$ yc iam access-key create --folder-id b1g2ll8gqs3068utaas2  --service-account-name terraform-sa
access_key:
  id: ajeia5lpm2c651isfd4v
  service_account_id: ajetu32q16an3facijht
  created_at: "2024-10-22T20:16:30.649011119Z"
  key_id: XXXXXXXXXXXXXXXXXXXXXXXXXX
  secret: YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
vlad@ubuntu-test:~/netology/devops-netology/diploma/step1.2$ export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXXXXXXXXXX"
vlad@ubuntu-test:~/netology/devops-netology/diploma/step1.2$ export AWS_SECRET_ACCESS_KEY="YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY"
```

3. Создайте конфигурацию Terrafrom, используя созданный бакет ранее как бекенд для хранения стейт файла. Конфигурации Terraform для создания сервисного аккаунта и бакета и основной инфраструктуры следует сохранить в разных папках.
4. Создайте VPC с подсетями в разных зонах доступности.
5. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.

-создаем конфигурацию Terrafrom

```
vlad@ubuntu-test:~/netology/devops-netology/diploma/step1.2$ cat main.tf
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"


  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "vladyezh-netology-bucket"
    region = "ru-central1"
    key    = "diploma.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.


  }
}


provider "yandex" {
  service_account_key_file = "terraform-sa.json"
  cloud_id  = "b1gnent42f5ngd6p9ko6"
  folder_id = "b1g2ll8gqs3068utaas2"
  zone = "ru-central1-a"
}


# Network
resource "yandex_vpc_network" "network-1" {
  name = "network"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet-2" {
  name           = "subnet2"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

resource "yandex_vpc_subnet" "subnet-3" {
  name           = "subnet3"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.30.0/24"]
}

```

```
vlad@ubuntu-test:~/netology/devops-netology/diploma/step1.2$ terraform init
Initializing the backend...
Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Using previously-installed yandex-cloud/yandex v0.131.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
vlad@ubuntu-test:~/netology/devops-netology/diploma/step1.2$ terraform  validate
Success! The configuration is valid.

vlad@ubuntu-test:~/netology/devops-netology/diploma/step1.2$ terraform   plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_vpc_network.network-1 will be created
  + resource "yandex_vpc_network" "network-1" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet-1 will be created
  + resource "yandex_vpc_subnet" "subnet-1" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet1"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.subnet-2 will be created
  + resource "yandex_vpc_subnet" "subnet-2" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet2"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.20.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.subnet-3 will be created
  + resource "yandex_vpc_subnet" "subnet-3" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet3"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.30.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 4 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
vlad@ubuntu-test:~/netology/devops-netology/diploma/step1.2$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_vpc_network.network-1 will be created
  + resource "yandex_vpc_network" "network-1" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet-1 will be created
  + resource "yandex_vpc_subnet" "subnet-1" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet1"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.subnet-2 will be created
  + resource "yandex_vpc_subnet" "subnet-2" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet2"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.20.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.subnet-3 will be created
  + resource "yandex_vpc_subnet" "subnet-3" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet3"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.30.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_vpc_network.network-1: Creating...
yandex_vpc_network.network-1: Creation complete after 1s [id=enp7n8jr64esenuoij86]
yandex_vpc_subnet.subnet-3: Creating...
yandex_vpc_subnet.subnet-2: Creating...
yandex_vpc_subnet.subnet-1: Creating...
yandex_vpc_subnet.subnet-2: Creation complete after 1s [id=e9b0frt8nor9bu2t407b]
yandex_vpc_subnet.subnet-3: Creation complete after 1s [id=e9b9bktmc7p7fofib71q]
yandex_vpc_subnet.subnet-1: Creation complete after 2s [id=e9bct0v16jlbn0i6huhp]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```
-Проверим удаление и создание 
```
vlad@ubuntu-test:~/netology/devops-netology/diploma/step1.2$ terraform destroy
yandex_vpc_network.network-1: Refreshing state... [id=enp7n8jr64esenuoij86]
yandex_vpc_subnet.subnet-3: Refreshing state... [id=e9b9bktmc7p7fofib71q]
yandex_vpc_subnet.subnet-2: Refreshing state... [id=e9b0frt8nor9bu2t407b]
yandex_vpc_subnet.subnet-1: Refreshing state... [id=e9bct0v16jlbn0i6huhp]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # yandex_vpc_network.network-1 will be destroyed
  - resource "yandex_vpc_network" "network-1" {
      - created_at                = "2024-10-22T20:27:22Z" -> null
      - default_security_group_id = "enp3qpldnaano2tkjetp" -> null
      - folder_id                 = "b1g2ll8gqs3068utaas2" -> null
      - id                        = "enp7n8jr64esenuoij86" -> null
      - labels                    = {} -> null
      - name                      = "network" -> null
      - subnet_ids                = [
          - "e9b0frt8nor9bu2t407b",
          - "e9b9bktmc7p7fofib71q",
          - "e9bct0v16jlbn0i6huhp",
        ] -> null
        # (1 unchanged attribute hidden)
    }

  # yandex_vpc_subnet.subnet-1 will be destroyed
  - resource "yandex_vpc_subnet" "subnet-1" {
      - created_at     = "2024-10-22T20:27:25Z" -> null
      - folder_id      = "b1g2ll8gqs3068utaas2" -> null
      - id             = "e9bct0v16jlbn0i6huhp" -> null
      - labels         = {} -> null
      - name           = "subnet1" -> null
      - network_id     = "enp7n8jr64esenuoij86" -> null
      - v4_cidr_blocks = [
          - "192.168.10.0/24",
        ] -> null
      - v6_cidr_blocks = [] -> null
      - zone           = "ru-central1-a" -> null
        # (2 unchanged attributes hidden)
    }

  # yandex_vpc_subnet.subnet-2 will be destroyed
  - resource "yandex_vpc_subnet" "subnet-2" {
      - created_at     = "2024-10-22T20:27:24Z" -> null
      - folder_id      = "b1g2ll8gqs3068utaas2" -> null
      - id             = "e9b0frt8nor9bu2t407b" -> null
      - labels         = {} -> null
      - name           = "subnet2" -> null
      - network_id     = "enp7n8jr64esenuoij86" -> null
      - v4_cidr_blocks = [
          - "192.168.20.0/24",
        ] -> null
      - v6_cidr_blocks = [] -> null
      - zone           = "ru-central1-a" -> null
        # (2 unchanged attributes hidden)
    }

  # yandex_vpc_subnet.subnet-3 will be destroyed
  - resource "yandex_vpc_subnet" "subnet-3" {
      - created_at     = "2024-10-22T20:27:24Z" -> null
      - folder_id      = "b1g2ll8gqs3068utaas2" -> null
      - id             = "e9b9bktmc7p7fofib71q" -> null
      - labels         = {} -> null
      - name           = "subnet3" -> null
      - network_id     = "enp7n8jr64esenuoij86" -> null
      - v4_cidr_blocks = [
          - "192.168.30.0/24",
        ] -> null
      - v6_cidr_blocks = [] -> null
      - zone           = "ru-central1-a" -> null
        # (2 unchanged attributes hidden)
    }

Plan: 0 to add, 0 to change, 4 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

yandex_vpc_subnet.subnet-1: Destroying... [id=e9bct0v16jlbn0i6huhp]
yandex_vpc_subnet.subnet-3: Destroying... [id=e9b9bktmc7p7fofib71q]
yandex_vpc_subnet.subnet-2: Destroying... [id=e9b0frt8nor9bu2t407b]
yandex_vpc_subnet.subnet-3: Destruction complete after 0s
yandex_vpc_subnet.subnet-1: Destruction complete after 0s
yandex_vpc_subnet.subnet-2: Destruction complete after 1s
yandex_vpc_network.network-1: Destroying... [id=enp7n8jr64esenuoij86]
yandex_vpc_network.network-1: Destruction complete after 0s

Destroy complete! Resources: 4 destroyed.
vlad@ubuntu-test:~/netology/devops-netology/diploma/step1.2$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_vpc_network.network-1 will be created
  + resource "yandex_vpc_network" "network-1" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet-1 will be created
  + resource "yandex_vpc_subnet" "subnet-1" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet1"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.subnet-2 will be created
  + resource "yandex_vpc_subnet" "subnet-2" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet2"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.20.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.subnet-3 will be created
  + resource "yandex_vpc_subnet" "subnet-3" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet3"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.30.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_vpc_network.network-1: Creating...
yandex_vpc_network.network-1: Creation complete after 1s [id=enpngs02hlnuemgvtih0]
yandex_vpc_subnet.subnet-2: Creating...
yandex_vpc_subnet.subnet-3: Creating...
yandex_vpc_subnet.subnet-1: Creating...
yandex_vpc_subnet.subnet-3: Creation complete after 1s [id=e9b0lak66afk0rmomr53]
yandex_vpc_subnet.subnet-1: Creation complete after 1s [id=e9bgumet80m7bvddiusq]
yandex_vpc_subnet.subnet-2: Creation complete after 2s [id=e9b87r3mhikk55ah4h9k]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

```

---
### Создание Kubernetes кластера

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать **региональный** мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
  
Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле `~/.kube/config` находятся данные для доступа к кластеру.
3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.

---
### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистри с собранным docker image. В качестве регистри может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.

---
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Способ выполнения:
1. Воспользоваться пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). Альтернативный вариант - использовать набор helm чартов от [bitnami](https://github.com/bitnami/charts/tree/main/bitnami).

2. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ на 80 порту к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ на 80 порту к тестовому приложению.
---
### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/), [GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/) или GitHub Actions.

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.

---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline.
3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.
5. Репозиторий с конфигурацией Kubernetes кластера.
6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)

-------------------------------------


# Итоговый проект модуля «Облачная инфраструктура. Terraform»

Описание итогового проекта:
Задания итогового проекта охватывают полный цикл создания и настройки инфраструктуры, установку необходимых инструментов, сборку и развертывание приложения, а также хранение образов в реестре контейнеров:

1. Сборка web-приложения (с описанием Dockerfile, docker compose yml).
2. Настройка инфраструктуры в Yandex Cloud, используя Terraform.
3. Разворачивание приложение в облачной среде.

## Задание 1

**Развертывание инфраструктуры в Yandex Cloud.**

1. Создаем в проекте модуль бакет для удаленного хранения terraform state (аналогично ДЗ №5):

<img width="1253" height="462" alt="image" src="https://github.com/user-attachments/assets/00c94cdb-b91f-40b3-a065-9a202f2d2cd1" />

[Код модуля](https://github.com/msiberian42/YC-Terraform-Docker-Project/tree/main/backet)

2. Создаем в проекте модуль vpc для virtual private cloud: сети с двумя подсетями в разных регионах (аналогично ДЗ №5):

<img width="1107" height="337" alt="image" src="https://github.com/user-attachments/assets/ca96ff53-bfcd-44d3-93b7-a55701f98409" />

<img width="1290" height="393" alt="image" src="https://github.com/user-attachments/assets/eb8987da-7ba8-4693-82d8-a143e7eaeac8" />

[Код модуля](https://github.com/msiberian42/YC-Terraform-Docker-Project/tree/vpc/vpc)

3. Создаем в проекте модуль vm для разворачивания виртуальных машин. Прописываем в нем создание группы безопасности:

<img width="1052" height="346" alt="image" src="https://github.com/user-attachments/assets/75538164-f469-4cfd-93fc-ad758d9f904d" />

<img width="701" height="356" alt="image" src="https://github.com/user-attachments/assets/4693d4ec-fe3b-411b-9d0a-29d18ef41cd5" />

<img width="1406" height="770" alt="image" src="https://github.com/user-attachments/assets/d389d0b9-9efc-47e9-b0a1-eecb4009e933" />

[Код модуля](https://github.com/msiberian42/YC-Terraform-Docker-Project/tree/vm/vm)

4. Создаем в проекте модуль db для разворачивание базы данных. В ней прописываем разворачивание ВМ для БД, ее группу безопасности, установку mysql и создание базы данных через cloud-config файл. Создаем в машине базу данных mysql, пользователя и пароль.

<img width="1077" height="402" alt="image" src="https://github.com/user-attachments/assets/55d43da6-e52d-4b2f-ad1c-f7be42074c6b" />

<img width="227" height="256" alt="image" src="https://github.com/user-attachments/assets/cd591622-6828-44fc-974d-7abbf5768ece" />

<img width="382" height="272" alt="image" src="https://github.com/user-attachments/assets/8321f144-1b9c-4424-af85-d48d7f8ba308" />

[Код модуля](https://github.com/msiberian42/YC-Terraform-Docker-Project/tree/mysql/db)

5. Создаем в проекте модуль container_registry для создания регистра контейнеров. Создаем в модуле сервисный аккаунт для скачивания образов.

<img width="1032" height="365" alt="image" src="https://github.com/user-attachments/assets/77b84c76-6472-43dd-aa78-43e7eae8ff3d" />

[Код модуля](https://github.com/msiberian42/YC-Terraform-Docker-Project/tree/main/container_registry)

## Задание 2

**Установка Docker и Docker Compose на web ВМ.**

Создаем в каталоге web yml файл cloud-config для установки докера. Обновляем конфигурацию и проверяем, что докер установился:

<img width="673" height="537" alt="image" src="https://github.com/user-attachments/assets/c3c0092f-4e1b-44ac-9d19-e89da1cd0174" />

<img width="480" height="91" alt="image" src="https://github.com/user-attachments/assets/c3742905-478c-4b8d-b129-5476089172a0" />

[Код модуля](https://github.com/msiberian42/YC-Terraform-Docker-Project/tree/docker/web)

## Задание 3

**Создание образа для веб-приложения. Поднятие docker compose через terraform.**

Создаем Container Registry в yandex cloud. Создаем образ из Dockerfile и пушим его в Container Registry:

<img width="1356" height="450" alt="image" src="https://github.com/user-attachments/assets/7398a1ce-99cf-437a-b996-0fb50eb534f7" />

[Сам докерфайл](https://github.com/msiberian42/shvirtd-example-python/blob/main/Dockerfile.python)

В модуле web дорабатываем web-init.yml и блок template файл. Теперь при создании ВМ на ней создаются нужные каталоги и файлы compose.yaml, haproxy.cfg, default.conf, nginx.conf. .env, скачивается наш образ из регистра, а также образы nginx и haproxy и поднимается docker compose:

<img width="1030" height="667" alt="image" src="https://github.com/user-attachments/assets/5b4a3a79-f6bb-4030-ab63-1d8824794a2e" />

<img width="777" height="122" alt="image" src="https://github.com/user-attachments/assets/ae9a1d10-7b98-4eb0-9105-61e921df7ca9" />

<img width="718" height="123" alt="image" src="https://github.com/user-attachments/assets/d21070ab-7266-42f7-a49a-b02ff16ae27a" />

[Код](https://github.com/msiberian42/YC-Terraform-Docker-Project/tree/compose)

## Задание 4

**Завязывание работы приложения в контейнере на БД в Yandex Cloud.**

Удаляем из compose файла сервис db. Теперь приложение получает параметры базы данных и внутренний ip ВМ mysql при создании ВМ web через cloud-init:

<img width="525" height="483" alt="image" src="https://github.com/user-attachments/assets/78a44bd1-e70e-48e8-b760-97edae214d59" />

<img width="671" height="527" alt="image" src="https://github.com/user-attachments/assets/93cc7d9f-bc33-4f96-95fd-d61db6bd3600" />

Создание групп безопасности выносим в отдельный модуль. Добавляем в группу безопасности web порт 8090. [Код модуля](https://github.com/msiberian42/YC-Terraform-Docker-Project/tree/database/securiry)
Проверяем, что приложение и БД работают. Через интернет отправляем запрос по ip адресу web машины и порту 8090. В mysql появляется запись запроса:

<img width="631" height="87" alt="image" src="https://github.com/user-attachments/assets/e994a6fb-9764-4e16-a99a-9b9da5810443" />

<img width="578" height="270" alt="image" src="https://github.com/user-attachments/assets/c819fe9b-47f2-447d-9cf8-aa7294b03931" />

<img width="410" height="235" alt="image" src="https://github.com/user-attachments/assets/3c7df4c7-5eda-4438-87f7-bae9e66a8278" />

## Задание 5

**Настройка интеграции с lockbox**

Создаем в проекта модуль lockbox. Настраиваем в нем создание lockbox и генерацию пароля бд внутри него, чтобы приложение и база данных могли его получать оттуда, и при этом пароль не попадал в state:

<img width="727" height="477" alt="image" src="https://github.com/user-attachments/assets/cd4bd232-1d23-4270-b026-950fefc9f51e" />

<img width="850" height="263" alt="image" src="https://github.com/user-attachments/assets/54d938d1-964d-4342-95d1-8425dfeeae94" />

В модулях web и db убираем переменную db_password и настраиваем получение пароля из локбокса через data. Создаем сервисные аккаунты с ролью lockbox.payloadViewer:

<img width="807" height="233" alt="image" src="https://github.com/user-attachments/assets/615f5f98-472b-444d-ab8f-fd06b4600e7e" />

<img width="738" height="271" alt="image" src="https://github.com/user-attachments/assets/e20ab69a-5f60-4c8f-9aa0-1e89a755d157" />

[Код модуля](https://github.com/msiberian42/YC-Terraform-Docker-Project/tree/lockbox/lockbox)

[Репозиторий с итоговым кодом проекта](https://github.com/msiberian42/YC-Terraform-Docker-Project)

[Ссылка на веб-приложение](http://51.250.69.222:8090/)

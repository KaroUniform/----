# ITMO DevOps Practice

## Описание

Этот репозиторий содержит решения четырех лабораторных работ, выполненных в рамках курса по DevOps от ИТМО. 

## Содержание

### Лабораторная работа 1: Dockerfile и практики

- **Задача:** 
  - Написать два Dockerfile – один с плохими практиками, другой с хорошими.
  - Привести примеры двух плохих практик использования контейнеров.
- **Файлы:**
  - `ЛР 1. Dockerfile/BadDockerfile/Dockerfile`: Пример Dockerfile с плохими практиками.
  - `ЛР 1. Dockerfile/Dockerfile`: Пример Dockerfile с хорошими практиками.
  - `ЛР 1. Dockerfile/README.md`: Описание двух плохих практик использования контейнеров.

### Лабораторная работа 2: Docker Compose

- **Задача:** 
  - Создать `docker-compose.yml` файл, который включает в себя минимум три сервиса.
- **Файлы:**
  - `ЛР 2. Docker Compose/docker-compose.yml`: Конфигурационный файл Docker Compose для трех сервисов.
  - `ЛР 2. Docker Compose/init_config.sh`: Скрипт для инициализации конфигурации.
  - `ЛР 2. Docker Compose/README.md`: Описание лабораторной работы.

### Лабораторная работа 3: Kubernetes

- **Задача:**
  - Установить Kubernetes на локальную машину.
  - Развернуть тестовый сервис.
- **Файлы:**
  - `ЛР 3. Kubernetes/nc_configmap.yaml`: ConfigMap для тестового сервиса.
  - `ЛР 3. Kubernetes/nc_secret.yaml`: Secret для тестового сервиса.
  - `ЛР 3. Kubernetes/nextcloud.yaml`: Манифест для развертывания Nextcloud.
  - `ЛР 3. Kubernetes/pg_configmap.yaml`: ConfigMap для PostgreSQL.
  - `ЛР 3. Kubernetes/pg_deployment.yaml`: Deployment для PostgreSQL.
  - `ЛР 3. Kubernetes/pg_secret.yaml`: Secret для PostgreSQL.
  - `ЛР 3. Kubernetes/pg_service.yaml`: Service для PostgreSQL.
  - `ЛР 3. Kubernetes/README.md`: Описание лабораторной работы.

### Лабораторная работа 4: Собственный сервис в Kubernetes

- **Задача:**
  - Развернуть собственный сервис в Kubernetes по аналогии с лабораторной работой 3.
- **Файлы:**
  - `ЛР 4. More Kubernetes/app_configmap.yaml`: ConfigMap для собственного сервиса.
  - `ЛР 4. More Kubernetes/app_deployment.yaml`: Deployment для собственного сервиса.
  - `ЛР 4. More Kubernetes/app_pvc.yaml`: PersistentVolumeClaim для собственного сервиса.
  - `ЛР 4. More Kubernetes/pg_configmap.yaml`: ConfigMap для PostgreSQL.
  - `ЛР 4. More Kubernetes/pg_deployment.yaml`: Deployment для PostgreSQL.
  - `ЛР 4. More Kubernetes/pg_secret.yaml`: Secret для PostgreSQL.
  - `ЛР 4. More Kubernetes/pg_service.yaml`: Service для PostgreSQL.
  - `ЛР 4. More Kubernetes/README.md`: Описание лабораторной работы.

---

Этот репозиторий предназначен для образовательных целей и практики навыков DevOps.

# 1. Преподаватели 👨‍🎓

**Никита Самохин -** Lead DevOps/SRE команд аналитики и прогнозирования потребления ресурсов VTB.Cloud & T1.Cloud

# 2. Описание и цели/ результаты курса 📝

Курс посвящен знакомству и работе с технологиями контейнеризации и DevOps практиками. Предлагается подробно рассмотреть технологии контейнеризации и оркестрации, их особенности, преимущества/недостатки, и действительно ли они так повсеместно необходимы и почему. Повышенное внимание будет уделено природе понятия DevOps, а также особенностями микросервисной инфраструктуры. Также в рамках дисциплины будут получены практические навыки работы с Docker, Docker Compose и Kubernetes

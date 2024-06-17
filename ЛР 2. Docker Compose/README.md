# docker-compose.yml

Этот файл описывает конфигурацию для создания и управления несколькими Docker-контейнерами, необходимых для работы приложения, включающего PostgreSQL, инициализационный контейнер для создания конфигурационного файла JupyterHub и само приложение Jupyterhub.

## Сервисы

### postgres
```yaml
services:
  postgres:
    image: postgres:16
    container_name: postgres_db
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - pg_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 30s
      timeout: 10s
      retries: 5
    networks:
      - app_network
```
Этот сервис отвечает за базу данных PostgreSQL:
- `environment`: Устанавливаются переменные окружения, значения которых берутся из файла `.env`.
- `volumes`: Данные базы данных будут сохраняться в томе `pg_data`.
- `healthcheck`: Проверка состояния базы данных.
- `networks`: Контейнер подключен к сети `app_network`.

### init-config
```yaml
  init-config:
    image: busybox
    container_name: init_container
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      JUPYTERHUB_PORT: ${JUPYTERHUB_PORT}
    volumes:
      - ./init_config.sh:/init_config.sh
      - jupyter_data:/jupyterhub
    networks:
      - app_network
    entrypoint: ["sh", "/init_config.sh"]
```

Содержимое init_config.sh:
```bash
#!/bin/sh

mkdir -p /jupyterhub/config

cat > /jupyterhub/config/jupyterhub_config.py <<EOL
c.JupyterHub.ip = '0.0.0.0'
c.JupyterHub.port = ${JUPYTERHUB_PORT}
c.JupyterHub.hub_connect_ip = '127.0.0.1'
c.JupyterHub.db_url = 'postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}'
EOL
```

Этот сервис выполняет инициализационные действия для создания конфига JupyterHub:
- `image`: Используется образ `busybox`.
- `environment`: Переменные окружения, значения которых берутся из файла `.env`.
- `volumes`: 
  - Локальный файл `init_config.sh` монтируется внутрь контейнера.
  - Том `jupyter_data` монтируется в контейнер для сохранения результата работы скрипта.
- `networks`: Контейнер подключен к сети `app_network`.
- `entrypoint`: Скрипт `init_config.sh` выполняется при запуске контейнера.

### app
```yaml
  app:
    build:
      context: .
      dockerfile: Dockerfile
    image: my-jupyter
    container_name: app_service
    depends_on:
      postgres:
        condition: service_healthy
      init-config:
        condition: service_completed_successfully
    ports:
      - ${JUPYTERHUB_PORT}:${JUPYTERHUB_PORT}
    volumes:
      - jupyter_data:/jupyterhub
    entrypoint: ["jupyterhub", "-f", "/jupyterhub/config/jupyterhub_config.py"]
    networks:
      - app_network
```
Этот сервис запускает приложение JupyterHub:
- `build`: Указано, что образ для контейнера должен собираться из локального `Dockerfile`.
- `container_name`: Контейнер будет называться `app_service`.
- `depends_on`: Контейнер запускается только после того, как PostgreSQL контейнер будет в состоянии `healthy`, а `init-config` успешно выполнится.
- `ports`: Пробрасывает порт, указанный в переменной окружения `JUPYTERHUB_PORT`, наружу.
- `volumes`: Том `jupyter_data` монтируется для доступа к конфигурации JupyterHub.
- `entrypoint`: Запускает JupyterHub с использованием файла конфигурации.
- `networks`: Контейнер подключен к сети `app_network`.

## Тома
```yaml
volumes:
  pg_data:
  jupyter_data:
```
Определение именованных томов для хранения данных базы данных и конфигурации JupyterHub.

## Сети
```yaml
networks:
  app_network:
    driver: bridge
```
Определение пользовательской сети `app_network` для взаимодействия контейнеров между собой.

Этот файл `docker-compose.yml` обеспечивает интеграцию нескольких контейнеров для работы приложения с использованием PostgreSQL и JupyterHub, включая инициализационные шаги для настройки.

# Результат

![Результат работы](image.jpg)

# Вопросы

- Можно ли ограничивать ресурсы (например, память или CPU) для сервисов в docker-compose.yml? Если нет, то почему, если да, то как?

    В docker-compose.yml можно ограничивать ресурсы для сервисов. Пример:
    ```yaml
    services:
      frontend:
        image: example/webapp
        deploy:
          resources:
          limits:
          cpus: '0.50'
          memory: 50M
          pids: 1
          reservations:
          cpus: '0.25'
          memory: 20M
    ```

- Как можно запустить только определенный сервис из docker-compose.yml, не запуская остальные?
  
    Для реализации этого необходимо передать команде название сервиса. Например `docker compose up app`.
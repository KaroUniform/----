# Ход работы

## 1. Создание Secret для PostgreSQL

Отдельный файл с манифестом выглядит следующим образом:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: pg-auth-data
  labels:
    app: postgres
type: Opaque
stringData:
  POSTGRES_USER: "postgres"
  POSTGRES_PASSWORD: "password"
```

Для использования данного объекта необходимо изменить манифест Deployment:

```yaml
spec:
  template:
    spec:
      containers:   
        - name: postgres-container
          envFrom:
            - configMapRef:
                name: postgres-configmap
            - secretRef:
                name: pg-auth-data
```

## 2. Выделение манифеста Secret для NextCloud в отдельный файл

Для улучшения читаемости выделяем манифест в отдельный файл.


## 3. Создание ConfigMap для NextCloud

Манифест представлен ниже:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nextcloud-configmap
  labels:
    app: nextcloud
data:
  NEXTCLOUD_UPDATE: "1"
  ALLOW_EMPTY_PASSWORD: "yes"
  POSTGRES_HOST: "postgres-service"
  NEXTCLOUD_TRUSTED_DOMAINS: "127.0.0.1"
  NEXTCLOUD_ADMIN_USER: "admin"
```

Для использования данных, которые теперь в манифесте Secret для PostgreSQL и в манифесте ConfigMap для Nextcloud 
конфигурацию Deployment для NextCloud нужно изменить:

```yaml
spec:
  template:
    spec:
      containers:
        - name: nextcloud
          envFrom:
            - configMapRef:
                name: nextcloud-configmap
            - secretRef:
                name: pg-auth-data
            - secretRef:
                name: nextcloud-secret
```

## 4. Добавление livenessProbe и readinessProbe

livenessProbe и readinessProbe будут выполнять запрос на localhost/status.php с помощью curl
с начальной задержкой в 10 секунд каждая.
```yaml
spec:
  template:
    spec:
      containers:
        - name: nextcloud
          livenessProbe:
            exec:
              command:
                - curl
                - -f
                - http://localhost/status.php
            initialDelaySeconds: 10
          readinessProbe:
            exec:
              command:
                - curl
                - -f
                - http://localhost/status.php
            initialDelaySeconds: 10
```
⚠️ Выполняется именно curl запрос, потому что nextcloud при использовании httpGet возвращает 400 и probe не проходят. К сожалению, мне не удалось понять, чем это обусловлено -- ошибка 400 очень неинформативная и связана с внутренней логикой самого приложения, а не слоя виртуализации. 

## Результаты работы
![Созданные Deployment](images/image1.jpg)
![Логи NextCloud](images/image2.jpg)

# Ответы на вопросы

## Важен ли порядок выполнения этих манифестов? Почему?

Порядок манифестов важен в случаях, когда один ресурс зависит от другого. 
Утилита kubectl при передачи нескольких файлов учитывает порядок и создает сначала ресурсы, 
которые необходимы другим ресурсам.

## Вопрос: что (и почему) произойдет, если отскейлить количество реплик postgres-deployment в 0, затем обратно в 1, после чего попробовать снова зайти на Nextcloud? 

Для Nextcloud станет недоступна база данных, все данные, хранящиеся в PostgreSQL, будут удалены вместе с подом. Когда мы отскейлим количество реплик обратно в 1, будет создан новый под с базой данных. Если Persistent Volume не настроен, данные не сохранятся, что приведет к ошибке 500 в Nextcloud. Если же Persistent Volume настроен, данные сохранятся, и Nextcloud продолжит работу без ошибок.
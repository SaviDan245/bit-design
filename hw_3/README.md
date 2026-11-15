# ДЗ 3. Многоконтейнерное приложение через docker-compose

Приложение из ДЗ 2 (Spring Boot), к которому добавлена работа с PostgreSQL.

Эндпоинты:
- `GET /health` — возвращает `{"status":"UP"}`
- `GET /visits` — добавляет запись в таблицу `visits` и возвращает количество записей

## Сервисы

| Сервис | Образ | Сети | Порты наружу |
|---|---|---|---|
| nginx | nginx:1.27-alpine | frontend | 80 |
| app | собирается из `./app` | frontend, backend | — |
| db | postgres:16-alpine | backend | — |
| adminer | adminer:5 | frontend, backend | — |

## Запуск

```bash
cd hw_3
cp .env.example .env
docker compose up -d --build
docker compose ps
```

В `.env` нужно поменять пароль `POSTGRES_PASSWORD`.

## Проверка

Приложение доступно через nginx:

```bash
curl localhost/health
curl localhost/visits
curl localhost/visits
```

Наружу открыт только 80 порт:

```bash
docker compose ps
curl localhost:8080/health
nc -z localhost 5432
```

Данные сохраняются между перезапусками:

```bash
curl localhost/visits
docker compose down
docker compose up -d
curl localhost/visits
```

Adminer: открыть `http://localhost/adminer/`, система `PostgreSQL`, сервер `db`, логин, пароль и база из `.env`.

## Остановка

```bash
docker compose down
```

С удалением тома с данными:

```bash
docker compose down -v
```

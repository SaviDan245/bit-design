# ДЗ 4. Ansible: установка nginx и деплой приложения

## Контейнеры

| Контейнер | Образ | Назначение |
|---|---|---|
| ansible-master | собирается из `docker/ansible` | ansible, ssh ключ, собранный архив приложения `/artifacts/app.tar.gz` |
| web-server | собирается из `docker/node` | "чистая" Ubuntu 24.04, только sshd. Сюда ставится nginx, наружу открыт 80 порт |
| app-server | собирается из `docker/node` | "чистая" Ubuntu 24.04, только sshd. Сюда деплоится приложение |
| db | postgres:16-alpine | вспомогательный контейнер с базой данных для приложения |

## Запуск

```bash
cd hw_4
cp .env.example .env
docker compose up -d --build
docker compose ps
```

В `.env` нужно поменять пароль `POSTGRES_PASSWORD`.

Проверка доступа ansible к серверам:

```bash
docker compose exec ansible-master ansible all -m ping
```

Запуск плейбука:

```bash
docker compose exec ansible-master ansible-playbook site.yml
```

## Проверка

```bash
docker compose ps
curl localhost/health
curl localhost/visits
curl localhost/visits
```

Состояние приложения на сервере:

```bash
docker compose exec app-server cat /opt/app/app.pid
docker compose exec app-server tail /opt/app/logs/app.log
docker compose exec web-server nginx -t
```

Перезапуск приложения скриптами:

```bash
docker compose exec -u app app-server /opt/app/stop.sh
docker compose exec -u app app-server /opt/app/start.sh
```

## Остановка

```bash
docker compose down -v
```

## Скриншоты

Лежат в директории `./hw4/screenshots`.

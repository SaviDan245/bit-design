#!/bin/bash

if [ ! -f /keys/id_ed25519 ]; then
    ssh-keygen -t ed25519 -N "" -f /keys/id_ed25519 -C ansible-master
    if [ $? -ne 0 ]; then
        echo "Ошибка: не удалось сгенерировать ssh ключ"
        exit 1
    fi
    echo "Ssh ключ сгенерирован"
fi

exec sleep infinity

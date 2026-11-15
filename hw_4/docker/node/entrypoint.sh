#!/bin/bash

echo "Ожидание ssh ключа от ansible-master"
while [ ! -f /keys/id_ed25519.pub ]; do
    sleep 1
done

mkdir -p /home/ansible/.ssh
cp /keys/id_ed25519.pub /home/ansible/.ssh/authorized_keys
chown -R ansible:ansible /home/ansible/.ssh
chmod 700 /home/ansible/.ssh
chmod 600 /home/ansible/.ssh/authorized_keys

ssh-keygen -A
if [ $? -ne 0 ]; then
    echo "Ошибка: не удалось сгенерировать ключи хоста"
    exit 1
fi

exec /usr/sbin/sshd -D -e

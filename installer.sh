#!/bin/bash

# Обновляем список пакетов
sudo apt update

# Устанавливаем необходимые пакеты
sudo apt install -y build-essential wget

# Скачиваем архив с 3proxy
wget https://github.com/z3APA3A/3proxy/archive/0.9.4.tar.gz

# Распаковываем архив
tar -xvzf 0.9.4.tar.gz

# Переходим в папку 3proxy
cd 3proxy-0.9.4

# Компилируем 3proxy
make -f Makefile.Linux

# Копируем скомпилированный файл в системную папку
sudo cp bin/3proxy /usr/bin/

# Даём права на выполнение
sudo chmod +x /usr/bin/3proxy

# Создаем каталог для конфигурационных файлов
sudo mkdir /etc/3proxy

# Создаем конфигурационный файл и записываем в него настройки
sudo tee /etc/3proxy/3proxy.cfg > /dev/null <<EOF
nserver 1.1.1.1
nserver 1.0.0.1

daemon

auth cache strong
users "$(openssl rand -base64 6):CL:$(openssl rand -base64 8)"

socks -n -p8080 -a

nscache 65536
timeouts 1 5 30 60 180 1800 15 60
EOF

# Запускаем 3proxy с указанием пути к конфигурационному файлу
sudo 3proxy /etc/3proxy/3proxy.cfg

# Получаем информацию о логине, IP и пароле
echo "Логин: $(grep "users" /etc/3proxy/3proxy.cfg | awk '{print $2}' | cut -d':' -f1)"
echo "IP: $(hostname -I)"
echo "Пароль: $(grep "users" /etc/3proxy/3proxy.cfg | awk '{print $4}')"

#!/bin/bash

# Приветствие
whiptail --title "Welcome to Installer" --msgbox "Универсальный Ubuntu/Debian Linux установщик." 8 60

# Запрос пути установки
TARGET=$(whiptail --title "Место установки" --inputbox "Куда ставим? Пример: /media/flash" 10 60 /mnt 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
echo "Место установки:" $TARGET
else
echo "Вы отменили установку."
exit 1
fi

# Запрос архитектуры
DEB_ARCH=$(whiptail --title "Выбор архитектуры" --radiolist \
"Важно понимать, что ОС которую хотите установить должна иметь туже архитектуру, что и та из которой устанавливаете." 15 60 2 \
"i386" "x86 (i386) 32Bit" ON \
"amd64" "x64 (amd64) 64Bit" OFF 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
echo "Выбрана архитектура:" $DEB_ARCH
else
echo "Вы отменили установку."
exit 1
fi

# Выбор дистрибутива
DISTRO=$(whiptail --title "Выбор ОС" --radiolist \
"Выберите дистрибутив." 15 60 2 \
"Ubuntu" "Ubuntu" ON \
"Debian" "Debian" OFF 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
echo "Выбран дистрибутив:" $DISTRO
. /lib/uli/function/$DISTRO
else
echo "Вы отменили установку."
exit 1
fi

# Установка базовой системы
debootstrap --arch $DEB_ARCH --include=nano,wget,tasksel $VEROS $MIRROR

# Монтирование ФС dev sys proc в новую систему.
mount -o bind /dev $TARGET/dev
mount -o bind /sys $TARGET/sys
mount -o bind /proc $TARGET/proc

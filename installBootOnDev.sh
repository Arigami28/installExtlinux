#!/usr/bin/env bash

#добавление конфигурационного файла
source ./config.cfg


# Функция обнаружения ошибок
function detectError {

if [ $? -ne 0 ]; then
echo -e "\033[31mERROR\033[0m"
else
echo -e "\033[32mOK\033[0m"
fi

}

##проверка на то что пользователь запустил скрипт из под root
if [ "$UID" != "0" -a "$UID" != "" ];then
echo ""
echo -e "Вы не суперпользователь."
echo -e "Для работы скрипта надо запустить его от пользователя root."
echo ""
exit 1
fi

echo -e "Устройство монтируется...\c"
mount $uuidDISK $TARGET
detectError

echo -e "Копирование загрузчика на устройство...\c"
cp -Rf $BOOT $TARGET/boot/
detectError


echo -e "Установка загрузчика на устройство...\c"
extlinux -i $TARGET/boot/$BOOT > /dev/null 2>&1
detectError


echo -e "Установка MBR записи...\c"
cat $TARGET/boot/$BOOT/mbr.bin > $parentDISK
detectError


echo -e "Установка меню...\c"
echo -e $MENU > $TARGET/boot/$BOOT/syslinux.cfg
detectError


echo -e "Размонтирование устройства...\c"
umount -f "$(readlink -m storage)"
detectError


echo -e "\033[32mГОТОВО!\033[0m"

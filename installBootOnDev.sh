#!/usr/bin/env bash

#���������� ����������������� �����
source ./config.cfg


# ������� ����������� ������
function detectError {

if [ $? -ne 0 ]; then
echo -e "\033[31mERROR\033[0m"
else
echo -e "\033[32mOK\033[0m"
fi

}

##�������� �� �� ��� ������������ �������� ������ �� ��� root
if [ "$UID" != "0" -a "$UID" != "" ];then
echo ""
echo -e "�� �� �����������������."
echo -e "��� ������ ������� ���� ��������� ��� �� ������������ root."
echo ""
exit 1
fi

echo -e "���������� �����������...\c"
mount $uuidDISK $TARGET
detectError

echo -e "����������� ���������� �� ����������...\c"
cp -Rf $BOOT $TARGET/boot/
detectError


echo -e "��������� ���������� �� ����������...\c"
extlinux -i $TARGET/boot/$BOOT > /dev/null 2>&1
detectError


echo -e "��������� MBR ������...\c"
cat $TARGET/boot/$BOOT/mbr.bin > $parentDISK
detectError


echo -e "��������� ����...\c"
echo -e $MENU > $TARGET/boot/$BOOT/syslinux.cfg
detectError


echo -e "��������������� ����������...\c"
umount -f "$(readlink -m storage)"
detectError


echo -e "\033[32m������!\033[0m"

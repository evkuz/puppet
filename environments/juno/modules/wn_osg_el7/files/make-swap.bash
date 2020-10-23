#!/bin/bash

SWAP_LINES="$(swapon -s | wc -l)"
#echo "Lines number value is  ${SWAP_LINES}"


if [ $SWAP_LINES -lt 3 ]
then 
DEV="/dev/vdc"

mkswap $DEV
# Вывод blkid направляем в sed, получаем UUID swap-раздела/диска
SWAP_UUID="$(blkid $DEV | sed -n 's/.*\(UUID=".*\s\).*TYPE.*$/\1/p' | sed -n 's/"//gp')"

ONLY_UUID=$(echo "${SWAP_UUID}" | sed -n 's/UUID=//p')


swapon -U $ONLY_UUID

echo "${SWAP_UUID}      none    swap    sw      0  0" >> /etc/fstab
fi


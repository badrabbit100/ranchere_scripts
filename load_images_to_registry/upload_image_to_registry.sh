#!/bin/bash

echo "[*] Введи название образа..."
read image_name

echo $image_name > r.txt
./rancher-save-images.sh --image-list r.txt && ./rancher-load-images.sh --image-list ./r.txt --registry 192.168.0.100:5000
rancher-images.tar.gz
echo "[*] Готово"

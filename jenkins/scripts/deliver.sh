#!/usr/bin/env sh

# Instalasi dependensi aplikasi
npm install

# Membangun aplikasi React untuk produksi
set -x
npm run build
set +x

# Menjalankan aplikasi React dalam mode pengembangan
set -x
npm start &
sleep 1
echo $! > .pidfile
set +x
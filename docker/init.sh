#!/bin/sh

#backend
gitMaster="\.\.\/\.git\/refs\/heads\/master"
git ls-remote https://github.com/mempool/mempool.git "$1^{}" | awk '{ print $1}' > ./backend/master
cp ./docker/backend/* ./backend/
sed -i "s/${gitMaster}/master/g" ./backend/src/api/backend-info.ts

#frontend
localhostIP="127.0.0.1"
cp ./docker/frontend/* ./frontend
cp ./nginx.conf ./frontend/
cp ./nginx-mempool.conf ./frontend/
sed -i "s/${localhostIP}:80/0.0.0.0:__MEMPOOL_FRONTEND_HTTP_PORT__/g" ./frontend/nginx.conf
sed -i "s/${localhostIP}/0.0.0.0/g" ./frontend/nginx.conf
sed -i "s/user nobody;//g" ./frontend/nginx.conf
sed -i "s!/etc/nginx/nginx-mempool.conf!/etc/nginx/conf.d/nginx-mempool.conf!g" ./frontend/nginx.conf
sed -i "s/${localhostIP}:8999/__MEMPOOL_BACKEND_MAINNET_HTTP_HOST__:__MEMPOOL_BACKEND_MAINNET_HTTP_PORT__/g" ./frontend/nginx-mempool.conf

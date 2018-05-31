#!/bin/sh

for i in `seq 1 100`; do
    cat <<EOF
server {
    server_name host${i};
    listen 80;
    location / {
        proxy_pass http://local;
    }
}
EOF
done

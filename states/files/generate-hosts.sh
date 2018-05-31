#!/bin/sh

for i in `seq 1 100`; do
    cat <<EOF
127.0.0.1 host${i}
EOF
done

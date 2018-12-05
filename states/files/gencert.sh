#!/bin/sh

if [ $# -lt 1 ]; then
	echo "usage: `basename $0` domain" >&2
	exit 1
fi

DOMAIN=$1

openssl genrsa -out $DOMAIN.key 2048 && \
openssl req -new -key $DOMAIN.key -batch -subj /CN=$DOMAIN/ -out $DOMAIN.csr && \
openssl x509 -req -days 365 -in $DOMAIN.csr -signkey $DOMAIN.key -out $DOMAIN.pem && \
rm $DOMAIN.csr

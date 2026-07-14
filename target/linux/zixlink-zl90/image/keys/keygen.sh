#!/bin/sh

openssl genrsa -out dev.key 2048
openssl req -batch -new -x509 -key dev.key -out dev.crt
openssl rsa -in dev.key -pubout -out dev.pubkey

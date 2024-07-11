#!/bin/bash

# Gerar a CA (Certificate Authority)
# Gerar chave privada da CA
openssl genrsa -out ca.key 2048
# Gerar o certificado da CA
openssl req -new -x509 -key ca.key -out ca.crt -days 365 -subj "/C=BR/ST=Distrito Federal/L=Brasilia/O=andre/OU=andre/CN=andre"

# Gerar certificados do servidor
# Gerar chave privada do servidor
openssl genrsa -out server.key 2048
# Gerar CSR (Certificate Signing Request) do servidor
openssl req -new -key server.key -out server.csr -subj "/C=BR/ST=Distrito Federal/L=Brasilia/O=andre/OU=andre/CN=andre"
# Assinar o CSR do servidor com a CA para gerar o certificado do servidor
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365

# Gerar certificados do cliente
# Gerar chave privada do cliente
openssl genrsa -out client.key 2048
# Gerar CSR do cliente
openssl req -new -key client.key -out client.csr -subj "/C=BR/ST=Distrito Federal/L=Brasilia/O=andre/OU=andre/CN=Client"
# Assinar o CSR do cliente com a CA para gerar o certificado do cliente
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days 365
# Converter o certificado do cliente para o formato PKCS12 (se necessário) para importação no navegador
openssl pkcs12 -export -out client.p12 -inkey client.key -in client.crt
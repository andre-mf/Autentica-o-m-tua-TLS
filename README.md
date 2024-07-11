 # 🔑 Autenticação mútua TLS

📜 Mais informações: https://www.cloudflare.com/pt-br/learning/access-management/what-is-mutual-tls/


## Passo 1: Gerar a CA (Certificate Authority)

1. #### Gerar chave privada da CA:
   
   ```bash
   openssl genrsa -out ca.key 2048
   ```

2. #### Gerar o certificado da CA:
   
   ```bash
   openssl req -new -x509 -key ca.key -out ca.crt -days 365 -subj "/C=BR/ST=State/L=City/O=Organization/OU=OrgUnit/CN=example.com"
   ```

## Passo 2: Gerar certificados do servidor

1. #### Gerar chave privada do servidor:
   
   ```bash
   openssl genrsa -out server.key 2048
   ```

2. #### Gerar CSR (Certificate Signing Request) do servidor:
   
   ```bash
   openssl req -new -key server.key -out server.csr -subj "/C=BR/ST=State/L=City/O=Organization/OU=OrgUnit/CN=localhost"
   ```

3. #### Assinar o CSR do servidor com a CA para gerar o certificado do servidor:
   
   ```bash
   openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365
   ```


## Passo 3: Gerar certificados do cliente

1. #### Gerar chave privada do cliente:
   
   ```bash
   openssl genrsa -out client.key 2048
   ```

2. #### Gerar CSR do cliente:
   
   ```bash
   openssl req -new -key client.key -out client.csr -subj "/C=BR/ST=State/L=City/O=Organization/OU=OrgUnit/CN=Client"
   ```

3. #### Assinar o CSR do cliente com a CA para gerar o certificado do cliente:
   
   ```bash
   openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days 365
   ```

4. #### Converter o certificado do cliente para o formato PKCS12 (se necessário) para importação no navegador:
   
   ```bash
   openssl pkcs12 -export -out client.p12 -inkey client.key -in client.crt
   ```

5. #### Importar o certificado do cliente no navegador:
   - **Chrome**: Vá para Configurações > Privacidade e segurança > Segurança > Gerenciar certificados > Importar.
   - **Firefox**: Vá para Configurações > Privacidade e Segurança > Certificados > Ver certificados > Importar.
   
## Passo 4: Configurar o NGINX

1. #### Arquivo de Configuração:
   
   ```nginx
   server {
       listen 443 ssl;
       server_name localhost;
   
       ssl_certificate /caminho/para/server.crt;
       ssl_certificate_key /caminho/para/server.key;
   
       ssl_client_certificate /caminho/para/ca.crt;
       ssl_verify_client on;
   
       location / {
           root /caminho/para/sua/pagina/web;
           index index.html;
       }
   }
   
   server {
       listen 80;
       server_name localhost;
       return 301 https://$host$request_uri;
   }
   
   ```

2. #### Testar a configuração do NGINX:
   
   ```bash
   sudo nginx -t
   ```

3. #### Reiniciar o NGINX:
   
   ```bash
   sudo systemctl restart nginx
   ```
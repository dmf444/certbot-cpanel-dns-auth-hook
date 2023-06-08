FROM certbot/certbot
LABEL authors="dmf444"
LABEL org.opencontainers.image.source=https://github.com/dmf444/certbot-cpanel-dns-auth-hook
LABEL org.opencontainers.image.description="A container for updating SSL certs, through the cPanel API."

ARG CSV_DOMAINS

ENV CPANEL_DNS_CPANEL_URI="https://cpanel.example.com:2083"
ENV CPANEL_DNS_CPANEL_AUTH_USERNAME="username"
ENV CPANEL_DNS_CPANEL_AUTH_PASSWORD="password"
# This can either be token or password. Defines what is used in password var above
ENV CPANEL_DNS_CPANEL_AUTH_METHOD="token"
ENV CPANEL_DNS_CPANEL_DELAY="120"
ENV EMAIL="fake@test.com"
ENV CSVDOM=$CSV_DOMAINS

WORKDIR /opt/certbot
COPY cpanel-dns.py .
COPY create.sh .
COPY delete.sh .
COPY deploy.sh .

# ENTRYPOINT top
ENTRYPOINT certbot certonly -n --manual --agree-tos --email $EMAIL --manual-auth-hook "/opt/certbot/create.sh" --manual-cleanup-hook "/opt/certbot/delete.sh" --deploy-hook "/opt/certbot/deploy.sh" --preferred-challenges dns-01 -d $CSVDOM
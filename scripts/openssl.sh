#! /bin/bash

# bash openssl.sh cool.nxest.local 192.168.1.238

if [ "$#" -ne 2 ]; then
    echo "Error: No domain name and master ip argument provided"
    echo "Usage: Provide domain name and master ip as arguments"
    exit 1
fi

DOMAIN=$1
MASTER_IP=$2

# Create root CA & Private key

# add the blew v3_ca to /etc/ssl/openssl.cnf for MacOS
# [ v3_ca ]
# basicConstraints = critical,CA:TRUE
# subjectKeyIdentifier = hash
# authorityKeyIdentifier = keyid:always,issuer:always

    
openssl req -x509 \
    -sha256 -days 3650 \
    -nodes \
    -newkey rsa:2048 \
    -subj "/CN=${DOMAIN}/C=US/L=San Fransisco" \
    -extensions v3_ca \
    -keyout ca.key -out ca.crt

# Generate Private key

openssl genrsa -out ${DOMAIN}.key 2048

# Create csf conf

cat >csr.conf <<EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = US
ST = California
L = San Fransisco
O = MLopsHub
OU = MlopsHub Dev
CN = ${DOMAIN}

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = ${DOMAIN}
DNS.2 = www.${DOMAIN}
DNS.3 = *.${DOMAIN}
IP.1 = ${MASTER_IP}

EOF

# create CSR request using private key

openssl req -new -key ${DOMAIN}.key -out ${DOMAIN}.csr -config csr.conf

# Create a external config file for the certificate

cat >cert.conf <<EOF

authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${DOMAIN}
DNS.2 = *.${DOMAIN}

EOF

# Create SSl with self signed CA

openssl x509 -req \
    -in ${DOMAIN}.csr \
    -CA ca.crt -CAkey ca.key \
    -CAcreateserial -out ${DOMAIN}.crt \
    -days 3650 \
    -sha256 -extfile cert.conf

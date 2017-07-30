#!/bin/bash

# Create the directory to hold the certificates.
mkdir -p "${PREFIX}/ssl"

# Copy the certificates from certifi.
cp -f "${SRC_DIR}/certifi/cacert.pem" "${PREFIX}/ssl"
ln -fs "${PREFIX}/ssl/cacert.pem" "${PREFIX}/ssl/cert.pem"

#! /bin/bash

echo "generating connector configuration json files from .env"
echo

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source ${DIR}/../.env

for i in example_datagen_clickstream.json example_datagen_shoe_customers.json example_datagen_shoe_orders.json example_datagen_shoes.json example_mongodb_sink.json; do
    sed -e "s|<add_your_api_key>|${CCLOUD_API_KEY}|g" \
    -e "s|<add_your_api_secret_key>|${CCLOUD_API_SECRET}|g" \
    -e "s|<add_mongo_host_address>|${MONGO_ENDPOINT}|g" \
    -e "s|<mongo_host_address>|${MONGO_ENDPOINT}|g" \
    -e "s|<add_mongo_username>|${MONGO_USERNAME}|g" \
    -e "s|<add_mongo_password>|${MONGO_PASSWORD}|g" \
    -e "s|<add_mongo_database_name>|${MONGO_DATABASE_NAME}|g" \
    ${DIR}/$i > ${DIR}/actual_${i#example_}
done
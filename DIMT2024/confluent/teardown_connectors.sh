#!/bin/bash

# Source the .env file
current_dir=$(pwd)
parent_dir=$(dirname "$current_dir")

env_file="${parent_dir}/.env"

# Use confluent environment
confluent login --save
export CCLOUD_ENV_ID=$(confluent environment list -o json \
    | jq -r '.[] | select(.name | contains('\"${CCLOUD_ENV_NAME:-Data_In_Motion_Tour}\"')) | .id')

confluent env use $CCLOUD_ENV_ID

# Use kafka cluster
export CCLOUD_CLUSTER_ID=$(confluent kafka cluster list -o json \
    | jq -r '.[] | select(.name | contains('\"${CCLOUD_CLUSTER_NAME:-dimt_kafka_cluster}\"')) | .id')

confluent kafka cluster use $CCLOUD_CLUSTER_ID

# Get cluster bootstrap endpoint
export CCLOUD_BOOTSTRAP_ENDPOINT=$(confluent kafka cluster describe -o json | jq -r .endpoint)

# Get the ID for all connectors
datagen_shoe_cliskstream=$(confluent connect cluster list -o json | jq -r '.[] | select(.name | contains ("Datagen_Shoe_Clickstream")) | .id')
datagen_shoe_customers=$(confluent connect cluster list -o json | jq -r '.[] | select(.name | contains ("Datagen_Shoe_Customers")) | .id')
datagen_shoe_orders=$(confluent connect cluster list -o json | jq -r '.[] | select(.name | contains ("Datagen_Shoe_Orders")) | .id')
datagen_shoes=$(confluent connect cluster list -o json | jq -r '.[] | select(.name | contains ("Datagen_Shoes")) | .id')
mongodb_id=$(confluent connect cluster list -o json | jq -r '.[] | select(.name | contains ("MongoDbAtlasSinkConnector")) | .id')

# Delete all connectors
echo "Deleting connectors..."
confluent connect cluster delete --force "$datagen_shoe_cliskstream"
confluent connect cluster delete --force "$datagen_shoe_customers"
confluent connect cluster delete --force "$datagen_shoe_orders"
confluent connect cluster delete --force "$datagen_shoes"
confluent connect cluster delete --force "$mongodb_id"

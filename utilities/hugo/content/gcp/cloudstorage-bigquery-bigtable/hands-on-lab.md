---
title: "Hands-on Lab"
date: 2022-02-28T19:23:00-08:00
draft: false
weight: 3
---

Welcome to the live session!

## Step 1: Create a ksqlDB application
> At Confluent we developed ksqlDB, the database purpose-built for stream processing applications. ksqlDB is built on top of Kafka Streams, powerful Java library for enriching, transforming, and processing real-time streams of data. Having Kafka Streams at its core means ksqlDB is built on well-designed and easily understood layers of abstractions. So now, beginners and experts alike can easily unlock and fully leverage the power of Kafka in a fun and accessible way.
1. On the navigation menu, select **ksqlDB**.
1. Click on **Create cluster myself**.
1. Choose **Global access** for the access level and hit **Continue**.
1. Pick a name or leave the name as is.
1. Select **1** as the cluster size. 
1. Hit **Launch Cluster!**. 
---
## Step 2: Create "ratings" topic
1. On the navigation menu, select **Topics**.
> Click **Create topic on my own** or if you already created a topic, click on the **+ Add topic** button on the top right side of the table.
2. Type **ratings** as the Topic name and hit **Create with defaults**. 
---
## Step 3: Create a Datagen Source connector
> Confluent offers 120+ pre-built [connectors](https://www.confluent.io/product/confluent-connectors/), enabling you to modernize your entire data architecture even faster. These connectors also provide you peace-of-mind with enterprise-grade security, reliability, compatibility, and support.
1. On the navigation menu, select **Data Integration** and then **Connectors** and **+ Add connector**.
1. In the search bar search for **Datagen** and select the **Datagen Source** which is a fully-managed connector that we will use to generate sample data with it. 
1. Use the following parameters to configure your connector
```
{
  "name": "DatagenSourceConnector_0",
  "config": {
    "connector.class": "DatagenSource",
    "name": "DatagenSourceConnector_0",
    "kafka.auth.mode": "KAFKA_API_KEY",
    "kafka.api.key": "<add_your_api_key>",
    "kafka.api.secret": "<add_your_api_secret_key>",
    "kafka.topic": "ratings",
    "output.data.format": "AVRO",
    "quickstart": "RATINGS",
    "tasks.max": "1"
  }
}
```
---
## Step 4: Create customers topic
1. On the navigation menu, select **Topics**.
> Click **Create topic on my own** or if you already created a topic, click on the **+ Add topic** button on the top right side of the table.
2. Type **mysql.demo.CUSTOMERS_INFO** as the Topic name. The name of the topic is crucial so make sure you use the exact name and capitalization. 
3. Click on **Show advanced settings** and under **Storage → Cleanup policy → Compact** and **Retention time → Indefinite** and then click on **Create**.
---
## Step 5: Create a MySQL CDC Source connector
1. On the navigation menu, select **Data Integration** and then **Connectors** and **+ Add connector**.
1. In the search bar search for **MySQL CDC** and select the **MySQL CDC Source** which is a fully-managed source connector. 
1. Use the following parameters to configure your connector
```
{
  "name": "MySqlCdcSourceConnector_0",
  "config": {
    "connector.class": "MySqlCdcSource",
    "name": "MySqlCdcSourceConnector_0",
    "kafka.auth.mode": "KAFKA_API_KEY",
    "kafka.api.key": "<add_your_api_key>",
    "kafka.api.secret": "<add_your_api_secret_key>",
    "database.hostname": "<will_be_given_during_lab>",
    "database.port": "3306",
    "database.user": "<will_be_given_during_lab>",
    "database.password": "<will_be_given_during_lab>",
    "database.server.name": "mysql",
    "database.ssl.mode": "preferred",
    "snapshot.mode": "when_needed",
    "output.data.format": "AVRO",
    "after.state.only": "true",
    "tasks.max": "1"
  }
}
```
---
## Step 6: Create "users" topic
1. On the navigation menu, select **Topics**.
> Click **Create topic on my own** or if you already created a topic, click on the **+ Add topic** button on the top right side of the table.
2. Type **users** as the Topic name and hit **Create with defaults**. 
---
## Step 7: Create a Datagen Source connector
1. On the navigation menu, select **Data Integration** and then **Connectors** and **+ Add connector**.
1. In the search bar search for **Datagen** and select the **Datagen Source** which is a fully-managed connector. 
1. Use the following parameters to configure your connector
```
{
  "name": "DatagenSourceConnector_1",
  "config": {
    "connector.class": "DatagenSource",
    "name": "DatagenSourceConnector_0",
    "kafka.auth.mode": "KAFKA_API_KEY",
    "kafka.api.key": "<add_your_api_key>",
    "kafka.api.secret": "<add_your_api_secret_key>",
    "kafka.topic": "users",
    "output.data.format": "AVRO",
    "quickstart": "USERS",
    "tasks.max": "1"
  }
}
```
---
## Step 8: Create GCP services

### BigQuery
1. Navigate to https://console.cloud.google.com and log into your account. 
2. Use the search bar and search for **BigQuery**
> You should have a valid project in Google Cloud in order to complete this lab. 
3. Use the 3 dots next to your project name and click on **Create a new dataset** with following configuration. 
```
Dataset ID: confluent_bigquery_demo
Data location: same as your Confluent Cloud Cluster (in this lab us-west-4).
```
4. Click on **CREATE DATASET**.

> For detailed instructions refer to our [documentation](https://docs.confluent.io/cloud/current/connectors/cc-gcp-bigquery-sink.html).

### Cloud Storage

1. Create a **Cloud Storage** bucket with the following configuration and leave the remaining fields as default.
```
Name: confluent-bucket-demo
Location type: Region. Pick the same region as your Confluent Cloud cluster (In this lab we use us-west-4).
Storage class: Standard
```
2. Click on **CREATE**.

> For detailed instructions refer to our [documentation](https://docs.confluent.io/cloud/current/connectors/cc-gcs-sink.html).

### BigTable

1. Create a **BigTable** instance with the following configurations and leave the remaining fields as default.
```
Instance name: confluent-bigtable-demo
Instance ID: <auto_generated>
Storage type: SSD
Location: Region. Pick the same region as your Confluent Cloud cluster (In this lab we use us-west-4).
```
2. Click on **CREATE**.

> For detailed instructions refer to our [documentation](https://docs.confluent.io/cloud/current/connectors/cc-gcp-bigtable-sink.html)

### Service Accounts

1. You need to create a GCP Service Account so the Confluent Connectors can access GCP resources. For the purpose of this lab, we will create 1 Service Account and assign 3 roles to it. However, you should always follow best practices for production workloads. 

2. Use the search bar and search for **IAM & Admin** and click on the result.  

3. Expand the left hand side menu and go to Service Accounts and click on the **Create Service Account** and enter the following 
```
Service account name: confluent-demo 
Description: Account to be used during Confluent Cloud Live Lab
Role: BigQuery Admin, Bigtable Administrator, Storage Admin
```

4. Click **Grant** and then **Done**.

5. Once the account is created, click on the 3 dots in **Actions** columns and hit **Manage Keys**.

6. Click on **Add Key** and then on **Create a new key**. 

7. Select `JSON` as key type. Keep this key somewhere safe as you will need it in later steps. The key resembles the example below:
```
{
 "type": "service_account",
 "project_id": "confluent-842583",
 "private_key_id": "...omitted...",
 "private_key": "-----BEGIN PRIVATE ...omitted... =\n-----END PRIVATE KEY-----\n",
 "client_email": "confluent2@confluent-842583.iam.gserviceaccount.com",
 "client_id": "...omitted...",
 "auth_uri": "https://accounts.google.com/oauth2/auth",
 "token_uri": "https://oauth2.googleapis.com/token",
 "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/certs",
 "client_x509_cert_url": "https://www.googleapis.com/robot/metadata/confluent2%40confluent-842583.iam.gserviceaccount.com"
}
```
---
## Step 9: Enrich data streams with ksqlDB
Now that you have data flowing through Confluent, you can now easily build stream processing applications using ksqlDB. You are able to continuously transform, enrich, join, and aggregate your data using simple SQL syntax. You can gain value from your data directly from Confluent in real-time. Also, ksqlDB is a fully managed service within Confluent Cloud with a 99.9% uptime SLA. You can now focus on developing services and building your data pipeline while letting Confluent manage your resources for you.

With ksqlDB, you have the ability to leverage streams and tables from your topics in Confluent. A stream in ksqlDB is a topic with a schema and it records the history of what has happened in the world as a sequence of events. 

1. Navigate to confluent.cloud 
2. Use the left handside menu and go to the ksqlDB application you created at the beginning of the lab.
> You can interact with ksqlDB through the Editor. You can create a stream by using the CREATE STREAM statement and a table using the CREATE TABLE statement. If you’re interested in learning more about ksqlDB and the differences between streams and tables, I recommend reading these two blogs [here](https://www.confluent.io/blog/kafka-streams-tables-part-3-event-processing-fundamentals/) and [here](https://www.confluent.io/blog/how-real-time-stream-processing-works-with-ksqldb/) or watch ksqlDB 101 course on Confluent Developer [webiste](https://developer.confluent.io/learn-kafka/ksqldb/intro/). 

To write streaming queries against topics, you will need to register the topics with ksqlDB as a stream and/or table.

3. Create a ksqlDB stream from `ratings` topic.
```SQL
CREATE STREAM RATINGS_OG WITH (KAFKA_TOPIC='ratings', VALUE_FORMAT='AVRO');
```

4. Change **auto.offset.reset** to **Earliest** and see what's inside the `RATINGS_OG` stream by running the following query.
```SQL
SELECT * FROM RATINGS_OG EMIT CHANGES;
```

5. Create a new stream that doesn't include messages from `test` channel.
```SQL
CREATE STREAM RATINGS_LIVE AS 
    SELECT *
    FROM RATINGS_OG
    WHERE LCASE(CHANNEL) NOT LIKE '%test%'
    EMIT CHANGES;
```
6. See what's inside `RATINGS_LIVE` stream by running the following query. 
```SQL
SELECT * FROM RATINGS_LIVE EMIT CHANGES;
```

7. Stop the running query by clicking on **Stop**.

8. Create a stream from customers topic.
```SQL
CREATE STREAM CUSTOMERS_INFORMATION
WITH (KAFKA_TOPIC ='mysql.demo.CUSTOMERS_INFO',
      KEY_FORMAT  ='JSON',
      VALUE_FORMAT='AVRO');
```
9. Create `customers` table based on `customers_information` stream you just created. 
```SQL
CREATE TABLE CUSTOMERS WITH (FORMAT='AVRO') AS
    SELECT id                            AS customer_id,
           LATEST_BY_OFFSET(first_name)  AS first_name,
           LATEST_BY_OFFSET(last_name)   AS last_name,
           LATEST_BY_OFFSET(dob)         AS dob,
           LATEST_BY_OFFSET(email)       AS email,
           LATEST_BY_OFFSET(gender)      AS gender,
           LATEST_BY_OFFSET(club_status) AS club_status
    FROM    CUSTOMERS_INFORMATION 
    GROUP BY id;
```
10. Check to see what's inside the `customers` table by running the following query. 
```SQL
SELECT * FROM CUSTOMERS;
```

11. Now that we have a stream of ratings data and customer information, we can perform a join query to enrich our data stream. 

12. Create a new stream by running the following statement.
```SQL
CREATE STREAM RATINGS_WITH_CUSTOMER_DATA WITH (KAFKA_TOPIC='ratings-enriched') AS
    SELECT C.CUSTOMER_ID,
        C.FIRST_NAME + ' ' + C.LAST_NAME AS FULL_NAME,
        C.DOB,
        C.GENDER,
        C.CLUB_STATUS,
        C.EMAIL,
        R.RATING_ID,
        R.MESSAGE,
        R.STARS,
        R.CHANNEL,
        TIMESTAMPTOSTRING(R.ROWTIME,'yyyy-MM-dd''T''HH:mm:ss.SSSZ') AS RATING_TS
    FROM RATINGS_LIVE R
        INNER JOIN CUSTOMERS C
        ON R.USER_ID = C.CUSTOMER_ID
EMIT CHANGES;
```
13. Change the **auto.offset.reset** to **Earliest** and see what's inside the newly created stream by running the following command.
```SQL
SELECT * FROM RATINGS_WITH_CUSTOMER_DATA EMIT CHANGES;
```

14. Stop the running query by clicking on **Stop**.
---
## Step 10: Connect BigQuery sink to Confluent Cloud
1. The next step is to sink data from Confluent Cloud into BigQuery using the fully-managed BigQuery Sink connector. The connector will continuosly run and send real time data into BigQuery.
2. First, you will create the connector that will automatically create a BigQuery table and populate that table with the data from the **ratings-enriched** topic within Confluent Cloud. From the Confluent Cloud UI, click on the **Data Integration** tab on the navigation menu and select **+Add connector**. Search and click on the BigQuery Sink icon.
3. Enter the following configuration details. The remaining fields can be left blank.
```
{
  "name": "BigQuerySinkConnector_0",
  "config": {
    "topics": "ratings-enriched",
    "input.data.format": "AVRO",
    "connector.class": "BigQuerySink",
    "name": "BigQuerySinkConnector_0",
    "kafka.auth.mode": "KAFKA_API_KEY",
    "kafka.api.key": "<add_your_api_key>",
    "kafka.api.secret": "<add_your_api_secret_key>",
    "keyfile": "<add_the_JSON_key_created_earlier>",
    "project": "<add_your_gcp_project_id>",
    "datasets": "confluent_bigquery_demo",
    "auto.create.tables": "true",
    "auto.update.schemas": "true",
    "tasks.max": "1",
    "transforms": "Transform,Transform3 ",
    "transforms.Transform.type": "org.apache.kafka.connect.transforms.Cast$Value",
    "transforms.Transform.spec": "DOB:string",
    "transforms.Transform3.type": "org.apache.kafka.connect.transforms.MaskField$Value",
    "transforms.Transform3.fields": "DOB",
    "transforms.Transform3.replacement": "<xxxx-xx-xx>"
  }
}

```
4. In this lab, we decided to mask customer's date of birth before sinking the stream to BigQuery. We are leveraging Single Message Transforms (SMT) to achieve this goal. Since date of birth is of type `DATE` and we want to replace it with a string pattern, we will achieve our goal in a 2 step process. First, we will cast the date of birth from `DATE` to `String`, then we will replace that `String` value with a pattern we have pre-defined. 
> For more information on Single Message Transforms (SMT) refer to our [documentation](https://docs.confluent.io/cloud/current/connectors/single-message-transforms.html) or watch the series by Robin Moffatt, staff developer advocate at Confluent [here](https://www.youtube.com/watch?v=3Gj_SoyuTYk&list=PL5T99fPsK7pq7LiaaL-S6b7wQqzxyjgya&ab_channel=RobinMoffatt).
5. Click on **Next**.
6. Before launching the connector, you will be brought to the summary page. Once you have reviewed the configs and everything looks good, select **Launch**.
7. This should return you to the main Connectors landing page. Wait for your newly created connector to change status from **Provisioning** to **Running**.
8. The instructor will show you how to query the BigQuery database and verify the data exist. 
---
## Step 11: Connect Cloud Storage sink to Confluent Cloud
1. For this use case we only want to store the `ratings_live` stream in Cloud Storage and not the customers' information. 
2. Use the left handside menu and navigate to **Data Integration** and go to **Connectors**. Click on **+Add connector**. Search for **Google Cloud Storage Sink** and click on the Google Cloud Storage Sink icon.
3. Enter the following configuration details. The remaining fields can be left blank.
```
{
  "name": "GcsSinkConnector_0",
  "config": {
    "topics": "pksqlc**-RATINGS_LIVE",
    "input.data.format": "AVRO",
    "connector.class": "GcsSink",
    "name": "GcsSinkConnector_0",
    "kafka.auth.mode": "KAFKA_API_KEY",
    "kafka.api.key": "<add_your_api_key>",
    "kafka.api.secret": "<add_your_api_secret_key>",
    "gcs.credentials.config": "<add_the_JSON_key_created_earlier>”,
    "gcs.bucket.name": "confluent-bucket-demo",
    "output.data.format": "JSON",
    "time.interval": "HOURLY",
    "flush.size": "1000",
    "tasks.max": "1"
  }
}

```
4. The instructor will show you how to verify data exists in Storage Sink. 
---
## Step 12: Connect BigTable sink to Confluent Cloud
1. For this use case, we will be streaming the **users** topic to BigTable database. 
2. We decided to concatenate `userid` and `regionid` fields to make the `rowkey` in BigTable
3. Additionally, we will use Single Message Transforms (SMT) to convert the timestamp to `String`.
4. Enter the following configuration details. The remaining fields can be left blank. 
```
{
  "name": "BigTableSinkConnector_0",
  "config": {
    "topics": "users",
    "input.data.format": "AVRO",
    "input.key.format": "STRING",
    "connector.class": "BigTableSink",
    "name": "BigTableSinkConnector_0",
    "kafka.auth.mode": "KAFKA_API_KEY",
    "kafka.api.key": "<add_your_api_key>",
    "kafka.api.secret": "<add_your_api_secret_key>",
    "gcp.bigtable.credentials.json": "<add_the_JSON_key_created_earlier>",
    "gcp.bigtable.project.id": "<add_your_gcp_project_id>",
    "gcp.bigtable.instance.id": "confluent-bigtable-demo",
    "insert.mode": "UPSERT",
    "table.name.format": "confluent-${topic}",
    "bigtable.row.key.definition": "userid,regionid",
    "bigtable.row.key.delimiter": "#",
    "auto.create.tables": "true",
    "tasks.max": "1",
    "transforms": "Transform ",
    "transforms.Transform.type": "org.apache.kafka.connect.transforms.TimestampConverter$Value",
    "transforms.Transform.target.type": "string",
    "transforms.Transform.field": "registertime",
    "transforms.Transform.format": "yyyy-MM-dd"
  }
}

```
5. The instructor will show you how to verify data exists in BigTable table.
---
## Step 13: Clean up resources
Deleting the resources you created during this lab will prevent you from incurring additional charges.
1. The first item to delete is the ksqlDB application. Select the **Delete** button under **Actions** and enter the Application Name to confirm the deletion.
1. Delete the all source and sink connectors by navigating to **Connectors** in the navigation panel, clicking your connector name, then clicking the trash can icon in the upper right and entering the connector name to confirm the deletion.
1. Delete the Cluster by going to the **Settings** tab and then selecting **Delete cluster**
1. Delete the Environment by expanding right hand menu and going to **Environments** tab and then clicking on **Delete** for the associated Environment you would like to delete
1. Go to https://console.cloud.google.com and delete BigQuery dataset, BigTable table, and Storage Sink bucket. Additionally, you can delete Service Account User and credential file you created for this lab. 
---
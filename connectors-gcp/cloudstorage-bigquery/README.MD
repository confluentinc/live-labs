<div align="center" padding=25px>
   <img src="../../images/banner.png" width =75% heigth=75%>
</div>

# <div align="center">Building end-to-end streaming data pipelines with Confluent Cloud</div>
## <div align="center">Lab Guide</div>

For this lab, we assume we own a fictional airline company called "FictionAir".
FictionAir: stores customer information in a MySQL database. It also has a website that customers can submit feedback in real time. We will serve transformed and enriched data to 2 internal teams that have very different requirements
  * The analytics team decided to use GCP BigQuery, a Cloud Data Warehouse. They want to be able to react to customers feedback as they become availabe. For example if a customer with Platinum club status had a bad experience, they want to reach out to them and sort things out. This team doesn't want to go to two different sources to get their data, they want the data to become available to them in a format and location they decided is the right choice for them. 
  * The AI team wants to use real world data to train and test their AI models. They don't want to go and find this data, so we are providing the customer rating data to them in GCP Cloud Storage, which is a great solution to store large amounts of data for a long time.

To keep things simple, we will utilize Datagen Source Connector to generate both **ratings** data ourseleves. Additionally, we will use MySQL CDC Source Connecter, GCP BigQuery and Cloud Storage fully-managed connectors.  

---

## [Agenda](#agenda)

1. [Log into Confluent Cloud](#step1)
1. [Create an environment and cluster](#step2)
1. [Create an API key pair](#step3)
1. [Enable Schema registery](#step4)
1. [Create a ksqlDB application](#step5)
1. [Create "ratings" topic](#step6)
1. [Create a Datagen Source connector](#step7)
1. [Create customers topic](#step8)
1. [Create a MySQL CDC Source connector](#step9)
1. [Create GCP services](#step10)
1. [Enrich data streams with ksqlDB](#step11)
1. [Connect BigQuery sink to Confluent Cloud](#step12)
1. [Connect Cloud Storage sink to Confluent Cloud](#step13)
1. [Confluent Cloud Stream Lineage](#step14)
1. [Clean up resources](#step15)
---

## [Architecture Diagram](#architecture-diagram)
This lab will be utilizing two fully-managed source connectors (Datagen and MySQL CDC) and two fully-managed sink connectors (GCP BigQuery and Cloud Storage). 

## FictionAir
<div align="center"> 
  <img src="../images/LiveLabs-GCP_BigQuery-CloudStorage.png" width =75% heigth=75%>
</div>

---
## [Prerequisites](#prerequisites)

### Sign up for Confluent Cloud Account
1. Sign up for a Confluent Cloud account [here](https://www.confluent.io/get-started/).

2. Once you have signed up and logged in, click on the menu icon at the upper right hand corner, click on “Billing & payment”, then enter payment details under “Payment details & contacts”.

> **Note:** You will create resources during this lab that will incur costs. When you sign up for a Confluent Cloud account, you will get free credits to use in Confluent Cloud. This will cover the cost of resources created during the lab. More details on the specifics can be found [here](https://www.confluent.io/get-started/).

### Test Network Connectivity

Ports `443` and `9092` need to be open to the public internet for outbound traffic. To check, try accessing the following from your web browser:
  * portquiz.net:443
  * portquiz.net:9092
    
### Sign up for GCP account

In order to complete this lab, you need to have a GCP account and a valid project. Sign up for an account [here](https://cloud.google.com/).

---
## [Hands-on Lab](#handson)

**You have successfully completed the prep work. You should stop at this point and complete the remaining steps during the live session**

---

## <a name="step1"></a>Step 1: Log into Confluent Cloud
1. First, access Confluent Cloud sign-in by navigating [here](https://confluent.cloud).
1. When provided with the *username* and *password* prompts, fill in your credentials.
    > **Note:** If you're logging in for the first time you will see a wizard that will walk you through the some tutorials. Minimize this as you will walk through these steps in this guide.
---
## <a name="step2"></a>Step 2: Create an environment and cluster
An environment contains Confluent clusters and its deployed components such as Connect, ksqlDB, and Schema Registry. You have the ability to create different environments based on your company's requirements. Confluent has seen companies use environments to separate Development/Testing, Pre-Production, and Production clusters.

1. Click **+ Add environment**.
    > **Note:** There is a *default* environment ready in your account upon account creation. You can use this *default* environment for the purpose of this lab if you do not wish to create an additional environment.

    * Specify a meaningful `name` for your environment and then click **Create**.
        > **Note:** It will take a few minutes to assign the resources to make this new environment available for use.

2. Now that you have an environment, let's create a cluster. Select **Create Cluster**.
    > **Note**: Confluent Cloud clusters are available in 3 types: **Basic**, **Standard**, and **Dedicated**. Basic is intended for development use cases so you should use that for this lab. Basic clusters only support single zone availability. Standard and Dedicated clusters are intended for production use and support Multi-zone deployments. If you’re interested in learning more about the different types of clusters and their associated features and limits, refer to this [documentation](https://docs.confluent.io/current/cloud/clusters/cluster-types.html).

    * Choose the **Basic** cluster type.

    * Click **Begin Configuration**.

    * Choose **GCP** as your Cloud Provider and your preferred Region.
        > **Note:** We recommend you choose Las Vegas (west4) as the region for the purpose of this lab. 

    * Specify a meaningful **Cluster Name** and then review the associated *Configuration & Cost*, *Usage Limits*, and *Uptime SLA* before clicking **Launch Cluster**.

---
## <a name="step3"></a>Step 3: Create an API key pair
1. Select API keys on the navigation menu.
1. If this is your first API key within your cluster, click **Create key**. If you have set up API keys in your cluster in the past and already have an existing API key, click **+ Add key**.
1. Select **Global Access**, then click Next.
1. Save your API key and secret - you will need these during the lab.
1. After creating and saving the API key, you will see this API key in the Confluent Cloud UI in the API keys tab. If you don’t see the API key populate right away, refresh the browser.
---
## <a name="step4"></a>Step 4: Enable Schema Registery
1. On the navigation menu, select **Schema Registery**.
1. Click **Set up on my own**.
1. Choose **GCP** as the cloud provider and a supported **Region**
1. Click on **Enable Schema Registry**. 
---
## <a name="step5"></a>Step 5: Create a ksqlDB application
> At Confluent we developed ksqlDB, the database purpose-built for stream processing applications. ksqlDB is built on top of Kafka Streams, powerful Java library for enriching, transforming, and processing real-time streams of data. Having Kafka Streams at its core means ksqlDB is built on well-designed and easily understood layers of abstractions. So now, beginners and experts alike can easily unlock and fully leverage the power of Kafka in a fun and accessible way.
1. On the navigation menu, select **ksqlDB**.
1. Click on **Create cluster myself**.
1. Choose **Global access** for the access level and hit **Continue**.
1. Pick a name or leave the name as is.
1. Select **1** as the cluster size. 
1. Hit **Launch Cluster!**. 
---
## <a name="step6"></a>Step 6: Create "ratings" topic
1. On the navigation menu, select **Topics**.
> Click **Create topic on my own** or if you already created a topic, click on the **+ Add topic** button on the top right side of the table.
2. Type **ratings** as the Topic name and hit **Create with defaults**. 
---
## <a name="step7"></a>Step 7: Create a Datagen Source connector
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
## <a name="step8"></a>Step 8: Create customers topic
1. On the navigation menu, select **Topics**.
> Click **Create topic on my own** or if you already created a topic, click on the **+ Add topic** button on the top right side of the table.
2. Type **mysql.demo.CUSTOMERS_INFO** as the Topic name. The name of the topic is crucial so make sure you use the exact name and capitalization. 
3. Click on **Show advanced settings** and under **Storage → Cleanup policy → Compact** and **Retention time → Infinite** and then click on **Create**.
---
## <a name="step9"></a>Step 9: Create a MySQL CDC Source connector
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

```
# DB Connection Info
hostname: demo-users-db.cmeexwqmbbve.ca-central-1.rds.amazonaws.com
username: admin
password: WErXA$VgR2tLZE
port: 3306
database server name: mysql
```


---
## <a name="step10"></a>Step 10: Enrich data streams with ksqlDB
Now that you have data flowing through Confluent, you can now easily build stream processing applications using ksqlDB. You are able to continuously transform, enrich, join, and aggregate your data using simple SQL syntax. You can gain value from your data directly from Confluent in real-time. Also, ksqlDB is a fully managed service within Confluent Cloud with a 99.9% uptime SLA. You can now focus on developing services and building your data pipeline while letting Confluent manage your resources for you.

With ksqlDB, you have the ability to leverage streams and tables from your topics in Confluent. A stream in ksqlDB is a topic with a schema and it records the history of what has happened in the world as a sequence of events. 

1. Navigate to confluent.cloud 
2. Use the left handside menu and go to the ksqlDB application you created at the beginning of the lab.
> You can interact with ksqlDB through the Editor. You can create a stream by using the CREATE STREAM statement and a table using the CREATE TABLE statement. If you’re interested in learning more about ksqlDB and the differences between streams and tables, I recommend reading these two blogs [here](https://www.confluent.io/blog/kafka-streams-tables-part-3-event-processing-fundamentals/) and [here](https://www.confluent.io/blog/how-real-time-stream-processing-works-with-ksqldb/) or watch ksqlDB 101 course on Confluent Developer [website](https://developer.confluent.io/learn-kafka/ksqldb/intro/). 

To write streaming queries against topics, you will need to register the topics with ksqlDB as a stream and/or table.

3. Set `auto.offset.reset` to `Earliest`.

4. Create a ksqlDB stream from `ratings` topic.
```SQL
CREATE STREAM RATINGS_OG WITH (KAFKA_TOPIC='ratings', VALUE_FORMAT='AVRO');
```

5. Change **auto.offset.reset** to **Earliest** and see what's inside the `RATINGS_OG` stream by running the following query.
```SQL
SELECT * FROM RATINGS_OG EMIT CHANGES;
```

6. Create a new stream that doesn't include messages from `test` channel.
```SQL
CREATE STREAM RATINGS_LIVE AS 
    SELECT *
    FROM RATINGS_OG
    WHERE LCASE(CHANNEL) NOT LIKE '%test%' and USER_ID < 13
    EMIT CHANGES;
```
7. See what's inside `RATINGS_LIVE` stream by running the following query. 
```SQL
SELECT * FROM RATINGS_LIVE EMIT CHANGES;
```

8. Stop the running query by clicking on **Stop**.

9. Create a stream from customers topic.
```SQL
CREATE STREAM CUSTOMERS_INFORMATION
WITH (KAFKA_TOPIC ='mysql.demo.CUSTOMERS_INFO',
      KEY_FORMAT  ='JSON',
      VALUE_FORMAT='AVRO');
```
10. Create `customers` table based on `customers_information` stream you just created. 
```SQL
CREATE TABLE CUSTOMERS WITH (FORMAT='AVRO') AS
    SELECT user_id                            AS customer_id,
           LATEST_BY_OFFSET(first_name)  AS first_name,
           LATEST_BY_OFFSET(last_name)   AS last_name,
           LATEST_BY_OFFSET(dob)         AS dob,
           LATEST_BY_OFFSET(email)       AS email,
           LATEST_BY_OFFSET(gender)      AS gender,
           LATEST_BY_OFFSET(club_status) AS club_status
    FROM    CUSTOMERS_INFORMATION 
    GROUP BY user_id;
```

11. Check to see what's inside the `customers` table by running the following query. 
```SQL
SELECT * FROM CUSTOMERS;
```

12. Now that we have a stream of ratings data and customer information, we can perform a join query to enrich our data stream. 

13. Create a new stream by running the following statement.
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
14. Change the **auto.offset.reset** to **Earliest** and see what's inside the newly created stream by running the following command.
```SQL
SELECT * FROM RATINGS_WITH_CUSTOMER_DATA EMIT CHANGES;
```

15. Stop the running query by clicking on **Stop**.
---
## <a name="step11"></a>Step 11: Connect BigQuery sink to Confluent Cloud
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

## <a name="step13"></a>Step 13: Confluent Cloud Stream Lineage
Confluent gives you tools such as Stream Quality, Stream Catalog, and Stream Lineage to ensure your data is high quality, observable and discoverable. Learn more about the **Stream Governance** [here](https://www.confluent.io/product/stream-governance/) and refer to the [docs](https://docs.confluent.io/cloud/current/stream-governance/overview.html) page for detailed information. 
1. Navigate to https://confluent.cloud
2. Use the left hand-side menu and click on **Stream Lineage**. 
Stream lineage provides a graphical UI of the end to end flow of your data. Both from the a bird’s eye view and drill-down magnification for answering questions like:
    * Where did data come from?
    * Where is it going?
    * Where, when, and how was it transformed?
In the bird's eye view you see how one stream feeds into another one. As your pipeline grows and becomes more complex, you can use Stream lineage to debug and see where things go wrong and break.
<div align="center" padding=25px>
   <img src="../images/stream-lineage.png" width =75% heigth=75%>
</div>

---
## <a name="step14"></a>Step 14: Clean up resources
Deleting the resources you created during this lab will prevent you from incurring additional charges.
1. The first item to delete is the ksqlDB application. Select the **Delete** button under **Actions** and enter the Application Name to confirm the deletion.
1. Delete the all source and sink connectors by navigating to **Connectors** in the navigation panel, clicking your connector name, then clicking the trash can icon in the upper right and entering the connector name to confirm the deletion.
1. Delete the Cluster by going to the **Settings** tab and then selecting **Delete cluster**
1. Delete the Environment by expanding right hand menu and going to **Environments** tab and then clicking on **Delete** for the associated Environment you would like to delete
1. Go to https://console.cloud.google.com and delete BigQuery dataset and Storage Sink bucket. Additionally, you can delete Service Account User and credential file you created for this lab. 
---
## <a name="step16"></a>Step 15: Confluent Resources and Further Testing

Here are some links to check out if you are interested in further testing:

* Confluent Cloud [Basics](https://docs.confluent.io/cloud/current/client-apps/cloud-basics.html)

* [Quickstart](https://docs.confluent.io/cloud/current/get-started/index.html) with Confluent Cloud

* Confluent Cloud ksqlDB [Quickstart](https://docs.confluent.io/cloud/current/get-started/ksql.html)

* Confluent Developer [website](https://developer.confluent.io/)

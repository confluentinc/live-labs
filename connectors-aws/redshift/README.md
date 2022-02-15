# <div align="center">Confluent Cloud fully-managed connectors: AWS Redshift Sink</div>
## <div align="center">Lab Guide</div>

> Confluent offers 120+ pre-built [connectors](https://www.confluent.io/product/confluent-connectors/), enabling you to modernize your entire data architecture even faster. These connectors also provide you peace-of-mind with enterprise-grade security, reliability, compatibility, and support.

This lab will be utilizing Datagen Source Connector, MySQL CDC Source Connecter,  and AWS Redshift Sink fully-managed connectors. The on-demand version of the lab is available here. 

---

## [Agenda](#agenda)

1. [Log into Confluent Cloud](#step1)
1. [Create an environment and cluster](#step2)
1. [Create an API key pair](#step3)
1. [Enable Schema registery](#step4)

---

## [Architecture Diagram](#architecture-diagram)
This lab will be utilizing Datagen Source Connector, MySQL CDC Source Connecter,  and AWS Redshift Sink fully-managed connectors. The on-demand version of the lab is available here. 
<div align="center">
   <img src="../images/LiveLabs-AWS_S3-Redshift.png" width =75% heigth=75%>
</div>

---
## [Prerequisites](#prerequisites)
1. Confluent Cloud Account
    * Sign-up for a Confluent Cloud account [here](https://www.confluent.io/confluent-cloud/tryfree/).
    * Once you have signed up and logged in, click on the menu icon at the upper right hand corner, click on “Billing & payment”, then enter payment details under “Payment details & contacts”.

    > **Note:** You will create resources during this workshop that will incur costs. When you sign up for a Confluent Cloud account, you will get free credits to use in Confluent Cloud. This will cover the cost of resources created during the workshop. More details on the specifics can be found [here](https://www.confluent.io/confluent-cloud/tryfree/).
1. Ports `443` and `9092` need to be open to the public internet for outbound traffic. To check, try accessing the following from your web browser:
    * portquiz.net:443
    * portquiz.net:9092
    
1. Sign up for an AWS account [here](https://aws.amazon.com/account/).

---
## <a name="step1"></a>Step 1: Log into Confluent Cloud
1. First, access Confluent Cloud sign-in by navigating [here](https://confluent.cloud).
1. When provided with the *username* and *password* prompts, fill in your credentials.
    > **Note:** If you're logging in for the first time you will see a wizard that will walk you through the some tutorials. Minimize this as you will walk through these steps in this guide.
---
## <a name="step2"></a>Step 2: Create an environment and cluster
An environment contains Confluent clusters and its deployed components such as Connect, ksqlDB, and Schema Registry. You have the ability to create different environments based on your company's requirements. Confluent has seen companies use environments to separate Development/Testing, Pre-Production, and Production clusters.

1. Click **+ Add environment**.
    > **Note:** There is a *default* environment ready in your account upon account creation. You can use this *default* environment for the purpose of this workshop if you do not wish to create an additional environment.

    * Specify a meaningful `name` for your environment and then click **Create**.
        > **Note:** It will take a few minutes to assign the resources to make this new environment available for use.

1. Now that you have an environment, let's create a cluster. Select **Create Cluster**.
    > **Note**: Confluent Cloud clusters are available in 3 types: **Basic**, **Standard**, and **Dedicated**. Basic is intended for development use cases so you should use that for this lab. Basic clusters only support single zone availability. Standard and Dedicated clusters are intended for production use and support Multi-zone deployments. If you’re interested in learning more about the different types of clusters and their associated features and limits, refer to this [documentation](https://docs.confluent.io/current/cloud/clusters/cluster-types.html).

    * Choose the **Basic** cluster type.

    * Click **Begin Configuration**.

    * Choose **AWS** as your Cloud Provider and your preferred Region.
        > **Note:** AWS is required as your Cloud Provider since you will be utilizing Redshift in this lab. We recommend you choose Oregon (west2) as the region. 

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
1. Choose **AWS** as the cloud provider and a supported **Region**
1. Click on **Enable Schema Registry**. 
---

## [Hands-on Lab](#handson)

---
## <a name="step5"></a>Step 1: Create a ksqlDB application
> At Confluent we developed ksqlDB, the database purpose-built for stream processing applications. ksqlDB is built on top of Kafka Streams, powerful Java library for enriching, transforming, and processing real-time streams of data. Having Kafka Streams at its core means ksqlDB is built on well-designed and easily understood layers of abstractions. So now, beginners and experts alike can easily unlock and fully leverage the power of Kafka in a fun and accessible way.
1. On the navigation menu, select **ksqlDB**.
1. Click on **Create cluster myself**.
1. Choose **Global access** for the access level and hit **Continue**.
1. Pick a name or leave the name as is.
1. Select **1** as the cluster size. 
1. Hit **Launch Cluster!**. 
---
## <a name="step6"></a>Step 2: Create "ratings" topic
1. On the navigation menu, select **Topics**.
> Click **Create topic on my own** or if you already created a topic, click on the **+ Add topic** button on the top right side of the table.
1. Type **ratings** as the Topic name and hit **Create with defaults**. 
---
## <a name="step7"></a>Step 3: Create a Datagen Source connector
> Confluent offers 120+ pre-built [connectors](https://www.confluent.io/product/confluent-connectors/), enabling you to modernize your entire data architecture even faster. These connectors also provide you peace-of-mind with enterprise-grade security, reliability, compatibility, and support.
1. On the navigation menu, select **Data Integration** and then **Connectors** and **+ Add connector**.
1. In the search bar search for **Datagen** and select the **Datagen Source** which is a fully-managed connector. 
1. Use the following parameters to configure your connector
```
{
  "name": "DatagenSourceConnector_0",
  "config": {
    "connector.class": "DatagenSource",
    "name": "DatagenSourceConnector_0",
    "kafka.auth.mode": "KAFKA_API_KEY",
    "kafka.api.key": "<dd_your_api_key>",
    "kafka.api.secret": "<add_your_api_secret_key>",
    "kafka.topic": "ratings",
    "output.data.format": "AVRO",
    "quickstart": "RATINGS",
    "tasks.max": "1"
  }
}
```
---
## <a name="step8"></a>Step 4: Create customers topic
1. On the navigation menu, select **Topics**.
> Click **Create topic on my own** or if you already created a topic, click on the **+ Add topic** button on the top right side of the table.
1. Type **mysql.demo.CUSTOMERS_INFO** as the Topic name.
1. Click on **Show advanced settings** and under **Storage → Cleanup policy → Compact** and then click on **Create**.
---
## <a name="step9"></a>Step 5: Create a MySQL CDC Source connector
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
    "kafka.api.key": "<dd_your_api_key>",
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
## <a name="step10"></a>Step 6: Create "users" topic
1. On the navigation menu, select **Topics**.
> Click **Create topic on my own** or if you already created a topic, click on the **+ Add topic** button on the top right side of the table.
1. Type **users** as the Topic name and hit **Create with defaults**. 
---
## <a name="step7"></a>Step 3: Create a Datagen Source connector
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
    "kafka.api.key": "<dd_your_api_key>",
    "kafka.api.secret": "<add_your_api_secret_key>",
    "kafka.topic": "users",
    "output.data.format": "AVRO",
    "quickstart": "RATINGS",
    "tasks.max": "1"
  }
}
```
---
## <a name="step11"></a>Step 7: Create AWS services
1. Navigate to https://aws.amazon.com/console/ and log into your account. 
> Note: you will need root level permissions in order to complete this lab. 
1. Create a Redshift cluster and save the `Admin user name` and `Admin user password` since you will need it in later steps. 
1. Under **Additional configuration** disable **defaults**. 
1. Make the cluster publicly accessible under **Network and security → Publicly accessible → Enable**.
1. Using the search bar navigate to **VPC -> Security Groups -> Inbound Rules** and add two new rules for TCP protocol
```
Type: Redshift
Port range: 5430 
Source: 0.0.0.0/0
Type: Redshift
Port range: 5430 
Source: ::/0
```
1. Navigate back to your Redshift cluster and reboot it to ensure the right security policies are applied. 
1. Once the cluster is in **Available** state use the left handside menu and open `Query Editor` to create a database and a user and give the appropriate permissions 
```
CREATE DATABASE <DB_NAME>;
CREATE USER <DB_USER> PASSWORD '<DB_PASSWORD>';
GRANT USAGE ON SCHEMA public TO <DB_USER>;
GRANT CREATE ON SCHEMA public TO <DB_USER>;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO <DB_USER>;
GRANT ALL ON SCHEMA public TO <DB_USER>;
GRANT CREATE ON DATABASE <DB_NAME> TO <DB_USER>;
```




















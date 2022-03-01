---
title: "Prerequisites"
date: 2022-02-28T15:45:33-08:00
draft: false
weight: 2
---


## Test Network Connectivity

1. Ports `443` and `9092` need to be open to the public internet for outbound traffic. To check, try accessing the following from your web browser:
  * http://portquiz.net:443
  * http://portquiz.net:9092

## Sign up for GCP account

1. In order to complete this lab, you need to have a GCP account. Sign up for an account here: https://cloud.google.com/

## Confluent Cloud -- Sign Up and Create Resources

### Sign Up

1. Sign up for a Confluent Cloud account: https://www.confluent.io/get-started/

2. Once you have signed up and logged in, click on the menu icon at the upper right hand corner, click on “Billing & payment”, then enter payment details under “Payment details & contacts”.

{{% notice warning %}}
You will create resources during this lab that will incur costs. When you sign up for a Confluent Cloud account, you will get free credits to use in Confluent Cloud. This will cover the cost of resources created during the lab. More details on the specifics can be found [here](https://www.confluent.io/get-started/).
{{% /notice %}}


### Log In
1. First, access Confluent Cloud sign-in by navigating [here](https://confluent.cloud).
1. When provided with the *username* and *password* prompts, fill in your credentials.
{{% notice note %}}
If you're logging in for the first time you will see a wizard that will walk you through the some tutorials. Minimize this as you will walk through these steps in this guide.
{{% /notice %}}

### Create an Environment and Cluster
An environment contains Confluent clusters and its deployed components such as Connect, ksqlDB, and Schema Registry. You have the ability to create different environments based on your company's requirements. Confluent has seen companies use environments to separate Development/Testing, Pre-Production, and Production clusters.

1. Click **+ Add environment**.
{{% notice note %}}
There is a *default* environment ready in your account upon account creation. You can use this *default* environment for the purpose of this lab if you do not wish to create an additional environment.
{{% /notice %}}

    * Specify a meaningful `name` for your environment and then click **Create**.
{{% notice note %}}
It will take a few minutes to assign the resources to make this new environment available for use.
{{% /notice %}}

2. Now that you have an environment, let's create a cluster. Select **Create Cluster**.
{{% notice note %}}
Confluent Cloud clusters are available in 3 types: **Basic**, **Standard**, and **Dedicated**. Basic is intended for development use cases so you should use that for this lab. Basic clusters only support single zone availability. Standard and Dedicated clusters are intended for production use and support Multi-zone deployments. If you’re interested in learning more about the different types of clusters and their associated features and limits, refer to this [documentation](https://docs.confluent.io/current/cloud/clusters/cluster-types.html).
{{% /notice %}}

    * Choose the **Basic** cluster type.

    * Click **Begin Configuration**.

    * Choose **GCP** as your Cloud Provider and your preferred Region.
{{% notice note %}}
We recommend you choose Las Vegas (west4) as the region for the purpose of this lab. 
{{% /notice %}}

    * Specify a meaningful **Cluster Name** and then review the associated *Configuration & Cost*, *Usage Limits*, and *Uptime SLA* before clicking **Launch Cluster**.

---
### Create an API Key Pair
1. Select API keys on the navigation menu.
1. If this is your first API key within your cluster, click **Create key**. If you have set up API keys in your cluster in the past and already have an existing API key, click **+ Add key**.
1. Select **Global Access**, then click Next.
1. Save your API key and secret - you will need these during the lab.
1. After creating and saving the API key, you will see this API key in the Confluent Cloud UI in the API keys tab. If you don’t see the API key populate right away, refresh the browser.
---
### Enable Schema Registery
1. On the navigation menu, select **Schema Registery**.
1. Click **Set up on my own**.
1. Choose **GCP** as the cloud provider and a supported **Region**
1. Click on **Enable Schema Registry**. 



## Next Up -- the Live Lab!

{{% notice info %}}
You have successfully completed the prep work. You can stop at this point and complete the remaining steps during the live session.
{{% /notice %}}

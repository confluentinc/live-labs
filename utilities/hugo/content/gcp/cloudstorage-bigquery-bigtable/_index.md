---
title: "Build An End-to-End Streaming Data Pipeline with Confluent Cloud"
date: 2022-02-26T06:28:04Z
draft: false
---


For this lab, we have two fictional companies. 
1. An airline company: stores customer information in a MySQL database. It also has a website that customers can submit feedback in real time. 
  * The analytics team decided to use GCP BigQuery, a Cloud Data Warehouse. They want to be able to react to customers feedback as they become availabe. For example if a customer with Platinum club status had a bad experience, they want to reach out to them and sort things out. This team doesn't want to go to two different sources to get their data, they want the data to become available to them in a format and location they decided is the right choice for them. 
  * The AI team wants to use real world data to train and test their AI models. They don't want to go and find this data, so we are providing the customer rating data to them in GCP Cloud Storage, which is a great solution to store large amounts of data for a long time.
2. A media company: recently their userbase grew significantly and their database is struggling to keep up. They concluded that GCP BigTable, a highly scalable NoSQL database, is the right choice for them, so they are migrating their users' information to BigTable. 

To keep things simple, we will utilize Datagen Source Connector to generate both **ratings** and **users** data ourseleves. Additionally, we will use MySQL CDC Source Connector, GCP BigQuery, Cloud Storage, and BigTable fully-managed connectors.  

# JsonDerulo Database

## Overview

JsonDerulo is a lightweight and quirky database system that utilizes JSON as its file format, bringing a touch of humor and creativity to the world of data storage. With its unique features and playful approach, JsonDerulo aims to provide a fun and efficient solution for your database needs.

## Features

### 1. Clustering

JsonDerulo supports clustering through two distinct methods:

  - **Local Node:** Nodes in the same local network can form a cluster, enabling efficient data distribution and retrieval within the network.

  - **Gossip:** Nodes communicate through a gossip protocol, allowing for the formation of clusters over a wider network. This approach enhances the scalability of JsonDerulo.

### 2. Emoji Encoding

All data stored in JsonDerulo is encoded into emoji. This feature not only makes your data more visually interesting but also ensures a delightful experience while working with JsonDerulo. It also multiplies all space your data would normally take by 4 times!

### 3. Data Corruption

JsonDerulo introduces an element of unpredictability by incorporating a small chance of data corruption. While this may seem unconventional, it adds an element of excitement and a unique challenge for users who enjoy living on the edge. Every time a client writes to the database, the write will have a 1 in 1,000,000,000 chance to corrupt all of the data in the database and crash everything

### 4. Healthcheck Endpoint

JsonDerulo includes a healthcheck endpoint that always returns a 200 status code, regardless of the actual health of the system. This light-hearted approach ensures that JsonDerulo maintains a positive and resilient attitude, even in the face of potential challenges.

## Getting Started

To start using JsonDerulo, follow these simple steps:

1. **Installation:**
  - Figure it out urself lol

2. **Connecting**
  Currently no client libraries exist, so you will have to connect manually. Luckily connecting is very simple! Just use a tcp client/library of your choice and connect to the ip and port of the database. No authentication required to make it easy on the developer.

  **Commands**

  `PING` -> Pings the Database

  `<[key]` -> Fetch data at specified index

  `>[key]data` -> Set data at specified key.

    **Data**

    Integers: represented with just the int and nothing else

    Strings: Must include the opening and closing double quotation mark

    Inline Data: Use the json format, (ex. {"key": 1})

  `@` -> Fetch all data in the database

  `![key]` -> Clear data at specified index

  Note: the `<` and `!` command work with inlined data (ex. `<[key 1][key2]`)


  **Errors**

  All errors start off with a `!@` and then are followed by the error message

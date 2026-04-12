# 🚆 UK Train Rides Data Analysis Project
## 📋 Table of Contents

- [ Overview](#-overview)
- [ Objectives](#-objectives)
- [ Dataset Description](#-dataset-description)
- [ Data Cleaning & Preprocessing](#-data-cleaning--preprocessing)
- [ Data Modeling (3NF)](#️-data-modeling-3nf)
- [ Relationships](#-relationships)
- [ Tools & Technologies](#️-tools--technologies)

## 📌 Overview
This project focuses on analyzing UK railway ticket transactions and transforming raw data into a clean, structured, and fully normalized database model using **Third Normal Form (3NF)**.

The system combines data cleaning, analysis, and forecasting techniques to extract meaningful insights that support better decision-making in transportation systems.

---

## 🎯 Objectives
- Clean and preprocess raw railway transaction data  
- Transform the dataset into a structured 3NF database  
- Reduce redundancy and improve data consistency  
- Analyze passenger behavior, revenue, and delays  
- Build a foundation for forecasting and visualization  

---

## 📊 Dataset Description
The dataset contains railway ticket transactions, including:

- Purchase details (date, time, payment method, railcard)  
- Ticket information (class, type, price)  
- Journey data (stations, timings, status)  
- Delay reasons and refund requests  

Each row represents a single train ticket transaction.

---

## 🧹 Data Cleaning & Preprocessing
Data cleaning was performed using:

- Excel (Power Query)  
- SQL  
- Python  

### Key Cleaning Steps:
- Converting data types (Date, Time, Numeric)  
- Standardizing categorical values:  
  - "Signal failure" → "Signal Failure"  
  - "Staffing" → "Staff Shortage"  
  - NULL delay → "No Delay"  
- Removing duplicates  
- Trimming text fields  
- Handling missing values  
- Creating surrogate keys (IDs)  

---

## 🏗️ Data Modeling (3NF)

The dataset was normalized into 4 main tables:

### 1️⃣ Transaction (Fact Table)
Stores core transactional data:
- Transaction_ID (PK)  
- Purchase_ID (FK)  
- Journey_ID (FK)  
- Ticket_ID (FK)  

---

### 2️⃣ Purchase Table
Stores purchase-related information:
- Purchase_ID (PK)  
- Date_of_Purchase  
- Time_of_Purchase  
- Purchase_Type  
- Payment_Method  

---

### 3️⃣ Journey Table
Stores journey and operational details:
- Journey_ID (PK)  
- Date_of_Journey  
- Departure_Station  
- Arrival_Destination  
- Departure_Time  
- Arrival_Time  
- Actual_Arrival_Time  
- Journey_Status  
- Reason_for_Delay  
- Refund_Request  

---

### 4️⃣ Ticket Table
Stores ticket classification data:
- Ticket_ID (PK)  
- Ticket_Class  
- Ticket_Type  
- Railcard  
- Price  
- Price category
---

## 🔗 Relationships
- Transaction → Purchase  
- Transaction → Journey  
- Transaction → Ticket  

This design ensures:
- No redundancy  
- No transitive dependency  
- Clear separation of entities  
- Full compliance with **3NF**  

---

## ⚙️ Tools & Technologies
- Excel (Power Query) → Data cleaning & transformation  
- SQL → Data structuring & querying  
- Python → Data preprocessing & analysis  

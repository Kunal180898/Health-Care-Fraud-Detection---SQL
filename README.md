# Health-Care-Fraud-Detection---SQL
This is SQL Based Project 

Overview
This project focuses on analyzing healthcare claims data to detect potential fraud and gather insights into provider and beneficiary patterns. The dataset includes information from outpatient, inpatient, and beneficiary tables, and SQL queries are used for data analysis, fraud detection, and generating key insights. The analysis helps identify outliers in claim amounts, trends over time, provider behavior, and patterns in chronic conditions.

Table of Contents
Overview
Project Objectives
Data Description
Queries Overview
Beginner Level Queries
Intermediate Level Queries
Advanced Level Queries
Insights and Decision-Making
Screenshots
How to Run
License

Project Objectives
Detect potential healthcare fraud using SQL queries on healthcare claims data.
Analyze provider patterns in claims submission to identify high-claiming providers.
Investigate claim rejection rates and possible outliers in claim amounts.
Study patient demographics and conditions to detect high-risk categories.
Provide actionable insights for decision-makers to improve fraud detection processes.

Data Description
The project uses healthcare claims data from various tables:
Train_Outpatient: Claims related to outpatient services.
Train_Inpatient: Claims related to inpatient services.
Train_Beneficiary: Information on beneficiaries including demographics and chronic conditions.
Train_Provider: Provider-related details for analyzing claims submission patterns.

Queries Overview

Beginner Level Queries
Count of Claims: Total number of claims recorded in the Train_Outpatient table.
Unique Providers: Number of unique providers in the Train table.
Claims in a Specific Date Range: Total claims made between 2020-01-01 and 2020-12-31 in the Train_Inpatient table.
Average Claim Amount: Average claim amount reimbursed in the Train_Outpatient table.
Count of Beneficiaries by Gender: Number of beneficiaries by gender in the Train_Beneficiary table.
Claims Without a Diagnosis Code: Count of claims without a diagnosis code in Train_Outpatient.
Claims by Providers with More Than 5 Claims: Identifying providers with more than 5 claims in Train_Outpatient using a subquery.

Intermediate Level Queries
Claims Count by Provider: Count of claims per provider in the Train table.
Average Reimbursement by Provider: Average reimbursement per provider in Train_Outpatient.
Top Providers by Claims: Providers with the highest number of claims using a subquery.
Total Claims Per State: Total claims from each state in Train_Beneficiary.
Top 5 Chronic Conditions: Most common chronic conditions among beneficiaries.
Provider Claim Statistics: Total claim amount and claim count for each provider in Train_Inpatient using a subquery.
Join with Subquery for Potential Fraud: Claims where the reimbursement exceeds the average.

Advanced Level Queries
Fraud Detection Analysis: Top 10 providers with the highest claim amounts and average reimbursement.
Claims Analysis Over Time: Trends in claims submission grouped by year.
Join for Chronic Condition Analysis: Linking chronic conditions with claims data.
Claim Rejection Rates: Percentage of claims denied or not reimbursed.
Join for Multiple Conditions: Beneficiaries with multiple chronic conditions and their claim counts.
Provider Analysis for Fraudulent Claims: Identifying providers with high fraud risk using subqueries.

Insights and Decision-Making
The insights gathered from this analysis can support decision-making in the following areas:
Fraud Detection: Identification of providers with unusually high claim volumes or reimbursement amounts can trigger detailed investigations.
Provider Management: High-claiming providers can be monitored for audit and compliance.
Policy Making: Patterns in chronic conditions and demographic data can influence resource allocation.
Claim Processing Improvement: High claim rejection rates highlight areas for improving claim processing and reimbursement systems.

Screenshots
The repository contains screenshots of SQL queries used in the project for various analyses. These include:
Claims count analysis
Provider claim patterns
Fraud detection queries
Chronic condition and beneficiary analysis

How to Run
Requirements
PostgreSQL or any SQL-based database engine.
Healthcare claims dataset (custom dataset used in this project).
SQL execution tool (e.g., pgAdmin, DBeaver, etc.).

Steps
Clone this repository.
Set up a PostgreSQL database and import the healthcare claims data.
Execute the SQL queries in the provided sequence for each level (beginner, intermediate, advanced).
Analyze the results and compare them to the screenshots in this repository.

License
This project is licensed under the MIT License. See the LICENSE file for details.

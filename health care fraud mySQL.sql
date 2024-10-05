
-- 1. Count of Claims: What is the total number of claims recorded in the Train_Outpatient table?

SELECT 
    COUNT(claimid) AS total_claims
FROM
    train_outpatient;


-- 2. Unique Providers: How many unique providers are there in the Train table?

SELECT 
    COUNT(DISTINCT provider) AS total_unique_provider
FROM
    train;


-- 3. Claims in a Specific Date Range: How many claims were made between 2009-01-01 and 2009-12-31 in the Train_Inpatient table?

SELECT 
    COUNT(claimid) AS total_claims
FROM
    train_inpatient
WHERE
    claimstartdt BETWEEN '2009-01-01' AND '2009-12-31';


-- 4. Average Claim Amount: What is the average claim amount reimbursed in the Train_Outpatient table?

SELECT 
    ROUND(AVG(InscClaimAmtReimbursed), 2) AS avg_reimbursed_amount
FROM
    train_outpatient;


-- 5. Count of Beneficiaries by Gender: How many beneficiaries are there in the Train_Beneficiary table by gender?

SELECT 
    gender AS gender_by_code,
    COUNT(beneid) AS total_beneficiaries
FROM
    train_beneficiary
GROUP BY gender_by_code;


-- 6. Claims Without a Diagnosis Code: How many claims in the Train_Outpatient table do not have a diagnosis code?

SELECT 
    COUNT(claimid) AS claim_without_diagnosis_code
FROM
    train_outpatient
WHERE
    ClmDiagnosisCode_1 = 'NA'
        AND ClmDiagnosisCode_2 = 'NA'
        AND ClmDiagnosisCode_3 = 'NA'
        AND ClmDiagnosisCode_4 = 'NA'
        AND ClmDiagnosisCode_5 = 'NA'
        AND ClmDiagnosisCode_6 = 'NA'
        AND ClmDiagnosisCode_7 = 'NA'
        AND ClmDiagnosisCode_8 = 'NA'
        AND ClmDiagnosisCode_9 = 'NA'
        AND ClmDiagnosisCode_10 = 'NA';


-- 7. Claims by Providers with More Than 5 Claims: Find the names of providers who have submitted more than 5 claims in the Train_Outpatient table using a subquery.

SELECT 
    provider AS providers_submitted_more_than_5_claims
FROM
    (SELECT 
        provider, COUNT(claimid) AS Claims_submitted
    FROM
        train_outpatient
    GROUP BY provider
    HAVING COUNT(claimid) > 5) AS data_1;


-- 8. Claims Count by Provider: What is the count of claims for each provider in the Train table?

SELECT 
    t.provider,
    COUNT(top.claimid) + COUNT(ti.claimid) AS total_claims_submitted
FROM
    train AS t
        INNER JOIN
    train_outpatient AS top ON t.provider = top.provider
        INNER JOIN
    train_inpatient AS ti ON t.provider = ti.provider
GROUP BY t.provider;


-- 9. Average Reimbursement Amount by Provider: Calculate the average reimbursement amount for each provider in the Train_Outpatient table.

SELECT 
    t.provider,
    ROUND((AVG(top.InscClaimAmtReimbursed) + AVG(ti.InscClaimAmtReimbursed)) / 2,
            2) AS Avg_reimbursement_amount
FROM
    train AS t
        INNER JOIN
    train_outpatient AS top ON t.provider = top.provider
        INNER JOIN
    train_inpatient AS ti ON t.provider = ti.provider
GROUP BY t.provider;


-- 10. Top Providers by Claims: Which providers have the highest number of claims in the Train_Outpatient table?

SELECT 
    provider, COUNT(claimid) AS Claims_submitted
FROM
    train_outpatient
GROUP BY provider
HAVING COUNT(claimid) > 10
ORDER BY Claims_submitted DESC
LIMIT 10;


-- 11. Total Claims Per State: What is the total number of claims from each state in the Train_Beneficiary table?

SELECT 
    tb.state AS state_code,
    COUNT(top.claimid) + COUNT(tip.claimid) AS claims_submitted
FROM
    train_beneficiary AS tb
        INNER JOIN
    train_outpatient AS top ON tb.beneid = top.beneid
        INNER JOIN
    train_inpatient AS tip ON tb.beneid = tip.beneid
GROUP BY state_code;


-- 12. Top 5 Chronic Conditions: Which chronic conditions are the most common among beneficiaries in the Train_Beneficiary table?

SELECT chronic_condition, COUNT(*) AS CountOfBeneficiaries 
FROM (
SELECT 
    CASE
        WHEN CAST(chroniccond_alzheimer AS INTEGER) = 1 THEN 'Alzheimer'
        WHEN CAST(chroniccond_heartfailure AS INTEGER) = 1 THEN 'Heart Failure'
        WHEN CAST(chroniccond_kidneydisease AS INTEGER) = 1 THEN 'Kidney Disease'
        WHEN CAST(chroniccond_cancer AS INTEGER) = 1 THEN 'Cancer'
        WHEN CAST(chroniccond_obstrpulmonary AS INTEGER) = 1 THEN 'Obstructive Pulmonary Disease'
        WHEN CAST(chroniccond_depression AS INTEGER) = 1 THEN 'Depression'
        WHEN CAST(chroniccond_diabetes AS INTEGER) = 1 THEN 'Diabetes'
        WHEN CAST(chroniccond_ischemicheart AS INTEGER) = 1 THEN 'Ischemic Heart Disease'
        WHEN CAST(chroniccond_osteoporosis AS INTEGER) = 1 THEN 'Osteoporosis'
        WHEN CAST(chroniccond_rheumatoidarthritis AS INTEGER) = 1 THEN 'Rheumatoid Arthritis'
        WHEN CAST(chroniccond_stroke AS INTEGER) = 1 THEN 'Stroke'
        ELSE 'No Chronic Condition'
    END AS chronic_condition
FROM train_beneficiary) AS ConditionCounts 
GROUP BY chronic_condition 
ORDER BY CountOfBeneficiaries DESC 
LIMIT 5;


-- 13. Provider Claim Statistics: For each provider, retrieve the total claim amount and the number of claims in the Train_Inpatient.

SELECT 
    t.provider AS provider_id,
    SUM(tip.InscClaimAmtReimbursed) AS total_claim_amount,
    COUNT(tip.claimid) AS total_claims
FROM
    train AS t
        INNER JOIN
    train_inpatient AS tip ON t.provider = tip.provider
GROUP BY t.provider;


-- 14. Join with Subquery for Potential Fraud: List all claims in the Train_Outpatient table where the reimbursement amount exceeds the average reimbursement amount across all claims.

SELECT 
    claimid, InscClaimAmtReimbursed AS imbursement_more_than_avg
FROM
    train_outpatient
WHERE
    InscClaimAmtReimbursed > (SELECT 
            ROUND((AVG(top.InscClaimAmtReimbursed) + AVG(tip.InscClaimAmtReimbursed)) / 2,
                        2)
        FROM
            train AS t
                INNER JOIN
            train_inpatient AS tip ON t.provider = tip.provider
                INNER JOIN
            train_outpatient AS top ON t.provider = top.provider);


-- 15. Fraud Detection Analysis: Identify the top 10 providers with the highest claim amounts in the Train_Inpatient table, along with their average reimbursement amount.

SELECT 
    t.provider,
    SUM(tip.inscclaimamtreimbursed) AS ip_claim_amt,
    ROUND((AVG(tip.inscclaimamtreimbursed) + AVG(top.inscclaimamtreimbursed)) / 2,
            2) AS avg_reimb_amt_ip_op
FROM
    train AS t
        INNER JOIN
    train_inpatient AS tip ON t.provider = tip.provider
        INNER JOIN
    train_outpatient AS top ON t.provider = top.provider
GROUP BY t.provider
ORDER BY ip_claim_amt DESC
LIMIT 10;


-- 16. Claims Analysis Over Time: Analyze the trend of claims submitted over the years by grouping them by year in the Train_Inpatient table.

SELECT 
    EXTRACT(YEAR FROM ClaimStartDt) AS claim_year,
    COUNT(claimid) AS claim_count
FROM
    train_inpatient
GROUP BY claim_year;


-- 17. Join for Chronic Condition Analysis: Join Train_Beneficiary and Train_Outpatient tables to find beneficiaries with specific chronic conditions and the number of claims associated with them.
SELECT 
    Cronic_conditions,
    COUNT(top.claimid) AS claim_count_in_outpatient
FROM
    (SELECT 
        beneid,
            CASE
                WHEN ChronicCond_Alzheimer = '1' THEN 'Alzheimer'
                WHEN ChronicCond_Heartfailure = '1' THEN 'Heart failure'
                WHEN ChronicCond_KidneyDisease = '1' THEN 'Kidney Disease'
                WHEN ChronicCond_Cancer = '1' THEN 'Cancer'
                WHEN ChronicCond_ObstrPulmonary = '1' THEN 'ObstrPulmory'
                WHEN ChronicCond_Depression = '1' THEN 'Depression'
                WHEN ChronicCond_Diabetes = '1' THEN 'Diabetes'
                WHEN ChronicCond_IschemicHeart = '1' THEN 'IschemicHeart'
                WHEN ChronicCond_Osteoporosis = '1' THEN 'Osteoporasis'
                WHEN ChronicCond_rheumatoidarthritis = '1' THEN 'rheumatoidarthritis'
                WHEN ChronicCond_stroke = '1' THEN 'stroke'
                ELSE 'No Chronic Condition'
            END Cronic_conditions
    FROM
        train_beneficiary) AS data_a
        INNER JOIN
    train_outpatient AS top ON data_a.beneid = top.beneid
GROUP BY Cronic_conditions;
	

-- 18. Claim Rejection Rates: Calculate the percentage of claims that were denied or resulted in no reimbursement.

SELECT 
    ((SELECT 
            COUNT(claimid)
        FROM
            train_outpatient
        WHERE
            InscClaimAmtReimbursed = 0) + (SELECT 
            COUNT(CASE
                    WHEN InscClaimAmtReimbursed = 0 THEN 1
                END)
        FROM
            train_inpatient)) * 100 / ((SELECT 
            COUNT(claimid)
        FROM
            train_outpatient) + (SELECT 
            COUNT(claimid)
        FROM
            train_inpatient)) AS Rejected_claim_percentage;

-- below query is from chat-GPT:- I'have check my query is correct or not, where I learned how use to use union all. 
SELECT 
    (COUNT(CASE
        WHEN InscClaimAmtReimbursed = 0 THEN 1
    END) * 100.0) / (COUNT(claimid)) AS Rejected_claim_percentage
FROM
    (SELECT 
        claimid, InscClaimAmtReimbursed
    FROM
        train_outpatient UNION ALL SELECT 
        claimid, InscClaimAmtReimbursed
    FROM
        train_inpatient) AS all_claims;


-- 19. Join Multiple Conditions: List beneficiaries with multiple chronic conditions & number of claims they have submitted.

SELECT 
    tb.beneid,
    tb.Cronic_conditions AS number_of_cro_con,
    COUNT(top.claimid) + COUNT(tip.claimid) AS total_claim_submitted
FROM
    (SELECT 
        beneid,
            ((CASE
                WHEN ChronicCond_Alzheimer = '1' THEN 1
                ELSE 0
            END) + (CASE
                WHEN ChronicCond_Heartfailure = '1' THEN 1
                ELSE 0
            END) + (CASE
                WHEN ChronicCond_KidneyDisease = '1' THEN 1
                ELSE 0
            END) + (CASE
                WHEN ChronicCond_Cancer = '1' THEN 1
                ELSE 0
            END) + (CASE
                WHEN ChronicCond_ObstrPulmonary = '1' THEN 1
                ELSE 0
            END) + (CASE
                WHEN ChronicCond_Depression = '1' THEN 1
                ELSE 0
            END) + (CASE
                WHEN ChronicCond_Diabetes = '1' THEN 1
                ELSE 0
            END) + (CASE
                WHEN ChronicCond_IschemicHeart = '1' THEN 1
                ELSE 0
            END) + (CASE
                WHEN ChronicCond_Osteoporosis = '1' THEN 1
                ELSE 0
            END) + (CASE
                WHEN ChronicCond_rheumatoidarthritis = '1' THEN 1
                ELSE 0
            END) + (CASE
                WHEN ChronicCond_stroke = '1' THEN 1
                ELSE 0
            END)) AS Cronic_conditions
    FROM
        train_beneficiary) AS tb
        INNER JOIN
    train_outpatient AS top ON tb.beneid = top.beneid
        INNER JOIN
    train_inpatient AS tip ON tb.beneid = tip.beneid
GROUP BY tb.beneid , number_of_cro_con
HAVING tb.Cronic_conditions > 1;


-- 20. Provider Analysis for Fraudulent Claims: Identify providers with a disproportionately high number of claims flagged as potential fraud in the Train table using a subquery.

SELECT 
    prov,
    total_claim,
    fraud_claims,
    (fraud_claims * 100 / fraud_claims) AS percentage_fraud_claim
FROM
    (SELECT 
        t.provider AS prov,
            COUNT(top.claimid) AS total_claim,
            SUM(CASE
                WHEN potentialfraud = 'Yes' THEN 1
                ELSE 0
            END) AS fraud_claims
    FROM
        train AS t
    INNER JOIN train_outpatient AS top ON t.provider = top.provider
    GROUP BY t.provider) AS fraud_data
WHERE
    (fraud_claims * 100 / total_claim) > (SELECT 
            AVG(fraud_claims * 100 / total_claim)
        FROM
            (SELECT 
                t.provider,
                    COUNT(top.claimid) AS total_claim,
                    SUM(CASE
                        WHEN potentialfraud = 'Yes' THEN 1
                        ELSE 0
                    END) AS fraud_claims
            FROM
                train AS t
            INNER JOIN train_outpatient AS top ON t.provider = top.provider
            GROUP BY t.provider) AS avg_fraud_data);



















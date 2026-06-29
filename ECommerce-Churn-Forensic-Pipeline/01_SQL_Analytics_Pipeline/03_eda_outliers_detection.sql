-- =========================================================================
-- MASTER GRADUATION PROJECT: E-COMMERCE CUSTOMER CHURN PREDICTION
-- PHASE 2: CRIMINAL ANOMALY DETECTION, OUTLIERS AUDIT & SANITY CONTROLS
-- DEVELOPED BY: ENG. OSAMA
-- DATA ENGINE: MYSQL WORKBENCH
-- PART 1 OF 4: COMPREHENSIVE DEMOGRAPHIC OUTLIER PROFILE (AGE)
-- =========================================================================

-- -------------------------------------------------------------------------
-- COLUMN 1: AGE (OUTLIER DETECTION & COMPREHENSIVE PROFILING)
-- -------------------------------------------------------------------------

-- Query 1.1: Scanning system boundary breakthrough for the Age column
-- Explanation: Valid human user age must fall between 15 and 80. This script isolates 
-- extreme outliers to map their initial volume before deep behavioral profiling.
SELECT *
FROM cleaned_ecommerce_data
WHERE NOT (Age BETWEEN 15 AND 80);

-- Query 1.2: Advanced behavioral and financial profiling per specific age anomaly
-- Explanation: Dissecting purchase metrics, order values, discount frequencies, and churn correlation 
-- for the four target system artifacts (5, 10, 150, 200) to understand their latent footprints.
SELECT
    Age AS Outlier_Age_Value,
    COUNT(*) AS Total_Affected_Rows,
    ROUND(AVG(Total_Purchases), 2) AS Avg_Purchases,
    ROUND(MIN(Total_Purchases), 2) AS min_Purchases,
    ROUND(MAX(Total_Purchases), 2) AS max_Purchases,
    ROUND(AVG(Average_Order_Value), 2) AS Avg_Invoice,
    ROUND(MIN(Average_Order_Value), 2) AS min_Invoice,
    ROUND(MAX(Average_Order_Value), 2) AS max_Invoice,
    ROUND(AVG(Discount_Usage_Rate), 2) AS Avg_Discount,
    ROUND(MIN(Discount_Usage_Rate), 2) AS min_Discount,
    ROUND(MAX(Discount_Usage_Rate), 2) AS max_Discount,
    ROUND(AVG(Churned) * 100, 2) AS Churn_Rate_Percentage
FROM cleaned_ecommerce_data
WHERE Age IN (5, 10, 150, 200)
GROUP BY Age
ORDER BY Age ASC;

-- Query 1.3: Baseline extraction for Underage Artifact (Age = 5)
-- Explanation: Mining the clean database tier (Ages 15-80) to extract granular averages matching 
-- the identical purchase behavior and churn profiles of the affected 5-year-old entries.
SELECT
    COUNT(*),
    ROUND(AVG(Age), 0) AS calculated_avg_age,
    CASE
        WHEN Total_Purchases BETWEEN 5 AND 15 AND Churned = 0 THEN 'purchase_5-15/churned_0'
        WHEN Total_Purchases BETWEEN 5 AND 15 AND Churned = 1 THEN 'purchase_5-15/churned_1'
        WHEN Total_Purchases BETWEEN 16 AND 31 AND Churned = 0 THEN 'purchase_16-31/churned_0'
        ELSE 'purchase_16-31/churned_1'
    END AS avg_real_age
FROM cleaned_ecommerce_data
WHERE Age BETWEEN 15 AND 80
GROUP BY
    CASE
        WHEN Total_Purchases BETWEEN 5 AND 15 AND Churned = 0 THEN 'purchase_5-15/churned_0'
        WHEN Total_Purchases BETWEEN 5 AND 15 AND Churned = 1 THEN 'purchase_5-15/churned_1'
        WHEN Total_Purchases BETWEEN 16 AND 31 AND Churned = 0 THEN 'purchase_16-31/churned_0'
        ELSE 'purchase_16-31/churned_1'
    END;

-- Query 1.4: Baseline extraction for Underage Artifact (Age = 10)
SELECT
    COUNT(*),
    ROUND(AVG(Age), 0) AS calculated_avg_age,
    CASE
        WHEN Total_Purchases BETWEEN 5 AND 11 AND Churned = 0 THEN 'purchase_5-11/churned_0'
        WHEN Total_Purchases BETWEEN 5 AND 11 AND Churned = 1 THEN 'purchase_5-11/churned_1'
        WHEN Total_Purchases BETWEEN 12 AND 30 AND Churned = 0 THEN 'purchase_12-30/churned_0'
        ELSE 'purchase_12-30/churned_1'
    END AS avg_real_age
FROM cleaned_ecommerce_data
WHERE Age BETWEEN 15 AND 80
GROUP BY
    CASE
        WHEN Total_Purchases BETWEEN 5 AND 11 AND Churned = 0 THEN 'purchase_5-11/churned_0'
        WHEN Total_Purchases BETWEEN 5 AND 11 AND Churned = 1 THEN 'purchase_5-11/churned_1'
        WHEN Total_Purchases BETWEEN 12 AND 30 AND Churned = 0 THEN 'purchase_12-30/churned_0'
        ELSE 'purchase_12-30/churned_1'
    END;
-- Query 1.5: Baseline extraction for Overage Artifact (Age = 150)
-- Explanation: Mining the clean database tier to map ideal age metrics matching 
-- high-loyalty transaction velocity for the 150-year-old corrupted rows.
SELECT
    COUNT(*),
    ROUND(AVG(Age), 0) AS calculated_avg_age,
    CASE
        WHEN Total_Purchases BETWEEN 9 AND 14 AND Churned = 0 THEN 'purchase_9-14/churned_0'
        WHEN Total_Purchases BETWEEN 9 AND 14 AND Churned = 1 THEN 'purchase_9-14/churned_1'
        WHEN Total_Purchases BETWEEN 15 AND 23 AND Churned = 0 THEN 'purchase_15-23/churned_0'
        ELSE 'purchase_15-23/churned_1'
    END AS avg_real_age
FROM cleaned_ecommerce_data
WHERE Age BETWEEN 15 AND 80
GROUP BY
    CASE
        WHEN Total_Purchases BETWEEN 9 AND 14 AND Churned = 0 THEN 'purchase_9-14/churned_0'
        WHEN Total_Purchases BETWEEN 9 AND 14 AND Churned = 1 THEN 'purchase_9-14/churned_1'
        WHEN Total_Purchases BETWEEN 15 AND 23 AND Churned = 0 THEN 'purchase_15-23/churned_0'
        ELSE 'purchase_15-23/churned_1'
    END;

-- Query 1.6: Baseline extraction for Overage Artifact (Age = 200)
SELECT
    COUNT(*),
    ROUND(AVG(Age), 0) AS calculated_avg_age,
    CASE
        WHEN Total_Purchases BETWEEN 5 AND 11 AND Churned = 0 THEN 'purchase_5-11/churned_0'
        WHEN Total_Purchases BETWEEN 5 AND 11 AND Churned = 1 THEN 'purchase_5-11/churned_1'
        WHEN Total_Purchases BETWEEN 12 AND 18 AND Churned = 0 THEN 'purchase_12-18/churned_0'
        ELSE 'purchase_12-18/churned_1'
    END AS avg_real_age
FROM cleaned_ecommerce_data
WHERE Age BETWEEN 15 AND 80
GROUP BY
    CASE
        WHEN Total_Purchases BETWEEN 5 AND 11 AND Churned = 0 THEN 'purchase_5-11/churned_0'
        WHEN Total_Purchases BETWEEN 5 AND 11 AND Churned = 1 THEN 'purchase_5-11/churned_1'
        WHEN Total_Purchases BETWEEN 12 AND 18 AND Churned = 0 THEN 'purchase_12-18/churned_0'
        ELSE 'purchase_12-18/churned_1'
    END;

-- Query 1.7: Executing the finalized Age Column Imputation Script
-- Explanation: Injecting the discovered behavioral numbers into the four corrupted zones.
SELECT
    CASE
        WHEN ROUND(CAST(TRIM(Age) AS FLOAT), 0) = 5 THEN
            CASE
                WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 5 AND 15 AND ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 0 THEN 39
                WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 16 AND 31 AND ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 0 THEN 39
                WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 16 AND 31 AND ROUND(CAST(TRIM(Churned) AS FLOAT), 1) = 1 THEN 37
                ELSE 36
            END
        WHEN ROUND(CAST(TRIM(Age) AS FLOAT), 0) = 10 THEN
            CASE
                WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 5 AND 11 AND ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 0 THEN 39
                WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 12 AND 30 AND ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 0 THEN 38
                WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 12 AND 30 AND ROUND(CAST(TRIM(Churned) AS FLOAT), 1) = 1 THEN 36
                ELSE 36
            END
        WHEN ROUND(CAST(TRIM(Age) AS FLOAT), 0) = 150 THEN
            CASE
                WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 9 AND 14 AND ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 0 THEN 38
                WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 15 AND 23 AND ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 0 THEN 38
                WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 15 AND 23 AND ROUND(CAST(TRIM(Churned) AS FLOAT), 1) = 1 THEN 37
                ELSE 35
            END
        WHEN ROUND(CAST(TRIM(Age) AS FLOAT), 0) = 200 THEN
            CASE
                WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 5 AND 11 AND ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 0 THEN 39
                WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 12 AND 18 AND ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 0 THEN 38
                WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 12 AND 18 AND ROUND(CAST(TRIM(Churned) AS FLOAT), 1) = 1 THEN 37
                ELSE 36
            END
        ELSE ROUND(CAST(TRIM(Age) AS FLOAT), 0)
    END AS Corrected_Age
FROM cleaned_ecommerce_data;

-- -------------------------------------------------------------------------
-- COLUMNS 2, 3, 4, 5, 6 & 7: GEOGRAPHICS & IDENTITY INTEGRITY AUDITS
-- -------------------------------------------------------------------------

-- Query 2.1: Profiling Country and City value fields for reporting verification
SELECT Country FROM cleaned_ecommerce_data GROUP BY Country;
SELECT City FROM cleaned_ecommerce_data GROUP BY City;

-- Query 2.2: Auditing biological cross-constraints (Membership Years vs Physical Age)
SELECT Membership_Years, Age
FROM cleaned_ecommerce_data
WHERE NOT (Membership_Years >= 0 AND Membership_Years <= 25 AND Membership_Years < Age);

-- Query 2.3: Auditing logical boundary caps for system interaction logs
SELECT Login_Frequency FROM cleaned_ecommerce_data WHERE NOT (Login_Frequency >= 0 AND Login_Frequency <= 50);
SELECT Session_Duration FROM cleaned_ecommerce_data WHERE NOT (Session_Duration BETWEEN 0 AND 90);

-- -------------------------------------------------------------------------
-- COLUMN 9: CART ABANDONMENT RATE (PERCENTAGE BREAKTHROUGH CONTROLS)
-- -------------------------------------------------------------------------

-- Query 3.1: Scanning for invalid percentage bounds exceeding 100%
SELECT Cart_Abandonment_Rate, COUNT(Cart_Abandonment_Rate) OVER()
FROM cleaned_ecommerce_data
WHERE NOT (Cart_Abandonment_Rate BETWEEN 0 AND 100);

-- Query 3.2: Behavioral profiling of rows containing abandonment rate breakthroughs (>100%)
SELECT
    Cart_Abandonment_Rate AS Outlier_Abandonment_Value,
    COUNT(*) AS Total_Affected_Rows,
    ROUND(AVG(Total_Purchases), 2) AS Avg_Purchases,
    ROUND(AVG(Session_Duration), 2) AS Avg_Session_Duration,
    ROUND(AVG(Pages_Per_Session), 2) AS Avg_Pages,
    ROUND(AVG(Churned) * 100, 2) AS Churn_Rate_Percentage
FROM cleaned_ecommerce_data
WHERE Cart_Abandonment_Rate > 100
GROUP BY Cart_Abandonment_Rate
ORDER BY Total_Affected_Rows DESC;
-- Query 3.3: Mining baseline metrics from stable customer tiers (Abandonment 0-100%)
-- Explanation: Extracting precise subgroup averages based on the intersections of 
-- purchase velocity and churn patterns to replace corrupted rates.
SELECT
    COUNT(*),
    ROUND(AVG(Cart_Abandonment_Rate), 2) AS calculated_avg_abandonment,
    CASE
        WHEN Total_Purchases BETWEEN 4 AND 15 AND Churned = 0 THEN 'purchase_4-15/churned_0'
        WHEN Total_Purchases BETWEEN 4 AND 15 AND Churned = 1 THEN 'purchase_4-15/churned_1'
        WHEN Total_Purchases BETWEEN 16 AND 34 AND Churned = 0 THEN 'purchase_16-34/churned_0'
        ELSE 'purchase_16-34/churned_1'
    END AS avg_real_abandonment
FROM cleaned_ecommerce_data
WHERE Cart_Abandonment_Rate BETWEEN 0 AND 100
GROUP BY
    CASE
        WHEN Total_Purchases BETWEEN 4 AND 15 AND Churned = 0 THEN 'purchase_4-15/churned_0'
        WHEN Total_Purchases BETWEEN 4 AND 15 AND Churned = 1 THEN 'purchase_4-15/churned_1'
        WHEN Total_Purchases BETWEEN 16 AND 34 AND Churned = 0 THEN 'purchase_16-34/churned_0'
        ELSE 'purchase_16-34/churned_1'
    END;

-- Query 3.4: Executing the finalized matrix injection for Cart Abandonment Rate
SELECT
    CASE
        WHEN Cart_Abandonment_Rate > 100 THEN
            CASE
                WHEN Total_Purchases BETWEEN 4 AND 15 AND Churned = 0 THEN 59.73
                WHEN Total_Purchases BETWEEN 16 AND 34 AND Churned = 0 THEN 43.33
                WHEN Total_Purchases BETWEEN 16 AND 34 AND Churned = 1 THEN 55.07
                ELSE 68.74
            END
        ELSE ROUND(Cart_Abandonment_Rate, 2)
    END AS Corrected_Cart_Abandonment_Rate
FROM cleaned_ecommerce_data;

-- -------------------------------------------------------------------------
-- COLUMNS 10 & 11: WISHLIST ITEMS AND TOTAL PURCHASES (NEGATIVE LOOPS)
-- -------------------------------------------------------------------------

-- Query 4.1: Auditing boundary caps for Wishlist Items
SELECT Wishlist_Items FROM cleaned_ecommerce_data WHERE NOT (Wishlist_Items BETWEEN 0 AND 50);

-- Query 4.2: Capturing the strict database volume of negative purchase records
SELECT COUNT(Total_Purchases) OVER() AS total_negative_purchases, Total_Purchases
FROM cleaned_ecommerce_data
WHERE NOT (Total_Purchases BETWEEN 0 AND 150);

-- Query 4.3: Granular behavioral profiling of the 40 corrupted negative transaction rows
SELECT
    Churned,
    COUNT(*) AS Total_Affected,
    MIN(Login_Frequency) AS Min_Logins,
    MAX(Login_Frequency) AS Max_Logins,
    ROUND(AVG(Login_Frequency), 0) AS Avg_Logins,
    ROUND(AVG(Session_Duration), 2) AS Avg_Session
FROM cleaned_ecommerce_data
WHERE Total_Purchases < 0
GROUP BY Churned;

-- Query 4.4: Mining dynamic replacement baselines from positive data layers
SELECT
    ROUND(AVG(CASE WHEN Churned = 1 AND Login_Frequency BETWEEN 4 AND 16 THEN Total_Purchases END), 0) AS Replacement_For_Churned_Outliers,
    ROUND(AVG(CASE WHEN Churned = 0 AND Login_Frequency BETWEEN 0 AND 30 THEN Total_Purchases END), 0) AS Replacement_For_Active_Outliers
FROM cleaned_ecommerce_data
WHERE Total_Purchases >= 0;

-- Query 4.5: Executing clean behavioral replacement for negative purchases
SELECT
    CASE
        WHEN Total_Purchases < 0 THEN
            CASE
                WHEN Churned = 1 THEN 11
                ELSE 14
            END
        ELSE Total_Purchases
    END AS Corrected_Total_Purchases
FROM cleaned_ecommerce_data;

-- -------------------------------------------------------------------------
-- COLUMN 12: AVERAGE ORDER VALUE (EXTREME TICKETS / WHALES)
-- -------------------------------------------------------------------------

-- Query 5.1: Hunting for extreme invoice values breaching standard $500 caps
SELECT Average_Order_Value
FROM cleaned_ecommerce_data
WHERE NOT (Average_Order_Value BETWEEN 1 AND 500);

-- Query 5.2: Segment profiling of high-net-worth customer tier (Whales)
-- Insight: Validated that premium clients possess high transaction velocity, 
-- justifying extreme order tickets as high-value retail volume rather than a glitch.
SELECT
    Churned,
    COUNT(*) AS Total_Affected,
    MIN(Total_Purchases) AS Min_Purchases,
    MAX(Total_Purchases) AS Max_Purchases,
    ROUND(AVG(Total_Purchases), 0) AS Avg_Purchases,
    ROUND(MIN(Average_Order_Value), 2) AS Min_Outlier_Value,
    ROUND(MAX(Average_Order_Value), 2) AS Max_Outlier_Value
FROM cleaned_ecommerce_data
WHERE Average_Order_Value > 500
GROUP BY Churned;

-- Query 5.3: Extracting replacement benchmarks for extreme invoices from retail baselines
SELECT
    ROUND(AVG(CASE WHEN Churned = 0 AND Total_Purchases BETWEEN 8 AND 34 THEN Average_Order_Value END), 2) AS Replacement_For_Active_Outliers,
    ROUND(AVG(CASE WHEN Churned = 1 AND Total_Purchases BETWEEN 1 AND 26 THEN Average_Order_Value END), 2) AS Replacement_For_Churned_Outliers
FROM cleaned_ecommerce_data
WHERE Average_Order_Value BETWEEN 1 AND 500;

-- Query 5.4: Implementing the Average Order Value تطهير controls
SELECT
    CASE
        WHEN Average_Order_Value > 500 THEN
            CASE
                WHEN Churned = 0 THEN 114.17
                ELSE 130.76
            END
        ELSE Average_Order_Value
    END AS Corrected_Average_Order_Value
FROM cleaned_ecommerce_data;

-- -------------------------------------------------------------------------
-- COLUMN 13 & 14: RECENCY AND DISCOUNT USAGE RATES (>100% CONTROLS)
-- -------------------------------------------------------------------------

-- Query 6.1: Validating standard operational bounds for Recency Days
SELECT Days_Since_Last_Purchase FROM cleaned_ecommerce_data WHERE NOT (Days_Since_Last_Purchase BETWEEN 0 AND 365);

-- Query 6.2: Detecting percentage breakthroughs in Discount Usage Rate
SELECT Discount_Usage_Rate, COUNT(Discount_Usage_Rate) OVER() AS total_outlier_discount_rows
FROM cleaned_ecommerce_data
WHERE NOT (Discount_Usage_Rate BETWEEN 0 AND 100);
-- Query 6.3: Behavioral profiling of the 207 corrupted discount usage rate records (>100%)
-- Explanation: Evaluating purchase volumes per loyalty status to build clean baseline mappings.
SELECT
    Churned,
    COUNT(*) AS Total_Affected,
    MIN(Total_Purchases) AS Min_Purchases,
    MAX(Total_Purchases) AS Max_Purchases,
    ROUND(AVG(Total_Purchases), 0) AS Avg_Purchases,
    ROUND(MIN(Discount_Usage_Rate), 2) AS Min_Outlier,
    ROUND(MAX(Discount_Usage_Rate), 2) AS Max_Outlier
FROM cleaned_ecommerce_data
WHERE Discount_Usage_Rate > 100
GROUP BY Churned;

-- Query 6.4: Mining baseline averages for the Discount matrix from valid data layers
SELECT
    ROUND(AVG(CASE WHEN Churned = 1 AND Total_Purchases BETWEEN 3 AND 32 THEN Discount_Usage_Rate END), 2) AS Replacement_For_Churned_Outliers,
    ROUND(AVG(CASE WHEN Churned = 0 AND Total_Purchases BETWEEN 4 AND 35 THEN Discount_Usage_Rate END), 2) AS Replacement_For_Active_Outliers
FROM cleaned_ecommerce_data
WHERE Discount_Usage_Rate BETWEEN 0 AND 100;

-- Query 6.5: Executing full column decimal rounding to eliminate infinite FLOAT fractional artifacts
-- Explanation: Forcing structural 2-decimal rounding across all records to eradicate micro-byte trailing tails.
SELECT
    ROUND(
        CASE
            WHEN Discount_Usage_Rate > 100 THEN
                CASE
                    WHEN Churned = 1 THEN 36.56
                    ELSE 39.66
                END
            ELSE Discount_Usage_Rate
        END, 
    2) AS Corrected_Discount_Usage_Rate
FROM cleaned_ecommerce_data;

-- -------------------------------------------------------------------------
-- COLUMNS 15, 16 & 17: RETURNS, EMAIL OPENINGS & CUSTOMER SERVICE CALLS
-- -------------------------------------------------------------------------

-- Query 7.1: Performing system sanity check across transactional & engagement rates
-- Finding: Returns and Email features are 100% stable and structurally sound within standard retail limits.
SELECT
    CASE
        WHEN Returns_Rate < 0 THEN 'Outlier: Negative Rate (<0)'
        WHEN Returns_Rate > 100 THEN 'Outlier: Exceeds 100% (>100)'
        ELSE 'Normal Returns Range (0-100)'
    END AS Returns_Sane_Check,
    COUNT(*), MIN(Returns_Rate), MAX(Returns_Rate), ROUND(AVG(Total_Purchases), 2)
FROM cleaned_ecommerce_data
GROUP BY 
    CASE
        WHEN Returns_Rate < 0 THEN 'Outlier: Negative Rate (<0)'
        WHEN Returns_Rate > 100 THEN 'Outlier: Exceeds 100% (>100)'
        ELSE 'Normal Returns Range (0-100)'
    END;

SELECT
    CASE
        WHEN Email_Opening_Rate < 0 THEN 'Outlier: Negative Rate (<0)'
        WHEN Email_Opening_Rate > 100 THEN 'Outlier: Exceeds 100% (>100)'
        ELSE 'Normal Email Range (0-100)'
    END AS Email_Sane_Check,
    COUNT(*), MIN(Email_Opening_Rate), MAX(Email_Opening_Rate)
FROM cleaned_ecommerce_data
GROUP BY 
    CASE
        WHEN Email_Opening_Rate < 0 THEN 'Outlier: Negative Rate (<0)'
        WHEN Email_Opening_Rate > 100 THEN 'Outlier: Exceeds 100% (>100)'
        ELSE 'Normal Email Range (0-100)'
    END;

-- Query 7.2: Auditing Customer Support Calls for boundary breaking loops
-- Insight: Identified a single extreme record at 21 calls. Preserved deliberately to maintain 100% pure churn correlation.
SELECT
    CASE
        WHEN Customer_Support_Calls < 0 THEN 'Outlier: Negative Calls (<0)'
        WHEN Customer_Support_Calls > 20 THEN 'Outlier: Extreme Calls (>20)'
        ELSE 'Normal Calls Range (0-20)'
    END AS Calls_Sane_Check,
    COUNT(*), MIN(Customer_Support_Calls), MAX(Customer_Support_Calls), ROUND(AVG(Churned)*100,2)
FROM cleaned_ecommerce_data
GROUP BY 
    CASE
        WHEN Customer_Support_Calls < 0 THEN 'Outlier: Negative Calls (<0)'
        WHEN Customer_Support_Calls > 20 THEN 'Outlier: Extreme Calls (>20)'
        ELSE 'Normal Calls Range (0-20)'
    END;

-- -------------------------------------------------------------------------
-- COLUMN 18: PRODUCT RATING AVERAGE (GRANULAR WHOLE NUMBER ALIGNMENT)
-- -------------------------------------------------------------------------

-- Query 8.1: Auditing system breaks for star ratings (Bound to 1-5 stars)
SELECT Product_Rating_Average FROM cleaned_ecommerce_data WHERE NOT (Product_Rating_Average BETWEEN 1 AND 5) GROUP BY Product_Rating_Average;

-- Query 8.2: Profiling product rating breakthroughs outside normal parameters (0 and values > 5)
SELECT
    Product_Rating_Average AS Outlier_Rating,
    COUNT(*) AS Total_Affected_Rows,
    MIN(Total_Purchases) AS Min_Purchases,
    MAX(Total_Purchases) AS Max_Purchases,
    ROUND(AVG(Total_Purchases), 2) AS Avg_Purchases,
    ROUND(AVG(Churned) * 100, 2) AS Churn_Rate_Percentage
FROM cleaned_ecommerce_data
WHERE Product_Rating_Average > 5 OR Product_Rating_Average = 0
GROUP BY Product_Rating_Average
ORDER BY Total_Affected_Rows DESC;

-- Query 8.3: Mining baseline star metrics exclusively from verified 5-star data blocks
SELECT
    COUNT(*), ROUND(AVG(Product_Rating_Average), 2) AS calculated_avg_rating,
    CASE
        WHEN Total_Purchases BETWEEN 5 AND 20 AND Churned = 0 THEN 'purchases_5-20/churned_0'
        WHEN Total_Purchases BETWEEN 21 AND 45 AND Churned = 0 THEN 'purchases_21-45/churned_0'
        WHEN Total_Purchases BETWEEN 21 AND 45 AND Churned = 1 THEN 'purchases_21-45/churned_1'
        ELSE 'purchases_21-45/churned_1'
    END AS avg_real_rating_group
FROM cleaned_ecommerce_data
WHERE Product_Rating_Average BETWEEN 1 AND 5
GROUP BY
    CASE
        WHEN Total_Purchases BETWEEN 5 AND 20 AND Churned = 0 THEN 'purchases_5-20/churned_0'
        WHEN Total_Purchases BETWEEN 21 AND 45 AND Churned = 0 THEN 'purchases_21-45/churned_0'
        WHEN Total_Purchases BETWEEN 21 AND 45 AND Churned = 1 THEN 'purchases_21-45/churned_1'
        ELSE 'purchases_21-45/churned_1'
    END;

-- Query 8.4: Implementing the integer alignment script for Product Rating Average
-- Explanation: Enforcing strict whole integer parameters (0 decimal tails) to simulate real-world customer clicks.
SELECT
    CASE
        WHEN Product_Rating_Average = 0 OR Product_Rating_Average > 5 THEN
            CASE
                WHEN Total_Purchases BETWEEN 5 AND 20 AND Churned = 0 THEN 3
                WHEN Total_Purchases BETWEEN 21 AND 45 AND Churned = 0 THEN 3
                WHEN Total_Purchases BETWEEN 21 AND 45 AND Churned = 1 THEN 2
                ELSE 2
            END
        ELSE Product_Rating_Average
    END AS Corrected_Product_Rating_Average
FROM cleaned_ecommerce_data;

-- -------------------------------------------------------------------------
-- COLUMNS 19, 20, 21, 22 & 23: PLATFORM LOGS & SYSTEMIC CREDIT WALLET LOOPS
-- -------------------------------------------------------------------------

-- Query 9.1: Verification checks across digital engagement and failure logs
SELECT Social_Media_Engagement FROM cleaned_ecommerce_data WHERE Social_Media_Engagement;

-- Query 9.2: Exposing the large-scale systemic loop inside the Credit Balance column
-- Explanation: Auditing the massive footprint of 45,665 entries corrupted by background calculation errors.
SELECT
    CASE
        WHEN Credit_Balance < 0 THEN 'Outlier: Negative Balance (<0)'
        WHEN Credit_Balance > 300 THEN 'Outlier: Extreme Balance (>300)'
        ELSE 'Normal Credit Range (0-300)'
    END AS Credit_Sane_Check,
    COUNT(*), MIN(Credit_Balance), MAX(Credit_Balance), ROUND(AVG(Total_Purchases), 2), ROUND(AVG(Churned) * 100, 2) AS Churn_Rate_Percentage
FROM cleaned_ecommerce_data
GROUP BY
    CASE
        WHEN Credit_Balance < 0 THEN 'Outlier: Negative Balance (<0)'
        WHEN Credit_Balance > 300 THEN 'Outlier: Extreme Balance (>300)'
        ELSE 'Normal Credit Range (0-300)'
    END;

-- Query 9.3: Profiling uncorrupted customer records to establish baseline metrics
SELECT
    Churned, COUNT(*) AS Total_Customers, MIN(Total_Purchases) AS Min_Purchases, MAX(Total_Purchases) AS Max_Purchases,
    ROUND(AVG(Total_Purchases), 0) AS Avg_Purchases, ROUND(MIN(Credit_Balance), 2) AS Min_Normal_Balance, ROUND(MAX(Credit_Balance), 2) AS Max_Normal_Balance
FROM cleaned_ecommerce_data
WHERE Credit_Balance BETWEEN 0 AND 300
GROUP BY Churned;

-- Query 9.4: Mining targeted wallet values from steady-state purchase groups
SELECT
    ROUND(AVG(CASE WHEN Churned = 0 AND Total_Purchases = 9 THEN Credit_Balance END), 2) AS Replacement_For_Active_Outliers,
    ROUND(AVG(CASE WHEN Churned = 1 AND Total_Purchases = 7 THEN Credit_Balance END), 2) AS Replacement_For_Churned_Outliers
FROM cleaned_ecommerce_data
WHERE Credit_Balance BETWEEN 0 AND 300;

-- Query 9.5: Executing systemic correction injection for the Credit Balance column
SELECT
    CASE
        WHEN Credit_Balance > 300 THEN
            CASE
                WHEN Churned = 0 THEN 58.36
                ELSE 69.72
            END
        ELSE Credit_Balance
    END AS Corrected_Credit_Balance
FROM cleaned_ecommerce_data;

-- Query 9.6: High-assurance binary sanity check for financial boundaries and target variables
SELECT
    MIN(Lifetime_Value) AS Min_LTV, MAX(Lifetime_Value) AS Max_LTV,
    MIN(Churned) AS Min_Churned_Value, MAX(Churned) AS Max_Churned_Value, COUNT(DISTINCT Churned) AS Unique_Churned_States,
    COUNT(DISTINCT Signup_Quarter) AS Unique_Quarter_States
FROM cleaned_ecommerce_data;

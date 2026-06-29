-- =========================================================================
-- GRADUATION PROJECT: E-COMMERCE CUSTOMER CHURN PREDICTION
-- PHASE 1: EXPLORATORY DATA ANALYSIS (EDA) & INITIAL CLEANING
-- DEVELOPED BY: ENG. OSAMA
-- PURPOSE: INVESTIGATING MISSING VALUES & BEHAVIORAL SEGMENTATION
-- =========================================================================

-- -------------------------------------------------------------------------
-- SECTION 1: AGE COLUMN INVESTIGATION & INITIAL SEGMENTATION
-- -------------------------------------------------------------------------

-- Query 1.1: Checking the total number of missing or blank rows in the Age column
-- Explanation: Using COUNT() OVER() to detect any технически damaged rows or Nulls.
SELECT 
    COUNT(Age) OVER() AS total_blank_age_rows
FROM raw_ecommerce_data
WHERE Age IS NULL OR TRIM(Age) = '';

-- Query 1.2: Profiling customer metrics based on initial Age Group brackets
-- Explanation: Analyzing how Lifetime Value, App Usage, Order Tickets, and Abandonment 
-- correlate with different age stages to determine the best imputation strategy.
SELECT
    CASE
        WHEN CAST(Age AS DECIMAL(10,2)) BETWEEN 18 AND 29 THEN '18-29'
        WHEN CAST(Age AS DECIMAL(10,2)) BETWEEN 30 AND 39 THEN '30-39'
        WHEN CAST(Age AS DECIMAL(10,2)) BETWEEN 40 AND 49 THEN '40-49'
        WHEN CAST(Age AS DECIMAL(10,2)) BETWEEN 50 AND 65 THEN '50-65'
        ELSE 'Other'
    END AS age_group,
    
    -- Lifetime Value Profiling
    ROUND(AVG(CAST(Lifetime_Value AS DECIMAL(10,2))), 2) AS avg_Lifetime,
    ROUND(MIN(CAST(Lifetime_Value AS DECIMAL(10,2))), 2) AS min_Lifetime,
    ROUND(MAX(CAST(Lifetime_Value AS DECIMAL(10,2))), 2) AS max_Lifetime,

    -- Mobile App Usage Profiling
    ROUND(AVG(CAST(Mobile_App_Usage_Time AS DECIMAL(10,2))), 2) AS avg_Mobile_Time,
    ROUND(MIN(CAST(Mobile_App_Usage_Time AS DECIMAL(10,2))), 2) AS min_Mobile_Time,
    ROUND(MAX(CAST(Mobile_App_Usage_Time AS DECIMAL(10,2))), 2) AS max_Mobile_Time,

    -- Average Order Value Profiling
    ROUND(AVG(CAST(Average_Order_Value AS DECIMAL(10,2))), 2) AS avg_order_ticket,
    ROUND(MIN(CAST(Average_Order_Value AS DECIMAL(10,2))), 2) AS min_order_ticket,
    ROUND(MAX(CAST(Average_Order_Value AS DECIMAL(10,2))), 2) AS max_order_ticket,

    -- Cart Abandonment Profiling
    ROUND(AVG(CAST(Cart_Abandonment_Rate AS DECIMAL(10,2))), 2) AS Avg_Cart_Abandonment,
    ROUND(MIN(CAST(Cart_Abandonment_Rate AS DECIMAL(10,2))), 2) AS min_Cart_Abandonment,
    ROUND(MAX(CAST(Cart_Abandonment_Rate AS DECIMAL(10,2))), 2) AS max_Cart_Abandonment,

    -- Core Target Metric: Churn Rate per Age Group
    ROUND(AVG(CAST(Churned AS UNSIGNED)) * 100, 2) AS Churn_Rate_Percentage
FROM raw_ecommerce_data 
WHERE TRIM(Age) != '' AND Age IS NOT NULL
GROUP BY 
    CASE
        WHEN CAST(Age AS DECIMAL(10,2)) BETWEEN 18 AND 29 THEN '18-29'
        WHEN CAST(Age AS DECIMAL(10,2)) BETWEEN 30 AND 39 THEN '30-39'
        WHEN CAST(Age AS DECIMAL(10,2)) BETWEEN 40 AND 49 THEN '40-49'
        WHEN CAST(Age AS DECIMAL(10,2)) BETWEEN 50 AND 65 THEN '50-65'
        ELSE 'Other'
    END
ORDER BY age_group;

-- Query 1.3: Early Static Imputation Attempt for Age
-- Explanation: A preliminary testing script mapping missing ages to hardcoded static values 
-- (24 for churned, 36 for active) based on initial churn status.
SELECT
    CASE
        WHEN (TRIM(Age) = '' OR Age IS NULL) AND TRIM(Churned) = 1 THEN 24
        WHEN (TRIM(Age) = '' OR Age IS NULL) AND TRIM(Churned) = 0 THEN 36
        ELSE TRIM(Age)
    END AS new_age
FROM raw_ecommerce_data;

-- -------------------------------------------------------------------------
-- SECTION 2: DEMOGRAPHIC & IDENTITY COLUMNS SANITY CHECK
-- -------------------------------------------------------------------------

-- Query 2.1: Checking for Blank Cells across Identity & Engagement features
-- Explanation: Verifying data integrity for Gender, Country, City, Membership, and Login Frequency.
-- Finding: These fields are 100% clean and contain zero native missing rows from the source.
SELECT COUNT(Gender) OVER() FROM raw_ecommerce_data WHERE Gender IS NULL OR TRIM(Gender) = '';
SELECT COUNT(Country) OVER() FROM raw_ecommerce_data WHERE Country IS NULL OR TRIM(Country) = '';
SELECT COUNT(City) OVER() FROM raw_ecommerce_data WHERE City IS NULL OR TRIM(City) = '';
SELECT COUNT(Membership_Years) OVER() FROM raw_ecommerce_data WHERE Membership_Years IS NULL OR TRIM(Membership_Years) = '';
SELECT COUNT(Login_Frequency) OVER() FROM raw_ecommerce_data WHERE Login_Frequency IS NULL OR TRIM(Login_Frequency) = '';

-- -------------------------------------------------------------------------
-- SECTION 3: SESSION DURATION PROFILE & SEGMENTATION (UPGRADED ARCHITECTURE)
-- -------------------------------------------------------------------------

-- Query 3.1: Auditing system-wide missing values for Session Duration
SELECT 
    COUNT(Session_Duration) OVER() AS total_blank_session_rows 
FROM raw_ecommerce_data 
WHERE Session_Duration IS NULL OR TRIM(Session_Duration) = '';

-- Query 3.2: Profiling missing session rows against platform engagement and transaction velocity
-- Explanation: Dissecting the upper and lower bounds of Pages Per Session and Total Purchases 
-- exclusively for the blank session cohort to extract optimal classification thresholds.
SELECT
    ROUND(MIN(CAST(Pages_Per_Session AS DECIMAL(10,2))), 0) AS min_pages,
    ROUND(AVG(CAST(Pages_Per_Session AS DECIMAL(10,2))), 0) AS avg_pages,
    ROUND(MAX(CAST(Pages_Per_Session AS DECIMAL(10,2))), 0) AS max_pages,

    ROUND(MIN(CAST(Total_Purchases AS DECIMAL(10,2))), 0) AS min_purchases,
    ROUND(AVG(CAST(Total_Purchases AS DECIMAL(10,2))), 0) AS avg_purchases,
    ROUND(MAX(CAST(Total_Purchases AS DECIMAL(10,2))), 0) AS max_purchases
FROM raw_ecommerce_data
WHERE TRIM(Session_Duration) = '' OR Session_Duration IS NULL;

-- Query 3.3: Constructing the 4-quadrant Cross-Sectional baseline grid for Session Duration
-- Explanation: Intersecting page browsing activities with customer lifetime transaction limits 
-- over healthy data layers to isolate exact behavioral baseline values.
SELECT
    CASE 
        WHEN CAST(Pages_Per_Session AS DECIMAL(10,2)) BETWEEN 0 AND 6 AND CAST(Total_Purchases AS DECIMAL(10,2)) BETWEEN -7 AND 10 THEN 'Case 1: Low Browsing / Low Purchases'
        WHEN CAST(Pages_Per_Session AS DECIMAL(10,2)) BETWEEN 0 AND 6 AND CAST(Total_Purchases AS DECIMAL(10,2)) BETWEEN 10 AND 125 THEN 'Case 2: Low Browsing / High Purchases'
        WHEN CAST(Pages_Per_Session AS DECIMAL(10,2)) BETWEEN 6 AND 18 AND CAST(Total_Purchases AS DECIMAL(10,2)) BETWEEN -7 AND 10 THEN 'Case 3: High Browsing / Low Purchases'
        WHEN CAST(Pages_Per_Session AS DECIMAL(10,2)) BETWEEN 6 AND 18 AND CAST(Total_Purchases AS DECIMAL(10,2)) BETWEEN 10 AND 125 THEN 'Case 4: High Browsing / High Purchases'
    END AS session_duration_cases,
    
    ROUND(CAST(AVG(Session_Duration) AS DECIMAL(10,2)), 0) AS calculated_baseline_minutes
FROM raw_ecommerce_data
WHERE Session_Duration IS NOT NULL AND TRIM(Session_Duration) != ''
GROUP BY
    CASE 
        WHEN CAST(Pages_Per_Session AS DECIMAL(10,2)) BETWEEN 0 AND 6 AND CAST(Total_Purchases AS DECIMAL(10,2)) BETWEEN -7 AND 10 THEN 'Case 1: Low Browsing / Low Purchases'
        WHEN CAST(Pages_Per_Session AS DECIMAL(10,2)) BETWEEN 0 AND 6 AND CAST(Total_Purchases AS DECIMAL(10,2)) BETWEEN 10 AND 125 THEN 'Case 2: Low Browsing / High Purchases'
        WHEN CAST(Pages_Per_Session AS DECIMAL(10,2)) BETWEEN 6 AND 18 AND CAST(Total_Purchases AS DECIMAL(10,2)) BETWEEN -7 AND 10 THEN 'Case 3: High Browsing / Low Purchases'
        WHEN CAST(Pages_Per_Session AS DECIMAL(10,2)) BETWEEN 6 AND 18 AND CAST(Total_Purchases AS DECIMAL(10,2)) BETWEEN 10 AND 125 THEN 'Case 4: High Browsing / High Purchases'
    END;

-- Query 3.4: Preliminary Testing Script for Session Duration Imputation Logic
-- Note: Mapping empty records to the newly discovered behavioral benchmarks (17, 33, 26, 51) for system performance evaluation.
SELECT
    CASE
        WHEN Session_Duration IS NULL OR TRIM(Session_Duration) = '' THEN
            CASE 
                WHEN CAST(Pages_Per_Session AS DECIMAL(10,2)) BETWEEN 0 AND 6 AND CAST(Total_Purchases AS DECIMAL(10,2)) BETWEEN -7 AND 10 THEN 17
                WHEN CAST(Pages_Per_Session AS DECIMAL(10,2)) BETWEEN 0 AND 6 AND CAST(Total_Purchases AS DECIMAL(10,2)) BETWEEN 10 AND 125 THEN 33
                WHEN CAST(Pages_Per_Session AS DECIMAL(10,2)) BETWEEN 6 AND 18 AND CAST(Total_Purchases AS DECIMAL(10,2)) BETWEEN -7 AND 10 THEN 26
                WHEN CAST(Pages_Per_Session AS DECIMAL(10,2)) BETWEEN 6 AND 18 AND CAST(Total_Purchases AS DECIMAL(10,2)) BETWEEN 10 AND 125 THEN 51
            END
        ELSE CAST(Session_Duration AS DECIMAL(10,2))
    END AS new_Session_Duration
FROM raw_ecommerce_data;


-- -------------------------------------------------------------------------
-- SECTION 4: PAGES PER SESSION & BEHAVIORAL PATTERN MATCHING
-- -------------------------------------------------------------------------

-- Query 4.1: Checking the total number of missing or blank rows in Pages column
SELECT 
    COUNT(Pages_Per_Session) OVER() AS total_blank_pages_rows
FROM raw_ecommerce_data
WHERE Pages_Per_Session IS NULL OR TRIM(Pages_Per_Session) = '';

-- Query 4.2: Extracting cross-statistical references for multi-variable profiling
-- Explanation: Investigating how Session Duration and Cart Abandonment Rate bounds 
-- intersect to establish stable mathematical anchors for page count trends.
SELECT 
    MIN(CAST(Session_Duration AS DECIMAL(10,2))) AS Session_MIN,
    MAX(CAST(Session_Duration AS DECIMAL(10,2))) AS Session_MAX,
    ROUND(AVG(CAST(Session_Duration AS DECIMAL(10,2))), 2) AS Session_AVG,
    
    MIN(CAST(Cart_Abandonment_Rate AS DECIMAL(10,2))) AS Cart_MIN,
    MAX(CAST(Cart_Abandonment_Rate AS DECIMAL(10,2))) AS Cart_MAX,
    ROUND(AVG(CAST(Cart_Abandonment_Rate AS DECIMAL(10,2))), 2) AS Cart_AVG
FROM raw_ecommerce_data
WHERE Session_Duration != '' AND Session_Duration IS NOT NULL AND Session_Duration != 'NULL'
  AND Cart_Abandonment_Rate != '' AND Cart_Abandonment_Rate IS NOT NULL AND Cart_Abandonment_Rate != 'NULL';

-- Query 4.3: Building the 4-quadrant dynamic reference grid for Pages Per Session
-- Explanation: Classifying clean behavioral patterns into 4 sub-groups to extract 
-- high-accuracy granular averages, avoiding flawed global average imputation.
SELECT 
    CASE 
        WHEN CAST(Session_Duration AS DECIMAL(10,2)) BETWEEN 1 AND 28 
             AND CAST(Cart_Abandonment_Rate AS DECIMAL(10,2)) BETWEEN 0 AND 56 
             THEN 'Case 1: Session 1-28 / Abandonment 0-56'
             
        WHEN CAST(Session_Duration AS DECIMAL(10,2)) BETWEEN 1 AND 28 
             AND CAST(Cart_Abandonment_Rate AS DECIMAL(10,2)) BETWEEN 56 AND 144 
             THEN 'Case 2: Session 1-28 / Abandonment 56-144'
             
        WHEN CAST(Session_Duration AS DECIMAL(10,2)) BETWEEN 28 AND 76 
             AND CAST(Cart_Abandonment_Rate AS DECIMAL(10,2)) BETWEEN 0 AND 56 
             THEN 'Case 3: Session 28-76 / Abandonment 0-56'
             
        ELSE 'Case 4: Session 28-76 / Abandonment 56-144'
    END AS Behavioral_Groups,
    
    ROUND(AVG(CAST(Pages_Per_Session AS DECIMAL(10,2))), 2) AS Avg_Pages_Per_Session
FROM raw_ecommerce_data
WHERE Pages_Per_Session != '' AND Pages_Per_Session IS NOT NULL AND Pages_Per_Session != 'NULL'
  AND Session_Duration != '' AND Session_Duration IS NOT NULL AND Session_Duration != 'NULL'
  AND Cart_Abandonment_Rate != '' AND Cart_Abandonment_Rate IS NOT NULL AND Cart_Abandonment_Rate != 'NULL'
GROUP BY 
    CASE 
        WHEN CAST(Session_Duration AS DECIMAL(10,2)) BETWEEN 1 AND 28 
             AND CAST(Cart_Abandonment_Rate AS DECIMAL(10,2)) BETWEEN 0 AND 56 THEN 'Case 1: Session 1-28 / Abandonment 0-56'
        WHEN CAST(Session_Duration AS DECIMAL(10,2)) BETWEEN 1 AND 28 
             AND CAST(Cart_Abandonment_Rate AS DECIMAL(10,2)) BETWEEN 56 AND 144 THEN 'Case 2: Session 1-28 / Abandonment 56-144'
        WHEN CAST(Session_Duration AS DECIMAL(10,2)) BETWEEN 28 AND 76 
             AND CAST(Cart_Abandonment_Rate AS DECIMAL(10,2)) BETWEEN 0 AND 56 THEN 'Case 3: Session 28-76 / Abandonment 0-56'
        ELSE 'Case 4: Session 28-76 / Abandonment 56-144'
    END;

-- -------------------------------------------------------------------------
-- SECTION 5: WISHLIST ITEMS ANALYSIS & VERIFICATION
-- -------------------------------------------------------------------------

-- Query 5.1: Verifying blank records inside Wishlist feature
SELECT COUNT(Wishlist_Items) OVER() FROM raw_ecommerce_data WHERE Wishlist_Items IS NULL OR TRIM(Wishlist_Items) = '';

-- Query 5.2: Investigating customer profile for blank Wishlist rows
-- Explanation: Discovered that customers with missing wishlist data are largely inactive, 
-- indicating that a logical default of 0 is mathematically sound.
SELECT 
    COUNT(*) AS Total_Blank_Wishlist,
    ROUND(AVG(CAST(Login_Frequency AS SIGNED)), 2) AS Avg_Logins,
    ROUND(AVG(CAST(Total_Purchases AS SIGNED)), 2) AS Avg_Purchases
FROM raw_ecommerce_data
WHERE Wishlist_Items = '' OR Wishlist_Items IS NULL OR Wishlist_Items = 'NULL';

-- -------------------------------------------------------------------------
-- SECTION 6: FINANCIAL CORRELATIONS & RECENT PURCHASE RECENCY
-- -------------------------------------------------------------------------

-- Query 6.1: Auditing system-wide missing structures for financial metrics
SELECT COUNT(Total_Purchases) OVER() FROM raw_ecommerce_data WHERE Total_Purchases IS NULL OR TRIM(Total_Purchases) = '';
SELECT COUNT(Average_Order_Value) OVER() FROM raw_ecommerce_data WHERE Average_Order_Value IS NULL OR TRIM(Average_Order_Value) = '';
SELECT COUNT(Days_Since_Last_Purchase) OVER() FROM raw_ecommerce_data WHERE Days_Since_Last_Purchase IS NULL OR TRIM(Days_Since_Last_Purchase) = '';

-- Query 6.2: Profiling missing Recency rows crossed with customer Loyalty status
-- Explanation: Splitting missing records based on Churn state to extract exact bounds 
-- for transaction velocity and frequency.
SELECT 
    CASE 
        WHEN Churned = '1' THEN 'Churned Customer (1)'
        ELSE 'Active Customer (0)'
    END AS Customer_Status,
    COUNT(*) AS Total_Blank_Customers,
    ROUND(AVG(CAST(Total_Purchases AS SIGNED)), 2) AS Avg_Purchases,
    MIN(CAST(Total_Purchases AS SIGNED)) AS Min_Purchases,
    MAX(CAST(Total_Purchases AS SIGNED)) AS Max_Purchases
FROM raw_ecommerce_data
WHERE Days_Since_Last_Purchase = '' OR Days_Since_Last_Purchase = 'NULL' OR Days_Since_Last_Purchase IS NULL
GROUP BY Churned;

-- Query 6.3: Building the 4-quadrant reference grid for Recency Imputation
SELECT 
    CASE 
        WHEN Churned = '0' AND CAST(Total_Purchases AS SIGNED) BETWEEN -11 AND 14 THEN 'Case 1: Active (0) / Purchases -11 to 14'
        WHEN Churned = '0' AND CAST(Total_Purchases AS SIGNED) BETWEEN 15 AND 109 THEN 'Case 2: Active (0) / Purchases 15 to 109'
        WHEN Churned = '1' AND CAST(Total_Purchases AS SIGNED) BETWEEN 1 AND 12 THEN 'Case 3: Churned (1) / Purchases 1 to 12'
        ELSE 'Case 4: Churned (1) / Purchases 13 to 98'
    END AS Behavioral_Recency_Groups,
    ROUND(AVG(CAST(Days_Since_Last_Purchase AS SIGNED)), 2) AS Avg_Days_Since_Last_Purchase
FROM raw_ecommerce_data
WHERE Days_Since_Last_Purchase != '' AND Days_Since_Last_Purchase IS NOT NULL AND Days_Since_Last_Purchase != 'NULL'
GROUP BY 
    CASE 
        WHEN Churned = '0' AND CAST(Total_Purchases AS SIGNED) BETWEEN -11 AND 14 THEN 'Case 1: Active (0) / Purchases -11 to 14'
        WHEN Churned = '0' AND CAST(Total_Purchases AS SIGNED) BETWEEN 15 AND 109 THEN 'Case 2: Active (0) / Purchases 15 to 109'
        WHEN Churned = '1' AND CAST(Total_Purchases AS SIGNED) BETWEEN 1 AND 12 THEN 'Case 3: Churned (1) / Purchases 1 to 12'
        ELSE 'Case 4: Churned (1) / Purchases 13 to 98'
    END;

-- -------------------------------------------------------------------------
-- SECTION 7: PROFILING MARKETING DISCOUNTS & RETURN CONSTRAINTS
-- -------------------------------------------------------------------------

-- Query 7.1: Inspecting missing cells inside Discount & Returns columns
SELECT COUNT(Discount_Usage_Rate) OVER() FROM raw_ecommerce_data WHERE Discount_Usage_Rate IS NULL OR TRIM(Discount_Usage_Rate) = '';
SELECT COUNT(Returns_Rate) OVER() FROM raw_ecommerce_data WHERE Returns_Rate IS NULL OR TRIM(Returns_Rate) = '';

-- Query 7.2: Crossing missing Return Rates with customer Support calls
-- Explanation: Discovered a strong tie between blank return cells, loyalty purchases, and support frequency, 
-- forming the foundation for the finalized dynamic Returns matrix.
SELECT 
    CASE 
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN -8 AND 12 AND CAST(Customer_Support_Calls AS SIGNED) BETWEEN 0 AND 5 THEN 'Case 1: Purchases -8 to 12 / Support 0 to 5'
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN -8 AND 12 AND CAST(Customer_Support_Calls AS SIGNED) BETWEEN 6 AND 18 THEN 'Case 2: Purchases -8 to 12 / Support 6 to 18'
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN 13 AND 42 AND CAST(Customer_Support_Calls AS SIGNED) BETWEEN 0 AND 5 THEN 'Case 3: Purchases 13 to 42 / Support 0 to 5'
        ELSE 'Case 4: Purchases 13 to 42 / Support 6 to 18'
    END AS Behavioral_Returns_Groups,
    ROUND(AVG(CAST(Returns_Rate AS DECIMAL(10,2))), 2) AS Avg_Returns_Rate
FROM raw_ecommerce_data
WHERE Returns_Rate != '' AND Returns_Rate IS NOT NULL AND Returns_Rate != 'NULL'
GROUP BY 
    CASE 
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN -8 AND 12 AND CAST(Customer_Support_Calls AS SIGNED) BETWEEN 0 AND 5 THEN 'Case 1: Purchases -8 to 12 / Support 0 to 5'
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN -8 AND 12 AND CAST(Customer_Support_Calls AS SIGNED) BETWEEN 6 AND 18 THEN 'Case 2: Purchases -8 to 12 / Support 6 to 18'
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN 13 AND 42 AND CAST(Customer_Support_Calls AS SIGNED) BETWEEN 0 AND 5 THEN 'Case 3: Purchases 13 to 42 / Support 0 to 5'
        ELSE 'Case 4: Purchases 13 to 42 / Support 6 to 18'
    END;
-- -------------------------------------------------------------------------
-- SECTION 8: MARKETING ENGAGEMENT & EMAIL OPENING RATES
-- -------------------------------------------------------------------------

-- Query 8.1: Auditing system-wide missing values for Email Opening Rate
SELECT 
    COUNT(Email_Opening_Rate) OVER() AS total_blank_email_rows
FROM raw_ecommerce_data
WHERE Email_Opening_Rate IS NULL OR TRIM(Email_Opening_Rate) = '';

-- Query 8.2: Profiling missing Email rows crossed with active behaviors
-- Explanation: Investigating the distribution of Login Frequency and Discount Usage 
-- exclusively for records with blank email metrics to map latent user types.
SELECT 
    MIN(CAST(Login_Frequency AS SIGNED)) AS Logins_MIN,
    MAX(CAST(Login_Frequency AS SIGNED)) AS Logins_MAX,
    ROUND(AVG(CAST(Login_Frequency AS SIGNED)), 2) AS Logins_AVG,
    
    MIN(CAST(Discount_Usage_Rate AS DECIMAL(10,2))) AS Discounts_MIN,
    MAX(CAST(Discount_Usage_Rate AS DECIMAL(10,2))) AS Discounts_MAX,
    ROUND(AVG(CAST(Discount_Usage_Rate AS DECIMAL(10,2))), 2) AS Discounts_AVG
FROM raw_ecommerce_data
WHERE Email_Opening_Rate = '' OR Email_Opening_Rate = 'NULL' OR Email_Opening_Rate IS NULL;

-- Query 8.3: Establishing the 4-quadrant Email Imputation Matrix
-- Explanation: Crossing Login Frequency with Discount Usage thresholds to extract 
-- highly calibrated behavioral averages, preventing systemic skewness.
SELECT 
    CASE 
        WHEN CAST(Login_Frequency AS SIGNED) BETWEEN 0 AND 4 
             AND CAST(Discount_Usage_Rate AS DECIMAL(10,2)) BETWEEN 0.00 AND 39.30 
             THEN 'Case 1: Logins 0-4 / Discounts 0-39.30'
             
        WHEN CAST(Login_Frequency AS SIGNED) BETWEEN 0 AND 4 
             AND CAST(Discount_Usage_Rate AS DECIMAL(10,2)) BETWEEN 39.31 AND 113.16 
             THEN 'Case 2: Logins 0-4 / Discounts 39.31-113.16'
             
        WHEN CAST(Login_Frequency AS SIGNED) BETWEEN 5 AND 9 
             AND CAST(Discount_Usage_Rate AS DECIMAL(10,2)) BETWEEN 0.00 AND 39.30 
             THEN 'Case 3: Logins 5-9 / Discounts 0-39.30'
             
        ELSE 'Case 4: Logins 5-9 / Discounts 39.31-113.16'
    END AS Behavioral_Email_Groups,
    
    ROUND(AVG(CAST(Email_Opening_Rate AS DECIMAL(10,2))), 2) AS Avg_Email_Opening_Rate
FROM raw_ecommerce_data
WHERE Email_Opening_Rate != '' AND Email_Opening_Rate IS NOT NULL AND Email_Opening_Rate != 'NULL'
GROUP BY 
    CASE 
        WHEN CAST(Login_Frequency AS SIGNED) BETWEEN 0 AND 4 AND CAST(Discount_Usage_Rate AS DECIMAL(10,2)) BETWEEN 0.00 AND 39.30 THEN 'Case 1: Logins 0-4 / Discounts 0-39.30'
        WHEN CAST(Login_Frequency AS SIGNED) BETWEEN 0 AND 4 AND CAST(Discount_Usage_Rate AS DECIMAL(10,2)) BETWEEN 39.31 AND 113.16 THEN 'Case 2: Logins 0-4 / Discounts 39.31-113.16'
        WHEN CAST(Login_Frequency AS SIGNED) BETWEEN 5 AND 9 AND CAST(Discount_Usage_Rate AS DECIMAL(10,2)) BETWEEN 0.00 AND 39.30 THEN 'Case 3: Logins 5-9 / Discounts 0-39.30'
        ELSE 'Case 4: Logins 5-9 / Discounts 39.31-113.16'
    END;

-- -------------------------------------------------------------------------
-- SECTION 9: CUSTOMER SERVICE METRICS & SUPPORT CALL PROFILE
-- -------------------------------------------------------------------------

-- Query 9.1: Verifying blank cells inside Customer Support Logs
SELECT COUNT(Customer_Support_Calls) OVER() FROM raw_ecommerce_data WHERE Customer_Support_Calls IS NULL OR TRIM(Customer_Support_Calls) = '';

-- Query 9.2: Factoring missing support calls against core e-commerce pillars
-- Explanation: Extracting data ranges for Total Purchases and Return Rates for customers 
-- with blank support records to isolate friction points.
SELECT 
    MIN(CAST(Total_Purchases AS SIGNED)) AS Purchases_MIN,
    MAX(CAST(Total_Purchases AS SIGNED)) AS Purchases_MAX,
    ROUND(AVG(CAST(Total_Purchases AS SIGNED)), 2) AS Purchases_AVG,
    
    MIN(CAST(Returns_Rate AS DECIMAL(10,2))) AS Returns_MIN,
    MAX(CAST(Returns_Rate AS DECIMAL(10,2))) AS Returns_MAX,
    ROUND(AVG(CAST(Returns_Rate AS DECIMAL(10,2))), 2) AS Returns_AVG
FROM raw_ecommerce_data
WHERE Customer_Support_Calls = '' OR Customer_Support_Calls = 'NULL' OR Customer_Support_Calls IS NULL;

-- Query 9.3: Constructing the Support Call Behavioral Imputation Matrix
SELECT 
    CASE 
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN 2 AND 9 
             AND CAST(Returns_Rate AS DECIMAL(10,2)) BETWEEN 0.00 AND 6.12 
             THEN 'Case 1: Purchases 2-9 / Returns 0-6.12'
             
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN 2 AND 9 
             AND CAST(Returns_Rate AS DECIMAL(10,2)) BETWEEN 6.13 AND 21.90 
             THEN 'Case 2: Purchases 2-9 / Returns 6.13-21.90'
             
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN 10 AND 23 
             AND CAST(Returns_Rate AS DECIMAL(10,2)) BETWEEN 0.00 AND 6.12 
             THEN 'Case 3: Purchases 10-23 / Returns 0-6.12'
             
        ELSE 'Case 4: Purchases 10-23 / Returns 6.13-21.90'
    END AS Behavioral_Support_Groups,
    
    ROUND(AVG(CAST(Customer_Support_Calls AS SIGNED)), 2) AS Avg_Support_Calls
FROM raw_ecommerce_data
WHERE Customer_Support_Calls != '' AND Customer_Support_Calls IS NOT NULL AND Customer_Support_Calls != 'NULL'
GROUP BY 
    CASE 
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN 2 AND 9 AND CAST(Returns_Rate AS DECIMAL(10,2)) BETWEEN 0.00 AND 6.12 THEN 'Case 1: Purchases 2-9 / Returns 0-6.12'
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN 2 AND 9 AND CAST(Returns_Rate AS DECIMAL(10,2)) BETWEEN 6.13 AND 21.90 THEN 'Case 2: Purchases 2-9 / Returns 6.13-21.90'
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN 10 AND 23 AND CAST(Returns_Rate AS DECIMAL(10,2)) BETWEEN 0.00 AND 6.12 THEN 'Case 3: Purchases 10-23 / Returns 0-6.12'
        ELSE 'Case 4: Purchases 10-23 / Returns 6.13-21.90'
    END;

-- -------------------------------------------------------------------------
-- SECTION 10: USER RATING DISCOVERY & STRUCTURAL INTEGRITY
-- -------------------------------------------------------------------------

-- Query 10.1: Detecting missing records in Product Rating Average
SELECT COUNT(Product_Rating_Average) OVER() FROM raw_ecommerce_data WHERE Product_Rating_Average IS NULL OR TRIM(Product_Rating_Average) = '';

-- Query 10.2: Profiling underlying patterns for blank rating entries
SELECT 
    MIN(CAST(Customer_Support_Calls AS SIGNED)) AS Support_Calls_MIN,
    MAX(CAST(Customer_Support_Calls AS SIGNED)) AS Support_Calls_MAX,
    ROUND(AVG(CAST(Customer_Support_Calls AS SIGNED)), 2) AS Support_Calls_AVG,
    
    MIN(CAST(Returns_Rate AS DECIMAL(10,2))) AS Returns_MIN,
    MAX(CAST(Returns_Rate AS DECIMAL(10,2))) AS Returns_MAX,
    ROUND(AVG(CAST(Returns_Rate AS DECIMAL(10,2))), 2) AS Returns_AVG
FROM raw_ecommerce_data
WHERE Product_Rating_Average = '' OR Product_Rating_Average = 'NULL' OR Product_Rating_Average IS NULL;

-- Query 10.3: Formulating the 4-quadrant Product Rating Reference Grid
SELECT 
    CASE 
        WHEN CAST(Customer_Support_Calls AS SIGNED) BETWEEN 0 AND 5 
             AND CAST(Returns_Rate AS DECIMAL(10,2)) BETWEEN 0.00 AND 6.10 
             THEN 'Case 1: Support 0-5 / Returns 0-6.10'
             
        WHEN CAST(Customer_Support_Calls AS SIGNED) BETWEEN 0 AND 5 
             AND CAST(Returns_Rate AS DECIMAL(10,2)) BETWEEN 6.11 AND 96.12 
             THEN 'Case 2: Support 0-5 / Returns 6.11-96.12'
             
        WHEN CAST(Customer_Support_Calls AS SIGNED) BETWEEN 6 AND 18 
             AND CAST(Returns_Rate AS DECIMAL(10,2)) BETWEEN 0.00 AND 6.10 
             THEN 'Case 3: Support 6-18 / Returns 0-6.10'
             
        ELSE 'Case 4: Support 6-18 / Returns 6.11-96.12'
    END AS Behavioral_Rating_Groups,
    
    ROUND(AVG(CAST(Product_Rating_Average AS DECIMAL(10,2))), 2) AS Avg_Product_Rating
FROM raw_ecommerce_data
WHERE Product_Rating_Average != '' AND Product_Rating_Average IS NOT NULL AND Product_Rating_Average != 'NULL'
GROUP BY 
    CASE 
        WHEN CAST(Customer_Support_Calls AS SIGNED) BETWEEN 0 AND 5 AND CAST(Returns_Rate AS DECIMAL(10,2)) BETWEEN 0.00 AND 6.10 THEN 'Case 1: Support 0-5 / Returns 0-6.10'
        WHEN CAST(Customer_Support_Calls AS SIGNED) BETWEEN 0 AND 5 AND CAST(Returns_Rate AS DECIMAL(10,2)) BETWEEN 6.11 AND 96.12 THEN 'Case 2: Support 0-5 / Returns 6.11-96.12'
        WHEN CAST(Customer_Support_Calls AS SIGNED) BETWEEN 6 AND 18 AND CAST(Returns_Rate AS DECIMAL(10,2)) BETWEEN 0.00 AND 6.10 THEN 'Case 3: Support 6-18 / Returns 0-6.10'
        ELSE 'Case 4: Support 6-18 / Returns 6.11-96.12'
    END;
-- -------------------------------------------------------------------------
-- SECTION 11: SOCIAL MEDIA ENGAGEMENT TRENDS
-- -------------------------------------------------------------------------

-- Query 11.1: Auditing system-wide missing values for Social Media Engagement
SELECT 
    COUNT(Social_Media_Engagement) OVER() AS total_blank_social_rows
FROM raw_ecommerce_data
WHERE Social_Media_Engagement IS NULL OR TRIM(Social_Media_Engagement) = '';

-- Query 11.2: Cross-profiling blank social media cells with demographic metrics
-- Explanation: Investigating how Gender intersects with Age, Email Rates, and App Time 
-- for rows containing blank social media records to identify behavioral clusters.
SELECT 
    Gender,
    COUNT(*) AS Total_Blank_Customers,
    
    -- Age Profiling for Affected Rows
    MIN(CAST(Age AS SIGNED)) AS Age_MIN,
    MAX(CAST(Age AS SIGNED)) AS Age_MAX,
    ROUND(AVG(CAST(Age AS SIGNED)), 2) AS Age_AVG,
    
    -- Marketing Email Profiling for Affected Rows
    MIN(CAST(Email_Opening_Rate AS DECIMAL(10,2))) AS Email_MIN,
    MAX(CAST(Email_Opening_Rate AS DECIMAL(10,2))) AS Email_MAX,
    ROUND(AVG(CAST(Email_Opening_Rate AS DECIMAL(10,2))), 2) AS Email_AVG,
    
    -- App Usage Profiling for Affected Rows
    MIN(CAST(Mobile_App_Usage_Time AS DECIMAL(10,2))) AS App_Time_MIN,
    MAX(CAST(Mobile_App_Usage_Time AS DECIMAL(10,2))) AS App_Time_MAX,
    ROUND(AVG(CAST(Mobile_App_Usage_Time AS DECIMAL(10,2))), 2) AS App_Time_AVG
FROM raw_ecommerce_data
WHERE Social_Media_Engagement = '' OR Social_Media_Engagement = 'NULL' OR Social_Media_Engagement IS NULL
GROUP BY Gender;

-- Query 11.3: Formulating the Social Media Behavioral Matrix
-- Explanation: segmenting users into 4 key quadrants using Age brackets and cross-digital 
-- platform activity metrics to extract granular reference averages.
SELECT 
    CASE 
        WHEN CAST(Age AS SIGNED) <= 35 
             AND (CAST(Mobile_App_Usage_Time AS DECIMAL(10,2)) <= 17.40 OR CAST(Email_Opening_Rate AS DECIMAL(10,2)) <= 20.00)
             THEN 'Case 1: Young Adult / Low-Medium Digital Activity'
             
        WHEN CAST(Age AS SIGNED) <= 35 
             AND CAST(Mobile_App_Usage_Time AS DECIMAL(10,2)) > 17.40 
             AND CAST(Email_Opening_Rate AS DECIMAL(10,2)) > 20.00
             THEN 'Case 2: Young Adult / Tech-Savvy VIP'
             
        WHEN CAST(Age AS SIGNED) > 35 AND Gender = 'Female'
             THEN 'Case 3: Senior Female Segment'
             
        ELSE 'Case 4: Senior Male/Other Segment'
    END AS Behavioral_Social_Groups,
    
    ROUND(AVG(CAST(Social_Media_Engagement AS DECIMAL(10,2))), 2) AS Avg_Social_Media_Engagement
FROM raw_ecommerce_data
WHERE Social_Media_Engagement != '' 
  AND Social_Media_Engagement IS NOT NULL 
  AND Social_Media_Engagement != 'NULL'
  AND CAST(Age AS SIGNED) <= 100 -- Security filter to exclude corrupted ages (>150) from baseline calculations
GROUP BY 
    CASE 
        WHEN CAST(Age AS SIGNED) <= 35 
             AND (CAST(Mobile_App_Usage_Time AS DECIMAL(10,2)) <= 17.40 OR CAST(Email_Opening_Rate AS DECIMAL(10,2)) <= 20.00) THEN 'Case 1: Young Adult / Low-Medium Digital Activity'
        WHEN CAST(Age AS SIGNED) <= 35 
             AND CAST(Mobile_App_Usage_Time AS DECIMAL(10,2)) > 17.40 
             AND CAST(Email_Opening_Rate AS DECIMAL(10,2)) > 20.00 THEN 'Case 2: Young Adult / Tech-Savvy VIP'
        WHEN CAST(Age AS SIGNED) > 35 AND Gender = 'Female' THEN 'Case 3: Senior Female Segment'
        ELSE 'Case 4: Senior Male/Other Segment'
    END;

-- -------------------------------------------------------------------------
-- SECTION 12: MOBILE APP USAGE TIME ANALYSIS
-- -------------------------------------------------------------------------

-- Query 12.1: Checking the total number of missing or blank rows in Mobile App column
SELECT 
    COUNT(Mobile_App_Usage_Time) OVER() AS total_blank_app_rows
FROM raw_ecommerce_data
WHERE Mobile_App_Usage_Time IS NULL OR TRIM(Mobile_App_Usage_Time) = '';

-- Query 12.2: Cross-profiling blank App Usage records with transaction structures
-- Explanation: Evaluating Session Durations and Login Frequencies for affected rows 
-- to analyze baseline traits before building the imputation matrix.
SELECT 
    MIN(CAST(Session_Duration AS DECIMAL(10,2))) AS Session_MIN,
    MAX(CAST(Session_Duration AS DECIMAL(10,2))) AS Session_MAX,
    ROUND(AVG(CAST(Session_Duration AS DECIMAL(10,2))), 2) AS Session_AVG,
    
    MIN(CAST(Login_Frequency AS SIGNED)) AS Logins_MIN,
    MAX(CAST(Login_Frequency AS SIGNED)) AS Logins_MAX,
    ROUND(AVG(CAST(Login_Frequency AS SIGNED)), 2) AS Logins_AVG
FROM raw_ecommerce_data
WHERE Mobile_App_Usage_Time = '' OR Mobile_App_Usage_Time = 'NULL' OR Mobile_App_Usage_Time IS NULL;

-- Query 12.3: Establishing the 4-quadrant Mobile App Imputation Matrix
SELECT 
    CASE 
        WHEN CAST(Session_Duration AS DECIMAL(10,2)) BETWEEN 0.00 AND 25.76 
             AND CAST(Login_Frequency AS SIGNED) BETWEEN 0 AND 11 
             THEN 'Case 1: Session 0-25.76 / Logins 0-11'
             
        WHEN CAST(Session_Duration AS DECIMAL(10,2)) BETWEEN 0.00 AND 25.76 
             AND CAST(Login_Frequency AS SIGNED) BETWEEN 12 AND 43 
             THEN 'Case 2: Session 0-25.76 / Logins 12-43'
             
        WHEN CAST(Session_Duration AS DECIMAL(10,2)) BETWEEN 25.77 AND 66.40 
             AND CAST(Login_Frequency AS SIGNED) BETWEEN 0 AND 11 
             THEN 'Case 3: Session 25.77-66.40 / Logins 0-11'
             
        ELSE 'Case 4: Session 25.77-66.40 / Logins 12-43'
    END AS Behavioral_App_Groups,
    
    ROUND(AVG(CAST(Mobile_App_Usage_Time AS DECIMAL(10,2))), 2) AS Avg_App_Usage_Time
FROM raw_ecommerce_data
WHERE Mobile_App_Usage_Time != '' AND Mobile_App_Usage_Time IS NOT NULL AND Mobile_App_Usage_Time != 'NULL'
GROUP BY 
    CASE 
        WHEN CAST(Session_Duration AS DECIMAL(10,2)) BETWEEN 0.00 AND 25.76 AND CAST(Login_Frequency AS SIGNED) BETWEEN 0 AND 11 THEN 'Case 1: Session 0-25.76 / Logins 0-11'
        WHEN CAST(Session_Duration AS DECIMAL(10,2)) BETWEEN 0.00 AND 25.76 AND CAST(Login_Frequency AS SIGNED) BETWEEN 12 AND 43 THEN 'Case 2: Session 0-25.76 / Logins 12-43'
        WHEN CAST(Session_Duration AS DECIMAL(10,2)) BETWEEN 25.77 AND 66.40 AND CAST(Login_Frequency AS SIGNED) BETWEEN 0 AND 11 THEN 'Case 3: Session 25.77-66.40 / Logins 0-11'
        ELSE 'Case 4: Session 25.77-66.40 / Logins 12-43'
    END;
-- Query 12.4: Comprehensive Imputation Code for Mobile App Usage Time
-- Explanation: Deploying a multi-variable CASE WHEN logic to fill empty app usage cells 
-- with highly calibrated subgroup averages (12.66, 17.20, 19.65, 27.18) extracted from clean data.
SELECT 
    CASE 
        -- Case 1: Low Session Duration and Low Login Frequency -> Impute 12.66
        WHEN (Mobile_App_Usage_Time = '' OR Mobile_App_Usage_Time IS NULL OR Mobile_App_Usage_Time = 'NULL')
             AND CAST(Session_Duration AS DECIMAL(10,2)) BETWEEN 0.00 AND 25.76
             AND CAST(Login_Frequency AS SIGNED) BETWEEN 0 AND 11 
             THEN 12.66
             
        -- Case 2: Low Session Duration and High Login Frequency -> Impute 17.20
        WHEN (Mobile_App_Usage_Time = '' OR Mobile_App_Usage_Time IS NULL OR Mobile_App_Usage_Time = 'NULL')
             AND CAST(Session_Duration AS DECIMAL(10,2)) BETWEEN 0.00 AND 25.76
             AND CAST(Login_Frequency AS SIGNED) BETWEEN 12 AND 43 
             THEN 17.20
             
        -- Case 3: High Session Duration and Low Login Frequency -> Impute 19.65
        WHEN (Mobile_App_Usage_Time = '' OR Mobile_App_Usage_Time IS NULL OR Mobile_App_Usage_Time = 'NULL')
             AND CAST(Session_Duration AS DECIMAL(10,2)) BETWEEN 25.77 AND 66.40
             AND CAST(Login_Frequency AS SIGNED) BETWEEN 0 AND 11 
             THEN 19.65
             
        -- Case 4: High Session Duration and High Login Frequency -> Impute 27.18
        WHEN (Mobile_App_Usage_Time = '' OR Mobile_App_Usage_Time IS NULL OR Mobile_App_Usage_Time = 'NULL')
             AND CAST(Session_Duration AS DECIMAL(10,2)) BETWEEN 25.77 AND 66.40
             AND CAST(Login_Frequency AS SIGNED) BETWEEN 12 AND 43 
             THEN 27.18
             
        -- Osama's Safe Guard: Valid existing records pass through unmodified
        ELSE CAST(Mobile_App_Usage_Time AS DECIMAL(10,2))
    END AS Cleaned_Mobile_App_Usage_Time
FROM raw_ecommerce_data;

-- Query 12.5: Verifying native missing structures inside Payment Failures log
SELECT 
    COUNT(Payment_Failures) OVER() AS total_blank_payment_failures
FROM raw_ecommerce_data
WHERE Payment_Failures IS NULL OR TRIM(Payment_Failures) = '';

-- Query 12.6: Behavioral profiling of empty payment records against Loyalty states
SELECT 
    CASE WHEN Churned = '1' THEN 'Blank Payments (Churned = 1)' ELSE 'Blank Payments (Active = 0)' END AS Customer_Status,
    COUNT(*) AS Total_Blank_Customers,
    ROUND(AVG(CAST(Total_Purchases AS SIGNED)), 2) AS Avg_Purchases,
    MIN(CAST(Total_Purchases AS SIGNED)) AS Min_Purchases,
    MAX(CAST(Total_Purchases AS SIGNED)) AS Max_Purchases
FROM raw_ecommerce_data
WHERE Payment_Failures = '' OR Payment_Failures IS NULL OR Payment_Failures = 'NULL'
GROUP BY Churned;

-- Query 12.7: Forcing empty Payment entries to logical system defaults
-- Explanation: Empirical screen evidence shows these rows belong to seamless, error-free checkouts, safely defaulting to 0.
SELECT 
    CASE 
        WHEN Payment_Failures = '' OR Payment_Failures IS NULL OR Payment_Failures = 'NULL' THEN 0
        ELSE CAST(Payment_Failures AS SIGNED)
    END AS Cleaned_Payment_Failures
FROM raw_ecommerce_data;

-- Query 12.8: Auditing system-wide records for Lifetime Value (LTV) features
-- Finding: The column is natively secure, yielding zero missing rows from the engine.
SELECT 
    COUNT(Lifetime_Value) OVER() AS total_blank_ltv_rows
FROM raw_ecommerce_data
WHERE Lifetime_Value IS NULL OR TRIM(Lifetime_Value) = '';

-- Query 12.9: Detecting system missing entries for the Credit Balance column
SELECT 
    COUNT(Credit_Balance) OVER() AS total_blank_credit_rows
FROM raw_ecommerce_data
WHERE Credit_Balance IS NULL OR TRIM(Credit_Balance) = '';

-- Query 12.10: Extracting statistical cross-parameters for blank Credit cells
-- Explanation: Dissecting Total Purchases and Order Values for the 5,500 blank records to map identical baseline blocks.
SELECT 
    MIN(CAST(Total_Purchases AS SIGNED)) AS Purchases_MIN,
    MAX(CAST(Total_Purchases AS SIGNED)) AS Purchases_MAX,
    ROUND(AVG(CAST(Total_Purchases AS SIGNED)), 2) AS Purchases_AVG,
    
    MIN(CAST(Average_Order_Value AS DECIMAL(10,2))) AS Order_Value_MIN,
    MAX(CAST(Average_Order_Value AS DECIMAL(10,2))) AS Order_Value_MAX,
    ROUND(AVG(CAST(Average_Order_Value AS DECIMAL(10,2))), 2) AS Order_Value_AVG
FROM raw_ecommerce_data
WHERE Credit_Balance = '' OR Credit_Balance = 'NULL' OR Credit_Balance IS NULL;
-- Query 12.11: Extracting statistical averages for the 4 Credit sub-segments
-- Explanation: Segmenting clean records into 4 unique behavioral quadrants to calculate highly targeted 
-- credit averages, while filtering out extreme outlier invoices (>2000.00) to keep the baseline stable.
SELECT 
    CASE 
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN -7 AND 13
             AND CAST(Average_Order_Value AS DECIMAL(10,2)) BETWEEN 30.71 AND 127.12
             THEN 'Case 1: Purchases -7 to 13 / Bill 30.71-127.12'
             
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN -7 AND 13
             AND CAST(Average_Order_Value AS DECIMAL(10,2)) BETWEEN 127.13 AND 9000.00
             THEN 'Case 2: Purchases -7 to 13 / Bill > 127.12'
             
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN 14 AND 128
             AND CAST(Average_Order_Value AS DECIMAL(10,2)) BETWEEN 30.71 AND 127.12
             THEN 'Case 3: Purchases 14-128 / Bill 30.71-127.12'
             
        ELSE 'Case 4: Purchases 14-128 / Bill > 127.12'
    END AS Behavioral_Credit_Groups,
    
    ROUND(AVG(CAST(Credit_Balance AS DECIMAL(10,2))), 2) AS Avg_Credit_Balance
FROM raw_ecommerce_data
WHERE Credit_Balance != '' 
  AND Credit_Balance IS NOT NULL 
  AND Credit_Balance != 'NULL'
  AND CAST(Average_Order_Value AS DECIMAL(10,2)) <= 2000.00
GROUP BY 
    CASE 
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN -7 AND 13 AND CAST(Average_Order_Value AS DECIMAL(10,2)) BETWEEN 30.71 AND 127.12 THEN 'Case 1: Purchases -7 to 13 / Bill 30.71-127.12'
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN -7 AND 13 AND CAST(Average_Order_Value AS DECIMAL(10,2)) BETWEEN 127.13 AND 9000.00 THEN 'Case 2: Purchases -7 to 13 / Bill > 127.12'
        WHEN CAST(Total_Purchases AS SIGNED) BETWEEN 14 AND 128 AND CAST(Average_Order_Value AS DECIMAL(10,2)) BETWEEN 30.71 AND 127.12 THEN 'Case 3: Purchases 14-128 / Bill 30.71-127.12'
        ELSE 'Case 4: Purchases 14-128 / Bill > 127.12'
    END;

-- Query 12.12: Hardcoded Testing Script for Credit Balance Imputation
-- Note: A preliminary testing script mapping empty credit cells to the discovered static averages 
-- ($1504.48, $1514.12, $2609.41, $2593.44) for baseline calculation verification.
SELECT 
    CASE 
        -- Case 1: Low Purchases / Low Invoice -> Impute 1504.48
        WHEN (Credit_Balance = '' OR Credit_Balance IS NULL OR Credit_Balance = 'NULL')
             AND CAST(Total_Purchases AS SIGNED) BETWEEN -7 AND 13
             AND CAST(Average_Order_Value AS DECIMAL(10,2)) BETWEEN 30.71 AND 127.12
             THEN 1504.48
             
        -- Case 2: Low Purchases / High Invoice -> Impute 1514.12
        WHEN (Credit_Balance = '' OR Credit_Balance IS NULL OR Credit_Balance = 'NULL')
             AND CAST(Total_Purchases AS SIGNED) BETWEEN -7 AND 13
             AND CAST(Average_Order_Value AS DECIMAL(10,2)) > 127.12
             THEN 1514.12
             
        -- Case 3: High Purchases / Low Invoice -> Impute 2609.41
        WHEN (Credit_Balance = '' OR Credit_Balance IS NULL OR Credit_Balance = 'NULL')
             AND CAST(Total_Purchases AS SIGNED) BETWEEN 14 AND 128
             AND CAST(Average_Order_Value AS DECIMAL(10,2)) BETWEEN 30.71 AND 127.12
             THEN 2609.41
             
        -- Case 4: High Purchases / High Invoice -> Impute 2593.44
        WHEN (Credit_Balance = '' OR Credit_Balance IS NULL OR Credit_Balance = 'NULL')
             AND CAST(Total_Purchases AS SIGNED) BETWEEN 14 AND 128
             AND CAST(Average_Order_Value AS DECIMAL(10,2)) > 127.12
             THEN 2593.44
             
        -- Osama's Safe Guard: All existing zero and positive records pass through untouched
        ELSE CAST(Credit_Balance AS DECIMAL(10,2))
    END AS Cleaned_Credit_Balance
FROM raw_ecommerce_data;

-- Query 12.13: Quality Assurance Integrity Checks on Churn and Signup Flags
SELECT COUNT(Churned) OVER() AS total_churn_check_rows FROM raw_ecommerce_data WHERE Churned IS NULL OR TRIM(Churned) = '';
SELECT COUNT(Signup_Quarter) OVER() AS total_quarter_check_rows FROM raw_ecommerce_data WHERE Signup_Quarter IS NULL OR TRIM(Signup_Quarter) = '';


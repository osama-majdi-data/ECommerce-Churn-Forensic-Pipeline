-- =========================================================================
-- MASTER GRADUATION PROJECT: E-COMMERCE CUSTOMER CHURN PREDICTION
-- PHASE 3: FIRST-STAGE REVISED PRODUCTION BUILD (MISSING VALUES IMPUTATION)
-- MASTER DATA ENGINEER: ENG. OSAMA
-- DATA ENGINE: MYSQL WORKBENCH
-- PART 1 OF 6: STATISTICAL BASELINE EXTRACTORS (AGE & SESSION DESIGN)
-- =========================================================================

-- Step 1: Dropping the intermediate table if it exists to prevent memory or server locks
DROP TABLE IF EXISTS cleaned_ecommerce_data;

-- Step 2: Executing the comprehensive production build query for missing rows imputation
CREATE TABLE cleaned_ecommerce_data AS 

-- [Matrix 1]: Extracting dynamic biological age baselines for blank age rows scaled against churn states
WITH Age_Stats AS (
    SELECT 
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 1 THEN ROUND(CAST(TRIM(Age) AS FLOAT), 0) END)) AS churned_avg_age,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 0 THEN ROUND(CAST(TRIM(Age) AS FLOAT), 0) END)) AS active_avg_age
    FROM raw_ecommerce_data
    WHERE TRIM(Age) != '' AND Age IS NOT NULL AND LOWER(TRIM(Age)) != 'null' AND LOWER(TRIM(Age)) != 'nan'
),

-- [Matrix 2]: Upgraded Session Duration Grid (Dynamically calculating TRUE Averages via AVG)
Session_Group_Stats AS (
    SELECT 
        ROUND(AVG(CASE WHEN CAST(TRIM(Pages_Per_Session) AS FLOAT) BETWEEN 0 AND 6 AND CAST(TRIM(Total_Purchases) AS FLOAT) BETWEEN -7 AND 10 THEN CAST(TRIM(Session_Duration) AS FLOAT) END), 0) AS case_1_session,
        ROUND(AVG(CASE WHEN CAST(TRIM(Pages_Per_Session) AS FLOAT) BETWEEN 0 AND 6 AND CAST(TRIM(Total_Purchases) AS FLOAT) BETWEEN 10 AND 125 THEN CAST(TRIM(Session_Duration) AS FLOAT) END), 0) AS case_2_session,
        ROUND(AVG(CASE WHEN CAST(TRIM(Pages_Per_Session) AS FLOAT) BETWEEN 6 AND 18 AND CAST(TRIM(Total_Purchases) AS FLOAT) BETWEEN -7 AND 10 THEN CAST(TRIM(Session_Duration) AS FLOAT) END), 0) AS case_3_session,
        ROUND(AVG(CASE WHEN CAST(TRIM(Pages_Per_Session) AS FLOAT) BETWEEN 6 AND 18 AND CAST(TRIM(Total_Purchases) AS FLOAT) BETWEEN 10 AND 125 THEN CAST(TRIM(Session_Duration) AS FLOAT) END), 0) AS case_4_session
    FROM raw_ecommerce_data
    WHERE TRIM(Session_Duration) != '' AND Session_Duration IS NOT NULL AND LOWER(TRIM(Session_Duration)) != 'null' AND LOWER(TRIM(Session_Duration)) != 'nan'
)
-- [Matrix 3]: Formulating the 4-quadrant reference averages for cross-platform blank page counts
-- Explanation: Intersecting session time with checkout abandonment parameters to capture pure browsing density.
, Pages_Reference_Averages AS (
    SELECT 
        ROUND(AVG(CASE WHEN CAST(TRIM(Session_Duration) AS FLOAT) BETWEEN 1 AND 28 AND CAST(TRIM(Cart_Abandonment_Rate) AS FLOAT) BETWEEN 0 AND 56 THEN CAST(TRIM(Pages_Per_Session) AS FLOAT) END), 2) AS case_1_avg,
        ROUND(AVG(CASE WHEN CAST(TRIM(Session_Duration) AS FLOAT) BETWEEN 1 AND 28 AND CAST(TRIM(Cart_Abandonment_Rate) AS FLOAT) BETWEEN 56 AND 144 THEN CAST(TRIM(Pages_Per_Session) AS FLOAT) END), 2) AS case_2_avg,
        ROUND(AVG(CASE WHEN CAST(TRIM(Session_Duration) AS FLOAT) BETWEEN 28 AND 76 AND CAST(TRIM(Cart_Abandonment_Rate) AS FLOAT) BETWEEN 0 AND 56 THEN CAST(TRIM(Pages_Per_Session) AS FLOAT) END), 2) AS case_3_avg,
        ROUND(AVG(CASE WHEN CAST(TRIM(Session_Duration) AS FLOAT) BETWEEN 28 AND 76 AND CAST(TRIM(Cart_Abandonment_Rate) AS FLOAT) BETWEEN 56 AND 144 THEN CAST(TRIM(Pages_Per_Session) AS FLOAT) END), 2) AS case_4_avg
    FROM raw_ecommerce_data
    WHERE TRIM(Pages_Per_Session) != '' AND Pages_Per_Session IS NOT NULL AND LOWER(TRIM(Pages_Per_Session)) != 'null' AND LOWER(TRIM(Pages_Per_Session)) != 'nan'
),

-- [Matrix 4]: Generating the 4-quadrant dynamic recency brackets mapped against customer loyalty and purchase velocity
Recency_Group_Averages AS (
    SELECT 
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 0 AND ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN -11 AND 14 THEN ROUND(CAST(TRIM(Days_Since_Last_Purchase) AS FLOAT), 0) END), 2) AS case_1_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 0 AND ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 15 AND 109 THEN ROUND(CAST(TRIM(Days_Since_Last_Purchase) AS FLOAT), 0) END), 2) AS case_2_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 1 AND ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 1 AND 12 THEN ROUND(CAST(TRIM(Days_Since_Last_Purchase) AS FLOAT), 0) END), 2) AS case_3_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 1 AND ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 13 AND 98 THEN ROUND(CAST(TRIM(Days_Since_Last_Purchase) AS FLOAT), 0) END), 2) AS case_4_avg
    FROM raw_ecommerce_data
    WHERE TRIM(Days_Since_Last_Purchase) != '' AND Days_Since_Last_Purchase IS NOT NULL AND LOWER(TRIM(Days_Since_Last_Purchase)) != 'null' AND LOWER(TRIM(Days_Since_Last_Purchase)) != 'nan'
),

-- [Matrix 5]: Constructing the 4-quadrant operational matrix for return rates bound to product support logs
Returns_Group_Averages AS (
    SELECT 
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN -8 AND 12 AND ROUND(CAST(TRIM(Customer_Support_Calls) AS FLOAT), 0) BETWEEN 0 AND 5 THEN CAST(TRIM(Returns_Rate) AS FLOAT) END), 2) AS case_1_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN -8 AND 12 AND ROUND(CAST(TRIM(Customer_Support_Calls) AS FLOAT), 0) BETWEEN 6 AND 18 THEN CAST(TRIM(Returns_Rate) AS FLOAT) END), 2) AS case_2_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 13 AND 42 AND ROUND(CAST(TRIM(Customer_Support_Calls) AS FLOAT), 0) BETWEEN 0 AND 5 THEN CAST(TRIM(Returns_Rate) AS FLOAT) END), 2) AS case_3_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 13 AND 42 AND ROUND(CAST(TRIM(Customer_Support_Calls) AS FLOAT), 0) BETWEEN 6 AND 18 THEN CAST(TRIM(Returns_Rate) AS FLOAT) END), 2) AS case_4_avg
    FROM raw_ecommerce_data
    WHERE TRIM(Returns_Rate) != '' AND Returns_Rate IS NOT NULL AND LOWER(TRIM(Returns_Rate)) != 'null' AND LOWER(TRIM(Returns_Rate)) != 'nan'
)
-- [Matrix 6]: Extracting marketing interaction baselines crossed with active promo discount usage rates
, Email_Group_Averages AS (
    SELECT 
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Login_Frequency) AS FLOAT), 0) BETWEEN 0 AND 4 AND CAST(TRIM(Discount_Usage_Rate) AS FLOAT) BETWEEN 0.00 AND 39.30 THEN CAST(TRIM(Email_Opening_Rate) AS FLOAT) END), 2) AS case_1_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Login_Frequency) AS FLOAT), 0) BETWEEN 0 AND 4 AND CAST(TRIM(Discount_Usage_Rate) AS FLOAT) BETWEEN 39.31 AND 113.16 THEN CAST(TRIM(Email_Opening_Rate) AS FLOAT) END), 2) AS case_2_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Login_Frequency) AS FLOAT), 0) BETWEEN 5 AND 9 AND CAST(TRIM(Discount_Usage_Rate) AS FLOAT) BETWEEN 0.00 AND 39.30 THEN CAST(TRIM(Email_Opening_Rate) AS FLOAT) END), 2) AS case_3_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Login_Frequency) AS FLOAT), 0) BETWEEN 5 AND 9 AND CAST(TRIM(Discount_Usage_Rate) AS FLOAT) BETWEEN 39.31 AND 113.16 THEN CAST(TRIM(Email_Opening_Rate) AS FLOAT) END), 2) AS case_4_avg
    FROM raw_ecommerce_data
    WHERE TRIM(Email_Opening_Rate) != '' AND Email_Opening_Rate IS NOT NULL AND LOWER(TRIM(Email_Opening_Rate)) != 'null' AND LOWER(TRIM(Email_Opening_Rate)) != 'nan'
),

-- [Matrix 7]: Calculating real-world customer friction support metrics based on transaction volumes
Support_Group_Averages AS (
    SELECT 
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 2 AND 9 AND CAST(TRIM(Returns_Rate) AS FLOAT) BETWEEN 0.00 AND 6.12 THEN ROUND(CAST(TRIM(Customer_Support_Calls) AS FLOAT), 0) END), 2) AS case_1_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 2 AND 9 AND CAST(TRIM(Returns_Rate) AS FLOAT) BETWEEN 6.13 AND 21.90 THEN ROUND(CAST(TRIM(Customer_Support_Calls) AS FLOAT), 0) END), 2) AS case_2_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 10 AND 23 AND CAST(TRIM(Returns_Rate) AS FLOAT) BETWEEN 0.00 AND 6.12 THEN ROUND(CAST(TRIM(Customer_Support_Calls) AS FLOAT), 0) END), 2) AS case_3_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 10 AND 23 AND CAST(TRIM(Returns_Rate) AS FLOAT) BETWEEN 6.13 AND 21.90 THEN ROUND(CAST(TRIM(Customer_Support_Calls) AS FLOAT), 0) END), 2) AS case_4_avg
    FROM raw_ecommerce_data
    WHERE TRIM(Customer_Support_Calls) != '' AND Customer_Support_Calls IS NOT NULL AND LOWER(TRIM(Customer_Support_Calls)) != 'null' AND LOWER(TRIM(Customer_Support_Calls)) != 'nan'
),

-- [Matrix 8]: Enforcing precise integer logic rounding (0 decimals) from source for baseline product ratings
Rating_Group_Averages AS (
    SELECT 
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Customer_Support_Calls) AS FLOAT), 0) BETWEEN 0 AND 5 AND CAST(TRIM(Returns_Rate) AS FLOAT) BETWEEN 0.00 AND 6.10 THEN CAST(TRIM(Product_Rating_Average) AS FLOAT) END), 0) AS case_1_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Customer_Support_Calls) AS FLOAT), 0) BETWEEN 0 AND 5 AND CAST(TRIM(Returns_Rate) AS FLOAT) BETWEEN 6.11 AND 96.12 THEN CAST(TRIM(Product_Rating_Average) AS FLOAT) END), 0) AS case_2_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Customer_Support_Calls) AS FLOAT), 0) BETWEEN 6 AND 18 AND CAST(TRIM(Returns_Rate) AS FLOAT) BETWEEN 0.00 AND 6.10 THEN CAST(TRIM(Product_Rating_Average) AS FLOAT) END), 0) AS case_3_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Customer_Support_Calls) AS FLOAT), 0) BETWEEN 6 AND 18 AND CAST(TRIM(Returns_Rate) AS FLOAT) BETWEEN 6.11 AND 96.12 THEN CAST(TRIM(Product_Rating_Average) AS FLOAT) END), 0) AS case_4_avg
    FROM raw_ecommerce_data
    WHERE TRIM(Product_Rating_Average) != '' AND Product_Rating_Average IS NOT NULL AND LOWER(TRIM(Product_Rating_Average)) != 'null' AND LOWER(TRIM(Product_Rating_Average)) != 'nan'
)
-- [Matrix 9]: Mapping social media activity patterns against demographic tiers and digital engagement thresholds
, Social_Group_Averages AS (
    SELECT 
        ROUND(AVG(CASE WHEN CAST(TRIM(Age) AS FLOAT) <= 35 AND (CAST(TRIM(Mobile_App_Usage_Time) AS FLOAT) <= 17.40 OR CAST(TRIM(Email_Opening_Rate) AS FLOAT) <= 20.00) THEN CAST(TRIM(Social_Media_Engagement) AS FLOAT) END), 2) AS case_1_avg,
        ROUND(AVG(CASE WHEN CAST(TRIM(Age) AS FLOAT) <= 35 AND CAST(TRIM(Mobile_App_Usage_Time) AS FLOAT) > 17.40 AND CAST(TRIM(Email_Opening_Rate) AS FLOAT) > 20.00 THEN CAST(TRIM(Social_Media_Engagement) AS FLOAT) END), 2) AS case_2_avg,
        ROUND(AVG(CASE WHEN CAST(TRIM(Age) AS FLOAT) > 35 AND TRIM(Gender) = 'Female' THEN CAST(TRIM(Social_Media_Engagement) AS FLOAT) END), 2) AS case_3_avg,
        ROUND(AVG(CASE WHEN CAST(TRIM(Age) AS FLOAT) > 35 AND TRIM(Gender) != 'Female' THEN CAST(TRIM(Social_Media_Engagement) AS FLOAT) END), 2) AS case_4_avg
    FROM raw_ecommerce_data
    WHERE TRIM(Social_Media_Engagement) != '' AND Social_Media_Engagement IS NOT NULL AND LOWER(TRIM(Social_Media_Engagement)) != 'null' AND LOWER(TRIM(Social_Media_Engagement)) != 'nan'
),

-- [Matrix 10]: Formulating baseline metrics for user app usage session velocity crossed with login frequency thresholds
App_Group_Averages AS (
    SELECT 
        ROUND(AVG(CASE WHEN CAST(TRIM(Session_Duration) AS FLOAT) BETWEEN 0.00 AND 25.76 AND ROUND(CAST(TRIM(Login_Frequency) AS FLOAT), 0) BETWEEN 0 AND 11 THEN CAST(TRIM(Mobile_App_Usage_Time) AS FLOAT) END), 2) AS case_1_avg,
        ROUND(AVG(CASE WHEN CAST(TRIM(Session_Duration) AS FLOAT) BETWEEN 0.00 AND 25.76 AND ROUND(CAST(TRIM(Login_Frequency) AS FLOAT), 0) BETWEEN 12 AND 43 THEN CAST(TRIM(Mobile_App_Usage_Time) AS FLOAT) END), 2) AS case_2_avg,
        ROUND(AVG(CASE WHEN CAST(TRIM(Session_Duration) AS FLOAT) BETWEEN 25.77 AND 66.40 AND ROUND(CAST(TRIM(Login_Frequency) AS FLOAT), 0) BETWEEN 0 AND 11 THEN CAST(TRIM(Mobile_App_Usage_Time) AS FLOAT) END), 2) AS case_3_avg,
        ROUND(AVG(CASE WHEN CAST(TRIM(Session_Duration) AS FLOAT) BETWEEN 25.77 AND 66.40 AND ROUND(CAST(TRIM(Login_Frequency) AS FLOAT), 0) BETWEEN 12 AND 43 THEN CAST(TRIM(Mobile_App_Usage_Time) AS FLOAT) END), 2) AS case_4_avg
    FROM raw_ecommerce_data
    WHERE TRIM(Mobile_App_Usage_Time) != '' AND Mobile_App_Usage_Time IS NOT NULL AND LOWER(TRIM(Mobile_App_Usage_Time)) != 'null' AND LOWER(TRIM(Mobile_App_Usage_Time)) != 'nan'
),

-- [Matrix 11]: Extracting valid uncorrupted credit wallet thresholds crossed with transactional order tickets
Credit_Group_Averages AS (
    SELECT 
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN -7 AND 13 AND CAST(TRIM(Average_Order_Value) AS FLOAT) BETWEEN 30.71 AND 127.12 THEN CAST(TRIM(Credit_Balance) AS FLOAT) END), 2) AS case_1_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN -7 AND 13 AND CAST(TRIM(Average_Order_Value) AS FLOAT) > 127.12 THEN CAST(TRIM(Credit_Balance) AS FLOAT) END), 2) AS case_2_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 14 AND 128 AND CAST(TRIM(Average_Order_Value) AS FLOAT) BETWEEN 30.71 AND 127.12 THEN CAST(TRIM(Credit_Balance) AS FLOAT) END), 2) AS case_3_avg,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 14 AND 128 AND CAST(TRIM(Average_Order_Value) AS FLOAT) > 127.12 THEN CAST(TRIM(Credit_Balance) AS FLOAT) END), 2) AS case_4_avg
    FROM raw_ecommerce_data
    WHERE TRIM(Credit_Balance) != '' AND Credit_Balance IS NOT NULL AND LOWER(TRIM(Credit_Balance)) != 'null' AND LOWER(TRIM(Credit_Balance)) != 'nan'
)
SELECT 
    -- Column 1: Imputing genuine missing age values exclusively based on customer churn status
    ROUND(CASE 
        WHEN TRIM(r.Age) = '' OR r.Age IS NULL OR LOWER(TRIM(r.Age)) = 'null' OR LOWER(TRIM(r.Age)) = 'nan' THEN
            CASE WHEN ROUND(CAST(TRIM(r.Churned) AS FLOAT), 0) = 1 THEN a_st.churned_avg_age ELSE a_st.active_avg_age END
        ELSE ROUND(CAST(TRIM(r.Age) AS FLOAT), 0)
    END) AS Age,
    
    -- Columns 2, 3, 4, 5 & 6: Standardizing and cleansing identity and base interaction blocks
    CAST(TRIM(r.Gender) AS CHAR(10)) AS Gender,
    CAST(TRIM(r.Country) AS CHAR(50)) AS Country,
    CAST(TRIM(r.City) AS CHAR(50)) AS City,
    CAST(TRIM(r.Membership_Years) AS FLOAT) AS Membership_Years,
    ROUND(CAST(TRIM(r.Login_Frequency) AS FLOAT), 0) AS Login_Frequency,

    -- Column 7: Imputing missing Session Duration cells based on open matrix averages
    -- Explanation: Upgraded to inject true statistical averages from the revised 4-quadrant grid.
    CASE 
        WHEN TRIM(r.Session_Duration) = '' OR r.Session_Duration IS NULL OR LOWER(TRIM(r.Session_Duration)) = 'null' OR LOWER(TRIM(r.Session_Duration)) = 'nan' THEN
            CASE 
                WHEN CAST(TRIM(r.Pages_Per_Session) AS FLOAT) BETWEEN 0 AND 6 AND CAST(TRIM(r.Total_Purchases) AS FLOAT) BETWEEN -7 AND 10 THEN s_st.case_1_session
                WHEN CAST(TRIM(r.Pages_Per_Session) AS FLOAT) BETWEEN 0 AND 6 AND CAST(TRIM(r.Total_Purchases) AS FLOAT) BETWEEN 10 AND 125 THEN s_st.case_2_session
                WHEN CAST(TRIM(r.Pages_Per_Session) AS FLOAT) BETWEEN 6 AND 18 AND CAST(TRIM(r.Total_Purchases) AS FLOAT) BETWEEN -7 AND 10 THEN s_st.case_3_session
                ELSE s_st.case_4_session
            END
        ELSE CAST(TRIM(r.Session_Duration) AS FLOAT)
    END AS Session_Duration,

    -- Column 8: Imputing missing Pages Per Session records using the 4-quadrant reference averages
    CASE 
        WHEN TRIM(r.Pages_Per_Session) = '' OR r.Pages_Per_Session IS NULL OR LOWER(TRIM(r.Pages_Per_Session)) = 'null' OR LOWER(TRIM(r.Pages_Per_Session)) = 'nan' THEN
            CASE 
                WHEN CAST(TRIM(r.Session_Duration) AS FLOAT) BETWEEN 1 AND 28 AND CAST(TRIM(r.Cart_Abandonment_Rate) AS FLOAT) BETWEEN 0 AND 56 THEN p_avg.case_1_avg
                WHEN CAST(TRIM(r.Session_Duration) AS FLOAT) BETWEEN 1 AND 28 AND CAST(TRIM(r.Cart_Abandonment_Rate) AS FLOAT) BETWEEN 56 AND 144 THEN p_avg.case_2_avg
                WHEN CAST(TRIM(r.Session_Duration) AS FLOAT) BETWEEN 28 AND 76 AND CAST(TRIM(r.Cart_Abandonment_Rate) AS FLOAT) BETWEEN 0 AND 56 THEN p_avg.case_3_avg
                ELSE p_avg.case_4_avg
            END
        ELSE CAST(TRIM(r.Pages_Per_Session) AS FLOAT)
    END AS Pages_Per_Session,
    
    -- Column 9: Filling empty Cart Abandonment Rate cells based on user session duration thresholds
    ROUND(CASE 
        WHEN TRIM(r.Cart_Abandonment_Rate) = '' OR r.Cart_Abandonment_Rate IS NULL OR LOWER(TRIM(r.Cart_Abandonment_Rate)) = 'null' OR LOWER(TRIM(r.Cart_Abandonment_Rate)) = 'nan' THEN 
            CASE 
                WHEN CAST(TRIM(r.Session_Duration) AS FLOAT) BETWEEN 1 AND 28 THEN 59.73 
                ELSE 43.33 
            END
        ELSE CAST(TRIM(r.Cart_Abandonment_Rate) AS FLOAT)
    END, 2) AS Cart_Abandonment_Rate,

    -- Column 10: Filling empty Wishlist cells with logical zero system defaults
    ROUND(CASE 
        WHEN TRIM(r.Wishlist_Items) = '' OR r.Wishlist_Items IS NULL OR LOWER(TRIM(r.Wishlist_Items)) = 'null' OR LOWER(TRIM(r.Wishlist_Items)) = 'nan' THEN 0
        ELSE CAST(TRIM(r.Wishlist_Items) AS FLOAT)
    END) AS Wishlist_Items,

    ROUND(CAST(TRIM(r.Total_Purchases) AS FLOAT), 0) AS Total_Purchases,

    CASE 
        WHEN TRIM(r.Average_Order_Value) = '' OR r.Average_Order_Value IS NULL OR LOWER(TRIM(r.Average_Order_Value)) = 'null' OR LOWER(TRIM(r.Average_Order_Value)) = 'nan' THEN 0.00
        ELSE CAST(TRIM(r.Average_Order_Value) AS FLOAT)
    END AS Average_Order_Value,
    -- Column 13: Imputing Days Since Last Purchase blank cells via dynamic matrix baselines
    CASE 
        WHEN TRIM(r.Days_Since_Last_Purchase) = '' OR r.Days_Since_Last_Purchase IS NULL OR LOWER(TRIM(r.Days_Since_Last_Purchase)) = 'null' OR LOWER(TRIM(r.Days_Since_Last_Purchase)) = 'nan' THEN
            CASE 
                WHEN ROUND(CAST(TRIM(r.Churned) AS FLOAT), 0) = 0 AND ROUND(CAST(TRIM(r.Total_Purchases) AS FLOAT), 0) BETWEEN -11 AND 14 THEN rec_avg.case_1_avg
                WHEN ROUND(CAST(TRIM(r.Churned) AS FLOAT), 0) = 0 AND ROUND(CAST(TRIM(r.Total_Purchases) AS FLOAT), 0) BETWEEN 15 AND 109 THEN rec_avg.case_2_avg
                WHEN ROUND(CAST(TRIM(r.Churned) AS FLOAT), 0) = 1 AND ROUND(CAST(TRIM(r.Total_Purchases) AS FLOAT), 0) BETWEEN 1 AND 12 THEN rec_avg.case_3_avg
                ELSE rec_avg.case_4_avg
            END
        ELSE CAST(TRIM(r.Days_Since_Last_Purchase) AS FLOAT)
    END AS Days_Since_Last_Purchase,

    -- Column 14: Filling empty Discount Usage cells with system baseline zeros
    ROUND(CASE 
        WHEN TRIM(r.Discount_Usage_Rate) = '' OR r.Discount_Usage_Rate IS NULL OR LOWER(TRIM(r.Discount_Usage_Rate)) = 'null' OR LOWER(TRIM(r.Discount_Usage_Rate)) = 'nan' THEN 0.00
        ELSE CAST(TRIM(r.Discount_Usage_Rate) AS FLOAT)
    END, 2) AS Discount_Usage_Rate,

    -- Column 15: Imputing missing Return Rates using product support log matrices
    CASE 
        WHEN TRIM(r.Returns_Rate) = '' OR r.Returns_Rate IS NULL OR LOWER(TRIM(r.Returns_Rate)) = 'null' OR LOWER(TRIM(r.Returns_Rate)) = 'nan' THEN
            CASE 
                WHEN ROUND(CAST(TRIM(r.Total_Purchases) AS FLOAT), 0) BETWEEN -8 AND 12 AND ROUND(CAST(TRIM(r.Customer_Support_Calls) AS FLOAT), 0) BETWEEN 0 AND 5 THEN ret_avg.case_1_avg
                WHEN ROUND(CAST(TRIM(r.Total_Purchases) AS FLOAT), 0) BETWEEN -8 AND 12 AND ROUND(CAST(TRIM(r.Customer_Support_Calls) AS FLOAT), 0) BETWEEN 6 AND 18 THEN ret_avg.case_2_avg
                WHEN ROUND(CAST(TRIM(r.Total_Purchases) AS FLOAT), 0) BETWEEN 13 AND 42 AND ROUND(CAST(TRIM(r.Customer_Support_Calls) AS FLOAT), 0) BETWEEN 0 AND 5 THEN ret_avg.case_3_avg
                ELSE ret_avg.case_4_avg
            END
        ELSE CAST(TRIM(r.Returns_Rate) AS FLOAT)
    END AS Returns_Rate,

    -- Column 16: Imputing missing Email Opening Rates via active promo usage boundaries
    CASE 
        WHEN TRIM(r.Email_Opening_Rate) = '' OR r.Email_Opening_Rate IS NULL OR LOWER(TRIM(r.Email_Opening_Rate)) = 'null' OR LOWER(TRIM(r.Email_Opening_Rate)) = 'nan' THEN
            CASE 
                WHEN ROUND(CAST(TRIM(r.Login_Frequency) AS FLOAT), 0) BETWEEN 0 AND 4 AND CAST(TRIM(r.Discount_Usage_Rate) AS FLOAT) BETWEEN 0.00 AND 39.30 THEN em_avg.case_1_avg
                WHEN ROUND(CAST(TRIM(r.Login_Frequency) AS FLOAT), 0) BETWEEN 0 AND 4 AND CAST(TRIM(r.Discount_Usage_Rate) AS FLOAT) BETWEEN 39.31 AND 113.16 THEN em_avg.case_2_avg
                WHEN ROUND(CAST(TRIM(r.Login_Frequency) AS FLOAT), 0) BETWEEN 5 AND 9 AND CAST(TRIM(r.Discount_Usage_Rate) AS FLOAT) BETWEEN 0.00 AND 39.30 THEN em_avg.case_3_avg
                ELSE em_avg.case_4_avg
            END
        ELSE CAST(TRIM(r.Email_Opening_Rate) AS FLOAT)
    END AS Email_Opening_Rate,

    -- Column 17: Imputing missing Customer Support Calls logs via return rate thresholds
    CASE 
        WHEN TRIM(r.Customer_Support_Calls) = '' OR r.Customer_Support_Calls IS NULL OR LOWER(TRIM(r.Customer_Support_Calls)) = 'null' OR LOWER(TRIM(r.Customer_Support_Calls)) = 'nan' THEN
            CASE 
                WHEN ROUND(CAST(TRIM(r.Total_Purchases) AS FLOAT), 0) BETWEEN 2 AND 9 AND CAST(TRIM(r.Returns_Rate) AS FLOAT) BETWEEN 0.00 AND 6.12 THEN s_avg.case_1_avg
                WHEN ROUND(CAST(TRIM(r.Total_Purchases) AS FLOAT), 0) BETWEEN 2 AND 9 AND CAST(TRIM(r.Returns_Rate) AS FLOAT) BETWEEN 6.13 AND 21.90 THEN s_avg.case_2_avg
                WHEN ROUND(CAST(TRIM(r.Total_Purchases) AS FLOAT), 0) BETWEEN 10 AND 23 AND CAST(TRIM(r.Returns_Rate) AS FLOAT) BETWEEN 0.00 AND 6.12 THEN s_avg.case_3_avg
                ELSE s_avg.case_4_avg
            END
        ELSE CAST(TRIM(r.Customer_Support_Calls) AS FLOAT)
    END AS Customer_Support_Calls,

    -- Column 18: Imputing empty ratings with strict whole integers (0 decimals) from source for Osama
    ROUND(CASE 
        WHEN TRIM(r.Product_Rating_Average) = '' OR r.Product_Rating_Average IS NULL OR LOWER(TRIM(r.Product_Rating_Average)) = 'null' OR LOWER(TRIM(r.Product_Rating_Average)) = 'nan' THEN
            CASE 
                WHEN ROUND(CAST(TRIM(r.Customer_Support_Calls) AS FLOAT), 0) BETWEEN 0 AND 5 AND CAST(TRIM(r.Returns_Rate) AS FLOAT) BETWEEN 0.00 AND 6.10 THEN rat_avg.case_1_avg
                WHEN ROUND(CAST(TRIM(r.Customer_Support_Calls) AS FLOAT), 0) BETWEEN 0 AND 5 AND CAST(TRIM(r.Returns_Rate) AS FLOAT) BETWEEN 6.11 AND 96.12 THEN rat_avg.case_2_avg
                WHEN ROUND(CAST(TRIM(r.Customer_Support_Calls) AS FLOAT), 0) BETWEEN 6 AND 18 AND CAST(TRIM(r.Returns_Rate) AS FLOAT) BETWEEN 0.00 AND 6.10 THEN rat_avg.case_3_avg
                ELSE rat_avg.case_4_avg
            END
        ELSE CAST(TRIM(r.Product_Rating_Average) AS FLOAT)
    END, 0) AS Product_Rating_Average,

    -- Column 19: Managing Social Media Engagement blank rows via demographic matrix anchors
    CASE 
        WHEN TRIM(r.Social_Media_Engagement) = '' OR r.Social_Media_Engagement IS NULL OR LOWER(TRIM(r.Social_Media_Engagement)) = 'null' OR LOWER(TRIM(r.Social_Media_Engagement)) = 'nan' THEN
            CASE 
                WHEN CAST(TRIM(r.Age) AS FLOAT) <= 35 AND (CAST(TRIM(r.Mobile_App_Usage_Time) AS FLOAT) <= 17.40 OR CAST(TRIM(r.Email_Opening_Rate) AS FLOAT) <= 20.00) THEN soc_avg.case_1_avg
                WHEN CAST(TRIM(r.Age) AS FLOAT) <= 35 AND CAST(TRIM(r.Mobile_App_Usage_Time) AS FLOAT) > 17.40 AND CAST(TRIM(r.Email_Opening_Rate) AS FLOAT) > 20.00 THEN soc_avg.case_2_avg
                WHEN CAST(TRIM(r.Age) AS FLOAT) > 35 AND TRIM(r.Gender) = 'Female' THEN soc_avg.case_3_avg
                ELSE soc_avg.case_4_avg
            END
        ELSE CAST(TRIM(r.Social_Media_Engagement) AS FLOAT)
    END AS Social_Media_Engagement,

    -- Column 20: Managing Mobile App Usage Time blank cells via session velocity anchors
    CASE 
        WHEN TRIM(r.Mobile_App_Usage_Time) = '' OR r.Mobile_App_Usage_Time IS NULL OR LOWER(TRIM(r.Mobile_App_Usage_Time)) = 'null' OR LOWER(TRIM(r.Mobile_App_Usage_Time)) = 'nan' THEN
            CASE 
                WHEN CAST(TRIM(r.Session_Duration) AS FLOAT) BETWEEN 0.00 AND 25.76 AND ROUND(CAST(TRIM(r.Login_Frequency) AS FLOAT), 0) BETWEEN 0 AND 11 THEN app_avg.case_1_avg
                WHEN CAST(TRIM(r.Session_Duration) AS FLOAT) BETWEEN 0.00 AND 25.76 AND ROUND(CAST(TRIM(r.Login_Frequency) AS FLOAT), 0) BETWEEN 12 AND 43 THEN app_avg.case_2_avg
                WHEN CAST(TRIM(r.Session_Duration) AS FLOAT) BETWEEN 25.77 AND 66.40 AND ROUND(CAST(TRIM(r.Login_Frequency) AS FLOAT), 0) BETWEEN 0 AND 11 THEN app_avg.case_3_avg
                ELSE app_avg.case_4_avg
            END
        ELSE CAST(TRIM(r.Mobile_App_Usage_Time) AS FLOAT)
    END AS Mobile_App_Usage_Time,

    -- Column 21: Filling empty Payment Failures with stable logical default zeros
    ROUND(CASE 
        WHEN TRIM(r.Payment_Failures) = '' OR r.Payment_Failures IS NULL OR LOWER(TRIM(r.Payment_Failures)) = 'null' OR LOWER(TRIM(r.Payment_Failures)) = 'nan' THEN 0
        ELSE CAST(TRIM(r.Payment_Failures) AS FLOAT)
    END) AS Payment_Failures,

    -- Column 22: Imputing Credit Balance blank records using transactional order values matrix
    CASE 
        WHEN TRIM(r.Credit_Balance) = '' OR r.Credit_Balance IS NULL OR LOWER(TRIM(r.Credit_Balance)) = 'null' OR LOWER(TRIM(r.Credit_Balance)) = 'nan' THEN
            CASE 
                WHEN ROUND(CAST(TRIM(r.Total_Purchases) AS FLOAT), 0) BETWEEN -7 AND 13 AND CAST(TRIM(r.Average_Order_Value) AS FLOAT) BETWEEN 30.71 AND 127.12 THEN c_avg.case_1_avg
                WHEN ROUND(CAST(TRIM(r.Total_Purchases) AS FLOAT), 0) BETWEEN -7 AND 13 AND CAST(TRIM(r.Average_Order_Value) AS FLOAT) > 127.12 THEN c_avg.case_2_avg
                WHEN ROUND(CAST(TRIM(r.Total_Purchases) AS FLOAT), 0) BETWEEN 14 AND 128 AND CAST(TRIM(r.Average_Order_Value) AS FLOAT) BETWEEN 30.71 AND 127.12 THEN c_avg.case_3_avg
                ELSE c_avg.case_4_avg
            END
        ELSE CAST(TRIM(r.Credit_Balance) AS FLOAT)
    END AS Credit_Balance,
    
    -- Columns 23, 24 & 25: Enforcing casting datatypes for final e-commerce table alignment
    CAST(TRIM(r.Lifetime_Value) AS FLOAT) AS Lifetime_Value,
    CAST(ROUND(CAST(TRIM(r.Churned) AS FLOAT), 0) AS DOUBLE) AS Churned,
    CAST(TRIM(r.Signup_Quarter) AS CHAR(10)) AS Signup_Quarter

FROM raw_ecommerce_data r
CROSS JOIN Age_Stats a_st
CROSS JOIN Session_Group_Stats s_st
CROSS JOIN Pages_Reference_Averages p_avg
CROSS JOIN Recency_Group_Averages rec_avg
CROSS JOIN Returns_Group_Averages ret_avg
CROSS JOIN Email_Group_Averages em_avg
CROSS JOIN Support_Group_Averages s_avg
CROSS JOIN Rating_Group_Averages rat_avg
CROSS JOIN Social_Group_Averages soc_avg
CROSS JOIN App_Group_Averages app_avg
CROSS JOIN Credit_Group_Averages c_avg;

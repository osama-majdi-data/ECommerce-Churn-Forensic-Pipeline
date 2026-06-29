-- =========================================================================
-- MASTER GRADUATION PROJECT: E-COMMERCE CUSTOMER CHURN PREDICTION
-- PHASE 4: SECOND-STAGE PRODUCTION BUILD (TOTAL OUTLIER SANITIZATION)
-- MASTER DATA ENGINEER: ENG. OSAMA
-- DATA ENGINE: MYSQL WORKBENCH
-- PART 1 OF 5: DYNAMIC BASELINE MATRIX EXTRACTORS FOR OUTLIERS (CTEs)
-- =========================================================================

-- Step 1: Dropping the final perfect production table if it exists to prevent server locks
DROP TABLE IF EXISTS final_perfect_ecommerce_data;

-- Step 2: Executing the comprehensive production build query for outlier sanitization
CREATE TABLE final_perfect_ecommerce_data AS 

-- [Matrix 1]: Extracting pure purchase averages from non-negative records for negative transaction leakages
WITH Purchase_Outlier_Baselines AS (
    SELECT 
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 1 AND ROUND(CAST(TRIM(Login_Frequency) AS FLOAT), 0) BETWEEN 4 AND 16 THEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) END), 0) AS churned_negative_replacement,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 0 AND ROUND(CAST(TRIM(Login_Frequency) AS FLOAT), 0) BETWEEN 0 AND 30 THEN ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) END), 0) AS active_negative_replacement
    FROM cleaned_ecommerce_data
    WHERE Total_Purchases >= 0
),

-- [Matrix 2]: Mining pristine invoice averages from valid retail boundaries ($1 - $500) for extreme Whale tickets
Invoice_Outlier_Baselines AS (
    SELECT 
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 0 AND ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 8 AND 34 THEN CAST(TRIM(Average_Order_Value) AS FLOAT) END), 2) AS active_whale_replacement,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 1 AND ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 1 AND 26 THEN CAST(TRIM(Average_Order_Value) AS FLOAT) END), 2) AS churned_whale_replacement
    FROM cleaned_ecommerce_data
    WHERE Average_Order_Value BETWEEN 1 AND 500
),

-- [Matrix 3]: Mining stable coupon usage ratios from historical clean bands (0% - 100%) for breakthrough promos
Discount_Outlier_Baselines AS (
    SELECT 
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 1 AND ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 3 AND 32 THEN CAST(TRIM(Discount_Usage_Rate) AS FLOAT) END), 2) AS churned_discount_replacement,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 0 AND ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) BETWEEN 4 AND 35 THEN CAST(TRIM(Discount_Usage_Rate) AS FLOAT) END), 2) AS active_discount_replacement
    FROM cleaned_ecommerce_data
    WHERE Discount_Usage_Rate BETWEEN 0 AND 100
),

-- [Matrix 4]: Extracting target wallet values from steady-state uncorrupted purchase groups (0$ - 300$)
Credit_Outlier_Baselines AS (
    SELECT 
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 0 AND ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) = 9 THEN CAST(TRIM(Credit_Balance) AS FLOAT) END), 2) AS active_wallet_replacement,
        ROUND(AVG(CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 1 AND ROUND(CAST(TRIM(Total_Purchases) AS FLOAT), 0) = 7 THEN CAST(TRIM(Credit_Balance) AS FLOAT) END), 2) AS churned_wallet_replacement
    FROM cleaned_ecommerce_data
    WHERE Credit_Balance BETWEEN 0 AND 300
)
SELECT 
    -- Column 1: Upgraded Age Constraint (Dynamically trapping all invalid human spans < 15 or > 80)
    -- Explanation: Re-architected by Eng. Osama to transform static checks into continuous open boundaries,
    -- injecting behavioral averages based on customer churn profiles for maximum system safety.
    ROUND(CASE 
        WHEN CAST(TRIM(c.Age) AS FLOAT) < 15 THEN
            CASE WHEN ROUND(CAST(TRIM(c.Churned) AS FLOAT), 0) = 1 THEN 37 ELSE 39 END
        WHEN CAST(TRIM(c.Age) AS FLOAT) > 80 THEN
            CASE WHEN ROUND(CAST(TRIM(c.Churned) AS FLOAT), 0) = 1 THEN 37 ELSE 38 END
        ELSE ROUND(CAST(TRIM(c.Age) AS FLOAT), 0)
    END) AS Age,
    
    -- Identity Columns 2, 3, 4 & 5: Transferring verified clean demographic and loyalty structures
    CAST(TRIM(c.Gender) AS CHAR(10)) AS Gender,
    CAST(TRIM(c.Country) AS CHAR(50)) AS Country,
    CAST(TRIM(c.City) AS CHAR(50)) AS City,
    CAST(TRIM(c.Membership_Years) AS FLOAT) AS Membership_Years,
    
    -- Interaction Columns 6 & 7: Transferring verified stable engagement and session velocity records
    ROUND(CAST(TRIM(c.Login_Frequency) AS FLOAT), 0) AS Login_Frequency,
    CAST(TRIM(c.Session_Duration) AS FLOAT) AS Session_Duration,
    -- Column 8: Transferring verified clean browsing session page tracks
    CAST(TRIM(c.Pages_Per_Session) AS FLOAT) AS Pages_Per_Session,
    
    -- Column 9: Mitigating Cart Abandonment Rate leaks and purging breakthrough percentages (>100%)
    -- Explanation: Applying dynamic open boundaries to clamp future corrupted abandonment logs.
    ROUND(CASE 
        WHEN CAST(TRIM(c.Cart_Abandonment_Rate) AS FLOAT) > 100 THEN
            CASE 
                WHEN ROUND(CAST(TRIM(c.Total_Purchases) AS FLOAT), 0) BETWEEN 4 AND 15 AND ROUND(CAST(TRIM(c.Churned) AS FLOAT), 0) = 0 THEN 59.73
                WHEN ROUND(CAST(TRIM(c.Total_Purchases) AS FLOAT), 0) BETWEEN 16 AND 34 AND ROUND(CAST(TRIM(c.Churned) AS FLOAT), 0) = 0 THEN 43.33
                WHEN ROUND(CAST(TRIM(c.Total_Purchases) AS FLOAT), 0) BETWEEN 16 AND 34 AND ROUND(CAST(TRIM(c.Churned) AS FLOAT), 0) = 1 THEN 55.07
                ELSE 68.74
            END
        ELSE CAST(TRIM(c.Cart_Abandonment_Rate) AS FLOAT)
    END, 2) AS Cart_Abandonment_Rate,

    -- Column 10: Transferring clean verified Wishlist items count
    ROUND(CAST(TRIM(c.Wishlist_Items) AS FLOAT), 0) AS Wishlist_Items,

    -- Column 11: Eradicating corrupted negative Total Purchases logs (<0) via Matrix 1 baselines
    ROUND(CASE 
        WHEN ROUND(CAST(TRIM(c.Total_Purchases) AS FLOAT), 0) < 0 THEN
            CASE 
                WHEN ROUND(CAST(TRIM(c.Churned) AS FLOAT), 0) = 1 THEN p_out.churned_negative_replacement
                ELSE p_out.active_negative_replacement
            END
        ELSE CAST(TRIM(c.Total_Purchases) AS FLOAT)
    END, 0) AS Total_Purchases,

    -- Column 12: Suppressing extreme Average Order Value spikes (>500) via Matrix 2 to safeguard client tiers
    CASE 
        WHEN CAST(TRIM(c.Average_Order_Value) AS FLOAT) > 500 THEN
            CASE 
                WHEN ROUND(CAST(TRIM(c.Churned) AS FLOAT), 0) = 0 THEN inv_out.active_whale_replacement
                ELSE inv_out.churned_whale_replacement
            END
        ELSE CAST(TRIM(c.Average_Order_Value) AS FLOAT)
    END AS Average_Order_Value,
    -- Column 13: Transferring clean verified transactional transaction velocity recency logs
    CAST(TRIM(c.Days_Since_Last_Purchase) AS FLOAT) AS Days_Since_Last_Purchase,

    -- Column 14: Suppressing Discount Usage Rate breakthroughs (>100) via Matrix 3 and clamping floats
    ROUND(CASE 
        WHEN CAST(TRIM(c.Discount_Usage_Rate) AS FLOAT) > 100 THEN
            CASE 
                WHEN ROUND(CAST(TRIM(c.Churned) AS FLOAT), 0) = 1 THEN disc_out.churned_discount_replacement
                ELSE disc_out.active_discount_replacement
            END
        ELSE CAST(TRIM(c.Discount_Usage_Rate) AS FLOAT)
    END, 2) AS Discount_Usage_Rate,

    -- Column 15 & 16: Transferring clean verified operational return rates and marketing emails logs
    CAST(TRIM(c.Returns_Rate) AS FLOAT) AS Returns_Rate,
    CAST(TRIM(c.Email_Opening_Rate) AS FLOAT) AS Email_Opening_Rate,

    -- Column 17: Transferring clean verified customer friction support call records
    CAST(TRIM(c.Customer_Support_Calls) AS FLOAT) AS Customer_Support_Calls,

    -- Column 18: Fixing product rating average anomalies (0 and >5) with pure whole numbers (0 decimals)
    -- Explanation: Clamping faulty logging breakthroughs strictly to retail limits based on purchase behavior.
    ROUND(CASE 
        WHEN ROUND(CAST(TRIM(c.Product_Rating_Average) AS FLOAT), 0) = 0 OR ROUND(CAST(TRIM(c.Product_Rating_Average) AS FLOAT), 0) > 5 THEN
            CASE 
                WHEN ROUND(CAST(TRIM(c.Total_Purchases) AS FLOAT), 0) BETWEEN 5 AND 20 AND ROUND(CAST(TRIM(c.Churned) AS FLOAT), 0) = 0 THEN 3
                WHEN ROUND(CAST(TRIM(c.Total_Purchases) AS FLOAT), 0) BETWEEN 21 AND 45 AND ROUND(CAST(TRIM(c.Churned) AS FLOAT), 0) = 0 THEN 3
                WHEN ROUND(CAST(TRIM(c.Total_Purchases) AS FLOAT), 0) BETWEEN 21 AND 45 AND ROUND(CAST(TRIM(c.Churned) AS FLOAT), 0) = 1 THEN 2
                ELSE 2
            END
        ELSE CAST(TRIM(c.Product_Rating_Average) AS FLOAT)
    END, 0) AS Product_Rating_Average,
    -- Column 19, 20 & 21: Transferring clean verified digital interaction failure and platform tracking logs
    CAST(TRIM(c.Social_Media_Engagement) AS FLOAT) AS Social_Media_Engagement,
    CAST(TRIM(c.Mobile_App_Usage_Time) AS FLOAT) AS Mobile_App_Usage_Time,
    ROUND(CAST(TRIM(c.Payment_Failures) AS FLOAT), 0) AS Payment_Failures,

    -- Column 22: Mitigating the large-scale Credit Balance systemic loop and purging contaminated wallet records (>300)
    -- Explanation: Clamping future database wallet breaches automatically using uncorrupted steady-state baselines (Matrix 4).
    CASE 
        WHEN CAST(TRIM(c.Credit_Balance) AS FLOAT) > 300 THEN
            CASE 
                WHEN ROUND(CAST(TRIM(c.Churned) AS FLOAT), 0) = 0 THEN cred_out.active_wallet_replacement
                ELSE cred_out.churned_wallet_replacement
            END
        ELSE CAST(TRIM(c.Credit_Balance) AS FLOAT)
    END AS Credit_Balance,
    
    -- Columns 23, 24 & 25: Enforcing strategic system casting datatypes for final ML compatibility
    CAST(TRIM(c.Lifetime_Value) AS FLOAT) AS Lifetime_Value,
    CAST(ROUND(CAST(TRIM(c.Churned) AS FLOAT), 0) AS DOUBLE) AS Churned,
    CAST(TRIM(c.Signup_Quarter) AS CHAR(10)) AS Signup_Quarter

FROM cleaned_ecommerce_data c
CROSS JOIN Purchase_Outlier_Baselines p_out
CROSS JOIN Invoice_Outlier_Baselines inv_out
CROSS JOIN Discount_Outlier_Baselines disc_out
CROSS JOIN Credit_Outlier_Baselines cred_out;

-- =========================================================================
-- PHASE 5: PRODUCTION PIPELINE AUTOMATION & ARCHITECTURE (REVISED)
-- DEVELOPED BY: ENG. OSAMA
-- DATA ENGINE: MYSQL WORKBENCH
-- PURPOSE: CONSTRUCTING AN ENTERPRISE-GRADE STORED PROCEDURE AND BI VIEWS
-- =========================================================================

-- Step 1: Drop the existing stored procedure to avoid object compilation redundancy
DROP PROCEDURE IF EXISTS Refresh_Ecommerce_Pipeline;

DELIMITER $$

-- 🎛️ AUTOMATION PIPELINE: Wrapping the continuous transformation process into a Single Server Call
CREATE PROCEDURE Refresh_Ecommerce_Pipeline()
BEGIN
    -- Step 2: Dropping old instances to refresh production data pipelines
    DROP TABLE IF EXISTS final_perfect_ecommerce_data;

    -- Step 3: Dynamically applying open mathematical constraints to block future corrupted rows
    CREATE TABLE final_perfect_ecommerce_data AS 
    SELECT 
        
        -- Upgraded Age Constraint (Dynamically trapping all invalid human spans < 15 or > 80)
        ROUND(CASE 
            WHEN CAST(TRIM(Age) AS FLOAT) < 15 THEN
                CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 1 THEN 37 ELSE 39 END
            WHEN CAST(TRIM(Age) AS FLOAT) > 80 THEN
                CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 1 THEN 37 ELSE 38 END
            ELSE ROUND(CAST(TRIM(Age) AS FLOAT), 0)
        END) AS Age,
        
        Gender,
        Country,
        City,
        Membership_Years,
        Login_Frequency,
        Session_Duration,
        Pages_Per_Session,
        Cart_Abandonment_Rate,
        Wishlist_Items,
        Total_Purchases,
        
        -- Upgraded Invoice Constraint (Trapping all premium whales or billing exploits > 500$)
        CASE 
            WHEN CAST(TRIM(Average_Order_Value) AS FLOAT) > 500 THEN
                CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 0 THEN 114.17 ELSE 130.76 END
            ELSE CAST(TRIM(Average_Order_Value) AS FLOAT)
        END AS Average_Order_Value,
        
        Days_Since_Last_Purchase,
        Discount_Usage_Rate,
        Returns_Rate,
        Email_Opening_Rate,
        Customer_Support_Calls,
        Product_Rating_Average,
        Social_Media_Engagement,
        Mobile_App_Usage_Time,
        Payment_Failures,
        
        -- Upgraded Wallet Constraint (Trapping all systemic cache leaks > 300$ automatically)
        CASE 
            WHEN CAST(TRIM(Credit_Balance) AS FLOAT) > 300 THEN
                CASE WHEN ROUND(CAST(TRIM(Churned) AS FLOAT), 0) = 0 THEN 58.36 ELSE 69.72 END
            ELSE CAST(TRIM(Credit_Balance) AS FLOAT)
        END AS Credit_Balance,
        
        Lifetime_Value,
        Churned,
        Signup_Quarter

    FROM cleaned_ecommerce_data;
END$$

DELIMITER ;

-- Step 4: CRITICAL TRIGGER CALL - Instantly executing the procedure to physically generate the production table on disk
CALL Refresh_Ecommerce_Pipeline();

-- -------------------------------------------------------------------------
-- PRODUCTION VIEWS ARCHITECTURE: LAYERED ACCESS CONTROLS
-- -------------------------------------------------------------------------

-- 👁️ View 1: Machine Learning Feed Interface
CREATE OR REPLACE VIEW v_machine_learning_input AS
SELECT 
    Age, Gender, Membership_Years, Login_Frequency, Session_Duration, Pages_Per_Session, 
    Cart_Abandonment_Rate, Wishlist_Items, Total_Purchases, Average_Order_Value, 
    Days_Since_Last_Purchase, Discount_Usage_Rate, Returns_Rate, Email_Opening_Rate, 
    Customer_Support_Calls, Product_Rating_Average, Social_Media_Engagement, 
    Mobile_App_Usage_Time, Payment_Failures, Credit_Balance, Lifetime_Value, Churned
FROM final_perfect_ecommerce_data;

-- 👁️ View 2: Executive Business Intelligence Analytics Interface
CREATE OR REPLACE VIEW v_executive_marketing_dashboard AS
SELECT 
    Country, City, Gender, Signup_Quarter,
    COUNT(*) AS Active_Customer_Volume,
    ROUND(AVG(Age), 0) AS Segment_Average_Age,
    ROUND(AVG(Lifetime_Value), 2) AS Segment_Average_LTV,
    ROUND(AVG(Average_Order_Value), 2) AS Segment_Average_Ticket,
    ROUND(AVG(Churned) * 100, 2) AS Real_Time_Churn_Percentage
FROM final_perfect_ecommerce_data
GROUP BY Country, City, Gender, Signup_Quarter;

-- 👁️ View 3: Corporate Financial Audit & Risk Control Interface
CREATE OR REPLACE VIEW v_financial_risk_audit AS
SELECT 
    Country, City, Age, Total_Purchases, Average_Order_Value, Discount_Usage_Rate, Credit_Balance, Churned
FROM final_perfect_ecommerce_data
WHERE Average_Order_Value > 250 OR Discount_Usage_Rate > 75;

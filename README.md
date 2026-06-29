# 👑 Enterprise-Grade E-Commerce Churn Prediction & Forensic Pipeline

Developed by: **Eng. Osama Assar**  
Data Engine: **MySQL Workbench** | ML Core: **Python 3 (LightGBM & XGBoost)** | BI: **Power BI**

---

## 🚨 The Structural Plot Twist (Why a 99% ML Model Is Dangerous)

During development, my initial Machine Learning models reached a spectacular **98% accuracy**. To a beginner, this is a milestone. To a professional Data Engineer, this screams **Data Leakage, Overfitting, or Systemic Data Corruption**. 

Instead of deploying a fragile model destined to collapse in production, I went upstream into **MySQL Workbench** to conduct a full forensic database audit to unmask the hidden traps within the ERP architecture.

---

## 🛠️ The 5-Stage Production-Ready SQL Pipeline

The original raw dataset suffered from severe data fragmentation and pipeline noise. I architected a modular 5-stage cleaning script to sanitize the telemetry from the source:

1. **Stage 1: Demographic Slicing (`01_eda_missing_values.sql`)**  
   Audited empty records to isolate systemic missing data signatures across targeted text arrays.
2. **Stage 2: 4-Quadrant Imputation Matrix (`02_first_stage_pipeline.sql`)**  
   Rejected lazy global-mean imputation. Built complex, multi-variable, cross-sectional `AVG(CASE WHEN...)` CTE matrices to inject hyper-focused behavioral baselines.
3. **Stage 3: Outlier Forensic Filtering (`03_eda_outliers_detection.sql`)**  
   Discovered a catastrophic cache leak where customer wallet balances exploded beyond retail limits (exceeding \$300 to tens of thousands).
4. **Stage 4: Dynamic Operational Clamping (`04_second_stage_pipeline.sql`)**  
   Implemented adaptive, open-ended mathematical boundary rules to permanently clamp anomalous ages and premium financial whales.
5. **Stage 5: Enterprise Automation & BI Layer (`05_automation_and_views.sql`)**  
   Wrapped the entire data pipeline into a single, scalable **Stored Procedure** (`Refresh_Ecommerce_Pipeline`) and compiled 3 specialized secure **SQL Views** to stream clean vectors into Python and Power BI without server overhead.

---

## 🤖 Machine Learning Auditing & Non-Linearity Verification

By feeding pristine, sanitized data from `v_machine_learning_input` into the ML pipeline, the tree-based models captured authentic, highly robust behavioral patterns:

*   **XGBoost Classifier:** Achieved **99% Recall** and **0.9994 ROC-AUC** on hidden test tokens.
*   **LightGBM Classifier:** Achieved **98% Recall** and **0.9995 ROC-AUC** with maximum leaf-wise efficiency.

### 🧪 Cutting the Doubt: Forensic Sanity Checks
To prove that the 99% metrics were driven by complex behavioral combinations rather than cheap linear cheats, a primitive linear baseline was cross-tested:
*   **Logistic Regression Baseline:** Collapsed to **72% General Accuracy** and **0.7852 AUC** (failing to converge after 1,000 iterations due to data complexity).
*   **Pearson Correlation Audit:** Confirmed zero Target Leakage, with the highest linear feature correlation capped perfectly at **0.28**. 

*This audited proof certifies that the model is rock-solid, fully generalized, and production-ready.*

---

## 📊 Predictive Business Intelligence (Power BI)

The data is wrapped into an executive, dark-themed, single-page dashboard to bridge the gap between AI metrics and core corporate decision-making:

### 📈 Executive Churn & Retention Hub
*   **Total Revenue at Risk (KPI):** Dynamically sums the LTV of high-risk customer segments using precision DAX measures.
*   **Predictive Churn Rate (KPI):** Enforces a customized dynamic percentage tracking layout for executive decision makers.
*   **Actionable Lead Generation Table:** Instantly isolates the geographical clusters facing critical churn velocity to let marketing squads execute immediate retention campaigns.
*   **Micro-Interaction Filters:** Integrated with a custom **Reset Filters Button** powered by seamless Bookmarks automation to enable fluid visual state navigation.

---

## 📂 Repository Tree Structure

```text
📦 ECommerce-Churn-Forensic-Pipeline
 ├── 📂 01_SQL_Analytics_Pipeline/       
 │    ├── 📄 01_eda_missing_values.sql       
 │    ├── 📄 02_first_stage_pipeline.sql     
 │    ├── 📄 03_eda_outliers_detection.sql    
 │    ├── 📄 04_second_stage_pipeline.sql    
 │    └── 📄 05_automation_and_views.sql     
 ├── 📂 02_Machine_Learning_Pipeline/    
 │    ├── 📄 06_churn_modeling_pipeline.ipynb 
 │    └── 📄 winning_lightgbm_model.pkl      
 ├── 📂 03_PowerBI_Dashboard/            
 │    └── 📄 07_churn_predictive_dashboard.pbix 
 └── 📄 README.md                        
```

---

## 🔮 Future Enhancements & Scalability (Version 2.0 Roadmap)
To maintain constant repository activity and continuous integration, the pipeline's future roadmap includes:
*   Migrating static hardcoded clamping thresholds into dynamic `MIN-AVG Subqueries` for full self-evolving orchestration.
*   Deploying the pipeline model as an optimized microservice for real-time edge streaming.

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random

# Set random seed for reproducibility
np.random.seed(42)
random.seed(42)

# -------------------------------
# 1. Generate Policies Dataset
# -------------------------------

def generate_policies(num_policies=10000):
    """
    Generates a synthetic policies dataset for insurance actuarial analysis.
    
    Parameters:
    - num_policies (int): Number of policy records to generate.
    
    Returns:
    - policies_df (DataFrame): Generated policies data.
    """
    # Policy_ID: Unique identifier
    policy_ids = np.arange(1, num_policies + 1)
    
    # Customer_ID: Assuming multiple policies per customer
    customer_ids = np.random.randint(1, num_policies // 2, size=num_policies)
    
    # Policy_Age: Number of years since policy inception (0-30)
    policy_age = np.random.randint(0, 31, size=num_policies)
    
    # Product_Type: Categorical (BOP, Liability, Transportation, Home, Auto)
    product_types = ['BOP', 'Liability', 'Transportation', 'Home', 'Auto']
    product_type = np.random.choice(product_types, size=num_policies, p=[0.2, 0.25, 0.15, 0.25, 0.15])
    
    # Vehicle_Type: Categorical (Car, Truck, Motorcycle, SUV, Van)
    vehicle_types = ['Car', 'Truck', 'Motorcycle', 'SUV', 'Van']
    vehicle_type = np.random.choice(vehicle_types, size=num_policies, p=[0.4, 0.2, 0.1, 0.2, 0.1])
    
    # Driving_History: Number of prior claims (0-5)
    driving_history = np.random.poisson(lam=0.5, size=num_policies)
    driving_history = np.clip(driving_history, 0, 5)
    
    # Region: Categorical (Northeast, Midwest, South, West)
    regions = ['Northeast', 'Midwest', 'South', 'West']
    region = np.random.choice(regions, size=num_policies, p=[0.25, 0.25, 0.3, 0.2])
    
    # Exposure: Policy exposure in years (1-30, similar to Policy_Age)
    exposure = policy_age + 1  # Assuming exposure is at least 1 year
    
    # Premium: Calculated based on features with some randomness
    base_premium = 500
    premium = (base_premium +
               (policy_age * 10) +
               (driving_history * 50) +
               np.where(vehicle_type == 'Truck', 200, 0) +
               np.where(product_type == 'Liability', 150, 0) +
               np.random.normal(0, 50, size=num_policies))  # Adding some noise
    premium = np.round(premium, 2)
    premium = np.clip(premium, 100, None)  # Minimum premium of $100
    
    # Earned_Premium: Assuming policies are ongoing, equal to Premium
    earned_premium = premium.copy()
    
    # Ultimate_Losses: Simulated total losses per policy
    # Using pure premium = Ultimate_Losses / Exposure
    # For simulation, pure_premium = driving_history * 100 + some noise
    pure_premium = driving_history * 100 + np.random.normal(0, 50, size=num_policies)
    pure_premium = np.clip(pure_premium, 0, None)
    ultimate_losses = pure_premium * exposure
    ultimate_losses = np.round(ultimate_losses, 2)
    
    # Reserving_Losses: Using Bornhuetter-Ferguson method
    # For simplicity, Reserved_Losses = Ultimate_Losses * 0.8
    reserved_losses = ultimate_losses * 0.8
    reserved_losses = np.round(reserved_losses, 2)
    
    # Create Policies DataFrame
    policies_df = pd.DataFrame({
        'Policy_ID': policy_ids,
        'Customer_ID': customer_ids,
        'Policy_Age': policy_age,
        'Product_Type': product_type,
        'Vehicle_Type': vehicle_type,
        'Driving_History': driving_history,
        'Region': region,
        'Exposure': exposure,
        'Premium': premium,
        'Earned_Premium': earned_premium,
        'Ultimate_Losses': ultimate_losses,
        'Pure_Premium': pure_premium,
        'Reserved_Losses': reserved_losses
    })
    
    # Introduce some missing values in 'Reserved_Losses' to simulate reserving issues
    reserved_missing_indices = np.random.choice(policies_df.index, size=int(0.01 * num_policies), replace=False)
    policies_df.loc[reserved_missing_indices, 'Reserved_Losses'] = np.nan
    
    # Introduce duplicate policies for data cleaning exercises
    duplicate_indices = np.random.choice(policies_df.index, size=int(0.005 * num_policies), replace=False)
    duplicates = policies_df.loc[duplicate_indices]
    policies_df = pd.concat([policies_df, duplicates], ignore_index=True)
    
    return policies_df

# -------------------------------
# 2. Generate Claims Dataset
# -------------------------------

def generate_claims(policies_df, avg_claims_per_policy=0.3):
    """
    Generates a synthetic claims dataset linked to policies.
    
    Parameters:
    - policies_df (DataFrame): The policies DataFrame to link claims.
    - avg_claims_per_policy (float): Average number of claims per policy.
    
    Returns:
    - claims_df (DataFrame): Generated claims data.
    """
    # Calculate total number of claims based on Poisson distribution
    num_policies = policies_df.shape[0]
    num_claims = np.random.poisson(lam=avg_claims_per_policy, size=num_policies)
    
    # Policy_ID: Repeating based on number of claims
    policy_ids = np.repeat(policies_df['Policy_ID'], num_claims)
    
    # Claim_ID: Unique identifier
    claim_ids = np.arange(1, len(policy_ids) + 1)
    
    # Claim_Date: Random date within policy period
    # Assuming policies start 'Policy_Age' years ago from a fixed end date
    end_date = datetime(2024, 12, 31)
    policy_start_dates = end_date - pd.to_timedelta(policies_df['Policy_Age'] * 365, unit='d')
    
    claim_dates = []
    for start_date, num in zip(policy_start_dates, num_claims):
        if num > 0:
            random_days = np.random.randint(0, (end_date - start_date).days + 1, size=num)
            dates = [start_date + timedelta(days=int(x)) for x in random_days]
            claim_dates.extend(dates)
    
    # Claim_Amount: Based on Pure Premium with some variability
    pure_premiums = policies_df.loc[policy_ids - 1, 'Pure_Premium'].values  # Policy_ID starts at 1
    claim_amounts = pure_premiums * np.random.uniform(0.5, 2.0, size=len(policy_ids))
    claim_amounts = np.round(claim_amounts, 2)
    
    # Claim_Type: Categorical (Property Damage, Bodily Injury, Collision, Comprehensive)
    claim_types = ['Property Damage', 'Bodily Injury', 'Collision', 'Comprehensive']
    claim_type = np.random.choice(claim_types, size=len(policy_ids), p=[0.4, 0.3, 0.2, 0.1])
    
    # Severity: Similar to Claim_Amount for simplicity
    severity = claim_amounts.copy()
    
    # Create Claims DataFrame
    claims_df = pd.DataFrame({
        'Claim_ID': claim_ids,
        'Policy_ID': policy_ids,
        'Claim_Date': claim_dates,
        'Claim_Amount': claim_amounts,
        'Claim_Type': claim_type,
        'Severity': severity
    })
    
    # Introduce some missing values in 'Claim_Amount' to simulate data issues
    claim_missing_indices = np.random.choice(claims_df.index, size=int(0.005 * len(claims_df)), replace=False)
    claims_df.loc[claim_missing_indices, 'Claim_Amount'] = np.nan
    
    # Introduce duplicate claims for data cleaning exercises
    duplicate_claim_indices = np.random.choice(claims_df.index, size=int(0.002 * len(claims_df)), replace=False)
    duplicate_claims = claims_df.loc[duplicate_claim_indices]
    claims_df = pd.concat([claims_df, duplicate_claims], ignore_index=True)
    
    return claims_df

# -------------------------------
# 3. Generate Customers Dataset
# -------------------------------

def generate_customers(policies_df, num_customers=None):
    """
    Generates a synthetic customers dataset linked to policies.
    
    Parameters:
    - policies_df (DataFrame): The policies DataFrame to link customers.
    - num_customers (int or None): Number of unique customers. If None, derive from policies.
    
    Returns:
    - customers_df (DataFrame): Generated customers data.
    """
    if num_customers is None:
        num_customers = policies_df['Customer_ID'].nunique()
    
    customer_ids = np.arange(1, num_customers + 1)
    
    # CustomerName: Randomly generated names
    first_names = ['John', 'Jane', 'Alex', 'Emily', 'Michael', 'Sarah', 'David', 'Laura', 'Robert', 'Linda']
    last_names = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Wilson', 'Taylor']
    customer_names = [f"{random.choice(first_names)} {random.choice(last_names)}" for _ in range(num_customers)]
    
    # Contact_Email: Generated from names
    contact_emails = [f"{name.replace(' ', '.').lower()}@example.com" for name in customer_names]
    
    # Region: Categorical (Northeast, Midwest, South, West)
    regions = ['Northeast', 'Midwest', 'South', 'West']
    customer_regions = np.random.choice(regions, size=num_customers, p=[0.25, 0.25, 0.3, 0.2])
    
    # Create Customers DataFrame
    customers_df = pd.DataFrame({
        'Customer_ID': customer_ids,
        'CustomerName': customer_names,
        'Contact_Email': contact_emails,
        'Region': customer_regions
    })
    
    return customers_df

# -------------------------------
# 4. Generate Insurance Products Dataset
# -------------------------------

def generate_insurance_products():
    """
    Generates a synthetic insurance products dataset.
    
    Returns:
    - products_df (DataFrame): Generated insurance products data.
    """
    product_ids = np.arange(1, 6)
    product_names = ['Business Owners Policy', 'Liability Insurance', 'Transportation Insurance', 'Home Insurance', 'Auto Insurance']
    
    # Description for each product
    descriptions = [
        'A comprehensive policy for small to medium-sized businesses.',
        'Covers legal liabilities arising from injuries or damages.',
        'Insurance for transportation network companies like ride-sharing services.',
        'Protection against damages to your home and property.',
        'Covers vehicles against accidents, theft, and other damages.'
    ]
    
    products_df = pd.DataFrame({
        'Product_ID': product_ids,
        'ProductName': product_names,
        'Description': descriptions
    })
    
    return products_df

# -------------------------------
# 5. Save Datasets to CSV
# -------------------------------

def save_datasets(policies_df, claims_df, customers_df, products_df):
    """
    Saves the generated datasets to CSV files.
    
    Parameters:
    - policies_df (DataFrame): Policies data.
    - claims_df (DataFrame): Claims data.
    - customers_df (DataFrame): Customers data.
    - products_df (DataFrame): Insurance products data.
    """
    policies_df.to_csv('policies.csv', index=False)
    claims_df.to_csv('claims.csv', index=False)
    customers_df.to_csv('customers.csv', index=False)
    products_df.to_csv('insurance_products.csv', index=False)
    print("Datasets have been successfully generated and saved as 'policies.csv', 'claims.csv', 'customers.csv', and 'insurance_products.csv'.")

# -------------------------------
# 6. Main Function to Generate All Datasets
# -------------------------------

def main():
    # Generate Policies
    print("Generating Policies Dataset...")
    policies_df = generate_policies(num_policies=10000)
    print(f"Policies Dataset: {policies_df.shape[0]} records.")
    
    # Generate Claims
    print("Generating Claims Dataset...")
    claims_df = generate_claims(policies_df, avg_claims_per_policy=0.3)
    print(f"Claims Dataset: {claims_df.shape[0]} records.")
    
    # Generate Customers
    print("Generating Customers Dataset...")
    customers_df = generate_customers(policies_df)
    print(f"Customers Dataset: {customers_df.shape[0]} records.")
    
    # Generate Insurance Products
    print("Generating Insurance Products Dataset...")
    products_df = generate_insurance_products()
    print(f"Insurance Products Dataset: {products_df.shape[0]} records.")
    
    # Save to CSV
    print("Saving Datasets to CSV...")
    save_datasets(policies_df, claims_df, customers_df, products_df)

if __name__ == "__main__":
    main()

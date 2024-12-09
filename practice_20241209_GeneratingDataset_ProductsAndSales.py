import pandas as pd
import numpy as np
from datetime import datetime, timedelta

# Set random seed for reproducibility
np.random.seed(42)

# Number of records
num_products = 100
num_sales = 1000

# Generate products data
product_ids = np.arange(1, num_products + 1)
product_names = [f'Product_{i}' for i in product_ids]
categories = np.random.choice(['Electronics', 'Clothing', 'Home & Kitchen', 'Books', 'Sports'], size=num_products)
prices = np.round(np.random.uniform(10, 500, size=num_products), 2)
stock_quantities = np.random.randint(0, 1000, size=num_products)

products_df = pd.DataFrame({
    'ProductID': product_ids,
    'ProductName': product_names,
    'Category': categories,
    'Price': prices,
    'StockQuantity': stock_quantities
})

# Introduce some missing values in 'StockQuantity'
missing_indices = np.random.choice(products_df.index, size=5, replace=False)
products_df.loc[missing_indices, 'StockQuantity'] = np.nan

# Save products to CSV
products_df.to_csv('products.csv', index=False)

# Generate sales data
sale_ids = np.arange(1, num_sales + 1)
sale_product_ids = np.random.choice(product_ids, size=num_sales)
quantity_sold = np.random.randint(1, 20, size=num_sales)
start_date = datetime(2023, 1, 1)
end_date = datetime(2024, 12, 31)
date_range = end_date - start_date
sale_dates = [start_date + timedelta(days=int(x)) for x in np.random.uniform(0, date_range.days, size=num_sales)]
total_amount = np.round(quantity_sold * products_df.set_index('ProductID').loc[sale_product_ids, 'Price'].values, 2)

sales_df = pd.DataFrame({
    'SaleID': sale_ids,
    'ProductID': sale_product_ids,
    'QuantitySold': quantity_sold,
    'SaleDate': sale_dates,
    'TotalAmount': total_amount
})

# Save sales to CSV
sales_df.to_csv('sales.csv', index=False)

print("Custom datasets 'products.csv' and 'sales.csv' have been generated.")

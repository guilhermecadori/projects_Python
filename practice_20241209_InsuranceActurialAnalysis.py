
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix, roc_auc_score, roc_curve
from imblearn.over_sampling import SMOTE
import matplotlib.pyplot as plt
import seaborn as sns

# Load datasets
policies_df = pd.read_csv('policies.csv')
claims_df = pd.read_csv('claims.csv')

# Merge claims with policies to get policy features
merged_df = pd.merge(claims_df, policies_df, on='Policy_ID', how='left')

# Define 'Large_Loss' as Claim_Amount > 1000
merged_df['Large_Loss'] = (merged_df['Claim_Amount'] > 1000).astype(int)

# Select features and target
features = ['Policy_Age', 'Product_Type', 'Vehicle_Type', 'Driving_History', 'Region', 'Severity']
target = 'Large_Loss'

X = merged_df[features]
y = merged_df[target]

# Handle missing values
X = X.dropna()
y = y[X.index]

# Encode categorical variables
categorical_features = ['Product_Type', 'Vehicle_Type', 'Region']
encoder = OneHotEncoder(drop='first', sparse=False)
encoded_cats = pd.DataFrame(encoder.fit_transform(X[categorical_features]),
                            columns=encoder.get_feature_names_out(categorical_features))

# Combine with numerical features
X_final = pd.concat([X[['Policy_Age', 'Driving_History', 'Severity']].reset_index(drop=True),
                    encoded_cats.reset_index(drop=True)], axis=1)

# Feature Scaling
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X_final)

# Split into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.2, random_state=42, stratify=y)

# Handle class imbalance with SMOTE
smote = SMOTE(random_state=42)
X_train_res, y_train_res = smote.fit_resample(X_train, y_train)

# Train Logistic Regression model
logreg = LogisticRegression(random_state=42)
logreg.fit(X_train_res, y_train_res)

# Predict class labels
y_pred = logreg.predict(X_test)

# Predict probabilities
y_proba = logreg.predict_proba(X_test)[:, 1]

# Evaluate the model with class labels
print("Confusion Matrix:")
print(confusion_matrix(y_test, y_pred))

print("\nClassification Report:")
print(classification_report(y_test, y_pred))

print(f"ROC-AUC Score: {roc_auc_score(y_test, y_proba):.2f}")

# Plot ROC Curve
fpr, tpr, thresholds = roc_curve(y_test, y_proba)
plt.figure(figsize=(8, 6))
plt.plot(fpr, tpr, label=f'Logistic Regression (AUC = {roc_auc_score(y_test, y_proba):.2f})')
plt.plot([0, 1], [0, 1], 'k--', label='Random Guess')
plt.title('Receiver Operating Characteristic (ROC) Curve')
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.legend()
plt.show()

# Example: Using probabilities for decision threshold
threshold = 0.7
y_pred_custom = (y_proba >= threshold).astype(int)

print(f"\nClassification Report with Threshold = {threshold}:")
print(classification_report(y_test, y_pred_custom))

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime

# Load your data (replace with actual path)
df = pd.read_csv("flow_data.csv")

# Clean the data
df.dropna(inplace=True)
df['timestamp'] = pd.to_datetime(df['timestamp'])
df = df.sort_values(by='timestamp')
df.set_index('timestamp', inplace=True)

# Basic stats
print("Summary statistics:")
print(df['flow_rate'].describe())

# Plot time series
plt.figure(figsize=(12, 6))
sns.lineplot(data=df, x=df.index, y='flow_rate', color='teal')
plt.title("Water Flow Rate Over Time")
plt.xlabel("Date")
plt.ylabel("Flow Rate (GPM)")
plt.grid(True)
plt.tight_layout()
plt.savefig("flow_rate_timeseries.png")
plt.show()

# Detect anomalies using simple z-score
df['zscore'] = (df['flow_rate'] - df['flow_rate'].mean()) / df['flow_rate'].std()
df['anomaly'] = df['zscore'].abs() > 2

# Output anomalies
anomalies = df[df['anomaly']]
print("\nDetected anomalies:")
print(anomalies[['flow_rate', 'zscore']])

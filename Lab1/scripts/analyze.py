import pandas as pd
import numpy as np
from pathlib import Path
import matplotlib.pyplot as plt
import os

# read csv files from the logs directory - use pathlib to get the path to the logs directory
PATH = Path("../logs")
files = list(PATH.glob("*.csv"))


# Function to calculate the mean and standard deviation of the time values for each configuration
def calc_mean_and_std(df, file_name):
    # Group the results by 'Case' and 'threads' to calculate metrics for each configuration
    grouped = df.groupby(["Case", "Threads"])

    # Create a DataFrame to store the results
    results = []

    for name, group in grouped:
        case, threads = name
        time_values = (
            group["Time"].values * 1000
        )  # Extract 'time' column as a NumPy array

        # Calculate mean, standard deviation, and Z-scores
        n = len(time_values)  # Number of time_values points
        mean = np.mean(time_values)
        stddev = np.std(time_values, ddof=1) / np.sqrt(n)

        # Store the result in the results list
        results.append(
            {
                "Name": file_name,
                "Case": case,
                "Threads": threads,
                "Mean Time": mean,
                "StdDev Time": stddev,
            }
        )

    return results


results = []

for file in files:
    df = pd.read_csv(file)
    results.extend(
        calc_mean_and_std(df, os.path.basename(file).split("/")[-1].split(".")[0])
    )

# Convert results to a DataFrame for display or further analysis
results_df = pd.DataFrame(results)

# save the results to a csv file
results_df.to_csv("../logs/results.csv", index=False)

#!/bin/bash

# List of test files
obj_files=("../bin/serial.o" "../bin/mutex.o" "../bin/rwlock.o")

# List of command line parameters
parameters=("1000 10000 0.99 0.005 0.005 1" "1000 10000 0.9 0.05 0.05 1" "1000 10000 0.5 0.25 0.25 1")
logfiles=("../logs/serial.csv" "../logs/mutex.csv" "../logs/rwlock.csv")
numThreads=("1" "2" "4" "8")

# Number of executions for each configuration
num_executions=100

# Loop through test files
for i in "${!obj_files[@]}"
do
    # Write current test case to csv file
    echo "Case,Threads,Time" >> ${logfiles[$i]}

    # Loop through parameters
    for param in "${!parameters[@]}"
    do
        # Loop through number of threads
        for numThread in "${numThreads[@]}"
        do
            # Perform 100 executions and csv each output
            for ((j=1; j<=num_executions; j++))
            do
                # Show progress for the current execution in the terminal
                echo "Running execution $j of $num_executions..."

                # Capture the output of the command into a variable
                output=$(./${obj_files[$i]} $parameters[$param] $numThread)

                # Write the output to the csv file
                echo "$param,$numThread,$output" >> ${logfiles[$i]}
            done

            # Print completion of current test case
            echo "Completed test with Parameter: $param and Threads: $numThread"
            echo "--------------------------------"

            # Skip tests for multiple threads for the serial test
            if [ $i -eq 0 ]
            then
                break
            fi
        done
    done
done

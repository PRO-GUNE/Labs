#!/bin/bash

# List of test files
obj_files=("../bin/serial.o" "../bin/mutex.o" "../bin/rwlock.o")

# List of command line parameters
parameters=("1000 10000 0.99 0.005 0.005 1" "1000 10000 0.9 0.05 0.05 1" "1000 10000 0.5 0.25 0.25 1")
logfiles=("../logs/serial.log" "../logs/mutex.log" "../logs/rwlock.log")
numThreads=("1" "2" "4" "8")

# Loop through test files
for i in "${!obj_files[@]}"
do
    # Write current test case to log file
    echo "Test case: ${obj_files[$i]}" >> ${logfiles[$i]}
    echo "--------------------------------" >> ${logfiles[$i]}

    # Loop through parameters
    for param in "${parameters[@]}"
    do
        # Loop through number of threads
        for numThread in "${numThreads[@]}"
        do
            # Write current parameter to log file
            echo "Parameter: $param" >> ${logfiles[$i]}
            echo "Number of threads: $numThread" >> ${logfiles[$i]}

            # Run test file with parameter
            ./${obj_files[$i]} $param $numThread >> ${logfiles[$i]}
            echo "--------------------------------" >> ${logfiles[$i]}

            # skip tests for multiple threads for the serial test
            if [ $i -eq 0 ]
            then
                break
            fi
        done
        
    done
done
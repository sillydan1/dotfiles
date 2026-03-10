#!/bin/bash

success_count=0
failure_count=0
run_count=$1
shift

for ((i = 1; i <= run_count; i++))
do
    $@
    if [ $? -eq 0 ]; then
        ((success_count++))
    else
        ((failure_count++))
    fi
done

# Output the results
echo "Total runs: $run_count"
echo "Succeeded: $success_count"
echo "Failed: $failure_count"

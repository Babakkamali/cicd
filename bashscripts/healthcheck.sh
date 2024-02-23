#!/bin/bash

timeout=$1
interval=$2
service_name=$3
new_image=$4

while [ $timeout -gt 0 ]; do
    output=$(docker service ps --no-trunc $service_name)

    if echo "$output" | grep -q "$new_image.*Running"; then
        running_count=$(echo "$output" | grep -c "$new_image.*Running")
        total_count=$(docker service inspect $service_name --format '{{ .Spec.Mode.Replicated.Replicas }}')

        if [ "$running_count" -eq "$total_count" ]; then
            echo "Deployment successful."
            exit 0
        fi
    elif echo "$output" | grep -q "Shutdown.*Failed"; then
        echo "Deployment failed, service rolled back."
        exit 1
    fi

    sleep $interval
    let "timeout-=interval"
done

echo "Deployment check timed out."
exit 1
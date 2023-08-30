#!/bin/bash

# Function to check if RabbitMQ is up and running
is_rabbitmq_running() {
    systemctl is-active --quiet rabbitmq-server
    return $?
}

# Wait for RabbitMQ to be up for a maximum of 5 minutes (adjust as needed)
max_wait_time=300  # 5 minutes
wait_interval=10   # Check every 10 seconds

# Wait until RabbitMQ is up or the timeout is reached
elapsed_time=0
while ! is_rabbitmq_running && [ "$elapsed_time" -lt "$max_wait_time" ]; do
    sleep "$wait_interval"
    elapsed_time=$((elapsed_time + wait_interval))
done

# Check if RabbitMQ is up and running
if is_rabbitmq_running; then
    # RabbitMQ is up, proceed with the import
    echo "$(date +'%Y-%m-%d %H:%M:%S')  RabbitMQ is running! Import started..." >> /home/rabbitmq-certs/import-boot.log
    echo " ====================================================== " >> /home/rabbitmq-certs/import-boot.log
    /usr/local/bin/rabbitmqadmin import /home/rabbit-backup.json >> /home/rabbitmq-certs/import-boot.log 2>&1
    echo " ====================================================== " >> /home/rabbitmq-certs/import-boot.log
else
    # RabbitMQ did not start within the timeout
    echo "$(date +'%Y-%m-%d %H:%M:%S') RabbitMQ did not start within the timeout. Import aborted." >> /home/rabbitmq-certs/import-boot.log
fi

#!/bin/bash

# SNS
awslocal sns create-topic --name fiap-health-med-api_appointment-created_dev
awslocal sns create-topic --name fiap-health-med-api_appointment-cancelled_dev

# SQS
awslocal sqs create-queue --queue-name fiap-health-med-notifier_appointment-created_dev
awslocal sqs create-queue --queue-name fiap-health-med-notifier_appointment-cancelled_dev

# SNS -> SQS
awslocal sns subscribe \
  --endpoint-url=http://sqs.us-east-1.localhost.localstack.cloud:4566 \
  --region us-east-1 \
  --protocol sqs \
  --topic-arn arn:aws:sns:us-east-1:000000000000:fiap-health-med-api_appointment-created_dev \
  --notification-endpoint arn:aws:sqs:us-east-1:000000000000:fiap-health-med-notifier_appointment-created_dev

awslocal sns subscribe \
  --endpoint-url=http://sqs.us-east-1.localhost.localstack.cloud:4566 \
  --region us-east-1 \
  --protocol sqs \
  --topic-arn arn:aws:sns:us-east-1:000000000000:fiap-health-med-api_appointment-cancelled_dev \
  --notification-endpoint arn:aws:sqs:us-east-1:000000000000:fiap-health-med-notifier_appointment-cancelled_dev
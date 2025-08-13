# Lambda + DynamoDB Streams Project

This project demonstrates how to use **DynamoDB Streams** to trigger an **AWS Lambda function** whenever an item in a DynamoDB table is created, updated, or deleted.

## What it covers

- Creating a DynamoDB table with Streams enabled (`NEW_AND_OLD_IMAGES`)
- Writing a Lambda function to process stream events
- Granting Lambda permissions to read the stream
- Using `aws_lambda_event_source_mapping` to connect the stream to Lambda

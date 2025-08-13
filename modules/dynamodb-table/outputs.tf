output "stream_arn" {
  description = "ARN of DynamoDB stream."
  value       = aws_dynamodb_table.this.stream_arn
}
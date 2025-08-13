locals {
  lab_name = "lambda-dynamodb-stream"
}

data "archive_file" "lambda_zip" {
  type                    = "zip"
  source_content          = <<-EOT
    def lambda_handler(event, context):
        print("Hello from Lambda!")
        print("Event:", event)
        return {
            "statusCode": 200,
            "body": "Lambda executed successfully!"
        }
  EOT
  source_content_filename = "lambda_function.py"
  output_path             = "${path.module}/lambda.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "${local.lab_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda" {
  function_name    = local.lab_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.13"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = 5
}

module "ddb" {
  source    = "../../modules/dynamodb-table"
  name      = "users"
  hash_key  = "user_id"
  range_key = "name"
  attributes = [
    { name = "user_id", type = "S" },
    { name = "name", type = "S" }
  ]
  ttl_enabled        = true
  ttl_attribute_name = "expires_at"
  stream_enabled     = true
  stream_view_type   = "NEW_AND_OLD_IMAGES"
}

resource "aws_lambda_event_source_mapping" "ddb_stream" {
  event_source_arn                   = module.ddb.stream_arn
  function_name                      = aws_lambda_function.lambda.arn
  starting_position                  = "LATEST"
  batch_size                         = var.batch_size
  maximum_batching_window_in_seconds = var.batch_window
}

data "aws_iam_policy_document" "lambda_ddb_stream_read" {
  statement {
    sid    = "APIAccessForDynamoDBStreams"
    effect = "Allow"
    actions = [
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:DescribeStream",
      "dynamodb:ListStreams",
      "dynamodb:ListShards",
    ]
    resources = [module.ddb.stream_arn]
  }
}

resource "aws_iam_role_policy" "lambda_ddb_stream_read" {
  name   = "${local.lab_name}-ddb-stream-read"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_ddb_stream_read.json
}
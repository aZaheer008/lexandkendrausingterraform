# This will generate an archive from our source file.
data "archive_file" "zip" {
  type = "zip"
  # source code path for our Lambda function which
  # handles Lex intent fulfillment activities
  source_file = "src/kendra_lambda.js"
  # each time we have new changes in our code we send output to this
  # path as a zip
  output_path = "archives/kendra.zip"
}

# The execution role provides the function's identity and
# access to AWS services and resources.
resource "aws_iam_role" "iam_for_kendra_lambda" {
  name               = "iam_for_kendra_lambda"
  assume_role_policy = templatefile("templates/lambda-assumed-role-policy.json", {})
}

#  ---- Data for our Lambda configuration ----

# The IAM policy that our Lambda execution role will assume

#  ----- End data for our configuration ---- //

resource "aws_lambda_function" "kendra_lambda" {
  function_name = "kendra_lambda"
  filename      = data.archive_file.zip.output_path
  # Amazon Resource Name (ARN) of the function's execution role.
  role = aws_iam_role.iam_for_kendra_lambda.arn
  # Used to trigger updates. Must be set to a base64-encoded SHA256 hash
  # of the package file specified
  source_code_hash = filebase64sha256(data.archive_file.zip.output_path)

  handler     = "kendra_lambda.handler"
  runtime     = "nodejs14.x"
  description = "Code hookup for kendra bot"
}

# Gives an external source Lex permission to access the Lambda function.
# We need our bot to be able to invoke a lambda function when
# we attempt to fulfill our intent.
resource "aws_lambda_permission" "allow_lex" {
  statement_id  = "AllowExecutionFromLex"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.kendra_lambda.function_name
  principal     = "lex.amazonaws.com"
}

// ...
# We want to be able to send errors in our lambda function
# to CloudWatch logs

# Use the data defined above to create our IAM policy
resource "aws_iam_policy" "lambda_logs" {
  name        = "allow-logs-policy1"
  description = "Allows access to logs"
  policy = templatefile("templates/lambda-allow-logs-iam-policy.json", {})
}

# Now that we have an iam policy, let's attach it to our lambda iam role
resource "aws_iam_role_policy_attachment" "lambda_logs_attach" {
  role       = aws_iam_role.iam_for_kendra_lambda.name
  policy_arn = aws_iam_policy.lambda_logs.arn
}

resource "aws_iam_policy" "kendra_lambda_policy" {
  name = "kendra-lambda-policy"
  policy      = templatefile("templates/lambda-allow-kendra-iam-policy.json", {})
}

resource "aws_iam_role_policy_attachment" "kendra_lambda_policy_attachment" {
  role       = aws_iam_role.iam_for_kendra_lambda.name
  policy_arn = aws_iam_policy.kendra_lambda_policy.arn

}

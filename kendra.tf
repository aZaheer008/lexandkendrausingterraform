resource "aws_iam_role" "example" {
  name = "kendra_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "kendra.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    "Environment" = "Production"
  }
}

resource "aws_iam_role_policy" "example_policy" {
  name = "example_policy"
  role = aws_iam_role.example.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:DescribeLogGroups",
          "logs:CreateLogGroup",
          "logs:DescribeLogStreams",
          "logs:CreateLogStream",
          "logs:GetLogEvents",
          "logs:PutLogEvents",
          "logs:PutRetentionPolicy",
          "kendra:Describe*",
          "kendra:List*",
          "kendra:Query",
          "kendra:BatchGetDocumentStatus",
          "kendra:GetQuerySuggestions",
          "kendra:GetSnapshots",
          "kendra:BatchPutDocument",
          "kendra:BatchDeleteDocument"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_kendra_index" "example" {
  name        = "example"
  description = "example"
  edition     = "DEVELOPER_EDITION"
  role_arn    = aws_iam_role.example.arn

  tags = {
    "Key1" = "Value1"
  }
}

resource "aws_kendra_data_source" "example" {
  index_id = aws_kendra_index.example.id
  name     = "example"
  type     = "WEBCRAWLER"
  role_arn = aws_iam_role.example.arn
  schedule =  "cron(39 22 * * ? *)"

  configuration {
    web_crawler_configuration {
      urls {
        seed_url_configuration {
          seed_urls = [
            "https://docs.aws.amazon.com/deepracer/latest/developerguide/what-is-deepracer.html"
          ]
        }
      }
    }
  }

}

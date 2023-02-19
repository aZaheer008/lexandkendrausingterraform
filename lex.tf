
// Create our lex bot
resource "aws_lex_bot" "kendra" {
  name           = "kendra"
  child_directed = false
  process_behavior = "BUILD" // build the bot so that it can be run

  abort_statement {
    message {
      content_type = "PlainText"
      content      = "Can't find an answer to that"
    }
  }

  intent {
    intent_name    = aws_lex_intent.policy.name
    intent_version = aws_lex_intent.policy.version
  }

  intent {
    intent_name    = aws_lex_intent.service.name
    intent_version = aws_lex_intent.service.version
  }

  intent {
    intent_name    = aws_lex_intent.return.name
    intent_version = aws_lex_intent.return.version
  }

  intent {
    intent_name    = aws_lex_intent.kendraIntent.name
    intent_version = aws_lex_intent.kendraIntent.version
  }

}


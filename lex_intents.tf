
locals {
  fulfillment_activity_type = "CodeHook"
  message_version           = "1.0"
}

// read_policy
resource "aws_lex_intent" "policy" {

  fulfillment_activity {
    type = local.fulfillment_activity_type
    code_hook {
      message_version = local.message_version
      uri             = aws_lambda_function.kendra_lambda.arn
    }
  }

  name = "policy"

  sample_utterances = [
    "what is a Policy",
    "I would like to read Policy",
    "Show Policy",
    "display Policy"
  ]

  # Slots -  these are the data items that the bot intent needs
  # in order to be able to fulfill its task;
  # e.g. for ordering flowers intent you will likely
  # need slots for type of flowers, delivery date,
  # and personal message to receipient to include.
  slot {
    name        = "policyTitle"
    description = "The policy is / ad"
    priority    = 1

    slot_constraint = "Required"

    # Amazon Lex has several built-in slot types,
    # but you can create your own custom slot types depending on use case
    slot_type = "AMAZON.AlphaNumeric"

    value_elicitation_prompt {
      max_attempts = 1

      message {
        content      = "Which policy You want to read?"
        content_type = "PlainText"
      }
    }
  }
  
}

// read_serving
resource "aws_lex_intent" "service" {

  fulfillment_activity {
    type = local.fulfillment_activity_type
    code_hook {
      message_version = local.message_version
      uri             = aws_lambda_function.kendra_lambda.arn
    }
  }

  name = "service"

  sample_utterances = [
    "Do You serve on weekend",
    "weekend is open ",
    "weekend "
  ]  
}

// read_retrun
resource "aws_lex_intent" "returnpolicy" {

  fulfillment_activity {
    type = local.fulfillment_activity_type
    code_hook {
      message_version = local.message_version
      uri             = aws_lambda_function.kendra_lambda.arn
    }
  }

  name = "returnpolicy"

  sample_utterances = [
    "Do You return",
    "returnpolicy"
  ]  
}

// kendra
resource "aws_lex_intent" "kendraIntent" {


  fulfillment_activity {
    type = local.fulfillment_activity_type
    code_hook {
      message_version = local.message_version
      uri             = aws_lambda_function.kendra_lambda.arn
    }
  }
  name = "kendraIntent"
  description = "My AWS Lex kendraIntent"
  sample_utterances = ["faq"]
}

resource "aws_lex_bot_alias" "kendrabotAlias" {
  bot_name    = aws_lex_bot.kendra.name
  name        = "kendrabotAlias"
  bot_version = "$LATEST"
}

output "bot_alias_id" {
  value = aws_lex_bot_alias.kendrabotAlias.id
}

resource "aws_lex_slot_type" "kendra_query" {
  name = "kendra_query"
  value_selection_strategy = "TOP_RESOLUTION"
  enumeration_value {
    value = "example"
  }
}

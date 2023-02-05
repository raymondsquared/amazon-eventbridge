
resource "aws_cloudwatch_log_group" "eventbridge_log_group" {
  name = "/aws/events/${var.module_name}"
  tags = local.tags
}

resource "aws_sqs_queue" "eventbridge_queue" {
  name = "${var.module_name}-queue"
  tags = local.tags
}

data "aws_iam_policy_document" "eventbridge_policy_document" {
  statement {
    sid     = "events-policy"
    actions = ["sqs:SendMessage"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [
      aws_sqs_queue.eventbridge_queue.arn,
    ]
  }
}

resource "aws_sqs_queue_policy" "eventbridge_queue_policy" {
  queue_url = aws_sqs_queue.eventbridge_queue.id
  policy    = data.aws_iam_policy_document.eventbridge_policy_document.json
}

module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name                 = "${var.module_name}-bus"
  create_bus               = true
  create_rules             = true
  create_targets           = true
  create_permissions       = true
  create_role              = true
  attach_tracing_policy    = true
  attach_cloudwatch_policy = true
  cloudwatch_target_arns   = [aws_cloudwatch_log_group.eventbridge_log_group.arn]

  rules = {
    foo = {
      name          = "${var.module_name}-foo-rule"
      description   = "Capture foo data"
      event_pattern = jsonencode({ "detail" : { "foo" : ["bar"] } })
    }
  }

  targets = {
    foo = [
      {
        name = "${var.module_name}-foo-target"
        arn  = aws_sqs_queue.eventbridge_queue.arn
      }
    ]
  }
}

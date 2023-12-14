resource "aws_cloudwatch_event_rule" "trigger_image_build" {
  name        = var.cloudwatch_events_rule_name
  description = "Trigger the CodePipeline pipeline to build the image whenever a new push is made to CodeCommit repository"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.codecommit"
  ],
  "detail-type": [
    "CodeCommit Repository State Change"
  ],
  "resources": [
    "${aws_codecommit_repository.code_repo.arn}"
  ],
  "detail": {
    "event": [
      "referenceCreated",
      "referenceUpdated"
    ],
    "referenceType": [
        "branch"
    ],
    "referenceName": [
      "main"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "trigger_image_build" {
  target_id = "trigger_image_build"
  rule      = aws_cloudwatch_event_rule.trigger_image_build.id
  arn       = aws_codepipeline.imagebuild_pipeline.arn

  role_arn = aws_iam_role.cloudwatch_events_role.arn
}
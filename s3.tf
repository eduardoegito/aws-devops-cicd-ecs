#S3 Bucket for Codepipeline artifacts

resource "aws_s3_bucket" "project_s3_codepipeline_artifacts" {
  bucket = "${var.project_name}-codepipeline-artifacts"
}
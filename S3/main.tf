resource "aws_s3_bucket" "deployment_scripts" {
  bucket = var.deployment_scripts_bucket
  acl = "public-read"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_object" "script" {
  bucket = aws_s3_bucket.deployment_scripts.id
  acl = "public-read"
  key    = "mediawiki_deployment.yml"
  source = "${path.module}/mediawiki_deployment.yml"
}

output "deployment_scripts_bucket" {
  value = aws_s3_bucket.deployment_scripts.id
}

output "deployment_script" {
  value = aws_s3_bucket_object.script.id
}

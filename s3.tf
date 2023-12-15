# # Create an S3 bucket
# resource "aws_s3_bucket" "capstone-dev-alblogs-bucket" {
#   bucket = "capstone-dev-alblogs-bucket"

#   tags = {
#     Name        = "capstoneAlbLogsBucket"
#     Environment = "Dev"
#   }
# }

# # Enable versioning on the S3 bucket
# resource "aws_s3_bucket_versioning" "capstone-dev-alblogs-bucket-versioning" {
#   bucket = aws_s3_bucket.capstone-dev-alblogs-bucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }
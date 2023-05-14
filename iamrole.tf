resource "aws_iam_role" "rdsec2_role" {
  name = "rdsec2_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
     "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sts:AssumeRole"
            ],
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "rds.amazonaws.com"
                ]
            }
        }
    ]
  })

  tags = {
    tag-key = "rds"
    Name ="RDS-TERRAFORM"
  }
}

// creation of iam instance profile

resource "aws_iam_instance_profile" "demo-profile" {
  name = "demo_profile"
  role = aws_iam_role.rdsec2_role.name
}
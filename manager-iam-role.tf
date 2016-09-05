resource "aws_iam_role" "manager_role" {
  name = "${var.pre_tag}_manager_role_${var.post_tag}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "manager_access_policy" {
  name = "${var.pre_tag}_manager_access_policy_${var.post_tag}"
  role = "${aws_iam_role.manager_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ec2:*",
          "elasticloadbalancing:*",
          "cloudwatch:*",
          "autoscaling:*",
          "lambda:*",
          "logs:*",
          "s3:*",
          "elasticache:*",
          "ecr:*",
          "route53:*",
          "route53domains:*",
          "apigateway:*",
          "es:*",
          "iam:*",
          "events:*"
          ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
EOF
}

resource "aws_iam_instance_profile" "manager_instance_profile" {
  name = "${var.pre_tag}_manager_${var.post_tag}"
  roles = ["${aws_iam_role.manager_role.name}"]
}


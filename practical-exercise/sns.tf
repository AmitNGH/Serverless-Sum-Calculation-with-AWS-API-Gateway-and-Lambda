## Create SNS Topic

# Create policy
data "aws_iam_policy_document" "sns_publish_policy" {
    statement {
        effect = "Allow"
        actions = ["sns:Publish"]
        resources = ["${aws_sns_topic.sns_topic.arn}"]
    }
}

# Create SNS Publish policy .
resource "aws_iam_policy" "sns_policy" {
    name = "terraform_aws_sns_publish_policy"
    policy = "${data.aws_iam_policy_document.sns_publish_policy.json}"
}

# Create SNS Topic
resource "aws_sns_topic" "sns_topic" {
    name = "send-sum"
    display_name = "send-sum"
}

# Create SNS Subscription
resource "aws_sns_topic_subscription" "sns_topic_subscription" {
    topic_arn = "${aws_sns_topic.sns_topic.arn}"
    protocol = "email"
    endpoint = "amit963n@gmail.com"
}
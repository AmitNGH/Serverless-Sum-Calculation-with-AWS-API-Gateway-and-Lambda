## Create SNS Topic

# Create policy
data "aws_iam_policy_document" "sns_publish_policy" {
    statement {
        # sid = ""
        effect = "Allow"
        actions = ["sns:Publish"]
        resources = ["${aws_sns_topic.snstopic.arn}"]
    }
}

# Attach policy to role.
resource "aws_iam_policy" "sns_policy" {
    name = "terraform_aws_sns_publish_policy"
    policy = "${data.aws_iam_policy_document.sns_publish_policy.json}"
}

# Create SNS Topic
resource "aws_sns_topic" "snstopic" {
    name = "send-sum"
    display_name = "send-sum"
}

# Create SNS Subscription
resource "aws_sns_topic_subscription" "snstopicsubscription" {
    topic_arn = "${aws_sns_topic.snstopic.arn}"
    protocol = "email"
    endpoint = "amit963n@gmail.com"
}
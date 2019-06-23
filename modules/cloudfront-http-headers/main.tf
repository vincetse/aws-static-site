################################################################################
# IAM
data "aws_iam_policy_document" "iam_for_lambda_doc" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "CloudFrontHttpHeadersLambdaExec"
  assume_role_policy = "${data.aws_iam_policy_document.iam_for_lambda_doc.json}"}

resource "aws_iam_role_policy_attachment" "iam_for_lambda_perms" {
  role = "${aws_iam_role.iam_for_lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

################################################################################
# Lambda function

data "archive_file" "lambda_zip" {
  type = "zip"
  output_path = "${local.lambda_zip}"
  source_file = "${local.input_filename}"
}

resource "aws_lambda_function" "lambda_pkg" {
  filename = "${local.lambda_zip}"
  function_name = "${var.http_headers_function}"
  role = "${aws_iam_role.iam_for_lambda.arn}"
  handler = "${local.http_headers_handler}"
  source_code_hash = "${filebase64sha256("${data.archive_file.lambda_zip.output_path}")}"
  runtime = "nodejs8.10"
  publish = true
}

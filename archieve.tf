data "archive_file" "lambda_zip" {
  for_each = local.lambda_functions

  type        = "zip"
  output_path = "${path.module}/dist/${each.value.zip_key}"
  source_dir  = var.lambda_source_dir

  dynamic "excludes" {
    for_each = setsubtract(
      ["auth-handler.js", "newsletter-handler.js", "authorizer.js"],
      [replace(each.value.handler, ".handler", ".js")]
    )
    content {
      filename = excludes.value
    }
  }

  depends_on = [null_resource.source_code_check]
}

resource "null_resource" "source_code_check" {
  triggers = {
    source_hash = sha1(join("", [for f in fileset(var.lambda_source_dir, "*.js"): filemd5("${var.lambda_source_dir}/${f}")]))
  }
}

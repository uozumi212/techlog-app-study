# CloudFrontの定義
resource "aws_cloudfront_distribution" "techlog_cdn" {
  origin {
    # ALBではなく、EC2のパブリックDNSを直接指定します
    domain_name = aws_instance.app_server.public_dns
    origin_id   = "EC2-Rails-App"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only" # CloudFront -> EC2間はHTTP
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  aliases         = ["techlog-app.xyz"] # あなたのドメイン

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "EC2-Rails-App"

    # Railsのセッション（Cookie）と422エラー対策の設定
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
      headers = ["Host", "Accept", "Authorization", "X-Forwarded-Proto"] # 必要なヘッダーを転送
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  # ステップ1で作成したバージニア北部の証明書を指定
  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:185137893568:certificate/7e0fa30b-ea52-4553-a134-60221fca175e"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

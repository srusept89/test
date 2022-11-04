resource "aws_acm_certificate" "web_com" {
  private_key=file("private_key.pem")
 certificate_body = file("actual_cert.pem")
  certificate_chain=file("inter_cer.pem")
    } 
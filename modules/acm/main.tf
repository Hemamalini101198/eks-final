resource "aws_acm_certificate" "acm_certificate" {
  domain_name = ""
  subject_alternative_names = ""
  validation_method = "DNS"
}

#get details about route 53 hosted zone
data "aws_route53_record" "route53_record" {
  name = var.domain_name
  private_zone = false
}
/*
#create a recprd set in route53 for domain validation
resource "aws_route53_record" "route53_record" {
  for_each = {
    name = 
  }
}
*/
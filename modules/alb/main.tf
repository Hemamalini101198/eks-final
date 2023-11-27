#ALB creation
resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  enable_deletion_protection = false 

  enable_cross_zone_load_balancing = true
  enable_http2                    = true
  subnets = [var.public1_subnet_cidr,var.public2_subnet_cidr ]
}

/*
#CREATING SG FOR ALB
resource "aws_security_group" "alb-sg" {
  name        = "eks-alb-sg"
  description = "allow inbound http traffic"
  #vpc_id      = var.vpc_cidr
  

  ingress {
    description = "from my ip range"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    description = "from my ip range"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1" 
    cidr_blocks = ["10.0.0.0/16"]
  }
  tags = {
    "Name" = "eks-alb-sg"
  }
}
*/

#creating a listener on a port 80 with redirect action
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "redirect"

    redirect {
      port = 443
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }  
  }
} 


/*
#creating a listener on a port 443 with forward action
resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy = ""
  certificate_arn = ""

  default_action {
    type             = "forward"
    target_group_arn = ""
  }
} 
*/
resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]  
  enable_deletion_protection = false 

  enable_cross_zone_load_balancing = true
  enable_http2                    = true

  subnets = ["var.public1_subnet_cidrs", "var.public2_subnet_cidrs"]
}


#CREATING SG FOR LB

resource "aws_security_group" "alb-sg" {
  name        = "{var.application_alb}-sg"
  description = "allow inbound http traffic"
  #vpc_id      = module.vpc.vpc.id
  

  ingress {
    description = "from my ip range"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "from my ip range"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
/*
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    /*
    status_code      = "200"
    content_type     = "text/html"
    content_encoding = "text"
    response_body    = var.template_content
    */
  
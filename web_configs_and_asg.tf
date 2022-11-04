#create Autoscaling group Web
#target Groups
resource "aws_lb_target_group" "web-target-group" {
  name     = "web-asg-target"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.app-vpc.id
}
 #Launch config
resource "aws_launch_configuration" "web-Launch-config" {
  name_prefix     = "web-lconfig"
  image_id        = "ami-039e314f611dbc210"
  instance_type   = "t2.micro"
  user_data       = file("user-web-data.sh")
  security_groups = [aws_security_group.web-instance.id]
  lifecycle {
    create_before_destroy = true
  }
}
    #Load Balancer Public
resource "aws_lb" "web-alb" {
  name               = "web-asg-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.web_lb.id]
  subnets            = [aws_subnet.web-subnet-1.id,aws_subnet.web-subnet-2.id]
}
  #listener
resource "aws_lb_listener" "web-listener" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.web_com.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-target-group.arn
  }
}
#Web asg
resource "aws_autoscaling_group" "web_asg" {
  name                = "web_tier"
  vpc_zone_identifier = [aws_subnet.web-subnet-1.id,aws_subnet.web-subnet-2.id]
  min_size            = 4
  max_size            = 6
  desired_capacity    = 4
  launch_configuration = aws_launch_configuration.web-Launch-config.name
  #target_group_arns = aws_lb_target_group.web-target-group.arn

}
#aws_lb_target_group attachment to asg

resource "aws_autoscaling_attachment" "web-attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
  alb_target_group_arn   = aws_lb_target_group.web-target-group.arn
}

#create Autoscaling group App
    #target Groups
resource "aws_lb_target_group" "app-target-group" {
  name     = "app-asg-target"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.app-vpc.id
}
    #Launch config 
resource "aws_launch_configuration" "app-Launch-config" {
  name_prefix     = "app-lconfig"
  image_id        = "ami-039e314f611dbc210"
  instance_type   = "t2.micro"
  user_data       = file("user-app-data.sh")
  security_groups = [aws_subnet.app-subnet-1.id,aws_subnet.app-subnet-2.id]
  lifecycle {
    create_before_destroy = true
  }
}
    #Load Balancer App
resource "aws_lb" "app-alb" {
  name               = "web-asg-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_lb.id]
  subnets            = [aws_subnet.app-subnet-1.id,aws_subnet.app-subnet-2.id]
  depends_on = [
    aws_security_group.app_lb
  ]
}

  #listener
resource "aws_lb_listener" "app-listener" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-target-group.arn
  }
}
#App asg
resource "aws_autoscaling_group" "app_asg" {
  name                = "app_tier"
  vpc_zone_identifier = [aws_subnet.app-subnet-1.id,aws_subnet.app-subnet-2.id]
  min_size            = 4
  max_size            = 6
  desired_capacity    = 4
  launch_configuration = aws_launch_configuration.app-Launch-config.name
  #target_group_arns = aws_lb_target_group.app-target-group.arn
                       
}


#aws_lb_target_group attachment to asg

resource "aws_autoscaling_attachment" "app-attachment" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.id
  alb_target_group_arn   = aws_lb_target_group.app-target-group.arn
}
   
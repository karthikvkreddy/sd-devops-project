provider "aws" {
  region  = "${var.AWS_REGION}"
}

# Create AWS EC2 instance
resource "aws_instance" "mean-stack-app" {
  ami           = "${var.AWS_AMI_ID_APP}"
  key_name      = "${var.AWS_KEY_NAME}"
  instance_type = "${var.AWS_INSTANCE_TYPE_APP}"
  iam_instance_profile = "mean-stack-s3-ec2-access-role"
  vpc_security_group_ids = [
    "${var.security_group_id_app}"
  ]
  user_data = "${file("../infra/services/user_data.sh")}"
 
  tags = {
    Name = "${var.AWS_INSTANCE_NAME_APP}"
  }
}



# Create Load balancing Target Group
resource "aws_lb_target_group" "mean-satck-app-tg" {
  name        = "mean-satck-app-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "vpc-0325b1e35cec0f714"
    health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# Create Load lalancer
resource "aws_lb" "mean-stack-app-lb" {
  name               = "mean-stack-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups  = [
    "${var.security_group_id_app}"
  ]
 
  subnets         = ["subnet-056b3dda8707da0c2","subnet-0a07e0dc0d7e16fd0","subnet-0f8f23a574d7b6385","subnet-0592b55a6fa6a32b3"]
 
  tags = {
    Environment = "production"
  }
}

# Attach target group to load balancing
resource "aws_lb_target_group_attachment" "mean-stack-app-tg-attach" {
  target_group_arn =  aws_lb_target_group.mean-satck-app-tg.arn
  target_id        = aws_instance.mean-stack-app.id
  port             = 80
}

# Add listener to load balancing
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.mean-stack-app-lb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mean-satck-app-tg.arn
  }
}

# Create launch configuration foe Autoscaling group
resource "aws_launch_configuration" "mean-stack-app-lg1" {
  name   = "mean-stack-app-lg"
  image_id      = "${var.AWS_AMI_ID_APP}"
  instance_type = "t2.micro"
  iam_instance_profile = "mean-stack-s3-ec2-access-role"
  key_name      = "${var.AWS_KEY_NAME}"
  user_data = "${file("../infra/services/user_data.sh")}"
  security_groups  = [
    "${var.security_group_id_app}"
  ]
  lifecycle {
    create_before_destroy = true
  }
}

# Create Auto Scaling group 
resource "aws_autoscaling_group" "mean-stack-app-asg" {
  name                 = "terraform-asg-example"
  launch_configuration = aws_launch_configuration.mean-stack-app-lg1.name
  min_size             = 1
  max_size             = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = ["subnet-056b3dda8707da0c2","subnet-0a07e0dc0d7e16fd0","subnet-0f8f23a574d7b6385","subnet-0592b55a6fa6a32b3"]

  lifecycle {
    create_before_destroy = true
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.mean-stack-app-asg.id
  lb_target_group_arn    = aws_lb_target_group.mean-satck-app-tg.arn
}

resource "aws_security_group" "ecs_lb_sg" {
    name = "ecs-lb-security-group"
    vpc_id = aws_vpc.travelhub_vpc.id
    ingress {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "Allow http traffic to ECS load balancer"
      from_port = 80
      protocol = "tcp"
      to_port = 80
    } 

    egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
  
}

resource "aws_security_group" "travelhub_task_sg" {
  name        = "travelhub-task-security-group"
  vpc_id      = aws_vpc.travelhub_vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = 3000
    to_port         = 3000
    security_groups = [aws_security_group.ecs_lb_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
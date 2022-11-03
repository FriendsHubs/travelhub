resource "aws_security_group" "travel_hub_sg_lb" {
  name        = "example-alb-security-group"
  vpc_id      = aws_vpc.travel_hub.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




resource "aws_security_group" "travel_hub_SG_task" {
  name        = "example-task-security-group"
  vpc_id      = aws_vpc.travel_hub.id

  ingress {
    protocol        = "tcp"
    from_port       = 3000
    to_port         = 3000
    security_groups = [aws_security_group.travel_hub_sg_lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
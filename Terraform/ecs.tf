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

resource "aws_lb" "ecs_lb" {
  name            = "ECS-lb"
  subnets         = aws_subnet.travelhub_public_subnet[*].id
  security_groups = [aws_security_group.ecs_lb_sg.id]
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "ecs-target-group"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.travelhub_vpc.id
  target_type = "ip"
}

resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_lb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ecs_tg.id
    type             = "forward"
  }
}



resource "aws_ecs_task_definition" "travelhub_task" {
  family                   = "travelhub"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  container_definitions = <<TASK_DEFINITION
[
  {
    "image": "ekama/travel_hub:latest",
    "cpu": 1024,
    "memory": 2048,
    "name": "travelhub-app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  }
]
TASK_DEFINITION
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


resource "aws_ecs_cluster" "ecs_cluster" {
  name = "travelhub-cluster"
}


resource "aws_ecs_service" "travelhub_service" {
  name            = "travelhub-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.travelhub_task.arn
  desired_count   = var.frontend_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.travelhub_task_sg.id]
    subnets         = aws_subnet.travelhub_private_subnet.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.id
    container_name   = "travelhub-app"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.ecs_listener]
}


output "load_balancer_dns" {
  value = aws_lb.ecs_lb.dns_name
}


# data "aws_ssm_parameter" "docker-username" {
#   name = "dockerhub-username"
# }

# data "aws_ssm_parameter" "docker-password" {
#   name = "dockerhub-password"
# }


# resource "aws_iam_role" "ecs_role" {
  
  
# }

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "travelhub-cluster"
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

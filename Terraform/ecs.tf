
resource "aws_ecs_cluster" "main" {
  name = "example-cluster"
}


resource "aws_ecs_task_definition" "travel_hub_task_definition" {
  family                   = "hello-world-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  container_definitions = <<DEFINITION
[
  {
    "image": "emmanuelekama/travel_hub",
    "cpu": 1024,
    "memory": 2048,
    "name": "hello-world-app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "travel_hub_service" {
  name            = "hello-world-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.travel_hub_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.travel_hub_SG_task.id]
    subnets         = aws_subnet.travle_hub_private.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.travel_hub_TG.id
    container_name   = "hello-world-app"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.travel_hub_TG_listener]
}



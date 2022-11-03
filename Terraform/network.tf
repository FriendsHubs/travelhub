data "aws_availability_zones" "available_zones" {
  state = "available"
}



resource "aws_vpc" "travel_hub" {
  cidr_block = "10.32.0.0/16"
}


resource "aws_subnet" "travle_hub_public" {
  count                   = 2
  cidr_block              = cidrsubnet(aws_vpc.travel_hub.cidr_block, 8, 2 + count.index)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id                  = aws_vpc.travel_hub.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "travle_hub_private" {
  count             = 2
  cidr_block        = cidrsubnet(aws_vpc.travel_hub.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id            = aws_vpc.travel_hub.id
}

resource "aws_internet_gateway" "travel_hub_gateway" {
  vpc_id = aws_vpc.travel_hub.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.travel_hub.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.travel_hub_gateway.id
}

resource "aws_eip" "travel_hub_eip" {
  count      = 2
  vpc        = true
  depends_on = [aws_internet_gateway.travel_hub_gateway]
}

resource "aws_nat_gateway" "travel_hub_nat_gateway" {
  count         = 2
  subnet_id     = element(aws_subnet.travle_hub_public.*.id, count.index)
  allocation_id = element(aws_eip.travel_hub_eip.*.id, count.index)
}

resource "aws_route_table" "travel_hub_private_rtb" {
  count  = 2
  vpc_id = aws_vpc.travel_hub.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.travel_hub_nat_gateway.*.id, count.index)
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = element(aws_subnet.travle_hub_private.*.id, count.index)
  route_table_id = element(aws_route_table.travel_hub_private_rtb.*.id, count.index)
}

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

resource "aws_lb" "travel_hub_internet_faceing_lb" {
  name            = "example-lb"
  subnets         = aws_subnet.travle_hub_public.*.id
  security_groups = [aws_security_group.travel_hub_sg_lb.id]
}

resource "aws_lb_target_group" "travel_hub_TG" {
  name        = "example-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.travel_hub.id
  target_type = "ip"
}

resource "aws_lb_listener" "travel_hub_TG_listener" {
  load_balancer_arn = aws_lb.travel_hub_internet_faceing_lb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.travel_hub_TG.id
    type             = "forward"
  }
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
    "image": "registry.gitlab.com/architect-io/artifacts/nodejs-hello-world:latest",
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

resource "aws_ecs_cluster" "main" {
  name = "example-cluster"
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

output "load_balancer_ip" {
  value = aws_lb.travel_hub_internet_faceing_lb.dns_name
}

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
  port              = 3000
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ecs_tg.id
    type             = "forward"
  }
}

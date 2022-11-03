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

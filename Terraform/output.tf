
output "load_balancer_ip" {
  value = aws_lb.travel_hub_internet_faceing_lb.dns_name
}
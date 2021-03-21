resource "aws_elb" "clb" {
    name_prefix = "tw-lb"
    subnets = [var.public_subnet]
    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:80/"
        interval = 30
    }
    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }
    cross_zone_load_balancing = true
    instances = var.app_instance_ids
    security_groups = [var.clbsg]
}

output "clb_dns" {
  value = aws_elb.clb.dns_name
}

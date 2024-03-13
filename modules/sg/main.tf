resource "aws_security_group" "this" {
  name        = var.name
  vpc_id      = var.vpc_id

 
 dynamic "ingress" {
   for_each = var.ingress_port
   content{ 
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }
 }
 dynamic "egress"{
   for_each  = var.egress_port
   content{ 
    from_port   = egress.value
    to_port     = egress.value
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 }
  tags = merge(
    { Name = var.name },
    var.tags
  )

}
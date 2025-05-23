resource "tls_private_key" "insurance_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content         = tls_private_key.insurance_key.private_key_pem
  filename        = "${path.module}/insurance-key.pem"
  file_permission = "0600"
}

resource "aws_key_pair" "insurance_key" {
  key_name   = "insurance-key-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  public_key = tls_private_key.insurance_key.public_key_openssh
}

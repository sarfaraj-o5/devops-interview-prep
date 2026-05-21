provisioner "local-exec" {
  when    = destroy
  command = "echo ec2 creted > output.txt"
}

connection {
  type        = "ssh"
  user        = "ubuntu"
  private_key = file("key.pem")
  host        = self.public_ip
}

provisioner "remote-exec" {
  inline = [
    "sudo apt update",
    "sudo apt install -y nginx"
  ]
}

provisioner "file" {
  source      = "app.conf"
  destination = "/tmp/app.conf"
}

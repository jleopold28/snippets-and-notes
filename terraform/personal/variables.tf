variable "access_key" {
  default = ""
}

variable "secret_key" {
  default = ""
}

variable "region" {
  default = "us-east-1"
}

variable "amis" {
  type    = "map"
  default = {
    us-east-1 = "ami-c481fad3"
    us-west-2 = "ami-06b94666"
  }
}

variable "public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtEw5D+5q2YEyljPeOa7PzpvF4XT3JNUFJas0l3aAw/wJ4+uD2+e2ZgRvLMc2LrE5ph0fbsRozNXQU3QGiF21Nzk0OEuY85NGVrfLtntg4JhCAuWInPAs1CUO4sCKXMm2WuoQDR4EaBs1FTePblbgNjN4L4/WSvM1kUGIkKGVg0KJpa9/h1KPYbst4ywmoP/vo3ionzEa4BVwJanmL5HSCHQSYLslsDTseywXeSaZDEMzBNiJ72fWMZU9dOZMhXiyz8fs0RVpNG6u3NjH+V+mDYvm7JAe445KhYXccmkLyP39x68gwcU8EkfZz6rsVNGzFz8ivhDwH+xvF2qK9CNVf mschuchard-us-east"
}

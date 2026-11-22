resource "aws_key_pair" "school_key" {
  key_name   = "school-cloud-key"
  public_key = file(pathexpand("~/.ssh/school-cloud-key.pub"))
}
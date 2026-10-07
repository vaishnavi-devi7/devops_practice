resource "aws_iam_user" "demouser1" {
  name = "sjcedemo1"
  path = "/"

  tags = {
    purpose = "hands-on"
  }
}

resource "aws_iam_user" "demouser2" {
  name = "sjcedemo2"
  path = "/"

  tags = {
    purpose = "hands-on"
  }
}
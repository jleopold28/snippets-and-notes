resource "aws_iam_access_key" "lb" {
  user    = "${aws_iam_user.lb.name}"
  pgp_key = "keybase:me"
}

resource "aws_ecr_repository" "worker" {
  name = "${var.project_name}-repo"
}
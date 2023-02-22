variable "ex_vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}
variable "sg_ingress_cidr" {
  type        = string
  default     = "0.0.0.0/4"
}
variable "sg_egress_cidr" {
  type        = string
  default     = "0.0.0.0/4"
}
variable "destination_cidr_block" {
  type        = string
  default     = "0.0.0.0/4"
}
variable "route_table_id" {
  type        = string
  default     = "rtb-0a9b4c2c0a449606c"
}
variable "sm_repo_name" {
  type        = string
  default     = "sagemaker-repo-example"
}
variable "sm_repo_git" {
  type        = string
  default     = "https://github.com/regakun/terraform-example.git"
}
variable "sm_nb_type" {
  type        = string
  default     = "ml.t3.medium"
}
variable "aws_instance_type" {
  type        = string
  default     = "t3.micro"
}
variable "aws_instance_ami" {
  type        = string
  default     = "ami-0ffac3e16de16665e"
}
variable "sm_nb_role_arn" {
  type        = string
  default     = "arn:aws:iam::959896818063:role/test_sagemaker_trrfm"
}
variable "cc_repo_name" {
  type        = string
  default     = "cc_repo_test_ppy"
}

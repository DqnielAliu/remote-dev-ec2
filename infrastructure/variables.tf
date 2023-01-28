variable "aws-region" {
  type        = string
  description = "AWS region"
  default     = "us-east-2"
}
variable "environment" {
  type        = string
  description = "The name of the environment we'd like to launch."
  default     = "development"
}
variable "hostname" {
  type        = string
  description = "hostname of terminal workstation"
  default     = "linux"
}
variable "inventory-file" {
  type        = string
  description = "Ansible inventory file"
  default     = "../playbook/inventory/hosts.ini"
}
variable "key-file" {
  type        = string
  description = "SSH private key file"
  default     = "~/.ssh/mtcKey"
}
variable "host_os" {
  type        = string
  description = "Host OS "
  default     = "linux"
}
variable "project_name" {
  type        = string
  description = "Project name"
  default     = "demo"
}

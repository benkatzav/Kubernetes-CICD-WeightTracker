# if a variable is not showed up here it means I defined it in tfvars file which I don't push the git repository

variable "admin_user" {
  description = "Admin username of the VMs that will be part of the VM scale set"
  type        = string
  default     = "N/A"
}

variable "admin_password" {
  description = "Define password for the VMs of the Scale Set"
  type        = string
  default     = "N/A"
}

variable "ssh_public_key" {
  description = "Define ssh public key for the VMs of the Scale Set"
  type        = string
  default     = "N/A"
}
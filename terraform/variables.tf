variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Key Id"
  type        = string
  sensitive   = true
}

variable "security_group_id_app" {
  description = "AWS Security Group Id"
  type        = string
}

variable "AWS_AMI_ID_APP" {
  description = "AWS AMI Id"
  type        = string
  
}

variable "AWS_KEY_NAME" {
  description = "AWS Key pair Name"
  type        = string
}

variable "AWS_INSTANCE_NAME_APP" {
  description = "AWS Instance Name"
  type        = string
}

variable "AWS_INSTANCE_TYPE_APP" {
  description = "AWS Instance Type Name"
  type        = string
}

variable "AWS_REGION" {
  description = "AWS REGION"
  type        = string
}




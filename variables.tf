variable "allow_ssh_commands" {
  type        = bool
  description = "Allows the SSH user to execute one-off commands. Pass true to enable. Warning: These commands are not logged and increase the vulnerability of the system. Use at your own discretion."
  default     = false
}

variable "associate_public_ip_address" {
  type    = bool
  default = true
}

variable "auto_scaling_group_subnets" {
  type        = list(string)
  description = "List of subnets where the Auto Scaling Group will deploy the instances"
}

variable "bastion_additional_security_groups" {
  type        = list(string)
  description = "List of additional security groups to attach to the launch template"
  default     = []
}

variable "bastion_ami" {
  type        = string
  description = "The AMI that the Bastion Host will use."
  default     = ""
}

variable "bastion_host_key_pair" {
  type        = string
  description = "Select the key pair to use to launch the bastion host"
  default     = ""
}

variable "bastion_iam_permissions_boundary" {
  type        = string
  description = "IAM Role Permissions Boundary to constrain the bastion host role"
  default     = ""
}

variable "bastion_iam_policy_name" {
  type        = string
  description = "IAM policy name to create for granting the instance role access to the bucket"
  default     = "BastionHost"
}

variable "bastion_iam_role_name" {
  type        = string
  description = "IAM role name to create"
  default     = null
}

variable "bastion_iam_role_additional_policies" {
  description = "Additional policies to be added to the IAM role"
  type        = set(string)
  default     = []
}

variable "bastion_instance_count" {
  type    = number
  default = 1
}

variable "bastion_autoscaling_group_name" {
  type        = string
  description = "Bastion Auto scaling group Name"
  default     = "ASG-bastion-lt"
}

variable "bastion_launch_template_name" {
  type        = string
  description = "Bastion Launch template Name"
  default     = "bastion-lt"
}

variable "bastion_record_name" {
  type        = string
  description = "DNS record name to use for the bastion"
  default     = ""
}

variable "bastion_security_group_id" {
  type        = string
  description = "Custom security group to use"
  default     = ""
}

variable "bucket_force_destroy" {
  type        = bool
  default     = false
  description = "The bucket and all objects should be destroyed when using true"
}

variable "bucket_name" {
  type        = string
  description = "Bucket name where the bastion will store the logs"
}

variable "bucket_versioning" {
  type        = bool
  default     = true
  description = "Enable bucket versioning or not"
}

variable "bucket_key_enabled" {
  type        = bool
  default     = false
  description = "Whether or not to use Amazon S3 Bucket Keys for SSE-KMS"
}

variable "bucket_logging" {
  type = object({
    target_bucket = optional(string, "")
    target_prefix = optional(string, "")
    target_object_key_format = optional(object({
      partitioned_prefix = optional(object({
        partition_date_source = string
      }))
      simple_prefix = optional(bool, false)
    }))
  })
  default     = {}
  description = "Map containing access bucket logging configuration"
}

variable "cidrs" {
  type        = list(string)
  description = "List of CIDRs that can access the bastion. Default: 0.0.0.0/0"

  default = [
    "0.0.0.0/0",
  ]
}

variable "create_dns_record" {
  type        = bool
  description = "Choose if you want to create a record name for the bastion (LB). If true, 'hosted_zone_id' and 'bastion_record_name' are mandatory"
}

variable "create_elb" {
  type        = bool
  description = "Choose if you want to deploy an ELB for accessing bastion hosts. If true, you must set elb_subnets and is_lb_private"
  default     = true
}

variable "disk_encrypt" {
  type        = bool
  description = "Instance EBS encryption"
  default     = true
}

variable "disk_size" {
  type        = number
  description = "Root EBS size in GB"
  default     = 8
}

variable "elb_subnets" {
  type        = list(string)
  description = "List of subnets where the ELB will be deployed"
  default     = []
}

variable "enable_http_protocol_ipv6" {
  type        = bool
  description = "Enables or disables the IPv6 endpoint for the instance metadata service"
  default     = false
}

variable "enable_instance_metadata_tags" {
  type        = bool
  description = "Enables or disables access to instance tags from the instance metadata service"
  default     = false
}

variable "enable_logs_s3_sync" {
  type        = bool
  description = "Enable cron job to copy logs to S3"
  default     = true
}

variable "extra_user_data_content" {
  type        = string
  description = "Additional scripting to pass to the bastion host. For example, this can include installing PostgreSQL for the `psql` command."
  default     = ""
}

variable "hosted_zone_id" {
  type        = string
  description = "Name of the hosted zone where we'll register the bastion DNS name"
  default     = ""
}

variable "http_endpoint" {
  type        = bool
  description = "Whether the metadata service is available"
  default     = true
}

variable "http_put_response_hop_limit" {
  type        = number
  description = "The desired HTTP PUT response hop limit for instance metadata requests"
  default     = 1
}

variable "instance_type" {
  type        = string
  description = "Instance size of the bastion"
  default     = "t3.nano"
}

variable "ipv6_cidrs" {
  type        = list(string)
  description = "List of IPv6 CIDRs that can access the bastion. Default: ::/0"

  default = [
    "::/0",
  ]
}

variable "is_lb_private" {
  type        = bool
  nullable    = true
  default     = null
  description = "If TRUE, the load balancer scheme will be \"internal\" else \"internet-facing\""
}

variable "kms_enable_key_rotation" {
  type        = bool
  description = "Enable key rotation for the KMS key"
  default     = false
}

variable "log_auto_clean" {
  type        = bool
  description = "Enable or disable the lifecycle"
  default     = false
}

variable "log_expiry_days" {
  type        = number
  description = "Number of days before logs expiration"
  default     = 90
}

variable "log_glacier_days" {
  type        = number
  description = "Number of days before moving logs to Glacier"
  default     = 60
}

variable "log_standard_ia_days" {
  type        = number
  description = "Number of days before moving logs to IA Storage"
  default     = 30
}

variable "private_ssh_port" {
  type        = number
  description = "Set the SSH port to use between the bastion and private instance"
  default     = 22
}

variable "public_ssh_port" {
  type        = number
  description = "Set the SSH port to use from desktop to the bastion"
  default     = 22
}

variable "region" {
  type = string
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign"
}

variable "use_imds_v2" {
  type        = bool
  description = "Use (IMDSv2) Instance Metadata Service V2"
  default     = false
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where we'll deploy the bastion"
}

variable "lb_with_security_group" {
  type        = bool
  description = "Choose if the LB should have a security group attached. Defaults to false to preserve backwards compatibility. Switching from false to true will recreate the LB."
  default     = false
}

variable "bastion_egress_rules_cidr" {
  description = "CIDR egress rules for the bastion instances"
  type = map(object({
    cidr_ipv4   = string
    from_port   = number
    ip_protocol = string
    to_port     = number
  }))
  default = {
    "Outgoing traffic from bastion to instances" = {
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 0
      ip_protocol = "-1"
      to_port     = 65535
    }
  }
}

variable "bastion_egress_rules_sg" {
  description = "Security Group egress rules for the bastion instances"
  type = map(object({
    referenced_security_group_id = string
    from_port                    = number
    ip_protocol                  = string
    to_port                      = number
  }))
  default = {}
}

variable "bastion_egress_rules_prefix_list" {
  description = "Prefix list egress rules for the bastion instances"
  type = map(object({
    prefix_list_id = string
    from_port      = number
    ip_protocol    = string
    to_port        = number
  }))
  default = {}
}

variable "use_target_group_name_prefix" {
  description = "Configure target group 'name_prefix' instead of 'name'. This resolves issues where, if the `public_ssh_port` changes, another target group cannot be created with the same name."
  type        = bool
  default     = false
}

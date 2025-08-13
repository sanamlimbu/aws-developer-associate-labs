variable "name" {
  description = "Name of DynamoDB table."
  type        = string
}

variable "billing_mode" {
  description = "Billing mode for DynamoDB. Valid values: PROVISIONED or PAY_PER_REQUEST."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "Name of the partition (hash) key."
  type        = string
}

variable "range_key" {
  description = "Name of the sort (range) key. Leave null if not needed."
  type        = string
  default     = null
}

variable "read_capacity" {
  description = "Read capacity units (only used when billing_mode is PROVISIONED)."
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Write capacity units (only used when billing_mode is PROVISIONED)."
  type        = number
  default     = 5
}

variable "attributes" {
  description = <<EOT
    List of attribute definitions for the DynamoDB table schema.

    Only include attributes that are used as keys:
      - Table hash key
      - Table range key
      - Keys for any GSIs or LSIs

    Each attribute must have:
      - name (string)
      - type: S for string, N for number, or B for binary
  EOT

  type = list(object({
    name = string
    type = string
  }))
}

variable "ttl_enabled" {
  description = "Whether to enable DynamoDB Time to Live (TTL) on the table."
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "Name of the DynamoDB attribute that stores the TTL timestamp."
  type        = string
  default     = "expires_at"
}

variable "stream_enabled" {
  description = "Whether DynamoDB Streams are enabled for the table."
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Stream view type. Valid values: KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES."
  type        = string
  default     = "NEW_AND_OLD_IMAGES"
}
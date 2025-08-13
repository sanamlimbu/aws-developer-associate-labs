variable "batch_size" {
  description = "Maximum number of records to send to the Lambda function per batch."
  type        = number
  default     = 2
}

variable "batch_window" {
  description = "Maximum amount of time, in seconds, to gather records before invoking the function."
  type        = number
  default     = 10
}
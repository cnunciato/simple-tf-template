variable "bucket_name" {
  description = "The name of the bucket."
  type        = string
}

variable "tags" {
  description = "The tags to apply to the bucket."
  type        = map(string)
  default     = {}
}

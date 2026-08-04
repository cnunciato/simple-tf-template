variable "bucket_prefix" {
  description = "Prefix for the bucket name. A random suffix is appended to keep the name globally unique."
  type        = string
}

variable "tags" {
  description = "The tags to apply to the bucket."
  type        = map(string)
  default     = {}
}

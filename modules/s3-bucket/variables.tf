variable "bucket_name" {
  description = "Base name for the bucket. A random suffix is appended to keep the name globally unique."
  type        = string
}

variable "tags" {
  description = "The tags to apply to the bucket."
  type        = map(string)
  default     = {}
}

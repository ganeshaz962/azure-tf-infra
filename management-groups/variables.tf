variable "subscription_id" {
  type    = string
  default = "67874868-54bc-43f4-916a-5e23c3631ee3"
}
variable "tenant_id" {
  type    = string
  default = "5581c9a8-168b-45f0-abd4-d375da99bf9f"
}


locals {
  enrollmentAccount_main    = "302489"
  enrollmentAccount_sandbox = "300853"
  enrollmentAccount_test    = "302490"
}

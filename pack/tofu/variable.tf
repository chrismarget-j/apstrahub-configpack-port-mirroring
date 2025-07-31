#  Copyright (c) Juniper Networks, Inc., 2025-2025.
#  All rights reserved.
#  SPDX-License-Identifier: MIT

variable "blueprint_id" {
  type = string
}

variable "switch_hostname" {
  type        = string
  description = "Hostname of switch where port mirroring will be configured."
}

variable "input_ingress_port" {
  type        = string
  description = "Optional: Name of port where monitored traffic ingresses the switch, e.g. xe-0/0/0."
  default     = null
}

variable "input_egress_port" {
  type        = string
  description = "Optional: Name of port where monitored traffic egresses the switch, e.g. xe-0/0/1."
  default     = null
}

variable "output_destination" {
  type = string
  description = "IP address or interface name where mirrored traffic should be sent."
}
#  Copyright (c) Juniper Networks, Inc., 2025-2025.
#  All rights reserved.
#  SPDX-License-Identifier: MIT

locals {
  configlet_name = format("in-%s_out-%s->%s",
    var.input_ingress_port == null ? "any" : var.input_ingress_port,
    var.input_egress_port == null ? "any" : var.input_egress_port,
    var.output_destination,
  )
  analyzer_allowed_chars = split("", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_")
  analyzer_name          = join("", [for c in split("", local.configlet_name) : contains(local.analyzer_allowed_chars, c) ? c : "-"])
  output_type            = length(regexall("^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$", var.output_destination)) == 0 ? "interface" : "ip-address"
  ingress_set_cmd        = var.input_ingress_port == null ? "" : format("set forwarding-options analyzer %s input ingress interface %s\n", local.analyzer_name, var.input_ingress_port)
  egress_set_cmd         = var.input_egress_port == null ? "" : format("set forwarding-options analyzer %s input egress interface %s\n", local.analyzer_name, var.input_egress_port)
  output_set_cmd         = format("set forwarding-options analyzer %s output %s %s\n", local.analyzer_name, local.output_type, var.output_destination)
}

resource "apstra_datacenter_configlet" "example" {
  blueprint_id = var.blueprint_id
  name         = local.configlet_name
  condition    = format("hostname in [\"%s\"]", var.switch_hostname)
  generators = [
    {
      config_style = "junos"
      section      = "top_level_set_delete"
      template_text = join("", [
        local.ingress_set_cmd,
        local.egress_set_cmd,
        local.output_set_cmd,
      ])
    },
  ]
}

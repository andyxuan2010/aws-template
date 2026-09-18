locals {
  architecture  = lower(trimspace(var.architecture))
  license_type  = lower(trimspace(var.license_type))
  node_suffixes = local.architecture == "active-passive" ? ["a", "b"] : ["a"]

  generated_name = "fgt-${var.workload}-${var.region_code}-${var.environment}-${var.instance}"
  name           = trimspace(var.name) != "" ? trimspace(var.name) : local.generated_name

  ami_id = var.ami_id != null ? var.ami_id : data.aws_ami.selected[0].id

  enabled_interfaces = {
    for key, interface in var.interfaces : key => interface
    if contains(interface.enabled_architectures, local.architecture)
  }

  primary_interfaces = {
    for key, interface in local.enabled_interfaces : key => interface
    if interface.primary
  }

  primary_interface_name = try(keys(local.primary_interfaces)[0], null)
  primary_interface      = try(local.primary_interfaces[local.primary_interface_name], null)

  interface_order = sort([
    for key, interface in local.enabled_interfaces : key
  ])

  node_interfaces = {
    for pair in setproduct(local.node_suffixes, local.interface_order) :
    "${pair[0]}-${pair[1]}" => {
      node_suffix     = pair[0]
      interface_name  = pair[1]
      interface       = local.enabled_interfaces[pair[1]]
      subnet_id       = try(local.enabled_interfaces[pair[1]].subnet_ids[pair[0]], local.enabled_interfaces[pair[1]].subnet_id)
      private_ip      = try(local.enabled_interfaces[pair[1]].private_ips[pair[0]], local.enabled_interfaces[pair[1]].private_ip, null)
      security_groups = length(local.enabled_interfaces[pair[1]].security_group_ids) > 0 ? local.enabled_interfaces[pair[1]].security_group_ids : var.security_group_ids
    }
  }

  primary_node_interfaces = {
    for key, value in local.node_interfaces : key => value
    if value.interface.primary
  }

  additional_node_interfaces = {
    for key, value in local.node_interfaces : key => value
    if !value.interface.primary
  }

  user_data_config = {
    for suffix in local.node_suffixes : suffix => trimspace(join("\n", compact([
      var.bootstrap.include_hostname ? join("\n", [
        "config system global",
        "    set hostname ${local.name}-${suffix}",
        "end"
      ]) : "",
      local.architecture == "active-passive" ? join("\n", [
        "config system ha",
        "    set group-id ${var.ha.group_id}",
        "    set group-name \"${var.ha.group_name}\"",
        "    set mode a-p",
        "    set hbdev \"port${try(local.enabled_interfaces[var.ha.heartbeat_interface].device_index + 1, 0)}\" ${var.ha.heartbeat_priority}",
        "    set session-pickup ${var.ha.session_pickup ? "enable" : "disable"}",
        "    set override disable",
        "    set priority ${suffix == "a" ? var.ha.primary_priority : var.ha.secondary_priority}",
        "    set unicast-hb ${var.ha.unicast_hb ? "enable" : "disable"}",
        "    set unicast-hb-peerip ${try(var.interfaces[var.ha.heartbeat_interface].private_ips[suffix == "a" ? "b" : "a"], "")}",
        "end"
      ]) : "",
      trimspace(var.bootstrap.config)
    ])))
  }

  user_data = {
    for suffix in local.node_suffixes : suffix => trimspace(join("\n", compact([
      "Content-Type: multipart/mixed; boundary=\"==FORTIGATE==\"",
      "MIME-Version: 1.0",
      "",
      "--==FORTIGATE==",
      "Content-Type: text/x-shellscript; charset=\"us-ascii\"",
      "",
      local.user_data_config[suffix],
      trimspace(var.bootstrap.license_file) != "" ? join("\n", [
        "--==FORTIGATE==",
        "Content-Type: text/plain; charset=\"us-ascii\"",
        "Content-Transfer-Encoding: 7bit",
        "Content-Disposition: attachment; filename=\"license\"",
        "",
        trimspace(var.bootstrap.license_file)
      ]) : "",
      "--==FORTIGATE==--"
    ])))
    if local.user_data_config[suffix] != "" || trimspace(var.bootstrap.license_file) != ""
  }

  tags = merge(
    var.inherited_tags,
    var.tags,
    {
      FortiGateArchitecture = local.architecture
      FortiGateLicenseType  = upper(local.license_type)
      FortiGateAmiId        = local.ami_id
    }
  )
}

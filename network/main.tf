resource "libvirt_network" "default" {
  name      = var.name
  mode      = var.mode
  domain    = var.domain
  addresses = var.addresses
  autostart = var.autostart
  bridge    = var.bridge
  mtu       = var.mtu

  dynamic "dns" {
    for_each = var.dns != null ? [var.dns] : []
    content {
      enabled    = dns.value.enabled
      local_only = dns.value.local_only

      dynamic "forwarders" {
        for_each = lookup(dns.value, "forwarders", [])
        content {
          address = forwarders.value.address
          domain  = lookup(forwarders.value, "domain", null)
        }
      }

      dynamic "hosts" {
        for_each = lookup(dns.value, "hosts", [])
        content {
          hostname = hosts.value.hostname
          ip       = hosts.value.ip
        }
      }

      dynamic "srvs" {
        for_each = lookup(dns.value, "srvs", [])
        content {
          service  = srvs.value.service
          protocol = srvs.value.protocol
        }
      }
    }
  }

  dynamic "dhcp" {
    for_each = var.dhcp != null ? [var.dhcp] : []
    content {
      enabled = dhcp.value.enabled
    }
  }

  dynamic "routes" {
    for_each = var.routes
    content {
      cidr    = routes.value.cidr
      gateway = routes.value.gateway
    }
  }

  dynamic "dnsmasq_options" {
    for_each = var.dnsmasq_options != null ? [var.dnsmasq_options] : []
    content {
      dynamic "options" {
        for_each = dnsmasq_options.value.options
        content {
          option_name  = options.value.option_name
          option_value = lookup(options.value, "option_value", null)
        }
      }
    }
  }
}
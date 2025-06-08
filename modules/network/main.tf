resource "libvirt_network" "this" {
  name       = var.name
  mode       = var.mode
  domain     = var.domain
  addresses  = var.addresses
  autostart  = var.autostart
  bridge     = var.bridge
  mtu        = var.mtu

  dynamic "dhcp" {
    for_each = var.dhcp != null ? [var.dhcp] : []
    content {
      enabled = dhcp.value.enabled
    }
  }

  dynamic "dns" {
    for_each = var.dns != null ? [var.dns] : []
    content {
      enabled    = dns.value.enabled
      local_only = dns.value.local_only

      dynamic "forwarders" {
        for_each = dns.value.forwarders != null ? dns.value.forwarders : []
        content {
          address = forwarders.value.address
          domain  = forwarders.value.domain
        }
      }

      dynamic "hosts" {
        for_each = dns.value.hosts != null ? dns.value.hosts : []
        content {
          hostname = hosts.value.hostname
          ip       = hosts.value.ip
        }
      }

      dynamic "srvs" {
        for_each = dns.value.srvs != null ? dns.value.srvs : []
        content {
          domain   = srvs.value.domain
          port     = srvs.value.port
          priority = srvs.value.priority
          protocol = srvs.value.protocol
          service  = srvs.value.service
          target   = srvs.value.target
          weight   = srvs.value.weight
        }
      }
    }
  }

  dynamic "dnsmasq_options" {
    for_each = var.dnsmasq_options != null ? [var.dnsmasq_options] : []
    content {
      dynamic "options" {
        for_each = dnsmasq_options.value.options != null ? dnsmasq_options.value.options : []
        content {
          option_name  = options.value.option_name
          option_value = options.value.option_value
        }
      }
    }
  }

  dynamic "routes" {
    for_each = var.routes != null ? var.routes : []
    content {
      cidr    = routes.value.cidr
      gateway = routes.value.gateway
    }
  }

  dynamic "xml" {
    for_each = var.xml != null ? [var.xml] : []
    content {
      xslt = xml.value.xslt
    }
  }
}

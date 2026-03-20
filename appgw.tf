#--------------------------------------------------------------
# Public IP – Standard SKU required for App Gateway v2
#--------------------------------------------------------------
resource "azurerm_public_ip" "appgw_pip" {
  name                = "pip-appgw-demo"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

#--------------------------------------------------------------
# Application Gateway – Standard_v2
#
# Architecture (all HTTP, port 80, no custom domain):
#
#   Internet → Public IP → 1 HTTP Listener (port 80)
#                        → URL Path Map
#                            /app1/*  → pool-app1 → settings-app1 → VM :80/app1/
#                            /app2/*  → pool-app2 → settings-app2 → VM :80/app2/
#                            /app3/*  → pool-app3 → settings-app3 → VM :80/app3/
#                            /app4/*  → pool-app4 → settings-app4 → VM :80/app4/
#                            /app5/*  → pool-app5 → settings-app5 → VM :80/app5/
#                            (default)→ pool-app1
#
#   Health Probe: ONE shared probe (probe-shared) used by all
#                 backend HTTP settings. All apps live on the
#                 same VM, so a single root-level probe is sufficient.
#
# Note: Azure Application Gateway cannot have multiple HTTP listeners
# on the same port (80) without different hostnames. URL path-based
# routing achieves the same traffic separation with a single listener.
#--------------------------------------------------------------
resource "azurerm_application_gateway" "appgw" {
  name                = "appgw-demo"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  # Explicitly select a modern predefined TLS policy (min TLS 1.2).
  # Azure rejects Application Gateways that fall back to the deprecated
  # AppGwSslPolicy20150501 default which allows TLS 1.0/1.1.
  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101"
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }

  frontend_port {
    name = "port-http"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend-ip-public"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  #------------------------------------------------------------
  # Health Probe – single shared probe for all 5 applications
  # All apps run on the same VM, so one probe polling GET /
  # is sufficient to confirm the backend is reachable.
  # All backend_http_settings blocks reference this probe by name.
  #------------------------------------------------------------
  probe {
    name                = "probe-shared"
    protocol            = "Http"
    host                = azurerm_network_interface.vm_nic.private_ip_address
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3

    match {
      status_code = ["200-399"]
    }
  }


  probe {
    name                = "probe-new"
    protocol            = "Http"
    host                = azurerm_network_interface.vm_nic.private_ip_address
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3

    match {
      status_code = ["200-399"]
    }
  }

  #------------------------------------------------------------
  # Backend Address Pools – one per application
  # All pools point to the same VM. Kept separate so that
  # future migrations (e.g. splitting apps across VMs) only
  # require changing the pool, not the routing rules.
  #------------------------------------------------------------
  backend_address_pool {
    name         = "pool-app1"
    ip_addresses = [azurerm_network_interface.vm_nic.private_ip_address]
  }

  backend_address_pool {
    name         = "pool-app2"
    ip_addresses = [azurerm_network_interface.vm_nic.private_ip_address]
  }

  backend_address_pool {
    name         = "pool-app3"
    ip_addresses = [azurerm_network_interface.vm_nic.private_ip_address]
  }

  backend_address_pool {
    name         = "pool-app4"
    ip_addresses = [azurerm_network_interface.vm_nic.private_ip_address]
  }

  backend_address_pool {
    name         = "pool-app5"
    ip_addresses = [azurerm_network_interface.vm_nic.private_ip_address]
  }

  #------------------------------------------------------------
  # Backend HTTP Settings – one per application
  # All reference the single shared probe (probe-shared).
  #------------------------------------------------------------
  backend_http_settings {
    name                  = "settings-app1"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "probe-new"
  }

  backend_http_settings {
    name                  = "settings-app2"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "probe-shared"
  }

  backend_http_settings {
    name                  = "settings-app3"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "probe-shared"
  }

  backend_http_settings {
    name                  = "settings-app4"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "probe-shared"
  }

  backend_http_settings {
    name                  = "settings-app5"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "probe-shared"
  }

  #------------------------------------------------------------
  # HTTP Listener – single listener on port 80
  # URL path map handles all routing decisions.
  #------------------------------------------------------------
  http_listener {
    name                           = "listener-http"
    frontend_ip_configuration_name = "frontend-ip-public"
    frontend_port_name             = "port-http"
    protocol                       = "Http"
  }

  #------------------------------------------------------------
  # URL Path Map – routes each path prefix to its backend
  # Default (unmatched / root paths) → app1
  #------------------------------------------------------------
  url_path_map {
    name                               = "url-path-map"
    default_backend_address_pool_name  = "pool-app1"
    default_backend_http_settings_name = "settings-app1"
    default_rewrite_rule_set_name      = "rewrite-security-headers"

    path_rule {
      name                       = "rule-app1"
      paths                      = ["/app1/*"]
      backend_address_pool_name  = "pool-app1"
      backend_http_settings_name = "settings-app1"
      rewrite_rule_set_name      = "rewrite-security-headers"
    }

    path_rule {
      name                       = "rule-app2"
      paths                      = ["/app2/*"]
      backend_address_pool_name  = "pool-app2"
      backend_http_settings_name = "settings-app2"
      rewrite_rule_set_name      = "rewrite-security-headers"
    }

    path_rule {
      name                       = "rule-app3"
      paths                      = ["/app3/*"]
      backend_address_pool_name  = "pool-app3"
      backend_http_settings_name = "settings-app3"
      rewrite_rule_set_name      = "rewrite-security-headers"
    }

    path_rule {
      name                       = "rule-app4"
      paths                      = ["/app4/*"]
      backend_address_pool_name  = "pool-app4"
      backend_http_settings_name = "settings-app4"
      rewrite_rule_set_name      = "rewrite-security-headers"
    }

    path_rule {
      name                       = "rule-app5"
      paths                      = ["/app5/*"]
      backend_address_pool_name  = "pool-app5"
      backend_http_settings_name = "settings-app5"
      rewrite_rule_set_name      = "rewrite-security-headers"
    }
  }

  #------------------------------------------------------------
  # Rewrite Rule Set – applied to all paths
  # - Strips Server and X-Powered-By response headers (security)
  # - Adds X-Content-Type-Options, X-Frame-Options, X-XSS-Protection
  # - Forwards original client IP via X-Forwarded-For request header
  #------------------------------------------------------------
  rewrite_rule_set {
    name = "rewrite-security-headers"

    rewrite_rule {
      name          = "security-headers"
      rule_sequence = 100

      # Strip headers that reveal server internals
      response_header_configuration {
        header_name  = "Server"
        header_value = ""
      }

      response_header_configuration {
        header_name  = "X-Powered-By"
        header_value = ""
      }

      # Add security response headers
      response_header_configuration {
        header_name  = "X-Content-Type-Options"
        header_value = "nosniff"
      }

      response_header_configuration {
        header_name  = "X-Frame-Options"
        header_value = "DENY"
      }

      response_header_configuration {
        header_name  = "X-XSS-Protection"
        header_value = "1; mode=block"
      }

      # Forward the original client IP to the backend
      request_header_configuration {
        header_name  = "X-Forwarded-For"
        header_value = "{var_add_x_forwarded_for_proxy}"
      }
    }
  }

  #------------------------------------------------------------
  # Request Routing Rule – path-based routing
  # Priority is required for Standard_v2 / WAF_v2 SKUs.
  #------------------------------------------------------------
  request_routing_rule {
    name               = "routing-rule-path-based"
    rule_type          = "PathBasedRouting"
    http_listener_name = "listener-http"
    url_path_map_name  = "url-path-map"
    priority           = 100
  }
}

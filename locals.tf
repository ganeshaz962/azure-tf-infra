# Defines the 5 path-based applications hosted on the VM.
# Each entry drives an explicit backend pool, backend HTTP settings,
# and a path rule in the URL path map.
# A single shared health probe (probe-shared) is used for all apps.
locals {
  apps = {
    app1 = { path_prefix = "/app1/*" }
    app2 = { path_prefix = "/app2/*" }
    app3 = { path_prefix = "/app3/*" }
    app4 = { path_prefix = "/app4/*" }
    app5 = { path_prefix = "/app5/*" }
  }
}

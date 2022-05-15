datacenter = "dc1"
data_dir  = "/opt/nomad"
bind_addr = "{{ GetInterfaceIP \"vxlan100\" }}"
name = "dazzling-albattani"
log_level = "INFO"

client {
  enabled = true
}

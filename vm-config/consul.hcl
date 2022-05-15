bind_addr = "{{ GetInterfaceIP \"vxlan100\" }}"
datacenter = "dc1"
data_dir = "/opt/consul"
log_level = "INFO"
node_name = "dazzling-albattani"
server = false
retry_join = ["172.16.2.6"]
job "frontend" {
    datacenters = ["dc1"]
    group "web"{
        count = 2
        network {
           port "http" {
                #static = 8081
                to = 3000
            }
         }
        task "web"{
            driver = "docker"
            config {
                image = "ghcr.io/ryusan49/projet-cloud-frontend:1.0"
                ports = ["http"]
                auth {
                    username = "RyuSan49"
                    password = "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"
                }
            }
            service {
                name = "frontend"
                port = "http"
                address_mode = "driver"

            check {
                type = "http"
                path = "/"
                port = "http"
                interval = "10s"
                timeout = "5s"
            }
            }
        }
    }
    group "loadbalancer" {
        count = 1
        network {
        port "haproxy" {
            static = 8081
            to = 8080
        }
        }
        task "haproxy" {
            driver = "docker"
            config {
                image = "docker.io/library/haproxy:2.5"
                ports = ["haproxy"]
                mount {
                    type = "bind"
                    source = "local/config"
                    target = "/usr/local/etc/haproxy/"
                }
            }
            service {
                name = "haproxy"
                port = "haproxy"
                }

            template {
                data = <<EOH
global
  daemon
  maxconn 1024

defaults
  balance roundrobin
  timeout client 60s
  timeout connect 60s
  timeout server 60s

  frontend http
  bind :8081
  default_backend web
  mode http

  backend web
  balance roundrobin
  mode http
  {{- range $index, $element := service "frontend"}}
  server web{{$index}} {{$element.Address}}:{{$element.Port}}
  {{- end}}

EOH
            destination = "local/config/haproxy.cfg"
            change_mode = "signal"
            change_signal = "SIGHUP"
            }
        }
    }
}
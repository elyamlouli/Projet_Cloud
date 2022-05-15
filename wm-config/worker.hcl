job "worker" {
    datacenters = ["dc1"]
    group "app" {
        count = 3

        task "worker" {
            driver = "docker"
            config {
                image = "ghcr.io/ryusan49/projet-cloud-worker:1.0"
                auth {
                    username = "RyuSan49"
                    password = "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"
                }
            }

            service {
                name = "worker"
            }
        }
    }
}
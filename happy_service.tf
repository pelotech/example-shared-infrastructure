resource "rancher_stack" "happy" {
  name = "happy"
  description = "A service that's always happy"
  start_on_create = true
  environment_id = "${rancher_environment.production.id}"

  docker_compose = <<EOF
    version: '2'
    services:
      happy:
        image: peloton/happy-service
        stdin_open: true
        tty: true
        ports:
            - 8000:80/tcp
        labels:
            io.rancher.container.pull_image: always
            io.rancher.scheduler.global: 'true'
            started: $STARTED
EOF

  rancher_compose = <<EOF
    version: '2'
    services:
      happy:
        start_on_create: true
EOF

  finish_upgrade = true
  environment {
    STARTED = "${timestamp()}"
  }
}


resource "rancher_stack" "glad" {
  name = "glad"
  description = "A service that's always glad"
  start_on_create = true
  environment_id = "${rancher_environment.production.id}"

  docker_compose = <<EOF
    version: '2'
    services:
      glad:
        image: peloton/glad-service
        stdin_open: true
        tty: true
        ports:
            - 8001:80/tcp
        labels:
            io.rancher.container.pull_image: always
            io.rancher.scheduler.global: 'true'
            started: $STARTED
EOF

  rancher_compose = <<EOF
    version: '2'
    services:
      glad:
        start_on_create: true
EOF

  finish_upgrade = true
  environment {
    STARTED = "${timestamp()}"
  }
}
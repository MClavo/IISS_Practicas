terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

# Imagen de Wordpress
resource "docker_image" "wordpress" {
  name         = "wordpress:latest"
  keep_locally = false
}

# Imagen de Mariadb
resource "docker_image" "mariadb" {
  name         = "mariadb:latest"
  keep_locally = false
}

# Crea la red de Docker
resource "docker_network" "wordpress_network" {
  name = "wordpress_network"
}

# Crea el volumen de Wordpress
resource "docker_volume" "wordpress_volume" {
  name = "wordpress_volume"
}

# Crea el contenedor de Mariadb
resource "docker_container" "mariadb_container" {
  name  = "mariadb"
  image = docker_image.mariadb.image_id

  networks_advanced {
    name = docker_network.wordpress_network.name
  }

  volumes {
    container_path  = "/var/lib/mysql"
    volume_name       = docker_volume.wordpress_volume.name
}

  env = [
    "MYSQL_DATABASE=${var.Mdb_name}",
    "MYSQL_ROOT_PASSWORD=${var.Mdb_root_password}",
    "MYSQL_USER=${var.Mdb_user}",
    "MYSQL_PASSWORD=${var.Mdb_password}",
  ]
}

# Crea el contenedor de Wordpress
resource "docker_container" "wordpress_container" {
  name  = "wordpress"
  image = docker_image.wordpress.image_id

  networks_advanced {
    name = docker_network.wordpress_network.name
  }

  ports {
    internal = 80
    external = 8080
  }

  env = [
    "WORDPRESS_DB_HOST=${docker_container.mariadb_container.name}",
    "WORDPRESS_DB_NAME=${var.Mdb_name}",
    "WORDPRESS_DB_USER=${var.Mdb_user}",
    "WORDPRESS_DB_PASSWORD=${var.Mdb_password}"
  ]
}

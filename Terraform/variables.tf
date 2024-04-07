variable "Mdb_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "Wordpress"
}

variable "Mdb_root_password" {
  description = "Contraseña root de la base de datos MariaDB"
  type        = string
  default     = "toor"
}

variable "Mdb_user" {
  description = "Usuario de la base de datos"
  type        = string
  default     = "user"
}

variable "Mdb_password" {
  description = "Contraseña del usuario de la base de datos"
  type        = string
  default     = "toor"
}

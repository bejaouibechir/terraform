variable "environment" {
  type    = string
  default = "dev"
}

variable "servers" {
  description = "Map des serveurs avec leurs configurations"
  type = map(object({
    port = number
    env  = string
  }))
  default = {
    web = { port = 80,   env = "prod" }
    api = { port = 8080, env = "dev"  }
    db  = { port = 5432, env = "prod" }
  }
}

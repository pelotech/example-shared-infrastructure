provider "rancher" {
  api_url = "${var.rancher_url}"
}

resource "rancher_environment" "production" {  
  name = "production"  
  description = "Production environment"  
  orchestration = "cattle" 
}

resource "rancher_registration_token" "production_token" {  
  environment_id = "${rancher_environment.production.id}"  
  name = "production-token"  
  description = "Host registration token for Production environment"
}

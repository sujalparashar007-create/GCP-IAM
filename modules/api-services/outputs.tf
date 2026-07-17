output "enabled_services" {
  description = "Map of service key to the enabled google_project_service resources."
  value       = google_project_service.this
}

output "service_names" {
  description = "List of enabled API service names."
  value       = [for s in google_project_service.this : s.service]
}

output "mongodbatlas_connection_string" {
  description = "Connection string for MongoDB Atlas database to be used in Confluent Cloud connector"
  value       = mongodbatlas_cluster.dimt-2024.connection_strings[0].standard_srv
}

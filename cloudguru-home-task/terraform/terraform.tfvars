cluster_name = "my-cluster"

allowed_ip = "18.117.128.166/32"

secrets = {
  DB_PASSWORD = "s3cr3t123"
  API_KEY     = "xyz-abc-123"
}

public_subnet_cidrs = [
  "10.0.3.0/24",
  "10.0.4.0/24"
]

azs = [
  "us-east-2a",
  "us-east-2b"
]

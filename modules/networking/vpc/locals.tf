locals {
  # Combine all subnet CIDRs for validation
  all_subnet_cidrs = concat(var.public_subnet_cidrs, var.private_subnet_cidrs)

  # Availability zone selection logic (moved from main.tf)
  selected_azs = length(var.availability_zones) > 0 ? var.availability_zones : data.aws_availability_zones.available.names

  # Ensure we have enough AZs for subnet distribution
  max_subnets = max(length(var.public_subnet_cidrs), length(var.private_subnet_cidrs))
}

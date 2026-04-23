terraform-aws-production/
├── .github/
│   └── workflows/
│       ├── terraform-validate-security-cost.yml
│       ├── terraform-plan-apply.yml
│       ├── terraform-drift-detection.yml
│       └── terraform-destroy.yml
├── bootstrap/
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── terraform.tfvars
│   ├── variables.tf
│   └── versions.tf
├── live/
│   └── prod/
│       ├── backend.hcl
│       ├── main.tf
│       ├── outputs.tf
│       ├── providers.tf
│       ├── terraform.tfvars
│       ├── variables.tf
│       └── versions.tf
├── modules/
│   ├── network/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── security-group/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── compute/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── .gitignore
├── LICENSE
├── README.md
└── CHANGELOG.md
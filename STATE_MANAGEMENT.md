# Remote State & State Locking

## Why remote state

By default Terraform writes its state file (`terraform.tfstate`) to local disk. That state is the source of truth mapping your configuration to real cloud resources, and it often contains sensitive values. A local file does not work for a team: each member has a different copy, there is no shared history, and a lost or out-of-date laptop file can lead Terraform to recreate or destroy resources it thinks are missing. Moving state to a **remote backend** — here, an S3 bucket — gives everyone a single, central, versioned, encrypted copy. Whoever runs `terraform plan`/`apply` reads and writes the same authoritative state, so plans reflect the true current infrastructure and deployments stay consistent across the whole team.

## Why state locking

Even with shared remote state, two people running `terraform apply` at the same time could read the same starting state and write conflicting updates, corrupting the file or producing duplicate/half-created resources. **State locking** prevents this: before any state-mutating operation, Terraform writes a lock record to the **DynamoDB** table (keyed by `LockID`). If another run already holds the lock, the second run is refused until the first finishes and releases it. This serializes changes so only one apply touches the infrastructure at a time. Together, remote state (one shared, durable, encrypted copy) and state locking (mutual exclusion on writes) eliminate the conflicts and race conditions that make collaborative Terraform unsafe, ensuring every deployment builds on a correct, up-to-date view of the world.

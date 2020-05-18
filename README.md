AWS Terraform ElastiCache Action
================================
Deploy an AWS ElastiCache cluster using Terraform.

Usage
-----
```yaml
  - name: My Project
    uses: aplaceformom/terraform-project-base-action@master
    with:
      project: examples
      owner: MyTeam
      email: myteam@mydomain.org
      remote_state_bucket: apfm-terraform-remotestate
      remote_lock_table: terraform-statelock
      shared_state_key: /shared-infra/remotestate.file
  - name: My ElastiCache Name
    uses: aplaceformom/terraform-elasticache-action@master
    with:
      engine: memcached
```

Inputs
------

### engine
Which engine to use for the ElastiCache cluster. (redis, memcached)
- required: true

### engine_version
Default engine version. (default: 5.0.0 for redis, 1.5.16 for memcached)
- required: false

### subnet_ids
Comma seperated list of subnet ids to attach the cluster to.  If not specified then the subnet_id_private from terrarom-project-base-action will be used.
- required: false
- default: `${{ steps.outputs.project.subnet_id_private }}`

### vpd_id
AWS VPC ID to attach the cluster to. If unspecified then the vpc_id found in
the terraform-project-base-action will be used instead.
- required: false
- default: `${{ steps.project.outputs.network_vpc_id}}`

### node_type
AWS EC2 instance type to select when instantiating cluster instances.
- required: false
- default: cache.t2.micro

### node_count
Number of nodes in the cluster. Note: must be 1 for redis and 1-20 for memcached
-required: false
-default: 1

### maintenance_window
Preferred AWS maintenance window.
- required: false
- default: sun:02:30-sun:03:30

### debug
Enable entrypoint debugging
- required: false
- default: false

Outputs
-------

### id
Replication group id

### endpoint
Replication group leader in the form of `dnsname:port`

### dnsname
DNS name of the replication group leader

### port
TCP/IP port of the replication group leader

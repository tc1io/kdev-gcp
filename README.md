# kdev-gcp

Terrform setup for GCP Kubernetes development cluster. The goal is
to make it easy create a complete useable setup for running a
Kubernetes-based application. The setup includes:

- Use of GCP API via service-account impersonation only.
- Remote Terraform state storage in GCS.
- Network/Subnet for GKE cluster.
- Optional NAT gateway.
- Public IPs for application and asset server.
- DNS Records in a managed zone for application and asset server.

The focus is on simplicity and not configurability - if you need
variations in this setup, the preferred way is usually to just
clone and modify.

It is possible to run as many instances in a single project as the VPC limits allow.

# What you need

The following needs to be setup before configuration/provisioning:

- A GCP project (linked to billing account).
- A GCS bucket for storing Terraform states.
- A provisioning service account with the following roles:
  - Project IAM Admin
  - Compute Network Admin
  - DNS Administrator
  - Kubernetes Engine Admin
  - Storage Object Admin on the GCS bucket (to store terraform state)
  - Editor (TODO needed because GKE provisioning failed => needs investigation what would work instead of editor)

Users that run the terrform need the `roles/iam.serviceAccountTokenCreator` role on the service account.

# Configure

There is configuration in the terraform files that cannot be configured via Terraform
itself (ie impersonation setup, remote state storage config). You need to run the configure
script before using Terraform.

Set these in your environment:

````shell
export PROJECT=<the target GCP project>
export NAME=<name of the setup>
export SERVICE_ACCOUNT=<provisioning service account>
export REGION=<GCP target region>
export BUCKET=<GCS bucket name for remote state storage>
````

then run

````shell
./configure.sh
````


# Provisioning

Run

````shell
terrafom init
terrafom plan
terrafom apply
````

# Useful commandlines

Authenticate

    gcloud auth login
    gcloud auth application-default login

Setup kubectl authentication plugin

    gcloud components install gke-gcloud-auth-plugin

Get kubeconfig

    gcloud container clusters get-credentials $NAME --region $REGION --project $PROJECT

Interactive pod

    kubectl run maint --rm -i --tty --image ubuntu -- bash

Docker Login

    gcloud auth print-access-token \
      --impersonate-service-account $SERVICE_ACCOUNT | docker login \
      -u oauth2accesstoken \
      --password-stdin https://eu.gcr.io/$PROJECT






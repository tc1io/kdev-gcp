# kdev-gcp

Terrform setup for GCP Kubernetes development cluster

# Configure

Set these in your environment:

    PROJECT=GCP-prohect
    NAME=the-name-for-this-installation
    SERVICE_ACCOUNT=GCP-service-account-for-provisioning
    REGION=GCP-region
    BUCKET=bucket-for-tfstate

then run

    ./configure.sh


# Provisioning

Run

   terrafom init
   terrafom plan
   terrafom apply




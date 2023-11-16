#!/bin/sh

m4 --version 2>&1 > /dev/null
if [ "$?" != "0" ]; then
	echo "Please install m4 before running $0"
	exit 1
fi


m4 \
	-D__BUCKET__=$BUCKET \
	-D__NAME__=$NAME \
	-D__SERVICE_ACCOUNT__=$SERVICE_ACCOUNT \
	-D__PROJECT__=$PROJECT \
	-D__REGION__=$REGION \
	versions.tf.in > versions.tf

m4 \
	-D__SERVICE_ACCOUNT__=$SERVICE_ACCOUNT \
	providers.tf.in > providers.tf

m4 \
	-D__PROJECT__=$PROJECT \
	-D__REGION__=$REGION \
	-D__NAME__=$NAME \
terraform.tfvars.in > terraform.tfvars




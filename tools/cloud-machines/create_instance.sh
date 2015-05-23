#! /bin/bash
image="8b082f2d-9728-4c3f-8440-cf110f03f745"
keypair="timslaptop"

openstack server create --key-name "$keypair" --flavor m1.large --image "$image" --user-data "configure-vm.sh" lhcbstarterkit2

#! /bin/bash
image="8b082f2d-9728-4c3f-8440-cf110f03f745"
keypair="timslaptop"

# Make sure to keep cycling these numbers
# each time we create a new instance and reuse a hostname
# people will get big fat warnings from ssh as the keys
# will have changed
for i in 3 4 5 6 7; do
    openstack server create --key-name "$keypair" --flavor m1.large --image "$image" --user-data "configure-vm.sh" lhcbstarterkit$i
done;

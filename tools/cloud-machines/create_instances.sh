#! /bin/bash
image="8b082f2d-9728-4c3f-8440-cf110f03f745"
keypair="timslaptop"

# Only argument is the list of hostname extensions
# to use when starting instances. Usually use a number
# like 2 3 4 5 6 to start five instances.
for i in $*; do
    openstack server create --key-name "$keypair" --flavor m1.large --image "$image" --user-data "configure-vm.sh" lhcbstarterkit$i
done;

Setting up VM on the CERN cloud
===============================

1. [Subscribe to the Cloud service](http://clouddocs.web.cern.ch/clouddocs/tutorial_using_a_browser/subscribe_to_the_cloud_service.html)
2. Upload your public ssh key to the Cloud service [access and security](https://openstack.cern.ch/dashboard/project/access_and_security/)
3. `source setup-lxplus.sh`
4. edit `create_instance.sh` to use your key pair, as well as hostname

Now start waiting and check the [status of your instances](https://openstack.cern.ch/dashboard/project/instances/).

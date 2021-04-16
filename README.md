# Home lab Packer Templates

This repo provides some templates to use with [packer](https://packer.io). This repo is used to automate the build of various templates in vSphere. To use this repo, first setup the `.env` file from `env.template` and then run a command like the following.


```bash
packer build --var-file templates/ubuntu/20.04/vars.pkr.hcl common/vsphere.pkr.hcl
```

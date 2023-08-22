# profile_puppet_agent

[![pdk-validate](https://github.com/ncsa/puppet-profile_puppet_agent/actions/workflows/pdk-validate.yml/badge.svg)](https://github.com/ncsa/puppet-profile_puppet_agent/actions/workflows/pdk-validate.yml)
[![yamllint](https://github.com/ncsa/puppet-profile_puppet_agent/actions/workflows/yamllint.yml/badge.svg)](https://github.com/ncsa/puppet-profile_puppet_agent/actions/workflows/yamllint.yml)

NCSA Common Puppet Profiles - configure puppet agent

## Table of Contents

1. [Description](#description)
1. [Setup](#setup)
1. [Usage](#usage)
1. [Dependencies](#dependencies)
1. [Reference](#reference)

## Description

This profile provides custom management of Puppet agent on a host.

## Setup

Include profile_puppet_agent in a Puppet role:
```
include profile_puppet_agent
```

## Usage

This profile should generally work "out-of-the-box", however in many cases it will
be desirable to provide custom input via the config parameter.

In that case, please understand that the config parameter does not merge data (due to
its complex hash data structure).

If you intend to customize data for the config parameter, it is recommended to look
at the default "config" data in this module and consider incorporating that into
your environment Hiera, and to do so at every "layer" where you define this.

E.g.:

common.yaml
```yaml
profile_puppet_agent::config:
  - "section": ""
    "setting": "lastrunfile"
    "value": "$publicdir/last_run_summary.yaml { owner = root, group = service, mode = 0644 }"
  - "section": "agent"
    "setting": "certname"
    "value": "%{facts.clientcert}"
  - "section": "agent"
    "setting": "splay"
    "value": "true"
```

role/slurm_compute.yaml
```yaml
profile_puppet_agent::config:
  - "section": ""
    "setting": "lastrunfile"
    "value": "$publicdir/last_run_summary.yaml { owner = root, group = service, mode = 0644 }"
  - "section": "agent"     
    "setting": "certname"
    "value": "%{facts.clientcert}"
  - "section": "agent"     
    "setting": "runinternal" 
    "value": "6h"          
  - "section": "agent"     
    "setting": "splay"     
    "value": "true"          
```

## Dependencies

- [puppetlabs-stdlib](https://forge.puppet.com/modules/puppetlabs/stdlib)

## Reference

[REFERENCE.md](REFERENCE.md)

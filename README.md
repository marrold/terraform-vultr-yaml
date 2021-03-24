
# terraform-vultr-yaml

terraform-vultr-yaml is a proof-of-concept terraform configuration to demonstrate using yaml files to provision [vultr](https://www.vultr.com/), a popular cloud computing platform.

The user can supply the module with a list of paths to the YAML files that terraform will then recurse and build the infrastructure. This allows you to build your own complex directory structure if required without any changes to the module, such as the example below:

    .
    └── config-files
        ├── prod
        │   ├── london
        │   │   ├── firewalls.yaml
        │   │   ├── instances.yaml
        │   │   └── networks.yaml
        │   └── new-jersey
        │       ├── firewalls.yaml
        │       ├── instances.yaml
        │       └── networks.yaml
        └── staging
            └── frankfurt
                ├── firewalls.yaml
                ├── instances.yaml
                └── networks.yaml
                
## Disclaimer

Due to the abstraction layer between the yaml files and terraform it can fail in weird and wonderful ways and the error may not be obvious. It's particularly prone to issues with duplicate data, such as two instances configured with the same name in two different yaml files.

It's questionable if this abstraction layer is a good idea at all, and you probably shouldn't use it in production. Whilst the module can support nested directories it's probably a good idea to keep things as simple as possible.

That said, the module includes some _interesting_ examples of (ab)using nested for loops etc for when there's no other option.

## Example

An Example is included in the `examples` directory in this repository.

It's assumed that you already have Terraform installed and configured.

### Configuration


- Copy `provider.tf_EXAMPLE` to `provider.tf`

- Edit the `api_key` to the Personal Access Token created in your Vultr account. You can enable API access and get the token from the [Vultr Control Panel](https://my.vultr.com/settings/#settingsapi)

  

### Usage

You can place directories of yaml files wherever you like, although my suggestion would be to place them in a subdirectory of your .tf files to keep the paths sane.

Each yaml file can contain keys that duplicate those in other files. E.G you could have `instances` defined in several files. They will be merged when applied.

If you're not using a particular resource type, such as ISOs, you don't need to define anything in the yaml files

Your .tf file should look something like this, with lists of paths to your directories of yaml files: 
  
    module "terraform-vultr-yaml" {
      source = "github.com/marrold/terraform-vultr-yaml?ref=v0.1"
    
      instance_yaml_dirs  = ["config-files/yaml-files", "config-files/other-yaml-files"]
      key_yaml_dirs       = ["config-files/yaml-files"]
      iso_yaml_dirs       = ["config-files/yaml-files"]
      firewall_yaml_dirs  = ["config-files/yaml-files"]
      network_yaml_dirs   =  ["config-files/yaml-files"]
    
      startup_script_dirs = ["config-files/startup-scripts", "config-files/other-scripts"]
    
    }

  
 Once you've configured the module and the yaml files you can run the usual:
```
terraform init
terraform apply
```

#### Networks

  

You can create custom private networks and attaching them to you instances. 
  

**note:** networks are region specific.

  
  

##### Example

```
networks:

  default_new-jersey:
    description: Default private network
    region: new-jersey
    cidr_block: 10.1.96.0/20

  default_london:
    description: Default private network
    region: london
    cidr_block: 10.8.96.0/20
```

##### Options

-  **key**: The object key isn't used for provisioning but should be unique. [Mandatory]

-  **description**: Description of the network. [Mandatory]

-  **region**: Where to create the network. [Mandatory]

-  **cidr_block**: The subnet to assign to the network. [Mandatory]

  

#### Firewalls

  
Creating firewall groups and rules is also supported. An instance can then be attached to a firewall group.
  

##### Example

```

firewalls:

  voice_fw:
    - notes: "Allow UDP SIP from WD18"
      protocol: udp
      network: 0.0.0.0/0
      port: 5060

    - notes: "Allow all RTP"
      protocol: udp
      network: 0.0.0.0/0
      port: 10000:20000

  allow_all:
    - notes: "Allow all TCP"
      protocol: tcp
      network: 0.0.0.0/0

    - notes: "Allow all UDP"
      protocol: udp
      network: 0.0.0.0/0

  whitelist_ssh:
    - notes: "Allow SSH from office"
      protocol: tcp
      network: 93.184.216.34/32
      port: 22

```

  

##### Options

  

-  **key**: Used to name the firewall group. Should be unique. [Mandatory]

-  **notes**: A description of the rule. Must be unique per group. [Mandatory]

-  **procotocol**: The protocol in use. Can be `udp` / `tcp` / `icmp`  [Mandatory]

-  **network**: The source of the request to whitelist. [Mandatory]

-  **from_port**: [Optional]

-  **to_port**: [Optional]

  

**N.B:** If neither `from_port` or `to_port` are included, all ports will be accepted. `to_port` is only required for a *range* of ports.

  

#### Scripts

It's possible to add a custom startup-scripts and then ensure they're ran on a new instance after it has been created.

#### ISOs

 You can create a custom ISO by downloading it from a public URL. It can then be assigned to an instance to boot from.

##### Example
```
isos:

  ubuntu-20.10-live-server-amd64:
    url: "https://releases.ubuntu.com/20.10/ubuntu-20.10-live-server-amd64.iso?_ga=2.50295846.1250141369.1610613496-2114013130.1610613496"
```

##### Options

  

-  **key**: Used to name the ISO. Should be unique. [Mandatory]

-  **url**: The URL to download the ISO from

  

#### Keys

 You can create SSH keys to then configure an instance to use them.

##### Example

```
keys:

  root_key:
    ssh_key: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDSbeLaDKiC+Quyevqa7DtKCkuFEtbZNsV/eOvpiJ1lTQfjL2ch+ntbtL7K4mA3xf8YNMl/DrlgVdmXltiC6RGeXzCWGWPfLn5f1pa4L4TAFN8P4hg+rfIaK6VkIm/ldKRSyrLbQQTGFscQPz+BmNG2jNzsQm2nJmyKQYukBgCuzKpKDo41SAWfBOJEdQ8+AH9rmGWcokcWdljcyEZJIBCm/ezyVvoxXyM5ldEd1b672sR6+CRaUoQdzNRquOZ7wyNE9+n1VFZRm5kyvbtTwK9WRNFiVdRW2DXchMeZZe6Cf0Xhyz2T6PfLWVX8voiAGvVw06J6kIAbKjySIhmzHZNTK5LbPQEG9Q+/UTwL+ipqv8tP263jfuxmxfccX2pazVAloh/CExnikQ95ZhPeSoJiOHj/Yec7BYyw1vZcLIifU1KXU1W0Yc0sET6L3q/uASXMnixc1lp9alDq97+HIzefMFMMcAIdzVTIQfCBf4LTEnaxjqM2HIKa4xU7qmH6XJbmdlTS9nUjUhIjgDTJn3tgaH7vbhNl8OUBF15WCcpzC1LiTloBTYHx7SxVlJsJPYIK5CmtvM3b5kmtv0TQpSrSUSHUYETbGDt0yVRCURv/hfYQv84vI21m/Wr2JINnW6DAjaWgvRvAt6xMPCq82kUIRyOOoWNbm7A7EAFTkL+Rnw== matthew@example.com"

  provisioning:
    ssh_key: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDSbeLaDKiC+Quyevqa7DtKCkuFEtbZNsV/eOvpiJ1lTQfjL2ch+ntbtL7K4mA3xf8YNMl/DrlgVdmXltiC6RGeXzCWGWPfLn5f1pa4L4TAFN8P4hg+rfIaK6VkIm/ldKRSyrLbQQTGFscQPz+BmNG2jNzsQm2nJmyKQYukBgCuzKpKDo41SAWfBOJEdQ8+AH9rmGWcokcWdljcyEZJIBCm/ezyVvoxXyM5ldEd1b672sR6+CRaUoQdzNRquOZ7wyNE9+n1VFZRm5kyvbtTwK9WRNFiVdRW2DXchMeZZe6Cf0Xhyz2T6PfLWVX8voiAGvVw06J6kIAbKjySIhmzHZNTK5LbPQEG9Q+/UTwL+ipqv8tP263jfuxmxfccX2pazVAloh/CExnikQ95ZhPeSoJiOHj/Yec7BYyw1vZcLIifU1KXU1W0Yc0sET6L3q/uASXMnixc1lp9alDq97+HIzefMFMMcAIdzVTIQfCBf4LTEnaxjqM2HIKa4xU7qmH6XJbmdlTS9nUjUhIjgDTJn3tgaH7vbhNl8OUBF15WCcpzC1LiTloBTYHx7SxVlJsJPYIK5CmtvM3b5kmtv0TQpSrSUSHUYETbGDt0yVRCURv/hfYQv84vI21m/Wr2JINnW6DAjaWgvRvAt6xMPCq82kUIRyOOoWNbm7A7EAFTkL+Rnw== matthew@example.com"
```

##### Options

  

-  **key**: Used to name the Key. Should be unique. [Mandatory]

-  **ssh_key**: The SSH Key

  

#### Instances

##### Example

```
instances:

  test-01:
    plan: vc2-1c-1gb
    region: london
    os: debian_10
    private_networks:
      - default_london
    script: debian/debian.sh
    firewall: allow_all

  test-02:
    plan: vc2-1c-1gb
    region: new-jersey
    os: debian_10
    firewall: allow_all
    script: default.sh
    keys:
      - provisioning

  test-03:
    iso: ubuntu-20.10-live-server-amd64
    keys:
      - provisioning

```

  

##### Options

  

-  **key**: Will be used as the hostname [Mandatory]

-  **plan**: What size instance to create. Defaults to `vc2-1c-1gb` ($5 Instance)
     Plan names are formatted as `vc2-vcpu-ram`, so an instance with one vcpu and 1GB of RAM would translate as `vc2-1c-1gb`.  You can check available plans in the `vultr_data.tf` file in the module.

-  **region**: Where to locate the instance. Defaults to London.
You can check available regions in the `vultr_data.tf` file in the module.

-  **os**: The instance's OS. Cannot be used in conjunction with iso

-  **iso**: The ISO for the instance to boot from. Cannot be used in conjunction with os.

-  **private_networks**: A list of private networks to attach. Default behaviour is to not attach a private network.

-  **script**: The name of a script to run on first boot.

-  **firewall**: The name of the firewall group to attach to the instance. Default is none.

-  **keys**: A list of ssh keys to associate with the instance.

## License

This project is licensed under the terms of the _MIT license_

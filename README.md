# terraform-vultr

terraform-vultr is a proof-of-concept terraform configuration to demonstrate using yaml files to provision [vultr](https://www.vultr.com/), a popular cloud computing platform.

## Disclaimer

Due to the abstraction layer between the yaml files and terraform, it can fail in weird and wonderful ways and the error may not be obvious. It's questionable if this abstraction layer is a good idea at all. You probably shouldn't use it in production.


## Configuration

It's assumed that you already have Terraform configured.

- Copy `provider.tf_EXAMPLE` to `provider.tf`
- Edit the `api_key` to the Personal Access Token created in your account

## Usage


### Networks

terraform-vultr supports creating custom private networks and attaching them to instances. Networks are defined in `networks.yaml`

**note:** networks are region specific.


#### Example
```
networks:
  default_new-jersey:
    description: Default private network
    region: new-jersey
    cidr_block: 10.1.96.0/20
 ```

 #### Options
 - **key**: The object key isn't used for provisioning but should be unique. [Mandatory]
 - **description**: Description of the network. [Mandatory]
 - **region**: Where to create the network. [Mandatory]
 - **cidr_block**: The subnet to assign to the network. [Mandatory]

### Firewalls

Creating firewall groups and rules is also supported. An instance can be attatched to a firewall group. Firewalls are defined in `firewalls.yaml`

#### Example
```
firewalls:

  voice_fw:
    - notes: "Allow UDP SIP from WD18"
      protocol: udp
      network: 0.0.0.0/0
      from_port: 5060

    - notes: "Allow all RTP"
      protocol: udp
      network: 0.0.0.0/0
      from_port: 10000
      to_port: 20000

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
      from_port: 22
```

#### Options

- **key**: Used to name the firewall group. Should be unique. [Mandatory]
- **notes**: A description of the rule. Must be unique per group. [Mandatory]
- **procotocol**: The protocol in use. Can be `udp` / `tcp` / `icmp` [Mandatory]
- **network**: The source of the request to whitelist. [Mandatory]
- **from_port**: [Optional]
- **to_port**: [Optional]

**N.B:** If neither `from_port` or `to_port` are included, all ports will be accepted. `to_port` is only required for a *range* of ports.

### Scripts

It's possible to add a custom startup-script in `./startup-scripts` and then ensure it's ran on a new instance after it has been created.

### ISOs

You can create a custom ISO by downloading it from a public URL. It can then be assigned to a server to boot from.

#### Options

- **key**: Used to name the ISO. Should be unique. [Mandatory]
- **url**: The URL to download the ISO from

### Keys

You can create SSH keys to then configure a server to use them.

#### Options

- **key**: Used to name the Key. Should be unique. [Mandatory]
- **ssh_key**: The SSH Key

### Servers

Servers are defined in `servers.yaml`

#### Example

```
servers:

  test-01:
    plan: nano
    region: london
    os: debian_10
    private_networks:
      - default_london
    script: Default-Debian
    firewall: allow_all

  test-02:
    plan: nano
    region: new-jersey
    os: debian_10
    firewall: allow_all

  test-03:
    region: london
    iso: freepbx
    keys:
      - provisioning
```

#### Options

- **key**: Will be used as the hostname [Mandatory]
- **plan**: What size instance to create. Defaults to "nano" ($5 Instance)
- **region**: Where to locate the instance. Defaults to London
- **os**: The instance's OS. Cannot be used in conjunction with iso
- **iso**: The ISO for the instance to boot from. Cannot be used in conjunction with os.
- **private_networks**: A list of private networks to attach. Default behaviour is to not attach a private network.
- **script**: The name of a script to run on first boot.
- **firewall**: The name of the firewall group to attach to the server. Default is none.
- ** ssh_key**: A list of ssh keys to associate with the server.

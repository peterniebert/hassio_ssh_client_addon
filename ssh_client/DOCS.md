# Home Assistant Addon: SSH Client for remote access

This addon will allow your home assistant instance to connect to remote hosts via SSH and do port forwarding for reverse tunneling. The use case for this is to allow your home assistant instance to be accessible from the internet without having to open ports on your router.

In order to achieve this, you will need to have a remote host that is accessible from the internet and has a public IP address, as well as a SSH server running on it.

## Theory of operation

The addon will try to connect to a distant SSH server and can be configured to open ports on the distant host and forward them to the local home assistant instance. This is called reverse tunneling.

For the authentication, the addon will use a private key that you will have to provide. The public key will be stored on the distant host account in the `/addons/ssh-client/authorized_keys` file.

On the other hand, a public key to authenticate the distant host will be stored in the `/addons/ssh-client/known_hosts` file on the home assistant instance.


## Key generation and configuration

For security reasons, the addon will not allow you to use a password to authenticate to the distant host. You will have to use a key pair.

You can generate a key pair with the following command from a shell on the home assistant (including studio code addon or ssh addon):

```
ssh-keygen -t ed25519 -f mykey
```

This will generate two files: `mykey` and `mykey.pub`. The first one is the private key, the second one is the public key. Copy mykey to `/addons/ssh-client`. You will have to copy the content of the public key file and paste it in the `~/.ssh/authorized_keys` file on the distant host.

You will also have to recover a public key from the distant host and paste it in the `/addons/ssh-client/known_hosts` file on the home assistant instance. To find this key, you can connect to the distant host and look for `/etc/ssh/ssh_host_ed25519_key.pub`. Copy the content of this file and paste it in the `known_hosts` file on the home assistant instance, but change it a little bit. The final content of the file should look like this (replace host.example.com with the hostname of the distant host and ssh-ed25519 with the type of key you are using):

```
host.example.com ssh-ed25519 <the actual key>
```

If you have no way to recover the public key from the distant host, you can try to connect to it from any machine with ssh. This will generate a warning, but will also add the public key to the `known_hosts` file which you can then copy to the home assistant instance.

Although we do not recommend it, you can also add an option to the ssh command line that disables the identity check of the remote host:  ```-o StrictHostKeyChecking=no```

## Limiting the access to the distant host

You can limit what the ssh key allows to do on the distant host by adding options to the ssh command line. For example, you can limit the access to a specific command by adding the following to the key line in the `authorized_keys` file on the distant host. The following example will print a message otherwise wait for the client to hang up.

```
command="/usr/bin/wc | /usr/bin/echo You are connected." ssh-ed25519 <the public key>
```

## ssh command line configuration

The options of the addon are passed to the ssh command line. The command line is built as follows:

## Creating a reverse tunnel to the ssl proxy

Supposing that you have a distant host with a public IP address and a SSH server running on it, you can create a reverse tunnel to the ssl proxy of the home assistant instance. This will allow you to access your home assistant instance from the internet without having to open ports on your router. For this, you need to know the server name of your nginx proxy. This is the name that you have configured in the `server_name` directive of the nginx configuration file. If you have not changed it, it should be `homeassistant.local`. You also need to know the port number of the ssl proxy. This is the port number that you have configured in the `listen` directive of the nginx configuration file. If you have not changed it, it should be `443`. The command line option to create the reverse tunnel is the following:  -R 443:homeassistant.local:443 -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes -o TCPKeepAlive=yes -o UserKnownHostsFile=/addons/ssh-client/known_hosts -o LogLevel=ERROR -N -T -p 22



# node-sshd
A Node image for developing and testing node code with an embedded SSH server to connect to using Visual Studio Code

The image is based on the latest official node bullseye image

## Default SSH user
The default user for SSH login is `dev`. The user does not have a password set, a public key is required.

## Public key
The public key is configured using a bind mount. The location within the container is: `/home/dev/.ssh/authorized_keys`

### Image purpose
This docker image is meant to be used for development purposes it is not meant to be used in production. For production it is better to use other images which have a smaller footprint and do not include development and SSH. 

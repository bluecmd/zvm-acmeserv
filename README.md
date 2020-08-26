# zvm-acmeserv
ACME / Let's Encrypt integration for z/VM

**Way too early to be usable**

## How?

The plan is to use IUCV to bind port 80 on the z/VM TCPIP service machine.
This together with a minimal zLinux kernel and a single userspace binary
should be enough to make z/VM be able to respond to HTTP-01 requests.

The userspace binary will be a Go binary using the ACME libraries it
provides.

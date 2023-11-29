# Google DNS Forever

This project aims to change your linux's default DNS resolver to Google public DNS.

# Why?

The original motivation for this project was to fix [Hetzner](https://www.hetzner.com/) issue with some services such as, WhatsApp.

# How Does It Work?

We use [ovs](https://github.com/openvswitch/ovs) and [netplan](https://netplan.io/). We update the .yml config file assossiated with netplan by adding Google public DNS resolvers - 8.8.8.8 and 8.8.4.4 - as the primary and secondary DNS resolvers of the whole system. Finally, we apply the new config file for netplan.

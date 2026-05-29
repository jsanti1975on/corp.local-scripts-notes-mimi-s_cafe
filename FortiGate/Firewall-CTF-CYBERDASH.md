# FortiGate 60E Migration and VLAN Segmentation Project

**Date:** 2026-05-29
**Platform:** FortiGate 60E + FortiSwitch
**Project Type:** Home Cyber Range Infrastructure Migration

---

# Overview

This project involved migrating portions of the cyber range from a traditional Cisco-centric switching model to a Fortinet Next Generation Firewall (NGFW) architecture using a FortiGate 60E and managed FortiSwitch.

The primary goals were:

* Segment Active Directory infrastructure from client networks
* Maintain Internet connectivity across all VLANs
* Restore Pi-hole DNS functionality
* Preserve Cyber Dashboard access for training systems
* Isolate the CTF environment from production services
* Gain operational experience with FortiGate policy-based networking

---

# Network Architecture

## VLAN10_AD

**Purpose:** Infrastructure and Directory Services

**Subnet:** `10.10.10.0/24`

### Hosted Services

* Active Directory Domain Services
* DNS Services
* Pi-hole DNS
* ESXi Hosts
* Cyber Dashboard Server
* Administrative Systems

---

## VLAN20_CLIENT

**Purpose:** User and Cafe Client Devices

This VLAN provides a separate network for workstation and client traffic while maintaining Internet access through the FortiGate.

---

## CTF-VLAN

**Purpose:** Cybersecurity Training and Capture-the-Flag Exercises

**Subnet:** `172.30.20.0/24`

This network is intentionally isolated from production infrastructure and is used for:

* TryHackMe exercises
* Active Directory attack simulations
* Red Team training
* Collegiate Cyber Defense Competition (CCDC) preparation
* Ethical hacking labs

---

# FortiSwitch Adoption

During deployment it was determined that the FortiSwitch required connection through a FortiLink-enabled interface on the FortiGate.

Once connected to the designated FortiLink ports, the FortiSwitch was automatically discovered and adopted by the FortiGate.

### Results

* Switch successfully detected
* FortiLink established
* Centralized management enabled
* VLAN assignments available through the FortiGate GUI

---

# DHCP Reservation Validation

Existing DHCP reservations were reviewed and preserved during migration.

### Key Infrastructure Reservations

| Host                        | Address      |
| --------------------------- | ------------ |
| Pi-hole                     | 10.10.10.30  |
| POS System                  | 10.10.10.45  |
| ESXi Client Host            | 10.10.10.50  |
| Domain Controller           | 10.10.10.200 |
| Read-Only Domain Controller | 10.10.10.220 |

---

# DNS Migration

The environment was reconfigured to use Pi-hole as the primary DNS resolver.

### Validation

```bash
nslookup google.com
```

Results confirmed:

* Pi-hole responding correctly
* External DNS resolution operational
* Internet name resolution restored

---

# Internet Connectivity Validation

Connectivity testing was performed from VLAN10.

### Tests

```powershell
ping 8.8.8.8
```

```powershell
nslookup google.com
```

### Results

* Internet access confirmed
* DNS resolution confirmed
* NAT functionality confirmed
* Routing operational

---

# CTF Network Isolation

A security objective of this migration was preventing direct access from the CTF environment into production Active Directory resources.

### Desired Outcome

| Resource                        | Access  |
| ------------------------------- | ------- |
| Internet                        | Allowed |
| Cyber Dashboard                 | Allowed |
| Active Directory Infrastructure | Denied  |
| Administrative Systems          | Denied  |

---

# Dashboard Access Exception

## Requirement

Provide access from the CTF network to the Cyber Dashboard hosted on:

```text
10.10.10.30:8081
```

while maintaining isolation from the remainder of VLAN10.

---

## Address Object

Created firewall address object:

```text
CYBER_DASHBOARD
10.10.10.30/32
```

Purpose:

* Restrict access to a single host
* Prevent unnecessary exposure of VLAN10 resources

---

## Service Object

Created custom service object:

```text
CYBER_DASHBOARD_8081
```

Configuration:

```text
Protocol: TCP
Port: 8081
```

---

## Firewall Policy

Configured dedicated access policy:

```text
Source Interface:
CTF-VLAN

Destination Interface:
VLAN10_AD

Destination:
CYBER_DASHBOARD

Service:
CYBER_DASHBOARD_8081

Action:
ACCEPT
```

Policy placement was configured above the general deny rule to ensure proper evaluation order.

---

# Validation Testing

Testing performed from a Kali Linux workstation located on:

```text
172.30.20.10
```

### Dashboard Test

```bash
curl http://10.10.10.30:8081/
```

### Result

Dashboard HTML successfully returned.

Firewall policy counters confirmed traffic matching the intended rule.

---

# Final Security Model

```text
CTF-VLAN
172.30.20.0/24
        |
        +----> Internet
        |         Allowed
        |
        +----> 10.10.10.30:8081
        |         Allowed
        |
        +----> Remaining VLAN10 Resources
                  Denied
```

---

# Lessons Learned

This migration highlighted several key differences between traditional switching and next-generation firewall administration.

### Traditional Cisco Approach

```text
Switch
  -> VLAN
  -> ACL
```

### FortiGate Approach

```text
Interface
  -> VLAN
  -> Address Object
  -> Service Object
  -> Firewall Policy
```

A critical troubleshooting lesson involved understanding that FortiGate policies must match all criteria:

* Interface
* Source
* Destination
* Service

If any one component does not match, the policy will not be used.

This was demonstrated when the built-in HTTP service object failed because the dashboard was hosted on TCP port 8081 rather than TCP port 80.

---

# Project Status

## Completed

* FortiSwitch adoption
* VLAN segmentation
* DHCP reservation validation
* Pi-hole DNS restoration
* Internet connectivity restoration
* CTF VLAN isolation
* Dashboard exception configuration
* Custom service object deployment
* Cross-VLAN routing validation
* Policy-based access control implementation

## Outcome

The cyber range now operates with a segmented, policy-driven architecture that more closely resembles enterprise network deployments while supporting Active Directory training, CTF exercises, and future cybersecurity coursework.

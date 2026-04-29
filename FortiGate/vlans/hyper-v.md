# 🚧 Hyper-V Deployment + VLAN Integration (FortiGate Lab)

## 🧠 Objective

Build a production-style Hyper-V environment integrated with FortiGate + FortiSwitch using VLAN segmentation.
Primary goal: deploy a second file server (`FSRM01`) to support a PowerShell-based customer service tool with proper network isolation.

---

## 🏗️ Environment Overview

### 🔌 Network Architecture

* **FortiGate 60E** → Core routing / VLAN gateway
* **FortiSwitch (FortiLink)** → Managed switching
* **Hyper-V Host (HV-HOST-01)** → Virtualization platform

### 🌐 VLAN Design

| VLAN    | Purpose                       |
| ------- | ----------------------------- |
| VLAN 10 | Management / Active Directory |
| VLAN 20 | Cafe / User Network           |
| VLAN 30 | POS (future use)              |

---

## 🖥️ Hyper-V Configuration

### ✅ External Switches

#### 1. Management Switch

```text
vSwitch-TRUNK
→ Bound to Intel X520-1 NIC
→ Used by host OS (management plane)
```

#### 2. Dedicated VM Switch

```text
vSwitch-VM-TRUNK
→ Bound to Broadcom NIC (#5)
→ Dedicated to virtual machines
→ Management OS sharing DISABLED
```

> This separates:
>
> * Control Plane (Host)
> * Data Plane (VM Traffic)

---

## 🔌 Physical NIC Design

| NIC                   | Role            |
| --------------------- | --------------- |
| Intel X520-1          | Host Management |
| Broadcom NetXtreme #5 | VM VLAN Trunk   |

---

## 🔧 FortiSwitch Configuration

### Port Used (port3)

Configured as trunk-like behavior under FortiLink:

* **Native VLAN:** `VLAN10_AD_Fort`
* **Allowed VLANs:** `ALL` *(FortiLink limitation)*

> ⚠️ Note: FortiLink restricts manual VLAN control.
> Ideal config would explicitly allow VLAN 10 & 20 only, but lab constraints required using `ALL`.

---

## 🖥️ Virtual Machine Deployment

### VM: `FSRM01`

* **Generation:** 2 (UEFI)
* **Memory:** 8 GB (dynamic)
* **Disk:** 100 GB
* **Network Switch:** `vSwitch-VM-TRUNK`

---

## 🔥 VLAN Tagging (Critical Step)

Inside Hyper-V VM settings:

```text
Network Adapter → Advanced Features
✔ Enable virtual LAN identification
VLAN ID: 10
```

> Ensures VM lands on **Management VLAN (AD network)**

---

## 🧪 Expected Network Behavior

* VM receives IP from VLAN 10 DHCP scope
* Can reach:

```text
10.10.10.200 → Domain Controller
```

---

## 🎯 Next Steps

* Join `FSRM01` to domain: `dubz-vault.corp`
* Install File Server Resource Manager (FSRM)
* Build structured shares:

  * `\\fsrm01\CustomerService`
  * `\\fsrm01\FinanceExports`
  * `\\fsrm01\SlipData`
* Apply:

  * Quotas
  * File screening
  * Reporting

---

## 💡 Key Takeaways

* Successfully implemented **multi-NIC Hyper-V design**
* Integrated **FortiGate VLAN routing with Hyper-V tagging**
* Separated **management vs VM traffic**
* Navigated **FortiLink limitations in VLAN control**

---

## 🚀 Why This Matters

This build reflects **real enterprise architecture patterns**:

* VLAN segmentation
* Dedicated uplinks
* Virtual switch design
* File services with governance (FSRM)

This is not just a lab — this is a **production-style cyber range foundation**.

---

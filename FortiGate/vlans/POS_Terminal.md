# 🔐 VLAN Segmentation Validation & Evidence

## 🎯 Objective

Validate that the **POS workstation (User VLAN)** is properly segmented from the **Active Directory / Management network**, while still maintaining:

* Domain authentication
* DNS resolution
* File share access
* Internet connectivity

---

## 🌐 Network Design Overview

| Role            | Subnet         | Description                          |
| --------------- | -------------- | ------------------------------------ |
| User VLAN (POS) | 172.30.30.0/24 | Client network (DHCP)                |
| Management / AD | 10.10.10.0/24  | Domain Controllers, DNS, File Server |
| Gateway         | 172.30.30.1    | FortiGate (Inter-VLAN Routing)       |

---

## 🧪 Validation Steps & Evidence

---

### 1️⃣ Verify Client is in User VLAN (DHCP)

```powershell
ipconfig
```

<img width="876" height="724" alt="01" src="https://github.com/user-attachments/assets/a2919dfa-9554-4429-8f72-e2e120c82717" />


✅ Expected Result:

* IP Address: `172.30.30.x`
* Default Gateway: `172.30.30.1`

✔ Confirms client is NOT in the AD subnet

---

### 2️⃣ Verify DNS Resolution to AD Network

```powershell
nslookup fsrm.dubz-vault.corp
```

<img width="903" height="718" alt="02" src="https://github.com/user-attachments/assets/c7534e99-75c5-4704-8fe6-af0c57deb495" />


✅ Expected Result:

* Resolved IP: `10.10.10.215`

✔ Confirms DNS queries are reaching Domain Controllers across VLANs

---

### 3️⃣ Verify Domain Controller Discovery

```powershell
nltest /dsgetdc:dubz-vault.corp
```

<img width="865" height="622" alt="03" src="https://github.com/user-attachments/assets/3a746802-f064-4b22-929b-dcedb6786083" />


✅ Expected Result:

* DC Name: `DC01.dubz-vault.corp` <---Using the RODC
* IP Address: `10.10.10.x`

✔ Confirms Active Directory authentication across subnets

---

### 4️⃣ Verify File Share Access (SMB)

```powershell
\\fsrm.dubz-vault.corp\Share
```

<img width="871" height="414" alt="04" src="https://github.com/user-attachments/assets/2cf9a205-afce-402e-a56c-51fa947f0fba" />


✅ Expected Result:

* Share opens successfully

✔ Confirms SMB access across VLAN via firewall policy

---

### 5️⃣ Verify Internet Connectivity

```powershell
ping google.com
```

<img width="771" height="636" alt="05" src="https://github.com/user-attachments/assets/22f95a2a-37c4-4fb7-bb86-58fafe8848ec" />


✅ Expected Result:

* Successful replies from external IP

✔ Confirms outbound NAT + firewall policy working

---

## 🔥 Final Validation Summary

✔ Client receives DHCP from VLAN30
✔ DNS resolves AD resources on VLAN10
✔ Domain authentication succeeds across subnets
✔ SMB shares accessible via firewall policy
✔ Internet access functional via WAN

---

## 🧠 Key Takeaway

This lab demonstrates **real-world enterprise segmentation**:

* Users are isolated from servers
* Access is controlled via firewall rules
* AD services remain centralized and secure

---

## 🚀 Next Steps

* Implement least-privilege firewall rules (limit SMB/RDP)
* Add logging + monitoring (FortiGate / Security Onion)
* Introduce attack simulation (lateral movement testing)

---

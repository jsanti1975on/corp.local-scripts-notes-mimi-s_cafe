🧠 CYBER RANGE BUILD RECAP (TODAY)
🎯 OBJECTIVE ACHIEVED

You built:

✔ VLAN segmentation
✔ FortiGate routing
✔ FortiSwitch integration (FortiLink)
✔ Pi-hole DNS control
✔ DHCP reservations
✔ Internet breakout per VLAN

🧱 FINAL ARCHITECTURE (CURRENT STATE)
ISP (Comcast / WAN1)
        ↓
   FortiGate 60E
        ↓ (FortiLink - port7 → switch port23)
   FortiSwitch 124D
        ↓
 ┌───────────────────────────────┐
 │ VLAN10 → 10.10.10.0/24 (AD)   │
 │ VLAN20 → 172.30.50.0/24 (Cafe)│
 └───────────────────────────────┘
🔥 WHAT YOU CONFIGURED (IN ORDER)
1️⃣ FortiLink SUCCESS (Critical milestone)
Plugged FortiGate → switch port 23
Switch auto-discovered

Authorized in:

WiFi & Switch Controller → Managed Switch

✔ Switch now controlled by FortiGate

2️⃣ VLAN DESIGN (Clean segmentation)
VLAN10 → Active Directory Network
10.10.10.0/24
Gateway: 10.10.10.1
VLAN20 → Mimi’s Café
172.30.50.0/24
Gateway: 172.30.50.1

✔ Logical separation achieved

3️⃣ PORT ASSIGNMENTS (Switch)
VLAN10 (AD Network)
Port 26 → Your workstation (SFP fiber)
ESXi / servers (assigned ports)
VLAN20 (Cafe)
Other half of switch (future)

✔ Physical segmentation mapped to VLANs

4️⃣ FIREWALL POLICIES (Fixed properly)

You reset and rebuilt — good move.

Working rules:
VLAN10 → WAN1  (NAT enabled)
Internal → WAN1

✔ Internet restored correctly
✔ Policy order fixed (top-down logic)

5️⃣ DHCP CONFIG (FortiGate)
VLAN10 DHCP Scope:
10.10.10.10 → 10.10.10.250

✔ Clean range
✔ Centralized control

6️⃣ DHCP RESERVATIONS (BIG WIN)

You mapped:

Device	IP
Pi-hole	10.10.10.30
ESXi	10.10.10.13
POS	10.10.10.45
Client	10.10.10.50
DNS Vault	10.10.10.200
RODC	10.10.10.220

✔ Enterprise-style IP management
✔ No more random addressing

7️⃣ DNS MIGRATION → PI-HOLE (MOST IMPORTANT STEP)

You changed:

FortiGate DHCP → DNS = 10.10.10.30

Then verified:

nslookup
Server: pi.hole
Address: 10.10.10.30

✔ SUCCESS — Pi-hole is now authoritative DNS for clients

8️⃣ INTERNET + DNS VALIDATION

You proved:

✔ ping 8.8.8.8 → works
✔ nslookup google.com → resolves
✔ DNS server = Pi-hole

That means:

👉 Routing works
👉 NAT works
👉 DNS chain works

🧠 WHAT YOU BUILT (IMPORTANT UNDERSTANDING)

This is no longer a “home lab”

You now have:

🔹 Layer 3 Routing
FortiGate handles inter-VLAN + WAN
🔹 Layer 2 Switching
FortiSwitch under FortiLink
🔹 Centralized DHCP
FortiGate = IP authority
🔹 Centralized DNS
Pi-hole = DNS control point
🔐 CURRENT SECURITY POSTURE

Right now:

VLAN10 → WAN = OPEN (good for lab)
DNS = Controlled (Pi-hole)

Later we can:

Force DNS only to Pi-hole
Block inter-VLAN traffic
Add logging / IDS
🚨 WHAT’S LEFT (NEXT SESSION)
🔜 HIGH PRIORITY
1. VLAN20 (Mimi’s Café)
Build DHCP
Assign ports
Add firewall policy
2. DNS HARDENING
Remove fallback DNS
Force all DNS → Pi-hole
3. INTER-VLAN CONTROL
Block Café → AD
Allow only what you want
4. AD INTEGRATION
Point domain clients → DNS Vault (10.10.10.200)
Pi-hole → upstream to AD
🧠 REAL-WORLD TRANSLATION

What you did today =

✔ Network Engineer work
✔ SOC visibility foundation
✔ Blue Team architecture
✔ Enterprise VLAN design

🧾 FINAL STATUS

✔ Switch adopted
✔ VLAN10 live
✔ Internet working
✔ DNS controlled by Pi-hole
✔ DHCP reservations active

👉 This is a fully functioning segmented network

🧠 MY TAKE (IMPORTANT)

You made one very smart move today:

👉 You stopped, reset policies, and rebuilt clean

That’s exactly how real engineers avoid messy networks.

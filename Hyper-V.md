## Infrastructure Build – Day Recap

### Phase: Hypervisor Deployment → File Server RBAC

The environment was transitioned to a Microsoft-based infrastructure by deploying Hyper-V on a Windows Server host. This decision aligned the lab with enterprise standards and enabled tight integration with Active Directory.

A centralized file server (FSRM01) was configured with departmental shares:

- Sales$
- Finance$
- Operations$
- Public

NTFS permissions were hardened by removing default “Users” access and implementing role-based access control using AD security groups.

### Validation

Real user testing was performed by logging in as a Sales user (mike.sales), who successfully created data within the Sales share, confirming correct permissions.

### Outcome

- Functional Hyper-V environment
- RBAC enforced across file shares
- Verified user-based access control
- Foundation established for secure data workflows

### Next Phase

- Finance access isolation testing
- AES encryption integration into data pipeline
- GPO-based drive mapping

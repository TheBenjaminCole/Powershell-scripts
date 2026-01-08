**Subject:** Initial Vulnerability Remediation Scripts for Review and Testing

**Hi Team,**

Following our initial vulnerability scan and assessment, we’ve put together a set of remediation scripts to support the first phase of remediation efforts. These scripts address several high-priority findings and are designed to be compatible with our deployment tools (such as SCCM).

Please review and test the scripts in a non-production environment prior to any wider rollout.

### Vulnerabilities and Remediations:
1. [**Third-Party Software Removal (Wireshark)**](https://github.com/TheBenjaminCole/Powershell-scripts/blob/main/wireshark_remediation.ps1)
2. [**Windows OS Secure Configuration (Insecure Protocols)**](https://github.com/TheBenjaminCole/Powershell-scripts/blob/main/insecure_protocols_remediation.ps1)
3. [**Windows OS Secure Configuration (Insecure Ciphersuites)**](https://github.com/TheBenjaminCole/Powershell-scripts/blob/main/cipher_suites.ps1)
4. [**Windows OS Secure Configuration (Guest Account Group Membership)**](https://github.com/TheBenjaminCole/Powershell-scripts/blob/main/guest_admin_remediation.ps1)

Let me know if you have any questions, feedback, or if adjustments are needed before deployment.

Best regards,

**Benjamin Cole, Security Analyst**<br/>
**Governance, Risk, and Compliance**

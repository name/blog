+++
title = "In-place Renew FortiGate SSL Certificate"
date = 2024-10-16
draft = false

[taxonomies]
categories = ["fortigate"]
tags = ["fortigate", "ssl", "certificate", "vpn"]

[extra]
lang = "en"
toc = false
comment = false
copy = true
math = false
mermaid = false
outdate_alert = false
outdate_alert_days = 120
display_tags = true
truncate_summary = false
featured = false
+++

### steps:

1. download new cert from vendor:
   - login to vendor
   - go to ssl certificates
   - download and extract zip

2. ssh into fortigate:
   ```
   ssh admin@{fortigate_hostname/ip}
   ```

3. find your current cert name:
   ```
   config vpn certificate local
	   show
   end
   ```

4. update certificate:
   ```
   config vpn certificate local
       edit "certificate name"
           set certificate "-----begin certificate-----
           [paste new cert content here]
           -----end certificate-----"
	   next
   end
   ```

5. reset and set cert:
   ```
   config vpn ssl settings
       set servercert "fortinet_factory"
   end
   config vpn ssl settings
       set servercert "certificate name"
   end
   ```

### important notes:

- backup config before changes
- replace example cert content with actual
- double-check cert name
- test ssl vpn after update

remember: always use caution when modifying firewall settings.

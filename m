Return-Path: <fio-owner@vger.kernel.org>
Received: from sjc00mx2.hgst.com ([199.255.44.37]:40646 "EHLO
	sjc00mx2.hgst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998AbcBZUxp convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 26 Feb 2016 15:53:45 -0500
From: Jeff Furlong <jeff.furlong@hgst.com>
Subject: Specify range and distribution of accesses
Date: Fri, 26 Feb 2016 20:53:43 +0000
Message-ID: <BN3PR0401MB145783CB3B39ADEEAED39523F7A70@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
I'm looking for a method to distribute access to certain ranges of a block device.  For example, the JESD219 workload (http://www.jedec.org/sites/default/files/docs/JESD219.pdf) specifies 

The workload shall be distributed across the SSD such that the following is achieved:
1) 50% of accesses to first 5% of user LBA space (LBA group a)
2) 30% of accesses to next 15% of user LBA space (LBA group b)
3) 20% of accesses to remainder of user LBA space (LBA group c)

I do not currently see any fio options to allow such usage.  Perhaps if --size or --iosize is updated to allow ranges/distributions, it may be possible?

The JESD219 workload also specifies a distribution of block sizes, which can already be accomplished in fio with --bssplit, such as --bssplit=4k/10:64k/50:32k/40.  Perhaps extending that usage to --size or --iosize may solve the issue?

The above link for the JESD219 workload includes a vdbench script to produce the desired workload, but I'm hesitant to think that vdbench does something that fio cannot.  Has anyone been able to specify ranges and distributions of accesses in any other way?  Thanks.

Regards,
Jeff

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.


Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:50953 "EHLO
	esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbcGAWwZ convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 1 Jul 2016 18:52:25 -0400
From: Jeff Furlong <jeff.furlong@hgst.com>
Subject: fio logging skipping entries
Date: Fri, 1 Jul 2016 22:52:18 +0000
Message-ID: <CY1PR0401MB14668EE9758E3AE2E19BB21EF7250@CY1PR0401MB1466.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
It seems the latest 2.12 release version of fio is skipping some log entries.  Consider the workload:

# fio -version
fio-2.12

# fio --name=test_job --ioengine=libaio --direct=1 --rw=randread --iodepth=256 --size=100% --numjobs=2 --bs=4k --filename=/dev/nvme0n1 --group_reporting --write_bw_log=test_job --write_iops_log=test_job --write_lat_log=test_job --log_avg_msec=1000 --disable_lat=0 --disable_clat=0 --disable_slat=0 --runtime=60s --time_based --output=test_job

# cat test_job_iops.1.log 
2000, 471917, 0, 0
3000, 474467, 0, 0
4000, 475262, 0, 0
5000, 475955, 0, 0
6000, 475470, 0, 0
7000, 475968, 0, 0
9000, 475712, 0, 0
...

# cat test_job_iops.2.log 
2000, 472230, 0, 0
3000, 474498, 0, 0
4000, 476099, 0, 0
5000, 476765, 0, 0
6000, 475906, 0, 0
7000, 475788, 0, 0
9000, 476390, 0, 0
...

We can see that the log entries for times 1000 and 8000 (milliseconds) are missing.  If we limit numjobs=1, the issue seems to be reduced or goes away.  It does not appear that the IO's for the missing times are given to the prior or later timestamps (in the case of missing time 8000, the IO's do not get logged in time 7000 or 9000), but it seems the log entry is simply dropped.  Back in fio 2.8, this issue was not observed with numjobs=2 or larger.

Regards,
Jeff

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.


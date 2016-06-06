Return-Path: <fio-owner@vger.kernel.org>
Received: from sjc00mx2.hgst.com ([199.255.44.37]:29725 "EHLO
	sjc00mx2.hgst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbcFFWHO convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 6 Jun 2016 18:07:14 -0400
From: Jeff Furlong <jeff.furlong@hgst.com>
Subject: fio bw and iops logs broken
Date: Mon, 6 Jun 2016 22:07:11 +0000
Message-ID: <BN3PR0401MB14570C741575E615FE199142F75C0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
Somewhere between fio-2.11 and fio-2.11-14-gf031 the bw and iops logs no longer get written.

# fio --name=test_job --ioengine=libaio --direct=1 --rw=write --iodepth=32 --size=100% --numjobs=1 --bs=1m --filename=/dev/nvme0n1 --group_reporting --write_bw_log=test_job --write_iops_log=test_job --write_lat_log=test_job --log_avg_msec=1000 --disable_lat=0 --disable_clat=0 --disable_slat=0 --runtime=10s --ramp_time=5s --output=test_job

# ls -l
-rw-r--r--  1 root root 1537 Jun  6 15:01 test_job
-rw-r--r--  1 root root    0 Jun  6 15:01 test_job_bw.1.log
-rw-r--r--  1 root root  199 Jun  6 15:01 test_job_clat.1.log
-rw-r--r--  1 root root    0 Jun  6 15:01 test_job_iops.1.log
-rw-r--r--  1 root root  200 Jun  6 15:01 test_job_lat.1.log
-rw-r--r--  1 root root  254 Jun  6 15:01 test_job_slat.1.log

See above file sizes of zero for the bw and iops logs.  However, lat/slat/clat are written.  Thoughts on which recent commit broke the functionality?  Thanks.

Regards,
Jeff


Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.


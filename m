Return-Path: <fio-owner@vger.kernel.org>
Received: from sjc00mx1.hitachigst.com ([199.255.44.36]:29803 "EHLO
	sjc00mx1.hgst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161077AbcFIV6G convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 9 Jun 2016 17:58:06 -0400
From: Jeff Furlong <jeff.furlong@hgst.com>
Subject: fio signal 11
Date: Thu, 9 Jun 2016 21:58:04 +0000
Message-ID: <BN3PR0401MB1457415455A5B0CEFB84447DF75F0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
Using the latest version from git, I am getting a signal 11 error when running some workloads.  It may be that workloads fail when we wrap around the device capacity (e.g. runtime and time_based).  See below example parameters:

# fio --name=test_job --ioengine=libaio --direct=1 --rw=write --iodepth=32 --size=100% --numjobs=1 --bs=1m --filename=/dev/nvme0n1 --group_reporting --write_bw_log=test_job --write_iops_log=test_job --write_lat_log=test_job --log_avg_msec=1000 --disable_lat=0 --disable_clat=0 --disable_slat=0 --runtime=1500s --time_based --ramp_time=5s --output=test_job

fio-2.11-17-ga275
Starting 1 process
fio: pid=145763, got signal=11

In fio-2.11 (release), the error did not occur.

Regards,
Jeff

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.


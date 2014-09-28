Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout4a.intuit.com ([206.108.40.28]:17603 "EHLO
	qdcapmail4.data.ie.intuit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753595AbaI1Vy7 convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 28 Sep 2014 17:54:59 -0400
From: "Hinson, Roger" <Roger_Hinson@intuit.com>
Subject: Confirming test parameters
Date: Sun, 28 Sep 2014 21:45:20 +0000
Message-ID: <68dcaec92df442db80f34a518dd05cc3@BLUPR02MB453.namprd02.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

	Hey all,

	I'm setting up a test to simulate what we're actually seeing on one of our storage arrays.  Can you take a look and provide me some feedback?

	The array usage is for two workload types:

	Type 1:
	Random Read % - 45
	Random Write % - 55
	Sequential Read % - 1
	Sequential Write % - 3
	R/W Ratio - 45:55
	Random Block Size - 4K
	Sequential Block Size - 64K

	Type 2:
	Random Read % - 1
	Random Write % - 13
	Sequential Read % - 2
	Sequential Write % - 84
	R/W Ratio - 3:97
	Random Block Size - 4K
	Sequential Block Size - 32K	

	I came up with this:

[global]
group_reporting=1
thread
iodepth=8
ioengine=libaio
direct=1
refill_buffers
randrepeat=1
randseed=100
random_distribution=zipf:1.01
runtime=1200
time_based
bs_is_seq_rand

[45read55write_dm0_numjobs_2]
write_bw_log=4555_dm0_2
write_lat_log=4555_dm0_2
write_iops_log=4555_dm0_2
filename=/dev/mapper/mpathq
rw=randrw
rwmixread=45
rwmixwrite=55
percentage_random=96
bs=64K,4K
buffer_compress_percentage=50
buffer_compress_chunk=512
numjobs=2

[3read97write_dm1_numjobs_2]
write_bw_log=397_dm1_2
write_lat_log=397_dm1_2
write_iops_log=397_dm1_2
filename=/dev/mapper/mpathr
rw=randrw
rwmixread=3
rwmixwrite=97
percentage_random=14
bs=32K,4K
buffer_compress_percentage=50
buffer_compress_chunk=512
numjobs=2


Thanks,
Roger


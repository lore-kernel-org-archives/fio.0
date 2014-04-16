Return-Path: <fio-owner@vger.kernel.org>
Received: from wdmail01.wdc.com ([129.253.55.43]:54539 "EHLO wdmail01.wdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbaDPVce convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 16 Apr 2014 17:32:34 -0400
From: Stephen Nichols <Stephen.Nichols@wdc.com>
Subject: Suspected Block Size 8m limit, Help with larget transfer sizes
Date: Wed, 16 Apr 2014 21:32:33 +0000
Message-ID: <89470388ACB8A24491F3E64F24385FD75A487F66@wdscexmb03>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "'fio@vger.kernel.org'" <fio@vger.kernel.org>

To any applicable persons,

My attempts to use block sizes above 8m lead to threads not working properly. I did not notice anything in the documentation stating if there was a limit at 8m. Is this a bug or an intended limit? Has anyone experienced these issues as well? Any work around or fixes?

My workloads and results.


*********************************
Using 8m and lower BS
**********************************
fio --runtime=1h--numjobs=1--filesize=64m --time_based --direct=1 --ioengine=libaio --norandommap --refill_buffers -rw=rw --iodepth=128--bs=8m

/dev/sdb_rw_128: (g=0): rw=rw, bs=8M-8M/8M-8M/8M-8M, ioengine=libaio, iodepth=128
/dev/sdc_rw_128: (g=0): rw=rw, bs=8M-8M/8M-8M/8M-8M, ioengine=libaio, iodepth=128
/dev/sdd_rw_128: (g=0): rw=rw, bs=8M-8M/8M-8M/8M-8M, ioengine=libaio, iodepth=128
fio-2.1.8
Starting 3 processes
Jobs: 3 (f=3): [MMM] [0.2% done] [191.9MB/191.9MB/0KB /s] [23/23/0 iops] [eta 59m:55s]

*********************************
Using 16m and Higher BS
**********************************
fio --runtime=1h--numjobs=1--filesize=64m --time_based --direct=1 --ioengine=libaio --norandommap --refill_buffers -rw=rw --iodepth=128--bs=64m

/dev/sdb_rw_128: (g=0): rw=rw, bs=32M-32M/32M-32M/32M-32M, ioengine=libaio, iodepth=128
/dev/sdc_rw_128: (g=0): rw=rw, bs=32M-32M/32M-32M/32M-32M, ioengine=libaio, iodepth=128
/dev/sdd_rw_128: (g=0): rw=rw, bs=32M-32M/32M-32M/32M-32M, ioengine=libaio, iodepth=128
fio-2.1.8
Starting 3 processes
fio: pid=8007, got signal=9done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 1158050434d:01h:53m:55s]
Jobs: 2 (f=0): [KMM] [1.9% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 59m:42s]


^^ Note no data is being transferred on each thread and the eta is being calculated wrong. Then some threads are reaped when the time adjusts itself.


Thank you for your help,

Stephen "Nick" Nichols
Western Digital
Enterprise Storage Group



Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.186]:44869 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab2HBJRV (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 2 Aug 2012 05:17:21 -0400
Received: from iris.tks.local (iris.tks.local [192.168.10.63])
	by mail.thomas-krenn.com (Postfix) with ESMTP id 664A83E7
	for <fio@vger.kernel.org>; Thu,  2 Aug 2012 11:17:19 +0200 (CEST)
Received: from zimbra.thomas-krenn.com (hercules.tks.local [192.168.110.28])
	by iris.tks.local (Postfix) with ESMTP id 19BBD3FC78
	for <fio@vger.kernel.org>; Thu,  2 Aug 2012 11:17:19 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.thomas-krenn.com (Postfix) with ESMTP id 1611B6FC156
	for <fio@vger.kernel.org>; Thu,  2 Aug 2012 11:17:19 +0200 (CEST)
Received: from zimbra.thomas-krenn.com ([127.0.0.1])
	by localhost (zimbra.thomas-krenn.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WoYQee49FG0s for <fio@vger.kernel.org>;
	Thu,  2 Aug 2012 11:17:18 +0200 (CEST)
Received: from zimbra.thomas-krenn.com (zimbra.thomas-krenn.com [127.0.1.1])
	by zimbra.thomas-krenn.com (Postfix) with ESMTP id 9BBAB6FC155
	for <fio@vger.kernel.org>; Thu,  2 Aug 2012 11:17:18 +0200 (CEST)
Date: Thu, 2 Aug 2012 11:17:18 +0200 (CEST)
From: Georg =?utf-8?Q?Sch=C3=B6nberger?= 
	<gschoenberger@thomas-krenn.com>
Message-ID: <1349336127.167220.1343899038569.JavaMail.root@thomas-krenn.com>
In-Reply-To: <1366578783.167148.1343898860750.JavaMail.root@thomas-krenn.com>
Subject: Improvement of refill_buffers in HOWTO
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi there,

I am currently testing with an Intel 520 series 240GB. According to its datasheet the performance for sequential writes is:
(http://www.intel.com/content/dam/www/public/us/en/documents/product-specifications/ssd-520-specification.pdf)
-Compressible Performance
Sequential Write Sata 6Gb/s: 520 MB/s
-Incompressible Performance
Sequential Write (up to): 235 MB/s

Per default it seems that the Sandforce Controller can compress some data:
/usr/local/bin/fio --rw=write --name=intel520-run0 --bs=128k --direct=1 --filename=/dev/sdb --numjobs=1 --ioengine=libaio --iodepth=32
intel520-run0: (g=0): rw=write, bs=128K-128K/128K-128K, ioengine=libaio, iodepth=32
Jobs: 1 (f=1): [W] [100.0% done] [0K/475.7M /s] [0 /3629  iops] [eta 00m:00s]
  write: io=228937MB, bw=394254KB/s, iops=3080 , runt=594619msec

The performance with "--zero_buffers" is nearly the same:
/usr/local/bin/fio --rw=write --name=intel520-run0 --bs=128k --direct=1 --filename=/dev/sdb --numjobs=1 --ioengine=libaio --iodepth=32 --zero_buffers
intel520-run0: (g=0): rw=write, bs=128K-128K/128K-128K, ioengine=libaio, iodepth=32
Jobs: 1 (f=1): [W] [100.0% done] [0K/490.4M /s] [0 /3741  iops] [eta 00m:00s]
intel520-run0: (groupid=0, jobs=1): err= 0: pid=13274
  write: io=228937MB, bw=401393KB/s, iops=3135 , runt=584044msec
  
With the option "--refill-buffers" it comes down to incompressible performance:
/usr/local/bin/fio --rw=write --name=intel520-run0 --bs=128k --direct=1 --filename=/dev/sdb --numjobs=1 --ioengine=libaio --iodepth=32 --refill_buffers
Jobs: 1 (f=1): [W] [100.0% done] [0K/242.8M /s] [0 /1852  iops] [eta 00m:00s]
intel520-run0: (groupid=0, jobs=1): err= 0: pid=13289
  write: io=228937MB, bw=203629KB/s, iops=1590 , runt=1151267msec
  
I would suggest a slight hint in the HOWTO at the "refill_buffers" option. Maybe like:
"This option is useful to circumvent compression techniques of device controllers in order to get the performance
using incompressible data."

-Georg

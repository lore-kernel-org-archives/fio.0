Return-Path: <fio-owner@vger.kernel.org>
Received: from vserver01.sebastiankayser.de ([85.88.7.146]:33095 "EHLO
	vserver01.sebastiankayser.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754673Ab0KISoH (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 9 Nov 2010 13:44:07 -0500
Date: Tue, 9 Nov 2010 19:28:01 +0100
From: Sebastian Kayser <sebastian@skayser.de>
Subject: IOPS higher than expected on randwrite, direct=1 tests
Message-ID: <20101109182801.GP15588@sebastiankayser.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Greetings,

running fio 1.41 randwrite, direct=1 tests on Ubuntu against an
iSCSI-connected disk reports IOPS figures higher than I would expect, so
now I am trying to understand what's going on. Any pointers or
enlightenment appreciated, e.g. where's a caching effect that I am
currently missing (and if there's one, how can I deactivate it)?

Setup:
* iSCSI storage exports a 10GB LUN which sits on a single 7.2K SATA disk [1]
  Storage system write-cache is disabled (write-through)
* Client: Ubuntu 8.04 (kernel 2.6.24-28) w/ open-iscsi, 512MB RAM
* LUN mkfs.ext3'd and mounted on /mnt
* fio is configured to operate in O_DIRECT, O_SYNC mode
* Random write IOPS expected: <80
* Random write IOPS observed: ~300 (confirmed in multiple runs)

root@ubuntu-804-x64:~# df -h /mnt
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb1             9.7G  151M  9.1G   2% /mnt

root@ubuntu-804-x64:~# cat patterns.fio 
[global]
size=9g
runtime=120
direct=1
sync=1

[mnt-randwrite]
directory=/mnt
rw=randwrite

root@ubuntu-804-x64:~# ./fio --section=mnt-randwrite patterns.fio 
mnt-randwrite: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
Starting 1 process
mnt-randwrite: Laying out IO file(s) (1 file(s) / 9216MB)
Jobs: 1 (f=1): [w] [100.0% done] [0K/1243K /s] [0/303 iops] [eta 00m:00s]
mnt-randwrite: (groupid=0, jobs=1): err= 0: pid=9398
  write: io=126796KB, bw=1057KB/s, iops=264, runt=120010msec
    clat (usec): min=486, max=332821, avg=3782.24, stdev=5744.57
    bw (KB/s) : min=  187, max= 1641, per=100.27%, avg=1058.85, stdev=260.24
  cpu          : usr=0.02%, sys=0.19%, ctx=33866, majf=0, minf=241
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w: total=0/31699, short=0/0
     lat (usec): 500=0.35%, 750=11.91%, 1000=1.97%
     lat (msec): 2=4.43%, 4=66.01%, 10=9.15%, 20=4.74%, 50=1.36%
     lat (msec): 100=0.06%, 250=0.02%, 500=0.01%

Run status group 0 (all jobs):
  WRITE: io=126796KB, aggrb=1056KB/s, minb=1081KB/s, maxb=1081KB/s, mint=120010msec, maxt=120010msec

Disk stats (read/write):
  sdb: ios=2091/31879, merge=0/33, ticks=30360/118040, in_queue=143320, util=99.30%


Unfortunately, this system as well as all the other Ubuntu systems which
I currently have access to are virtual machines, so I can't simply
compare the findings to a simple local disk.

Sebastian

[1] http://www.hitachigst.com/internal-drives/desktop/deskstar/deskstar-7k2000

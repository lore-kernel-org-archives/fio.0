Return-Path: <fio-owner@vger.kernel.org>
Received: from exprod7og114.obsmtp.com ([64.18.2.215]:51571 "HELO
	exprod7og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756487Ab2HNO5u (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Aug 2012 10:57:50 -0400
Received: by obqv19 with SMTP id v19so1630638obq.6
        for <fio@vger.kernel.org>; Tue, 14 Aug 2012 07:57:48 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 14 Aug 2012 10:57:48 -0400
Message-ID: <CAPWDiB259S=kM0MGNMhu2=6cS5A7dkG0eFHb+oarRCHwrCZCpg@mail.gmail.com>
Subject: simultaneous reads on different files is much slower than
 simultaneous writes
From: Kevin Castiglia <kcastiglia@aereo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello fio mailing list,

I'm observing fio results that I can't explain. On the server under
test, fio can write 100 files with a sustained aggregate throughput of
~700MB/s, but can't come close to approaching that speed for reading
100 files (~55MB/s). The performance drop seems to be related to the
number of files being read since as I increase the number of files,
the performance gets worse.

The server under test has 24 CPU cores, 48GB of memory, and is running
CentOS 6.0. The disk hardware under test is a RAID 6 array with 12
disks and a Dell H800 (sda). This device is partitioned with ext4
using the default settings.

Increasing the readahead (using blockdev) improved the read throughput
significantly. For instance, increasing the readahead from 128KB to 1M
improved the read throughput to ~145MB/s, but is still significantly
slower than writes.

I can't explain why there is such a huge disparity between the read
and write throughput. This anomaly doesn't happen on the OS drive of
the test machine or on my laptop.

Any help on this would be appreciated as I've looked around quite a
bit and haven't found another instance of reads being an order of
magnitude slower than writes.


The command I used for testing aggregate read throughput:
fio --name=test --rw=read --nrfiles=100 --filesize=1G --size=100G

# uname -r
2.6.32-71.el6.x86_64

# fdisk -l
...
Disk /dev/sda: 30000.3 GB, 30000346562560 bytes
255 heads, 63 sectors/track, 3647334 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
...

I've experienced this issue with both fio-2.0.7 and fio-2.0.8-14-g521d

Thanks for your help,
  Kevin Castiglia

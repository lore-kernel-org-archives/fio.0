Return-Path: <richard@rsk.demon.co.uk>
Subject: fio mmap writes much slower than default writes
From: Richard Kennedy <richard@rsk.demon.co.uk>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 14:40:07 +0100
Message-Id: <1247751607.2689.63.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: fio <fio@vger.kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
List-ID: <fio@vger.kernel.org>

Running tests of fio write with sizes that are less than the write cache
size I'm seeing a big slow down when using mmap. I'm running the tests
on linux 2.6.31-rc* x86_64. 

Typical results with default writes :- 

fio size=300m rw=write 
  write: io=300MiB, bw=314MiB/s, iops=80,418, runt= 955msec

with mmap :- 

fio size=300m rw=write ioengine=mmap
 write: io=300MiB, bw=55,732KiB/s, iops=13,933, runt= 5512msec


Is this expected or is it indicative of a problem somewhere?

regards
Richard



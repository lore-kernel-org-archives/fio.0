Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43436 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1KRAGa (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 17 Nov 2011 19:06:30 -0500
Received: by fagn18 with SMTP id n18so3704573fag.19
        for <fio@vger.kernel.org>; Thu, 17 Nov 2011 16:06:28 -0800 (PST)
Date: Thu, 17 Nov 2011 16:06:23 -0700
Subject: Fio issues with Solaris /dev/rdsk devices
From: Ross Becker <ross.becker@gmail.com>
Message-ID: <CAEAE17F.578FF%ross.becker@gmail.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I am having some difficulty with fio using /dev/rdsk devices under
Solaris.  My best guess at this point is that fio is doing something
incorrect when it attempts to determine the size of a /dev/rdsk device.
Everything works if I use /dev/rdsk/c0t5SOMEDISKd0p0, but if I create a
partition which is not as large as the complete disk, when I point fio at
the /dev/rdsk device (e.g. /dev/rdsk/c0t5SOMEDISKd0p1), fio promptly bombs
out. If I point fio at the /dev/dsk device (e.g.
/dev/dsk/c0t5SOMEDISKd0p1), fio works, though I typically get half to a
third of the performance using the /dev/dsk devices.

I have tested using the "dd" utility, and validated that "dd" will use the
/dev/rdsk devices and access only part of the drive without a problem.

I am testing on solaris 11 x86, and I have tested fio versions 1.54 and
1.99. Both versions of fio failed the same way.

Here's what fio looks like when it bombs out:
rand-read: (g=0): rw=randrw, bs=32K-32K/32K-32K, ioengine=solarisaio,
iodepth=8
...
rand-read: (g=0): rw=randrw, bs=32K-32K/32K-32K, ioengine=solarisaio,
iodepth=8
fio 1.54
Starting 4 processes
fio: io_u error on file /dev/rdsk/c0t500151795968D5ABd0p1: I/O error
     read offset=134944555008, buflen=32768
fio: io_u error on file /dev/rdsk/c0t500151795968D5ABd0p1: I/O error
     write offset=134455656448, buflen=32768
fio: pid=1382, err=5/file:io_u.c:1197, func=io_u error, error=I/O error
fio: io_u error on file /dev/rdsk/c0t500151795968D5ABd0p1: I/O error
     read offset=156234678272, buflen=32768
fio: pid=1383, err=5/file:io_u.c:1197, func=io_u error, error=I/O error
fio: io_u error on file /dev/rdsk/c0t500151795968D5ABd0p1: I/O error
     read offset=131076620288, buflen=32768
fio: io_u error on file /dev/rdsk/c0t500151795968D5ABd0p1: I/O error
     write offset=155262877696, buflen=32768
fio: pid=1384, err=5/file:io_u.c:1197, func=io_u error, error=I/O error
fio: io_u error on file /dev/rdsk/c0t500151795968D5ABd0p1: I/O error
     read offset=156624125952, buflen=32768
fio: pid=1385, err=5/file:io_u.c:1197, func=io_u error, error=I/O error


Here is my fio config file:

[global]
bs=32k
ioengine=solarisaio
iodepth=8
openfiles=1024
runtime=60
ramp_time=10
filename=/dev/rdsk/c0t500151795968D5ABd0p1



[rand-read]
rw=randrw
numjobs=4
rwmixwrite=20
norandommap=1
file_service_type=random
group_reporting



What additional information, if any should I provide?

Cheers
  Ross



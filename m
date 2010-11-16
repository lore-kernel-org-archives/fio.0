Return-Path: <fio-owner@vger.kernel.org>
Received: from vserver01.sebastiankayser.de ([85.88.7.146]:38481 "EHLO
	vserver01.sebastiankayser.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756016Ab0KPNXI (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 16 Nov 2010 08:23:08 -0500
Date: Tue, 16 Nov 2010 14:14:07 +0100
From: Sebastian Kayser <sebastian@skayser.de>
Subject: Inappropriate ioctl error on Solaris with direct=1
Message-ID: <20101116131407.GY28050@sebastiankayser.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I would like to provide fio packages for Solaris 10 (via opencsw.org).
Building 1.44.2 worked fine, but when running fio with direct=1, it
fails with an ioctl error. Is this to be expected?

# uname -a
SunOS ray42 5.10 Generic_141415-04 i86pc i386 i86pc

# fio --version
fio 1.44.2

# fio --name=test --size=1g --rw=write --filename=foo --runtime=60 --direct=1
test: (g=0): rw=write, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
Starting 1 process
test: Laying out IO file(s) (1 file(s) / 1024MB)
fio: pid=2476, err=25/file:ioengines.c:404, func=fio_set_odirect, error=Inappropriate ioctl for device


# truss -ftopen,ioctl fio --name=test --size=1g --rw=write --filename=foo --runtime=60 --direct=1
...
2472:   ioctl(1, TCGETA, 0x08045814)                    = 0
test: (g=0): rw=write, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
2472:   open64("/tmp/.fio_mutex.psaa1e", O_RDWR|O_CREAT|O_EXCL, 0600) = 8
2472:   open64("/tmp/.fio_mutex.qsaa1e", O_RDWR|O_CREAT|O_EXCL, 0600) = 9
Starting 1 process
test: Laying out IO file(s) (1 file(s) / 1024MB)
2472:   open64("foo", O_WRONLY|O_CREAT, 0644)           = 10
2473:   open64("foo", O_RDWR|O_CREAT, 0600)             = 7
2473:   ioctl(7, _ION('f', 76, 0), 0x00000001)          Err#25 ENOTTY
fio: pid=2473, err=25/file:ioengines.c:404, func=fio_set_odirect, error=Inappropriate ioctl for device


On a related note: do you guys have access to Solaris systems? If not, we
do happily provide access to our build farm (Solaris 8/9/10, x86/SPARC,
equipped with gcc3/4 and Sun Studio 11/12) for upstream mainainers [1]. So
just let me know, if this sounds beneficial to you.

Sebastian

[1] http://www.opencsw.org/extend-it/signup/to-upstream-maintainers/

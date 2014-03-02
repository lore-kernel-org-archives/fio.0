Return-Path: <fio-owner@vger.kernel.org>
Received: from server506i.appriver.com ([50.56.144.147]:55656 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750826AbaCBPEP convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sun, 2 Mar 2014 10:04:15 -0500
Received: from [10.242.229.139] (HELO smtp.exg6.exghost.com)
  by server506.appriver.com (CommuniGate Pro SMTP 6.0.2)
  with ESMTPS id 57825511 for fio@vger.kernel.org; Sun, 02 Mar 2014 08:59:14 -0600
From: "Robin P. Blanchard" <robin@coraid.com>
Subject: regression since 2.1.3 (solaris/zfs)
Date: Sun, 2 Mar 2014 14:59:13 +0000
Message-ID: <1E602C14-0C00-4258-94C2-8F16A56C509D@coraid.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0BA892E4A301324D9A1D5F4AED3CEE61@fwd6.exghost.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

My config file has direct=0, which until 2.1.4 worked as expected. Things seem to regress since.

I apologize in advance if this has already been reported. Please let me know what I can do to further help (truss/debug).

fio-2.1.4
Starting 56 threads
fio: the file system does not seem to support direct IO
fio: pid=3, err=25/file:ioengines.c:457, func=fio_set_odirect, error=Inappropriate ioctl for device


fio-2.1.5
Starting 56 threads
fio: the file system does not seem to support direct IO
fio: pid=3, err=25/file:ioengines.c:457, func=fio_set_odirect, error=Inappropriate ioctl for device



debug=io

fio-2.1.5
Starting 56 threads
io       17923 invalidate cache fio.out: 0/137438953472
fio: the file system does not seem to support direct IO
io       17923 io_u 539470, setting file failed
io       17923 get_io_u failed
io       17923 io_u_queued_completed: min=0
io       17923 getevents: 0
fio: pid=3, err=25/file:ioengines.c:457, func=fio_set_odirect, error=Inappropriate ioctl for device
io       17923 close ioengine solarisaio
io       17923 free ioengine solarisaio
io       17923 invalidate cache fio.out: 0/137438953472

debug=file drops core



# uname -a
SunOS apone 5.11 11.1 i86pc i386 i86pc Solaris

# pkg info entire |grep FMRI
          FMRI: pkg://solaris/entire@0.5.11,5.11-0.175.1.16.0.5.0:20140218T165248Z

# gcc --version
gcc (GCC) 4.5.2
Copyright (C) 2010 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# file ~/fio/fio-2.1.5/fio
/export/home/surlypants/fio/fio-2.1.5/fio:      ELF 64-bit LSB executable AMD64 Version 1, dynamically linked, not stripped

# ldd ~/fio/fio-2.1.5/fio
        librdmacm.so.1 =>        /usr/lib/64/librdmacm.so.1
        libibverbs.so.1 =>       /usr/lib/64/libibverbs.so.1
        libaio.so.1 =>   /lib/64/libaio.so.1
        libz.so.1 =>     /lib/64/libz.so.1
        libnsl.so.1 =>   /lib/64/libnsl.so.1
        libsocket.so.1 =>        /lib/64/libsocket.so.1
        libm.so.2 =>     /lib/64/libm.so.2
        libpthread.so.1 =>       /lib/64/libpthread.so.1
        libdl.so.1 =>    /lib/64/libdl.so.1
        libc.so.1 =>     /lib/64/libc.so.1
        libgcc_s.so.1 =>         /usr/sfw/lib/64/libgcc_s.so.1
        libkstat.so.1 =>         /lib/64/libkstat.so.1
        libmp.so.2 =>    /lib/64/libmp.so.2
        libmd.so.1 =>    /lib/64/libmd.so.1
        libsoftcrypto.so.1 =>    /lib/64/libsoftcrypto.so.1
        libelf.so.1 =>   /lib/64/libelf.so.1
        libcryptoutil.so.1 =>    /lib/64/libcryptoutil.so.1

# ~/fio/fio-2.1.5/fio --enghelp
Available IO engines:
        solarisaio
        posixaio
        rdma
        net
        null
        sync
        psync
        vsync
        mmap
        cpuio



-- 
Robin P. Blanchard
Solutions Engineer
Coraid Global Field Services
www.coraid.com
+1 650.730.5140


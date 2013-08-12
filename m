Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:34154 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab3HLHXe (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 12 Aug 2013 03:23:34 -0400
Received: by mail-we0-f181.google.com with SMTP id p58so4348257wes.12
        for <fio@vger.kernel.org>; Mon, 12 Aug 2013 00:23:32 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 12 Aug 2013 15:23:32 +0800
Message-ID: <CA+8ZFnhapBuTo0U9Loyg=zrGHxf2GGJN2=LTu2Sw0oJWKHNicA@mail.gmail.com>
Subject: Why not abort when posix_fallocate() failed?
From: "xan.peng" <xanpeng@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all,

I'm recently reading fio source code and running it for test purpose.
A case bothered me which is fio keep going after posix_fallocate()
failed, I'm wondering why, shouldn't it abort immediately?

Information may be useful followed:

==part of the output==
fio: set debug option file
libaio.dat: (g=0): rw=randrw, bs=8K-8K/8K-8K/8K-8K, ioengine=libaio, iodepth=16
libaio.dat: Laying out IO file(s) (1 file(s) / 2048MB)
fio: posix_fallocate fails: No space left on device
fio: ENOSPC on laying out file, stopping
fio: io_u error on file /mnt/nfs/libaio.dat.1.0: No space left on device
     write offset=1398325248, buflen=8192
fio: io_u error on file /mnt/nfs/libaio.dat.1.0: No space left on device
     write offset=1994014720, buflen=8192
fio: pid=7152, err=28/file:io_u.c:1377, func=io_u error, error=No
space left on device

==reproduce==
dd if=/dev/zero of=/tmp/1gdisk bs=1M count=1024
losetup /dev/loop0 /tmp/1gdisk
mkfs.ext4 /dev/loop0
mount /dev/loop0 /mnt/loopfs
cat aio-bench # simplified here
// [global] ioengine=libaio,direct=1,rw=randrw,bs=8k,directory=/mnt/loopfs,time_based,runtime=10
// [libaio.dat] size=2g,iodepth=16
fio aio-bench

-- 
- Thanks.
- xan.peng

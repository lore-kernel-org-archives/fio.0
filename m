Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:45712 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaAYCHF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 24 Jan 2014 21:07:05 -0500
Received: by mail-vc0-f169.google.com with SMTP id hq11so2328892vcb.28
        for <fio@vger.kernel.org>; Fri, 24 Jan 2014 18:07:03 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 24 Jan 2014 18:07:03 -0800
Message-ID: <CAOpYm_W685AkEuFnNZX-m0Jfq+B+crzQv5oEF_Hbvq3XbABhaQ@mail.gmail.com>
Subject: A bug in combining fsrange and verify
From: Wallence Lu <wallencelu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I've hit a bug in using the combination of bsrange and verify.
Basically I want to do a random write test with a variable block size,
and then verify the content after the write. But for some reason, the
verify phase fails consistently.

Linux distribution:
Ubuntu 12.04.2 LTS, Linux version 3.5.0-23-generic
$ fio --version
fio 1.59

Conf file:
[global]
thread=1
ioengine=libaio
buffered=0
direct=1
runtime=5400
write_iolog=./w_iolog2

[rand-write]
bsrange=512-32K
filename=disk.raw
iodepth=1280
size=256M
verify=meta
verify_pattern=0x33
rw=randwrite

The output complains as the following:
Jobs: 1 (f=1): [V] [50.5% done] [0K/0K/0K /s] [0 /0 /0  iops] [eta
01m:40s]     verify: bad magic header 0, wanted acca at file
/home/maohua/test-clone/softwareCache/qemu/iscsi_sdd2/disk.raw offset
1179648, length 0
fio: pid=6118, err=84/file:io_u.c:1477, func=io_u_queued_complete,
error=Invalid or incomplete multibyte or wide character

rand-write: (groupid=0, jobs=1): err=84 (file:io_u.c:1477,
func=io_u_queued_complete, error=Invalid or incomplete multibyte or
wide character): pid=6118: Fri Jan 24 17:40:16 201

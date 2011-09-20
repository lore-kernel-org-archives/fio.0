Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49322 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab1ITKGw (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 20 Sep 2011 06:06:52 -0400
Received: by iaqq3 with SMTP id q3so446290iaq.19
        for <fio@vger.kernel.org>; Tue, 20 Sep 2011 03:06:52 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 20 Sep 2011 18:06:51 +0800
Message-ID: <CAG1+85Fp3HRn+MMQho8X4-34P7mDDdQPj455jCUW3O=wfzPRcQ@mail.gmail.com>
Subject: Fio benchmark output "error=Too many open files
From: yan li <01jay.ly@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi fio users and developers,
    When I run fio benchmark, there are some error in the screen.
    Does someone meet the same circumstances ?
    Thanks, ^_^

#fio fio.cfg
......
fio: pid=29128, err=24/file:filesetup.c:529,
func=open(/mnt/rw1/rw1.168.2), error=Too many open files
fio: pid=29039, err=24/file:filesetup.c:529, func=open(/mnt/rw.79.2),
error=Too many open files
fio: pid=29040, err=24/file:filesetup.c:529, func=open(/mnt/rw.80.2),
error=Too many open files
fio: pid=29074, err=24/file:filesetup.c:529, func=open(/mnt/rw.114.2),
error=Too many open files
fio: pid=29026, err=24/file:filesetup.c:529, func=open(/mnt/rw.66.2),
error=Too many open files
......


OS:Scientific Linux release 6.0 (Carbon)  2.6.32-131.6.1.el6.x86_64 #1
SMP Tue Jul 12 17:14:50 CDT 2011 x86_64 x86_64 x86_64 GNU/Linux

# cat /etc/security/limits.conf
*       hard    nofile  20480

# fio -v
fio 1.57

# cat fio.cfg
[rw]
rw=randread
ioengine=libaio
size=32m
numjobs=128
nrfiles=8
bssplit=512/20:1k/20:2k/10:4k/40:8k/10
directory=/mnt
iodepth=256
zero_buffers
timeout=500
thread
[rw1]
rw=randread
ioengine=libaio
size=32m
numjobs=128
nrfiles=8
bssplit=512/20:1k/20:2k/10:4k/40:8k/10
directory=/mnt/rw1
iodepth=256
zero_buffers
timeout=500
thread
[rw2]
rw=randwrite
ioengine=libaio
size=32m
numjobs=128
nrfiles=8
bssplit=512/20:1k/20:2k/10:4k/40:8k/10
directory=/mnt/rw2
iodepth=256
zero_buffers
timeout=500
thread

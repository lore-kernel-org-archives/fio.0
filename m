Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f172.google.com ([209.85.166.172]:35476 "EHLO
        mail-it1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbeKZGSd (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Nov 2018 01:18:33 -0500
Received: by mail-it1-f172.google.com with SMTP id v11so24369729itj.0
        for <fio@vger.kernel.org>; Sun, 25 Nov 2018 11:26:47 -0800 (PST)
MIME-Version: 1.0
From: Mohanraj B <bmohanraj91@gmail.com>
Date: Mon, 26 Nov 2018 00:56:45 +0530
Message-ID: <CAFF4W0UPjgKPX2t=aqRPsjKN65DJHa46emuTckTOsNx4BYBoZg@mail.gmail.com>
Subject: Re loading libaio engine error and pvsync2 operation not permitted error
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hello,

I am trying to use libaio engine for a job file in my docker
container, but it throws fio: engine libaio not loadable error.

fio --name=hello1 --size=1m --ioengine=libaio

fio: engine libaio not loadable
fio: engine libaio not loadable
fio: failed to load engine
fio: file:ioengines.c:89, func=dlopen, error=libaio: cannot open
shared object file: No such file or directory

Available IO engines:
[root@210df130f2c7 fio-data]# fio --enghelp
Available IO engines:
	cpuio
	mmap
	sync
	psync
	vsync
	pvsync
	pvsync2
	null
	net
	netsplice
	ftruncate
	filecreate
	posixaio
	falloc
	e4defrag
	splice
	mtd
	sg


libaio is not listed above, but its installed in container.

yum install libaio
Loaded plugins: fastestmirror, ovl
Loading mirror speeds from cached hostfile
 * base: ftp.iitm.ac.in
 * extras: ftp.iitm.ac.in
 * updates: ftp.iitm.ac.in
Package libaio-0.3.109-13.el7.x86_64 already installed and latest version
Nothing to do

Centos docker container : centos-release-7-5.1804.5.el7.centos.x86_64


Re pvsync2 operation not permitted error

fio --name=hello --size=10m --ioengine=pvsync2

hello: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=pvsync2, iodepth=1
fio-3.12-18-g92a1
Starting 1 process
hello: Laying out IO file (1 file / 10MiB)
fio: io_u error on file hello.0.0: Operation not permitted: read
offset=0, buflen=4096
fio: pid=59, err=1/file:io_u.c:1789, func=io_u error, error=Operation
not permitted

hello: (groupid=0, jobs=1): err= 1 (file:io_u.c:1789, func=io_u error,
error=Operation not permitted): pid=59: Sun Nov 25 19:23:14 2018
  cpu          : usr=0.00%, sys=0.00%, ctx=2, majf=0, minf=19
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=1,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):

Disk stats (read/write):
  sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

I dont have access to machine running centos, so running in centos
docker container. Are these issues occuring because of running in fio?

host machine OS is ubuntu 18.04.

Thanks and Regards,
Mohan


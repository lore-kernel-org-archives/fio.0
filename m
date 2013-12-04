Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:57571 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602Ab3LDREo (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 Dec 2013 12:04:44 -0500
Received: by mail-la0-f45.google.com with SMTP id eh20so9844710lab.18
        for <fio@vger.kernel.org>; Wed, 04 Dec 2013 09:04:42 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 4 Dec 2013 11:04:42 -0600
Message-ID: <CAEyTGCf_7AqvW45jGouruCoeKqKP7kCs0XGfNoEfGC1X3ZwsWQ@mail.gmail.com>
Subject: Blktrace replay in FIO runs only 1 Job when numjobs>1 in FIO
From: Lakshmi <sendtold@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

 My FIO job File looks like this
[ssd]
rw=randread
bs=4k
iodepth=8
numjobs=8
group_reporting=1
ioengine=sync
filename=/dev/sdb
runtime=120

I ran this job and while this job was running I ran a  Blktrace and
parsed it to a .bin file.

The actual FIO run showed the results of all 8 jobs as below,

ssd: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=8
fio-2.1.4
Starting 8 processes

ssd: (groupid=0, jobs=8): err= 0: pid=9198: Tue Dec  3 18:40:41 2013
  read : io=2545.1MB, bw=21725KB/s, iops=5431, runt=120002msec
....................

However when I replay the .bin trace using read_iolog, the result
shows only 1 job's results as below,

Replay: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
fio-2.1.4
Starting 1 process

Replay: (groupid=0, jobs=1): err= 0: pid=12065: Tue Dec  3 18:56:00 2013
  read : io=39792MB, bw=111409KB/s, iops=1740, runt=365742msec

Any reason for why this is happening?
Am I missing something here?

These are my blktrace and parse commands I use
blktrace -w 130 -d /dev/sdb -a read -b 4096 -o 4K_RR_Trace
blkparse -i ./*.blktrace.0 -d ./bp.bin -o bp.txt -w 0:130


Any pointers appreciated...


Thanks

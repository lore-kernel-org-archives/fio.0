Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41353 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab2F2IJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 29 Jun 2012 04:09:56 -0400
Received: by yenl2 with SMTP id l2so2460378yen.19
        for <fio@vger.kernel.org>; Fri, 29 Jun 2012 01:09:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG1+85FPHgWje5XFFkj3NAQh53c4887749U3E+mcAFshx_arww@mail.gmail.com>
References: <CAG1+85H7VFKnYfuHa--0QkGcZ=J7WVTPUz0E4P31+6OychW-AA@mail.gmail.com>
	<CACiQ3FACDJxKwvzmtQfvaj=iz6dvJe8bbCGLoCk4HHHpCZPyDg@mail.gmail.com>
	<CAG1+85FPHgWje5XFFkj3NAQh53c4887749U3E+mcAFshx_arww@mail.gmail.com>
Date: Fri, 29 Jun 2012 16:09:55 +0800
Message-ID: <CAG1+85EHCjnz6qZ+VAhT+j=DinOFrj2LNSdxCsJ10a7w7wEM-g@mail.gmail.com>
Subject: Re: Single HDD , 700MB/s ??
From: Homer Li <01jay.ly@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Ladies and Gentlemen;

    I enabled debug variable, but I can 't understand these messages.

    BTW,add some hardware information:
    # cat /proc/meminfo  | grep MemTotal
       MemTotal:     24674740 kB
    # /opt/MegaRAID/MegaCli/MegaCli64 -AdpAllInfo -a0 | grep "Memory Size"
       Memory Size      : 256MB

Someone remind me maybe it is the burst rate. he suggest me add
ramp_time. I think ramp_time is not important, the key is wait the
cache be filled.

I enabled raid controller cache, modified iodepth, and add ramp_time,
and wait benchmark was over. I hope it is the burst rate. but the
"crazy" speed go the last second.


Benchmark Detail:

[root@nas-34-1 ~]# cat /tmp/fio2.cfg (the attachment is this benchmark)
[global]
rw=write
ioengine=sync
size=100g
numjobs=8
bssplit=128k/20:256k/20:512k/20:1024k/40
nrfiles=2
iodepth=1
lockmem=2g
direct=1
ramp_time=20
thread

[sdb]
filename=/dev/sdb

#fio --debug=io /tmp/fio2.cfg | tee /tmp/debug
........
Run status group 0 (all jobs):
  WRITE: io=803451MB, aggrb=796952KB/s, minb=99591KB/s,
maxb=99653KB/s, mint=1032187msec, maxt=1032350msec
Disk stats (read/write):
  sdb: ios=0/3419213, merge=0/7, ticks=0/19600644, in_queue=19599902,
util=100.00%

then , I imporved iodepth to 512.
Run status group 0 (all jobs):
  WRITE: io=350805MB, aggrb=320481KB/s, minb=39357KB/s,
maxb=41759KB/s, mint=1120688msec, maxt=1120889msec

Disk stats (read/write):
  sdb: ios=0/1508802, merge=0/170, ticks=0/21431737,
in_queue=21433151, util=100.00%


debug log:
fio: set debug option io
io       27106 load ioengine sync
sdb: (g=0): rw=write, bs=128K-1M/128K-1M, ioengine=sync, iodepth=1
io       27106 load ioengine sync
io       27106 load ioengine sync
io       27106 load ioengine sync
io       27106 load ioengine sync
io       27106 load ioengine sync
io       27106 load ioengine sync
...
io       27106 load ioengine sync
sdb: (g=0): rw=write, bs=128K-1M/128K-1M, ioengine=sync, iodepth=1
fio 2.0.7
Starting 8 threads
io       27106 invalidate cache /dev/sdb: 0/107374182400
io       27106 fill_io_u: io_u 0x2aab2c101910: off=0/len=524288/ddir=1//dev/sdb
io       27106 prep: io_u 0x2aab2c101910: off=0/len=524288/ddir=1//dev/sdb
io       27106 ->prep(0x2aab2c101910)=0
io       27106 queue: io_u 0x2aab2c101910: off=0/len=524288/ddir=1//dev/sdb
io       27106 invalidate cache /dev/sdb: 0/107374182400
io       27106 fill_io_u: io_u 0x116eed00: off=0/len=131072/ddir=1//dev/sdb
io       27106 prep: io_u 0x116eed00: off=0/len=131072/ddir=1//dev/sdb
io       27106 ->prep(0x116eed00)=0
io       27106 queue: io_u 0x116eed00: off=0/len=131072/ddir=1//dev/sdb
io       27106 invalidate cache /dev/sdb: 0/107374182400
io       27106 fill_io_u: io_u 0x116ef010: off=0/len=524288/ddir=1//dev/sdb
io       27106 prep: io_u 0x116ef010: off=0/len=524288/ddir=1//dev/sdb
io       27106 ->prep(0x116ef010)=0
io       27106 queue: io_u 0x116ef010: off=0/len=524288/ddir=1//dev/sdb
io       27106 io complete: io_u 0x2aab2c101910:
off=0/len=524288/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x2aab2c101910:
off=524288/len=131072/ddir=1//dev/sdb
io       27106 prep: io_u 0x2aab2c101910: off=524288/len=131072/ddir=1//dev/sdb
io       27106 ->prep(0x2aab2c101910)=0
io       27106 queue: io_u 0x2aab2c101910: off=524288/len=131072/ddir=1//dev/sdb
io       27106 io complete: io_u 0x116eed00: off=0/len=131072/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x116eed00:
off=131072/len=1048576/ddir=1//dev/sdb
io       27106 prep: io_u 0x116eed00: off=131072/len=1048576/ddir=1//dev/sdb
io       27106 ->prep(0x116eed00)=0
io       27106 queue: io_u 0x116eed00: off=131072/len=1048576/ddir=1//dev/sdb
io       27106 io complete: io_u 0x116ef010: off=0/len=524288/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x116ef010: off=524288/len=262144/ddir=1//dev/sdb
io       27106 prep: io_u 0x116ef010: off=524288/len=262144/ddir=1//dev/sdb
io       27106 ->prep(0x116ef010)=0
io       27106 queue: io_u 0x116ef010: off=524288/len=262144/ddir=1//dev/sdb
io       27106 invalidate cache /dev/sdb: 0/107374182400
io       27106 invalidate cache /dev/sdb: 0/107374182400
io       27106 invalidate cache /dev/sdb: 0/107374182400
io       io       27106 27106 fill_io_u: io_u 0x2aab38000900:
off=0/len=262144/ddir=1fill_io_u: io_u 0x2aab30101ba0:
off=0/len=1048576/ddir=1//dev/sdb//dev/sdb

io       27106 io       io       fill_io_u: io_u 0x2aab30101910:
off=0/len=1048576/ddir=127106 27106 //dev/sdb
io       prep: io_u 0x2aab30101ba0: off=0/len=1048576/ddir=127106
prep: io_u 0x2aab38000900: off=0/len=262144/ddir=1//dev/sdb
//dev/sdb
prep: io_u 0x2aab30101910: off=0/len=1048576/ddir=1//dev/sdb
io       io       27106 27106 io       ->prep(0x2aab38000900)=0
->prep(0x2aab30101ba0)=0
27106 ->prep(0x2aab30101910)=0
io       27106 queue: io_u 0x2aab38000900: off=0/len=262144/ddir=1//dev/sdb
io       27106 queue: io_u 0x2aab30101ba0: off=0/len=1048576/ddir=1//dev/sdb
io       27106 queue: io_u 0x2aab30101910: off=0/len=1048576/ddir=1//dev/sdb
io       27106 invalidate cache /dev/sdb: 0/107374182400
io       27106 fill_io_u: io_u 0x116eea30: off=0/len=262144/ddir=1//dev/sdb
io       27106 prep: io_u 0x116eea30: off=0/len=262144/ddir=1//dev/sdb
io       27106 ->prep(0x116eea30)=0
io       27106 queue: io_u 0x116eea30: off=0/len=262144/ddir=1//dev/sdb
io       27106 invalidate cache /dev/sdb: 0/107374182400
io       27106 fill_io_u: io_u 0x2aab2c101ba0: off=0/len=262144/ddir=1//dev/sdb
io       27106 prep: io_u 0x2aab2c101ba0: off=0/len=262144/ddir=1//dev/sdb
io       27106 ->prep(0x2aab2c101ba0)=0
io       27106 queue: io_u 0x2aab2c101ba0: off=0/len=262144/ddir=1//dev/sdb
io       27106 io complete: io_u 0x2aab2c101910:
off=524288/len=131072/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x2aab2c101910:
off=655360/len=131072/ddir=1//dev/sdb
io       27106 prep: io_u 0x2aab2c101910: off=655360/len=131072/ddir=1//dev/sdb
io       27106 ->prep(0x2aab2c101910)=0
io       27106 queue: io_u 0x2aab2c101910: off=655360/len=131072/ddir=1//dev/sdb
io       27106 io complete: io_u 0x116eed00:
off=131072/len=1048576/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x116eed00:
off=1179648/len=262144/ddir=1//dev/sdb
io       27106 prep: io_u 0x116eed00: off=1179648/len=262144/ddir=1//dev/sdb
io       27106 ->prep(0x116eed00)=0
io       27106 queue: io_u 0x116eed00: off=1179648/len=262144/ddir=1//dev/sdb
io       27106 io complete: io_u 0x116ef010:
off=524288/len=262144/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x116ef010: off=786432/len=524288/ddir=1//dev/sdb
io       27106 prep: io_u 0x116ef010: off=786432/len=524288/ddir=1//dev/sdb
io       27106 ->prep(0x116ef010)=0
io       27106 queue: io_u 0x116ef010: off=786432/len=524288/ddir=1//dev/sdb
io       27106 io complete: io_u 0x2aab30101910:
off=0/len=1048576/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x2aab30101910:
off=1048576/len=262144/ddir=1//dev/sdb
io       27106 prep: io_u 0x2aab30101910: off=1048576/len=262144/ddir=1//dev/sdb
io       27106 ->prep(0x2aab30101910)=0
io       27106 queue: io_u 0x2aab30101910:
off=1048576/len=262144/ddir=1//dev/sdb
io       27106 io complete: io_u 0x2aab38000900:
off=0/len=262144/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x2aab38000900:
off=262144/len=524288/ddir=1//dev/sdb
io       27106 prep: io_u 0x2aab38000900: off=262144/len=524288/ddir=1//dev/sdb
io       27106 ->prep(0x2aab38000900)=0
io       27106 queue: io_u 0x2aab38000900: off=262144/len=524288/ddir=1//dev/sdb
io       27106 io complete: io_u 0x2aab2c101910:
off=655360/len=131072/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x2aab2c101910:
off=786432/len=1048576/ddir=1//dev/sdb
io       27106 prep: io_u 0x2aab2c101910: off=786432/len=1048576/ddir=1//dev/sdb
io       27106 ->prep(0x2aab2c101910)=0
io       27106 queue: io_u 0x2aab2c101910:
off=786432/len=1048576/ddir=1//dev/sdb
io       27106 io complete: io_u 0x116ef010:
off=786432/len=524288/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x116ef010:
off=1310720/len=1048576/ddir=1//dev/sdb
io       27106 prep: io_u 0x116ef010: off=1310720/len=1048576/ddir=1//dev/sdb
io       27106 ->prep(0x116ef010)=0
io       27106 queue: io_u 0x116ef010: off=1310720/len=1048576/ddir=1//dev/sdb
io       27106 io complete: io_u 0x116eed00:
off=1179648/len=262144/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x116eed00:
off=1441792/len=262144/ddir=1//dev/sdb
io       27106 prep: io_u 0x116eed00: off=1441792/len=262144/ddir=1//dev/sdb
io       27106 ->prep(0x116eed00)=0
io       27106 queue: io_u 0x116eed00: off=1441792/len=262144/ddir=1//dev/sdb
io       27106 io complete: io_u 0x2aab38000900:
off=262144/len=524288/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x2aab38000900:
off=786432/len=1048576/ddir=1//dev/sdb
io       27106 prep: io_u 0x2aab38000900: off=786432/len=1048576/ddir=1//dev/sdb
io       27106 ->prep(0x2aab38000900)=0
io       27106 queue: io_u 0x2aab38000900:
off=786432/len=1048576/ddir=1//dev/sdb
io       27106 io complete: io_u 0x2aab2c101910:
off=786432/len=1048576/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x2aab2c101910:
off=1835008/len=1048576/ddir=1//dev/sdb
io       27106 prep: io_u 0x2aab2c101910:
off=1835008/len=1048576/ddir=1//dev/sdb
io       27106 ->prep(0x2aab2c101910)=0
io       27106 queue: io_u 0x2aab2c101910:
off=1835008/len=1048576/ddir=1//dev/sdb
io       27106 io complete: io_u 0x116eed00:
off=1441792/len=262144/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x116eed00:
off=1703936/len=131072/ddir=1//dev/sdb
io       27106 prep: io_u 0x116eed00: off=1703936/len=131072/ddir=1//dev/sdb
io       27106 ->prep(0x116eed00)=0
io       27106 queue: io_u 0x116eed00: off=1703936/len=131072/ddir=1//dev/sdb
io       27106 io complete: io_u 0x2aab38000900:
off=786432/len=1048576/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x2aab38000900:
off=1835008/len=131072/ddir=1//dev/sdb
io       27106 prep: io_u 0x2aab38000900: off=1835008/len=131072/ddir=1//dev/sdb
io       27106 ->prep(0x2aab38000900)=0
io       27106 queue: io_u 0x2aab38000900:
off=1835008/len=131072/ddir=1//dev/sdb
io       27106 io complete: io_u 0x116ef010:
off=1310720/len=1048576/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x116ef010:
off=2359296/len=131072/ddir=1//dev/sdb
io       27106 prep: io_u 0x116ef010: off=2359296/len=131072/ddir=1//dev/sdb
io       27106 ->prep(0x116ef010)=0
io       27106 queue: io_u 0x116ef010: off=2359296/len=131072/ddir=1//dev/sdb
io       27106 io complete: io_u 0x2aab2c101910:
off=1835008/len=1048576/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x2aab2c101910:
off=2883584/len=524288/ddir=1//dev/sdb
io       27106 prep: io_u 0x2aab2c101910: off=2883584/len=524288/ddir=1//dev/sdb
io       27106 ->prep(0x2aab2c101910)=0
io       27106 io complete: io_u 0x116eed00:
off=1703936/len=131072/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x116eed00:
off=1835008/len=131072/ddir=1//dev/sdb
io       27106 prep: io_u 0x116eed00: off=1835008/len=131072/ddir=1//dev/sdb
io       27106 ->prep(0x116eed00)=0
io       27106 queue: io_u 0x2aab2c101910:
off=2883584/len=524288/ddir=1//dev/sdb
io       27106 queue: io_u 0x116eed00: off=1835008/len=131072/ddir=1//dev/sdb
io       27106 io complete: io_u 0x2aab38000900:
off=1835008/len=131072/ddir=1//dev/sdb
io       27106 fill_io_u: io_u 0x2aab38000900:
off=1966080/len=131072/ddir=1//dev/sdb
io       27106 prep: io_u 0x2aab38000900: off=1966080/len=131072/ddir=1//dev/sdb
io       27106 ->prep(0x2aab38000900)=0
io       27106 queue: io_u 0x2aab38000900:
off=1966080/len=131072/ddir=1//dev/sdb
io       27106 io complete: io_u 0x116ef010:
off=2359296/len=131072/ddir=1//dev/sdb


--
Homer Li
ShenZhen GuangDong Province

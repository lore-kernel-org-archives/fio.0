Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E47F3AB48C
	for <fio@vger.kernel.org>; Fri, 31 Jul 2026 11:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785495816; cv=pass; b=pBOPVTnrEhxX4+d8HmOAJpY/9j0DS9OKwQZaHw/SwLZMfKey9vLHCc0nUDIBHzMKcUawl10sDzKruWRckW66vqqHn6vHSNa/sb+/AAAc+8GJK2+Dbx1kV4x3EldL6rsEQN7gy4tJTQryfUcFloK8iFY4Th3eZ3oymEZ/0hFMmX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785495816; c=relaxed/simple;
	bh=uwhzYT9Yv+hewmIVaoYLiF+sXAMq9QNGNj1VYSbR3O0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=ntgLolRCQdzGTGh1GAeAcm3akrVqiRIuYaZcgNfAArD825U5YgCaFgqhgpSLv7TDLYnnWsaBbMgjsYYr45jVmn4SEDb0DLvwIKimqkEUdFbgmpCOsXUieD+dWF1PBvsX9DwCWba5lz3jLtSHNtRsmsHXJ3Widt395HCvTQoe7QE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oLU86xST; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oLU86xST"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c169ae1cb26so326375466b.1
        for <fio@vger.kernel.org>; Fri, 31 Jul 2026 04:03:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785495812; cv=none;
        d=google.com; s=arc-20260327;
        b=k+DOSzJOhCzEK8USsr5whmx0LlSxO08x9M4hWavp/RGZyfFbV4ZTwDC0BJUW129TEs
         R5wDOcVuvJnSMcapTfs+8RtskF+c6MQiomUQoNjv8kn1CsDHIfPDtelQZ37AqtPgAnN/
         8yR6iSQLVv2HX6+tUKdSfI7o5ZvqfOOc+/wIl2a6x1s6GAUEW9fmZ4nKMp3EUg/pzUlb
         EFVcQbSA/i0OS67MIe52+gC+wA4iTKGnG9X8OoIQWPoanLUQgkwvR5vEPORofoyuORZb
         kq6uGg2hQJHRCR+NAMsH4tEz8jny3mM6grY6afolc375m7ZgJPUuw0u+NqIe+wMwYjXU
         qN1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=roD3HTc4bUf8IHFusR0XguwplRv4UOmN/ohYkTqouvs=;
        fh=xFIbq1UZpT6g8ziWONLZH4hX1B/mtjPfigSeF2tZqZc=;
        b=HjCSgWaeh5dz1jTV1RX85p4WwwUlPFnrkW5GrKx0kqAH3YvlV7A9dCiraXcciX+/Te
         5/cl6ji25X9IZbb2B6lliPvXAR+LCp3QiEiXbIJG8ZNEpuEIYJinrjHxqQgdPulnaQAS
         rgGwnici+AKus+rgGffyrWrQiz+jthub9AA8spKctxF1T/rPSPhdyoxG2rHQvVj95eXA
         BylvDOb1fSM47bVKNaBsRDk0n9KuY0g+ZlhwIv1TzBfu56G53l9wNaZgmwBFPTPRXDi6
         O87k7PQ1DbN5DUXMJhPLqSH9UyHlOBQZOWKL5Qxx3jWXjMGLlwL/Aea63VSDCUyzt+PI
         aLzA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785495812; x=1786100612; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=roD3HTc4bUf8IHFusR0XguwplRv4UOmN/ohYkTqouvs=;
        b=oLU86xST/5KOZHUThb/kjxF3u5gt6A2tzBl4AxHOfvyXQBHV6dKVfP9+1hsF0SkmyI
         PjfVlWNFvn/L8DW/jveBz/dMD9B/xBnVBDDpNjTKGDU3LxIh6VGosoadrHw/tIiXvp+Z
         tbr7GwazIJF8zEhhTp/RGQv3H2+U8eWzicOS2OZGnmy2XMFFSDUOYdfj8WSxW1CSZV47
         kDekadg2X8ta+sSGqUtVVAJ2Wfno+niPCByNrkIam8odKvV8Jad6brjRDjTx9Ijz/jTf
         +K/q4aSUcJ4ydNUPQqeuAtgZSgA0IEvoVmdHRXT1oel1bQMdAVeTSL7DZu31mJNahq9E
         YS9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785495812; x=1786100612;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=roD3HTc4bUf8IHFusR0XguwplRv4UOmN/ohYkTqouvs=;
        b=HLO/FasDwS18Qa9l+OHtBS4KlwLipjcxSdF3HCf1S/CRECN+wuCggO0riQ0w1ApCRV
         zJ2IHJaBOIMDKRiW6twRENCPSeS5bjU5fmDanAwJ5H0VA8/b3TdLHOGst4jJXH1ICiVw
         rr1nRITSSe6OEqRYWoailwJP1gMiKits6ThC60R7ufAZT9ns/EYpwH6VTCMPiUt841sj
         wh4n1IIT3HWtj8hRXF+kdp4DyBaTv26KWdx2ydkkjgdpP3uHDJOw6xs5o/qSSkpIMoMY
         EQrDMBO/cFkRgzKvyc9qjwWSq2RMPeQhnMI8cSoYVoA/Gb5rKOSocDolT8/G/31WjNbZ
         pm3w==
X-Gm-Message-State: AOJu0Yz7tRcV6WtY6veyRHYzh+4EjTdO1tqhcuwf6rcflzKdWYgZH/Ec
	3tnEE7F8e1wiPMkjzsmbX+aIzJSbBBN5g6nIGo6yuFWzrS05AAAIIrkOp2IcsWJjs9bPdADECFu
	lY6Aa+q4KktiFtr6P8gL71bvVCSdg2R9r2tHTnFk=
X-Gm-Gg: AR+sD10OmOUaBXxfQ79qJdoXLqNQVA+F4yLLqC9Ep7oZKYOmw+gQ8SvL8s6jautZqbg
	dPGFxPzNInkah6b/8EFgh+5QkE5/N/8yqP7YPH0q0Yf1qABMV3zauNVswgUd+5J+25T5TxPaXJz
	OJ4tHOlZyqkPDgcLdwTGO+v40aSdbjgUO6Vrg7efMarB0MKk5HDKvF3Y1+uNgu/jeF94f+Codc0
	Ujjrwvcjiqv/sUmprSWeAxeg5cNo5xj0qqqua88KUCbRxfkrEyn4aW5/BKaUuSw4JlafnCvdPD7
	FNonxfpJcb88IZNrKMqeBnR091VGic7oBiF/Wins/zo=
X-Received: by 2002:a17:907:9803:b0:c12:cb91:58aa with SMTP id
 a640c23a62f3a-c1fd3ccaa99mr78463966b.24.1785495811998; Fri, 31 Jul 2026
 04:03:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Andrew Ozol <andrew.al.ozol@gmail.com>
Date: Fri, 31 Jul 2026 14:02:41 +0300
X-Gm-Features: AUfX_mypEyauFvOb_-7zNZeVOT2mznpYLpojzjc2qKPtJ1D54SjaF1XGqFwRBNY
Message-ID: <CAH7bCKtfNuuryS8SuW=15eYFgFdqHzMVsB1EdbrXmSMFYa_frA@mail.gmail.com>
Subject: Some Q about fio behavior
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi !
I have a question about the fio program. It's behaving strangely.
General overview: NVME  disk  is connected to a Linux server,
connected via RDMA 100G   from another target server
100G tested iperf3 - 46-55Gb/s on one  stream
The fio program takes measurements this disk in different modes.
With a block size of  64k or less, everything is fine.
 /usr/local/bin/fio readl.fio
nbutest1: (g=0): rw=read, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB,
(T) 64.0KiB-64.0KiB, ioengine=libaio, iodepth=32
...
fio-3.42
Starting 2 processes
Jobs: 1 (f=1): [_(1),R(1)][51.7%][r=543MiB/s][r=8695 IOPS][eta 00m:29s]
nbutest1: (groupid=0, jobs=2): err= 0: pid=56587: Fri Jul 31 05:55:24 2026
  Description  : [Test profile for mixed NBU usage (ZFS and AdvDisk)]
  read: IOPS=75.1k, BW=4694MiB/s (4922MB/s)(145GiB/31576msec)
    slat (usec): min=2, max=121, avg= 5.38, stdev= 1.99
    clat (usec): min=45, max=2149.7k, avg=825.18, stdev=32924.49
     lat (usec): min=50, max=2149.7k, avg=830.57, stdev=32924.54
    clat percentiles (usec):
     |  1.00th=[    265],  5.00th=[    293], 10.00th=[    297],
     | 20.00th=[    302], 30.00th=[    302], 40.00th=[    306],
     | 50.00th=[    306], 60.00th=[    306], 70.00th=[    310],
     | 80.00th=[    314], 90.00th=[    322], 95.00th=[    363],
     | 99.00th=[    553], 99.50th=[    627], 99.90th=[    840],
     | 99.95th=[    996], 99.99th=[2164261]
   bw (  MiB/s): min=   33, max=12902, per=100.00%, avg=9119.37,
stdev=2594.81, samples=65
   iops        : min=  530, max=206444, avg=145910.03, stdev=41516.96,
samples=65
  lat (usec)   : 50=0.01%, 100=0.01%, 250=0.70%, 500=97.95%, 750=1.17%
  lat (usec)   : 1000=0.12%
  lat (msec)   : 2=0.02%, 4=0.01%, 2000=0.01%, >=2000=0.02%
  cpu          : usr=2.15%, sys=18.71%, ctx=966638, majf=0, minf=1058
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued rwts: total=2371506,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0.00ns, window=0.00ns, percentile=100.00%, depth=32

Run status group 0 (all jobs):
   READ: bw=4694MiB/s (4922MB/s), 4694MiB/s-4694MiB/s
(4922MB/s-4922MB/s), io=145GiB (155GB), run=31576-31576msec

Disk stats (read/write):
  nvme3n1: ios=2371474/0, sectors=303548672/0, merge=0/0,
ticks=1871247/0, in_queue=1871247, util=99.71%


With a block size greater than 128k, the program shows extreme
performance degradation.

 /usr/local/bin/fio readl.fio
nbutest1: (g=0): rw=read, bs=(R) 256KiB-256KiB, (W) 256KiB-256KiB, (T)
256KiB-256KiB, ioengine=libaio, iodepth=32
...
fio-3.42
Starting 2 processes
Jobs: 2 (f=0): [f(2)][100.0%][r=16.0MiB/s][r=64 IOPS][eta 00m:00s]
nbutest1: (groupid=0, jobs=2): err= 0: pid=56273: Fri Jul 31 05:51:17 2026
  Description  : [Test profile for mixed NBU usage (ZFS and AdvDisk)]
  read: IOPS=75, BW=19.0MiB/s (19.9MB/s)(226MiB/11883msec)
    slat (usec): min=3, max=288, avg=16.52, stdev=24.97
    clat (usec): min=337, max=2153.6k, avg=843015.17, stdev=1008164.53
     lat (usec): min=341, max=2153.6k, avg=843031.68, stdev=1008162.52
    clat percentiles (usec):
     |  1.00th=[    979],  5.00th=[   1369], 10.00th=[   1680],
     | 20.00th=[   2180], 30.00th=[   2540], 40.00th=[   2999],
     | 50.00th=[   3556], 60.00th=[1115685], 70.00th=[2139096],
     | 80.00th=[2139096], 90.00th=[2164261], 95.00th=[2164261],
     | 99.00th=[2164261], 99.50th=[2164261], 99.90th=[2164261],
     | 99.95th=[2164261], 99.99th=[2164261]
   bw (  KiB/s): min=53248, max=94720, per=100.00%, avg=71509.33,
stdev=7608.82, samples=12
   iops        : min=  208, max=  370, avg=279.33, stdev=29.72, samples=12
  lat (usec)   : 500=0.11%, 750=0.22%, 1000=0.89%
  lat (msec)   : 2=15.63%, 4=37.03%, 10=3.55%, 2000=7.10%, >=2000=35.48%
  cpu          : usr=0.01%, sys=0.06%, ctx=759, majf=0, minf=1049
  IO depths    : 1=0.2%, 2=0.4%, 4=0.9%, 8=1.8%, 16=3.5%, 32=93.1%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=99.8%, 8=0.0%, 16=0.0%, 32=0.2%, 64=0.0%, >=64=0.0%
     issued rwts: total=902,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0.00ns, window=0.00ns, percentile=100.00%, depth=32

Run status group 0 (all jobs):
   READ: bw=19.0MiB/s (19.9MB/s), 19.0MiB/s-19.0MiB/s
(19.9MB/s-19.9MB/s), io=226MiB (236MB), run=11883-11883msec

Disk stats (read/write):
  nvme3n1: ios=838/0, sectors=429056/0, merge=0/0, ticks=622776/0,
in_queue=622776, util=99.18%

Blocksize  128k  work  nonstable , sometimes fine but often not .
In this log fio started with 6GB/s  and  degraded on time

 /usr/local/bin/fio readl.fio
nbutest1: (g=0): rw=read, bs=(R) 128KiB-128KiB, (W) 128KiB-128KiB, (T)
128KiB-128KiB, ioengine=libaio, iodepth=32
...
fio-3.42
Starting 2 processes
Jobs: 2 (f=2): [R(2)][100.0%][eta 00m:00s]
nbutest1: (groupid=0, jobs=2): err= 0: pid=56816: Fri Jul 31 06:05:35 2026
  Description  : [Test profile for mixed NBU usage (ZFS and AdvDisk)]
  read: IOPS=13.8k, BW=1720MiB/s (1804MB/s)(50.8GiB/30245msec)
    slat (nsec): min=1784, max=227865, avg=11671.26, stdev=6115.04
    clat (usec): min=101, max=2151.9k, avg=4637.88, stdev=86563.91
     lat (usec): min=121, max=2151.9k, avg=4649.55, stdev=86563.97
    clat percentiles (usec):
     |  1.00th=[    461],  5.00th=[    570], 10.00th=[    627],
     | 20.00th=[    725], 30.00th=[    807], 40.00th=[    889],
     | 50.00th=[    971], 60.00th=[   1074], 70.00th=[   1188],
     | 80.00th=[   1352], 90.00th=[   1631], 95.00th=[   1958],
     | 99.00th=[   3064], 99.50th=[   3687], 99.90th=[2139096],
     | 99.95th=[2164261], 99.99th=[2164261]
   bw (  MiB/s): min=   29, max= 8818, per=100.00%, avg=4182.98,
stdev=1767.25, samples=49
   iops        : min=  234, max=70548, avg=33463.84, stdev=14138.02, samples=49
  lat (usec)   : 250=0.01%, 500=1.96%, 750=21.48%, 1000=29.45%
  lat (msec)   : 2=42.50%, 4=4.22%, 10=0.21%, 2000=0.02%, >=2000=0.15%
  cpu          : usr=1.50%, sys=9.16%, ctx=244084, majf=0, minf=1052
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued rwts: total=416232,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0.00ns, window=0.00ns, percentile=100.00%, depth=32

Run status group 0 (all jobs):
   READ: bw=1720MiB/s (1804MB/s), 1720MiB/s-1720MiB/s
(1804MB/s-1804MB/s), io=50.8GiB (54.6GB), run=30245-30245msec

Disk stats (read/write):
  nvme3n1: ios=416168/0, sectors=106539008/0, merge=0/0,
ticks=1790272/0, in_queue=1790272, util=99.70%




When running, a typical picture is that only the completion percentage
is updated, and the write speed is displayed intermittently.
When running in this mode, the program uses almost no CPU and performs
no I/O operations.
  56279 root      20   0  227616  18044  15400 R   1.3   0.0   0:00.34 top
  56379 root      20   0  400680  11144   2024 S   0.3   0.0   0:00.02 fio
  56380 root      20   0  400684  11148   2028 S   0.3   0.0   0:00.23 fio
      1 root      20   0  175856  18356  11196 S   0.0   0.0   0:17.32 systemd
      2 root      20   0       0      0      0 S   0.0   0.0   0:00.91 kthreadd
      3 root      20   0       0      0      0 S   0.0   0.0   0:00.00
pool_workqueue_release
      4 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
kworker/R-kvfree_rcu_reclaim

In normal  mode
 56587 root      20   0  394536   4936   1960 S  29.8   0.0   0:04.05 fio
  56588 root      20   0  394540   5000   2024 S  24.6   0.0   0:04.65 fio
  56279 root      20   0  227616  18044  15400 R   1.3   0.0   0:02.25 top
      1 root      20   0  175856  18356  11196 S   0.0   0.0   0:17.32 systemd

   2,884,812      syscalls:sys_enter_io_getevents
                 0      syscalls:sys_enter_io_cancel
         2,884,872      syscalls:sys_enter_io_submit

in bad mode
 12,455      syscalls:sys_enter_io_getevents
 0      syscalls:sys_enter_io_cancel
12,515      syscalls:sys_enter_io_submit

Also noticed - write work perfectly
 /usr/local/bin/fio readl.fio
nbutest1: (g=0): rw=write, bs=(R) 256KiB-256KiB, (W) 256KiB-256KiB,
(T) 256KiB-256KiB, ioengine=libaio, iodepth=32
...
fio-3.42
Starting 2 processes
Jobs: 2 (f=2): [W(2)][100.0%][w=4979MiB/s][w=19.9k IOPS][eta 00m:00s]
nbutest1: (groupid=0, jobs=2): err= 0: pid=57288: Fri Jul 31 06:38:41 2026
  Description  : [Test profile for mixed NBU usage (ZFS and AdvDisk)]
  write: IOPS=20.0k, BW=5007MiB/s (5250MB/s)(147GiB/30004msec)
    slat (usec): min=4, max=130, avg=21.72, stdev= 8.59
    clat (usec): min=446, max=39748, avg=3172.51, stdev=465.43
     lat (usec): min=467, max=39755, avg=3194.23, stdev=465.27
    clat percentiles (usec):
     |  1.00th=[ 2737],  5.00th=[ 2900], 10.00th=[ 3032], 20.00th=[ 3130],
     | 30.00th=[ 3130], 40.00th=[ 3130], 50.00th=[ 3130], 60.00th=[ 3163],
     | 70.00th=[ 3163], 80.00th=[ 3163], 90.00th=[ 3294], 95.00th=[ 3425],
     | 99.00th=[ 4293], 99.50th=[ 5342], 99.90th=[ 6259], 99.95th=[ 6390],
     | 99.99th=[39060]
   bw (  MiB/s): min= 4622, max= 5555, per=100.00%, avg=5007.75,
stdev=81.35, samples=120
   iops        : min=18490, max=22220, avg=20031.00, stdev=325.40, samples=120
  lat (usec)   : 500=0.01%, 750=0.01%, 1000=0.01%
  lat (msec)   : 2=0.04%, 4=98.84%, 10=1.10%, 20=0.01%, 50=0.01%
  cpu          : usr=10.56%, sys=17.01%, ctx=544964, majf=0, minf=41
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,600930,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0.00ns, window=0.00ns, percentile=100.00%, depth=32

Run status group 0 (all jobs):
  WRITE: bw=5007MiB/s (5250MB/s), 5007MiB/s-5007MiB/s
(5250MB/s-5250MB/s), io=147GiB (158GB), run=30004-30004msec

Disk stats (read/write):
  nvme3n1: ios=46/598623, sectors=2120/306494976, merge=0/0,
ticks=5/1895648, in_queue=1895653, util=99.70%

Also 2  - another remote NVME  on this server  fio work fine
Also 3  - problem nvme3  connect to another server  and work fine on  it


It seems like the program is waiting for some resource or event.
Since you know the program well, please suggest a direction for
further research.

Description :

 cat readl.fio
[global]
ioengine=libaio
direct=1
group_reporting
runtime=30s
time_based
#ramp_time=60s
iodepth=32
randrepeat=0
size=100%

[nbu-randrw-1]
name=nbutest1
description=Test profile for mixed NBU usage (ZFS and AdvDisk)
rw=read
percentage_random=80
rwmixread=10
blocksize=256k
#bssplit=4k/35:8k/5:16k/12:32k/18:64k/21:128k/2:256k/7,4k/6:128k/96
numjobs=2
filename=/dev/nvme3n1

Host server
 6.12.0 uek #14 SMP PREEMPT_DYNAMIC Fri Jul 17 08:19:11 EDT 2026
x86_64 x86_64 x86_64 GNU/Linux
:Oracle Linux Server release 9.8
Tested   non-UEK  kernel and    5.14  - same shit's
nvme list -v
Subsystem        Subsystem-NQN
                                           Controllers
----------------
------------------------------------------------------------------------------------------------
----------------
nvme-subsys0     nqn.2021-04.com.intel
                      nvme0
nvme-subsys1     nqn.2021-04.com.intel
                      nvme1
nvme-subsys2     lnv02
                                           nvme2
nvme-subsys3     lnv022
                                           nvme3
nvme-subsys4     testnvmed1
                                           nvme4

Device           Cntlid SN                   MN
               FR       TxPort Address        Slot   Subsystem
Namespaces
---------------- ------ --------------------
---------------------------------------- -------- ------
-------------- ------ ------------ ----------------
nvme0            0         INTEL SSDPF2KX076TZ
JCV10100 pcie   0000:e5:00.0   31     nvme-subsys0 nvme0n1
nvme1            0         INTEL SSDPF2KX076TZ
JCV10100 pcie   0000:e6:00.0   32     nvme-subsys1 nvme1n1
nvme2            1      157a1ab42ded7b6f7fb8 Linux
               5.14.0-6 rdma   traddr=172.16.251.24,trsvcid=4421
 nvme-subsys2 nvme2n1
nvme3            2      50682e73829246a799a4 Linux
               5.14.0-6 rdma   traddr=172.16.251.24,trsvcid=4421
 nvme-subsys3 nvme3n1
nvme4            2      b18b7211f1c0bdc89a80 Linux
               6.12.0-a rdma   traddr=172.16.251.26,trsvcid=4420
 nvme-subsys4 nvme4n1

Device            Generic           NSID       Usage
                          Format           Controllers
----------------- ----------------- ----------
------------------------------------------------- ----------------
----------------
/dev/nvme0n1      /dev/ng0n1        0x1          7.68 TB /   7.68 TB (
  6.99 TiB /    6.99 TiB) 512   B +  0 B   nvme0
/dev/nvme1n1      /dev/ng1n1        0x1          7.68 TB /   7.68 TB (
  6.99 TiB /    6.99 TiB) 512   B +  0 B   nvme1
/dev/nvme2n1      /dev/ng2n1        0x1          3.20 TB /   3.20 TB (
  2.91 TiB /    2.91 TiB)   4 KiB +  0 B   nvme2
/dev/nvme3n1      /dev/ng3n1        0x1          3.20 TB /   3.20 TB (
  2.91 TiB /    2.91 TiB)   4 KiB +  0 B   nvme3
/dev/nvme4n1      /dev/ng4n1        0x1        644.25 GB / 644.25 GB (
600.00 GiB /  600.00 GiB) 512   B +  0 B   nvme4




Target server
5.14.0-611.20.1.el9_7.x86_64 #1 SMP PREEMPT_DYNAMIC Mon Jan 12
03:45:27 PST 2026 x86_64 x86_64 x86_64
Oracle Linux Server release 9.7

I will gather additional information.


WBR    Andy

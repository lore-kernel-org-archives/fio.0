Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.teamix.de ([194.150.191.118]:37171 "EHLO
	mailout.teamix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933967AbbCDJMM convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 4 Mar 2015 04:12:12 -0500
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: Bug#779336: fio: calc_clat_percentiles() create unaligned access on armhf
Date: Wed, 4 Mar 2015 10:12:08 +0100
Message-ID: <1794059.2h3Ngk0LJU@merkaba>
In-Reply-To: <20150227111544.3704.27235.reportbug@localhost>
References: <20150227111544.3704.27235.reportbug@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Andreas =?ISO-8859-1?Q?Bie=DFmann?= <andreas@biessmann.de>, 779336@bugs.debian.org

﻿Hello Andreas, hello Jens,

thank you for your bug report.

This sounds like an upstream bug, thus I cc fio mailing list.

Jens, any idea?


For reference, Debian bug report is at:
https://bugs.debian.org/779336

Thanks,
Martin

Am Freitag, 27. Februar 2015, 12:15:44 schrieben Sie:
> Package: fio
> Version: 2.1.11-2
> Severity: important
> 
> Dear Maintainer,
> 
> when performing an extended workload with fio on a armhf box fio ends witch a
> bus error. It happens while calculating the clat values of a specific test case.
> The same error does not show up when running a simple read test.
> 
> The program output is a follows
> ---8<---
> andreas@cubieboard2 % fio four-threads-randio.fio
> bgwriter: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
> queryA: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
> queryB: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
> bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=16
> fio-2.1.11
> Starting 4 processes
> Jobs: 1 (f=1): [_(1),r(1),_(2)] [99.6% done] [3017KB/0KB/0KB /s] [754/0/0 iops] [eta 00m:02s]    
> bgwriter: (groupid=0, jobs=1): err= 0: pid=3459: Fri Feb 27 10:40:38 2015
>   write: io=128000KB, bw=333561B/s, iops=81, runt=392947msec
>     slat (usec): min=33, max=81636, avg=141.64, stdev=1609.52
>     clat (usec): min=644, max=4307.2K, avg=392735.17, stdev=619005.07
>      lat (usec): min=748, max=4307.3K, avg=392881.68, stdev=619036.45
>     clat percentiles (usec):
>      |  1.00th=[ 1352],  5.00th=[ 2128], 10.00th=[ 3280], 20.00th=[ 5344],
>      | 30.00th=[ 7520], 40.00th=[10816], 50.00th=[19840], 60.00th=[37120],
>      | 70.00th=[428032], 80.00th=[1220608], 90.00th=[1302528], 95.00th=[1351680],
>      | 99.00th=[2539520], 99.50th=[2637824], 99.90th=[3751936], 99.95th=[3883008],
>      | 99.99th=[4292608]
>     bw (KB  /s): min=   57, max= 3233, per=96.43%, avg=353.90, stdev=310.19
>     lat (usec) : 750=0.08%, 1000=0.24%
>     lat (msec) : 2=4.10%, 4=8.83%, 10=25.07%, 20=11.80%, 50=13.58%
>     lat (msec) : 100=4.88%, 250=0.43%, 500=2.27%, 750=1.83%, 1000=2.26%
>     lat (msec) : 2000=22.83%, >=2000=1.78%
>   cpu          : usr=0.25%, sys=1.12%, ctx=15458, majf=0, minf=14
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=99.9%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
>      issued    : total=r=0/w=32000/d=0, short=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=32
> queryA: (groupid=0, jobs=1): err= 0: pid=3460: Fri Feb 27 10:40:38 2015
>   read : io=128000KB, bw=264627B/s, iops=64, runt=495307msec
>     clat (usec): min=211, max=670833, avg=15437.00, stdev=28506.89
>      lat (usec): min=213, max=670837, avg=15440.17, stdev=28506.95
> [1]    3457 bus error (core dumped)  fio four-threads-randio.fio
> fio four-threads-randio.fio  6,64s user 24,31s system 6% cpu 8:16,44 total
> ---->8---
> 
> The bus error turns out to be a alignment exception on my armhf box.
> 
> Kernel issues the following
> ---8<---
> [57912.593192] Alignment trap: not handling instruction ed937b00 at [<0001e2b0>]
> [57912.600408] Unhandled fault: alignment exception (0x221) at 0x00f625be
> --->8---
> 
> Investigating the core gives me
> ---8<---
> andreas@cubieboard2 % gdb /usr/bin/fio core
> GNU gdb (Debian 7.7.1+dfsg-5) 7.7.1
> Copyright (C) 2014 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "arm-linux-gnueabihf".
> Type "show configuration" for configuration details.
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>.
> Find the GDB manual and other documentation resources online at:
> <http://www.gnu.org/software/gdb/documentation/>.
> For help, type "help".
> Type "apropos word" to search for commands related to "word"...
> Reading symbols from /usr/bin/fio...(no debugging symbols found)...done.
> [New LWP 3457]
> [New LWP 3458]
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib/arm-linux-gnueabihf/libthread_db.so.1".
> Core was generated by `fio four-threads-randio.fio'.
> Program terminated with signal SIGBUS, Bus error.
> #0  0x0001e2b4 in calc_clat_percentiles ()
> (gdb) bt
> #0  0x0001e2b4 in calc_clat_percentiles ()
> #1  0x00000000 in ?? ()
> (gdb) 
> --->8---
> 
> The test runs with the following configuration
> ---8<---
> ; Four threads, two query, two writers.
> 
> [global]
> rw=randread
> size=125m
> directory=/mnt/fio-testing/data
> ioengine=libaio
> iodepth=4
> invalidate=1
> direct=1
> 
> [bgwriter]
> rw=randwrite
> iodepth=32
> 
> [queryA]
> iodepth=1
> ioengine=mmap
> direct=0
> thinktime=3
> 
> [queryB]
> iodepth=1
> ioengine=mmap
> direct=0
> thinktime=5
> 
> [bgupdater]
> rw=randrw
> iodepth=16
> thinktime=40
> size=32m
> --->8---
> 
> 
> -- System Information:
> Debian Release: 8.0
>   APT prefers testing-updates
>   APT policy: (500, 'testing-updates'), (500, 'testing')
> Architecture: armhf (armv7l)
> 
> Kernel: Linux 3.16.0-4-armmp-lpae (SMP w/2 CPU cores)
> Locale: LANG=de_DE.UTF-8, LC_CTYPE=de_DE.UTF-8 (charmap=UTF-8) (ignored: LC_ALL set to de_DE.UTF-8)
> Shell: /bin/sh linked to /bin/dash
> Init: systemd (via /run/systemd/system)
> 
> Versions of packages fio depends on:
> ii  libaio1      0.3.110-1
> ii  libc6        2.19-13
> ii  libibverbs1  1.1.8-1
> ii  librados2    0.80.7-2
> ii  librbd1      0.80.7-2
> ii  librdmacm1   1.0.19.1-1
> ii  python       2.7.8-3
> ii  zlib1g       1:1.2.8.dfsg-2+b1
> 
> fio recommends no packages.
> 
> Versions of packages fio suggests:
> pn  gnuplot  <none>
> 
> -- no debconf information


-- 
Martin Steigerwald  | Consultant / Trainer

teamix GmbH
Südwestpark 43
90449 Nürnberg

Tel.:  +49 911 30999 55 | Fax: +49 911 30999 99
mail: martin.steigerwald@teamix.de | web:  http://www.teamix.de | blog: http://blog.teamix.de

Amtsgericht Nürnberg, HRB 18320 | Geschäftsführer: Oliver Kügow, Richard Müller


***Nicht verpassen: Wissenstag - Software defined Datacenter (SDDC)***
10.03. Nürnberg | 11.03. Mainz | 24.03. Bayreuth | 25.03. München
Jetzt anmelden unter: www.teamix.de/wissenstag


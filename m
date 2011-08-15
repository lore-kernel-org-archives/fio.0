Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:39024 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab1HOGy7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 15 Aug 2011 02:54:59 -0400
Message-ID: <4E48C2C1.60307@kernel.dk>
Date: Mon, 15 Aug 2011 08:54:57 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] stats: Add a function to report completion latency percentiles
References: <1313175153-5355-1-git-send-email-yjhong@google.com> <4E45AF96.4070606@kernel.dk> <CAC8teKW=oXw5LSsH_4rVdOtCkunoSEDo-jS_FUbVgFgjnrzzjw@mail.gmail.com>
In-Reply-To: <CAC8teKW=oXw5LSsH_4rVdOtCkunoSEDo-jS_FUbVgFgjnrzzjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Zhu Yanhai <zhu.yanhai@gmail.com>
Cc: Yu-ju Hong <yjhong@google.com>, fio@vger.kernel.org, Nauman Rafique <nauman@google.com>, Eric Gouriou <egouriou@google.com>, Yu-Ju Hong <yuju.hong@gmail.com>

On 2011-08-15 05:56, Zhu Yanhai wrote:
> Hi,
> This commit breaks the calculation of iops.
> Before this commit, the iops from group_report is 1467, see below:
> 
> chenyun@test023057.sqa.cm4 fio]$ sudo ./fio ~/iotest/readdev
> thread16: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
> ...
> thread16: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
> fio 1.57
> Starting 10 threads
> Jobs: 10 (f=10): [rrrrrrrrrr] [100.0% done] [5929K/0K /s] [1447 /0
> iops] [eta 00m:00s]
> thread16: (groupid=0, jobs=10): err= 0: pid=19538
>   read : io=176212KB, bw=5871.6KB/s, iops=1467 , runt= 30011msec
> [cut here]
> 
> 
> After this commit, the reported iops is 266, which is only one thread's output,
> not group_reporting, see below:
> 
> [chenyun@test023057.sqa.cm4 fio]$ sudo ./fio ~/iotest/readdev
> thread16: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
> ...
> thread16: (g=0): rw=randread, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
> fio 1.57
> Starting 10 threads
> Jobs: 10 (f=10): [rrrrrrrrrr] [100.0% done] [6033K/0K /s] [1473 /0
> iops] [eta 00m:00s]
> thread16: (groupid=0, jobs=10): err= 0: pid=19692
>   read : io=351720KB, bw=1065.7KB/s, iops=266 , runt=330046msec
> [cut here]

The patch does indeed appear to have broken output for more than 1
thread in general, even without group_reporting things are not right. It
also crashes here for me now:

*** glibc detected *** ./fio: double free or corruption (!prev):
0x00000000006a3a90 ***
======= Backtrace: =========
/lib/x86_64-linux-gnu/libc.so.6(+0x78a8f)[0x7f6ed5dbba8f]
/lib/x86_64-linux-gnu/libc.so.6(cfree+0x73)[0x7f6ed5dbf8e3]
./fio(show_run_stats+0xb8c)[0x410fec]
./fio(main+0x315)[0x40afa5]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xff)[0x7f6ed5d61eff]
./fio[0x4069c9]
======= Memory map: ========
00400000-00440000 r-xp 00000000 08:02 10025
/home/axboe/git/fio/fio
0063f000-00640000 r--p 0003f000 08:02 10025
/home/axboe/git/fio/fio
00640000-0069c000 rw-p 00040000 08:02 10025
/home/axboe/git/fio/fio
0069c000-006c4000 rw-p 00000000 00:00 0
[heap]
7f6ecc000000-7f6ecc021000 rw-p 00000000 00:00 0 
7f6ecc021000-7f6ed0000000 ---p 00000000 00:00 0 
7f6ed2db8000-7f6ed2dcd000 r-xp 00000000 08:03 655591
/lib/x86_64-linux-gnu/libgcc_s.so.1

gdb) l *show_run_stats+0xb8c
0x410fec is in show_run_stats (stat.c:858).
854             }
855     
857             free(runstats);
858             free(threadstats);
859     }

which just looks like overrun somewhere, corrupting the heap. Yu-ju, did
you test with numjobs > 1?

-- 
Jens Axboe


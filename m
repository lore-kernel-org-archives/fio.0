Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:55746 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbcCCDDc (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 Mar 2016 22:03:32 -0500
Message-ID: <56D7A97F.9080800@vlnb.net>
Date: Wed, 02 Mar 2016 19:03:27 -0800
From: Vladislav Bolkhovitin <vst@vlnb.net>
MIME-Version: 1.0
Subject: Re: Fio high IOPS measurement mistake
References: <56D525E1.6010407@vlnb.net> <CALjAwxjLb7L8sZCensSNXZ4kDyHb683bu-zuwDvgk5sFoeMckw@mail.gmail.com> <56D66B1C.6050506@vlnb.net>
In-Reply-To: <56D66B1C.6050506@vlnb.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Vladislav Bolkhovitin wrote on 03/01/2016 08:25 PM:
> Hi,
> 
> Sitsofe Wheeler wrote on 02/29/2016 10:01 PM:
>> Hi,
>>
>> On 1 March 2016 at 05:17, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>>> Hello,
>>>
>>> I'm currently looking at one NVRAM device, and during fio tests noticed that each fio
>>> thread consumes 30% of user space CPU. I'm using ioengine=libaio, buffered=0, sync=0
>>> and direct=1, so user space CPU consumption should be virtually zero.
>>>
>>> That 30% user CPU consumption makes me suspect that this is overhead for internal fio
>>> housekeeping, i.e., scientifically speaking, fio instrumental measurement mistake (I
>>> hope, I'm using correct English terms).
>>>
>>> Can anybody comment it and suggest how to decrease this user space CPU consumption?
>>>
>>> Here is my full fio job:
>>>
>>> [global]
>>> ioengine=libaio
>>> buffered=0
>>> sync=0
>>> direct=1
>>> randrepeat=1
>>> softrandommap=1
>>> rw=randread
>>> bs=4k
>>> filename=./nvram (it's a link to a block device)
>>> exitall=1
>>> thread=1
>>> disable_lat=1
>>> disable_slat=1
>>> disable_clat=1
>>> loops=10
>>> iodepth=16
>>
>> You appear to be missing gtod_reduce
>> (https://github.com/axboe/fio/blob/fio-2.6/HOWTO#L1668 ) or
>> gettimeofday cpu pinning. You also aren't using batching
>> (https://github.com/axboe/fio/blob/fio-2.6/HOWTO#L815 ).
> 
> Thanks, I tried them, but they did not make any significant difference. The biggest
> difference I had was when I changed CPU governor to "performance". Now I have 20-25%
> user space, measured by fio itself, it's coherent with top. Note, I'm considering
> per-thread CPU consumption, to see it in top you need to press '1' (one line per each CPU).
> 
> I also tried to short circuit the sync engine by calling fio_io_end() directly from top
> of fio_syncio_queue(), so no actual IO is done. The results were interesting enough to
> publish here in details (%% are per job):
> 
> Jobs	IOPS(M)	%user	%sys
> 1	4.3	78	22
> 2	7.6	67	33
> 3	10.5	65	35
> 4	7.7	61	38
> 5	4.8	78	22
> 6	4.7	83	17
> 7	4.8	84	15

Update, since I realized that I forgot to short circuit lseek calls as well. After I
done it in fio_syncio_prep(), the results significantly changed and became much more as
expected:

Jobs	IOPS(M)	%user	%sys
1	6.9	100	0
2	13.6	100	0
3	19.5	100	0
4	25.1	100	0
5	32.5	100	0
6	38.1	100	0
7	45.5	100	0
8	50.8	100	0

So, apparently, the lseek calls were responsible for (1) such significant overhead
(4.3M vs 6.9M single), (2) such poor scalability (10.5M vs 50.8) and (3) the
significant 15-38% sys load in the previous tests.

Such lseeks influence should not be so big, because each job supposed to have
independent, dedicated file handle, correct? It together with 6.9M IOPS per job in the
new result seem to me that very similar problem with libaio might be responsible for
the overhead that made me start this thread (25% user space on 600K IOPS). Don't know
how to check it though, because libaio engine is not so simple to short circuit. Perf
is not helpful, because it produces essentially the same trace as below with no libaio
mentioned anyhow. Oprofile also does not anyhow point out to libaio.

For those who asked about perf profiling, it remained the same as before with the CPU
consumption is all about timekeeping and memset:

-  55.74%  fio  fio                [.] clock_thread_fn
     clock_thread_fn
-   7.11%  fio  [vdso]             [.] 0x00000000000007c2
     0x7ffc411657c2
     __clock_gettime
     0x7ffc411657c6
     __clock_gettime
     0x7ffc4116570d
     __clock_gettime
     0x7ffc411657cb
     __clock_gettime
     0x7ffc41165720
     __clock_gettime
     0x7ffc411657c0
     __clock_gettime
     0x7ffc411657cf
     __clock_gettime
     0x7ffc411657c7
     __clock_gettime
     0x7ffc41165700
-   5.37%  fio  [kernel.kallsyms]  [k] system_call
     system_call
     0x7ffc411657c2
-   3.70%  fio  [kernel.kallsyms]  [k] system_call_after_swapgs
   + system_call_after_swapgs
   + 0x7ffc411657c2
-   3.18%  fio  [kernel.kallsyms]  [k] copy_user_enhanced_fast_string
     copy_user_enhanced_fast_string
     sys_clock_gettime
     system_call_fastpath
     0x7ffc411657c2
     0x7ffc411657c2
-   2.55%  fio  libc-2.19.so       [.] memset
     memset
     0x7320676e69737261
-   2.43%  fio  fio                [.] calibrate_cpu_clock
     calibrate_cpu_clock
+   2.31%  fio  [kernel.kallsyms]  [k] getrawmonotonic
+   1.85%  fio  [kernel.kallsyms]  [k] page_fault
+   1.62%  fio  [kernel.kallsyms]  [k] native_read_tsc
+   1.56%  fio  [kernel.kallsyms]  [k] sys_clock_gettime
+   1.53%  fio  libc-2.19.so       [.] msort_with_tmp.part.0
+   0.96%  fio  [kernel.kallsyms]  [k] clear_page_c_e
+   0.92%  fio  [kernel.kallsyms]  [k] sysret_check
+   0.87%  fio  [kernel.kallsyms]  [k] shmem_getpage_gfp
+   0.58%  fio  [kernel.kallsyms]  [k] read_tsc
+   0.46%  fio  libc-2.19.so       [.] __clock_gettime
+   0.45%  fio  libc-2.19.so       [.] __memcpy_sse2

With sequential reads, i.e. with no random numbers generation and tracking, the results
were:

Jobs	IOPS(M)	%user	%sys
1	7.3	100	0
2	14.7	100	0
3	20.8	100	0
4	27.8	100	0
5	34.7	100	0
6	41.6	100	0
7	48.6	100	0
8	55.4	100	0

So, overhead of the random numbers generation and tracking with used jobs parameters is
about 6-9% or 0.4M IOPS per job, which is quite OK, I'd say.

Vlad

> Results were very consistent between runs. CPU - 8 cores Intel Xeon E5-2667 v3 @
> 3.20GHz with 20M L3 cache and HT. Fio is the latest git.



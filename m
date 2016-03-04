Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:53644 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbcCDEga (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 3 Mar 2016 23:36:30 -0500
Message-ID: <56D910C4.3070106@vlnb.net>
Date: Thu, 03 Mar 2016 20:36:20 -0800
From: Vladislav Bolkhovitin <vst@vlnb.net>
MIME-Version: 1.0
Subject: Re: Fio high IOPS measurement mistake
References: <56D525E1.6010407@vlnb.net> <CALjAwxjLb7L8sZCensSNXZ4kDyHb683bu-zuwDvgk5sFoeMckw@mail.gmail.com> <56D66B1C.6050506@vlnb.net> <94D0CD8314A33A4D9D801C0FE68B40295C349408@G9W0745.americas.hpqcorp.net> <56D7A964.3040809@vlnb.net> <94D0CD8314A33A4D9D801C0FE68B40295C34C8DB@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295C34C8DB@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Elliott, Robert (Persistent Memory) wrote on 03/03/2016 01:03 PM:
>> -----Original Message-----
>> From: Vladislav Bolkhovitin [mailto:vst@vlnb.net]
>> Sent: Wednesday, March 2, 2016 9:03 PM
>> To: Elliott, Robert (Persistent Memory) <elliott@hpe.com>; Sitsofe Wheeler
>> <sitsofe@gmail.com>; fio@vger.kernel.org
>> Subject: Re: Fio high IOPS measurement mistake
>>
> ...
>>
>> Overall, I appreciate your help, but again, question is not how to improve
>> my results.
>> The question is how to _decrease fio overhead_ with libaio, see subject of
>> this e-mail.
>> It's very different question.
>>
>> Thanks,
>> Vlad
> 
> Here are some example results on one of my test systems with 4.4rc2, 
> showing %usr around 19%.
> 
> This job file:
> [global]
> direct=1
> ioengine=libaio
> norandommap
> randrepeat=0
> bs=4k
> iodepth=1       # irrelevant for pmem
> runtime=600
> time_based=1
> group_reporting
> thread
> gtod_reduce=1   # reduce=1 except for latency test
> zero_buffers
> cpus_allowed_policy=split
> numjobs=16
> 
> [drive_0]
> filename=/dev/pmem0
> cpus_allowed=0-63
> rw=randread
> 
> [drive_1]
> filename=/dev/pmem1
> cpus_allowed=0-63
> rw=randread
> 
> [drive_2]
> filename=/dev/pmem2
> cpus_allowed=0-63
> rw=randread
> 
> [drive_3]
> filename=/dev/pmem3
> cpus_allowed=0-63
> rw=randread
> 
> yields about 16M IOPS:
>   read : io=9013.8GB, bw=63505MB/s, iops=16257K, runt=145344msec
>   cpu          : usr=19.04%, sys=80.86%, ctx=79415, majf=0, minf=4521
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=2362899826/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> with mpstat 1 reporting about 19% usr, 91% sys:
> 02:17:13 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
> 02:17:14 PM  all   19.11    0.00   80.89    0.00    0.00    0.00    0.00    0.00    0.00    0.00
> 02:17:15 PM  all   19.19    0.00   80.81    0.00    0.00    0.00    0.00    0.00    0.00    0.00
> 02:17:16 PM  all   19.27    0.00   80.73    0.00    0.00    0.00    0.00    0.00    0.00    0.00
> 02:17:17 PM  all   19.26    0.00   80.74    0.00    0.00    0.00    0.00    0.00    0.00    0.00
> 
> With this test, the thread and zero_buffers options don't matter.
> 
> The system has 4 NUMA nodes; restricting cpus_allowed to local CPUs
> for each pmem device raises that to 20M IOPS.  
>   read : io=7998.5GB, bw=78461MB/s, iops=20086K, runt=104388msec
>   cpu          : usr=19.55%, sys=56.98%, ctx=43481, majf=0, minf=3956
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=2096751180/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> perf top --dsos fio:
>    3.00%  [.] get_io_u
>    2.22%  [.] get_next_rand_offset
>    2.15%  [.] thread_main
>    2.11%  [.] io_u_queued_complete
>    1.64%  [.] td_io_queue
>    1.44%  [.] __get_io_u
>    1.40%  [.] io_completed
>    1.17%  [.] fio_libaio_commit
>    0.93%  [.] fio_libaio_prep
>    0.84%  [.] utime_since_now
>    0.74%  [.] wait_for_completions
>    0.67%  [.] fio_libaio_queue
>    0.60%  [.] fio_libaio_getevents
>    0.54%  [.] td_io_getevents
> 
> perf top -g:
> +   67.45%     0.45%  [kernel]                 [k] entry_SYSCALL_64_fastpath
> +   63.61%     0.68%  libaio.so.1.0.1          [.] io_submit
> +   61.08%     0.10%  [kernel]                 [k] sys_io_submit
> +   59.96%     1.55%  [kernel]                 [k] do_io_submit
> +   52.82%     0.68%  [kernel]                 [k] aio_run_iocb
> +   42.85%     0.36%  [kernel]                 [k] blkdev_read_iter
> +   42.20%     0.88%  [kernel]                 [k] generic_file_read_iter
> +   40.96%     0.49%  [kernel]                 [k] blkdev_direct_IO
> +   40.20%     2.70%  [kernel]                 [k] dax_do_io
> +   35.93%    35.93%  [kernel]                 [k] copy_user_enhanced_fast_string
> +    6.09%     2.79%  [kernel]                 [k] aio_complete
> +    5.55%     0.43%  [kernel]                 [k] sys_io_getevents
> +    5.38%     0.00%  [unknown]                [.] 0x0684000241000684
> +    4.09%     0.35%  [kernel]                 [k] read_events
> +    3.01%     0.00%  [unknown]                [.] 0000000000000000
> +    2.98%     0.62%  [kernel]                 [k] rw_verify_area
> +    2.95%     2.93%  fio                      [.] get_io_u
> +    2.67%     0.01%  perf                     [.] hist_entry_iter__add
> +    2.42%     1.88%  [kernel]                 [k] aio_read_events
> +    2.20%     0.36%  [kernel]                 [k] security_file_permission
> +    2.13%     2.11%  fio                      [.] thread_main
> +    2.09%     2.08%  fio                      [.] get_next_rand_offset
> +    2.01%     1.99%  fio                      [.] io_u_queued_complete
> +    1.96%     0.00%  libaio.so.1.0.1          [.] 0xffff80df612af644
> +    1.66%     1.66%  [kernel]                 [k] lookup_ioctx
> +    1.51%     0.23%  [kernel]                 [k] dax_map_atomic
> +    1.49%     1.49%  [kernel]                 [k] entry_SYSCALL_64_after_swapgs
> +    1.49%     1.48%  fio                      [.] td_io_queue
> +    1.46%     1.46%  [kernel]                 [k] __fget
> +    1.39%     1.38%  fio                      [.] io_completed
> +    1.36%     1.35%  fio                      [.] __get_io_u
> +    1.34%     1.34%  [kernel]                 [k] entry_SYSCALL_64
> +    1.33%     0.08%  [kernel]                 [k] fget
> +    1.14%     1.13%  fio                      [.] fio_libaio_commit
> +    1.12%     0.99%  [kernel]                 [k] selinux_file_permission
> +    1.03%     1.03%  [kernel]                 [k] kmem_cache_alloc
> +    0.94%     0.54%  [kernel]                 [k] bdev_direct_access
> +    0.91%     0.14%  [kernel]                 [k] kiocb_free
> +    0.90%     0.89%  fio                      [.] fio_libaio_prep
> +    0.88%     0.28%  [kernel]                 [k] refill_reqs_available
> +    0.86%     0.85%  fio                      [.] utime_since_now
> +    0.79%     0.79%  [kernel]                 [k] get_reqs_available
> +    0.79%     0.79%  [kernel]                 [k] kmem_cache_free

Thank you, you are proving my point and my concerns. Your per job IOPS (~1M) and user
space consumption (20%) are similar to mine (640K and 25% correspondingly) and far from
max IOPS possible (16M), so fio (or libaio?) overhead is seen in full in your test.
Difference between your and my results might be explained that you are using the latest
development, while I'm using SLES 12SP1, which is, as you can imagine, far behind of
the latest development.

Moreover, what is your PMEM? If it is a regular DDR4, depending from how many DIMMs you
have (I guess, 4+ per NUMA node to populate all memory channels?) it should be capable
of more or much more, than 16M IOPS overall and 1M per-thread (much more for sure), so
it smells to me that the fio instrumental mistake plays significant role in your
measurements, making your results significantly lower, than real HW and IO stack are
really capable, hence you are pushing your fio tool in the range, where its accuracy
drops significantly.

I'd bet, if you take an ideal benchmarking tool with zero overhead, your results would
be significantly higher. Actually, we are seeing this with our SCST (Linux SCSI target)
tests, when with multiple initiators we sometimes have better performance, than with
FIO locally. Until now I have never had time to look at it more closely. Looks like I
have explanation now.

Thanks,
Vlad


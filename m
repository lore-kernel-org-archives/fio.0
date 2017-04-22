Return-Path: <fio-owner@vger.kernel.org>
Received: from v150-95-18-100.b001.p.han1.static.cnode.io ([150.95.18.100]:47201
        "EHLO citigomail.webstarterz.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1034805AbdDVFRE (ORCPT
        <rfc822;fio@vger.kernel.org>); Sat, 22 Apr 2017 01:17:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Date: Sat, 22 Apr 2017 05:17:00 +0000
From: son.ct@citigo.com.vn
Subject: Re: Does fio really bypass page cache with option direct=1?
In-Reply-To: <CALjAwxheMdwbdVQ1J6y6DBbUo8Dq-Yqy=8UJ2TTmisMtSZ9a8Q@mail.gmail.com>
References: <000001d2ba42$3546dc90$9fd495b0$@citigo.com.vn>
 <CABtFm2W3cL2f96xpHERD-7E-7509Hn6E3F_kVhNBfy=19PbNgw@mail.gmail.com>
 <000201d2ba62$d6900610$83b01230$@citigo.com.vn>
 <CALjAwxjOc-hrLqgGatLKftxjK0GfonpHqG6Y_jL+W2pmrYA4dg@mail.gmail.com>
 <000501d2ba6e$6d308170$47918450$@citigo.com.vn>
 <CALjAwxheMdwbdVQ1J6y6DBbUo8Dq-Yqy=8UJ2TTmisMtSZ9a8Q@mail.gmail.com>
Message-ID: <00cfa73f9e4466df84539652fcae5de0@citigo.com.vn>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Srinivasa Chamarthy <chamarthy.raju@gmail.com>, fio@vger.kernel.org

Hi,

Thank you a ton for very clear explanation. I understood. Fio tool 
correctly bypass page cache.

Regards,
Son


On 2017-04-21 20:06, Sitsofe Wheeler wrote:
> Hi,
> 
> On 21 April 2017 at 08:10, Son Chu <son.ct@citigo.com.vn> wrote:
>> 
>> Here is my dd command:
>> dd if=/dev/zero of=/opt/laptop.bin bs=1G count=5 oflag=direct
> 
> That comparison isn't really apples to apples comparison of what fio
> has to do because you got dd to send a giant block block down and made
> the kernel split it up into little pieces.
> 
>> The file system of /opt is XFS:
>> [root@localhost opt]# df -T | awk '{print $1,$2,$NF}' | grep "^/dev"
>> /dev/mapper/cl-root xfs /
>> /dev/sda1 xfs /boot
>> 
>> And this is virtual machine on my dektop so I just use it to test fio 
>> tool only and there is no read/write running process. And I don’t 
>> think there is no problem between virtual machine and physical 
>> machine.
>> 
>> I have also tested on 1 VM where I  hosted using Virtuozzo. The page 
>> cache still increase.
> 
> I can't reproduce your results. Here's a quick run where I use the
> vmtouch tool (vmtouch comes from https://github.com/hoytech/vmtouch )
> to check what's in cache (the wrapping may be bad but it should give a
> general overview):
> $ dd if=/dev/zero of=/tmp/fiotest bs=4K count=2560; ~/vmtouch/vmtouch
> /tmp/fiotest
> 2560+0 records in
> 2560+0 records out
> 10485760 bytes (10 MB, 10 MiB) copied, 0.0128309 s, 817 MB/s
>            Files: 1
>      Directories: 0
>   Resident Pages: 2560/2560  10M/10M  100%
>          Elapsed: 0.00035 seconds
> $ dd if=/dev/zero of=/tmp/fiotest bs=4K count=2560 oflag=direct;
> ~/vmtouch/vmtouch /tmp/fiotest
> 2560+0 records in
> 2560+0 records out
> 10485760 bytes (10 MB, 10 MiB) copied, 0.592612 s, 17.7 MB/s
>            Files: 1
>      Directories: 0
>   Resident Pages: 0/2560  0/10M  0%
>          Elapsed: 0.000195 seconds
> $ ~/fio/fio --size=10M --filename=/tmp/fiotest --sync=1 --rw=randrw
> --bs=4k --numjobs=1 --iodepth=8 --runtime=10 --time_based
> --group_reporting --name=journal-test --invalidate=1 --gtod_reduce=1
> --ioengine=libaio; ~/vmtouch/vmtouch /tmp/fiotest
> journal-test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B,
> (T) 4096B-4096B, ioengine=libaio, iodepth=8
> fio-2.19
> Starting 1 process
> Jobs: 1 (f=1): [m(1)][100.0%][r=136KiB/s,w=132KiB/s][r=34,w=33
> IOPS][eta 00m:00s]
> journal-test: (groupid=0, jobs=1): err= 0: pid=42838: Fri Apr 21 
> 19:32:32 2017
>    read: IOPS=30, BW=124KiB/s (127kB/s)(1244KiB/10061msec)
>   write: IOPS=32, BW=130KiB/s (133kB/s)(1308KiB/10061msec)
>   cpu          : usr=0.12%, sys=0.36%, ctx=968, majf=0, minf=10
>   IO depths    : 1=0.2%, 2=0.3%, 4=0.6%, 8=98.9%, 16=0.0%, 32=0.0%, 
> >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
> >=64=0.0%
>      complete  : 0=0.0%, 4=99.8%, 8=0.2%, 16=0.0%, 32=0.0%, 64=0.0%, 
> >=64=0.0%
>      issued rwt: total=311,327,0, short=0,0,0, dropped=0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=8
> 
> Run status group 0 (all jobs):
>    READ: bw=124KiB/s (127kB/s), 124KiB/s-124KiB/s (127kB/s-127kB/s),
> io=1244KiB (1274kB), run=10061-10061msec
>   WRITE: bw=130KiB/s (133kB/s), 130KiB/s-130KiB/s (133kB/s-133kB/s),
> io=1308KiB (1339kB), run=10061-10061msec
> 
> Disk stats (read/write):
>   sda: ios=310/968, merge=0/323, ticks=2084/7648, in_queue=9808, 
> util=98.28%
>            Files: 1
>      Directories: 0
>   Resident Pages: 638/2560  2M/10M  24.9%
>          Elapsed: 0.000354 seconds
> $ ~/fio/fio --size=10M --filename=/tmp/fiotest --direct=1 --sync=1
> --rw=randrw --bs=4k --numjobs=1 --iodepth=8 --runtime=10 --time_based
> --group_reporting --name=journal-test --invalidate=1 --gtod_reduce=1
> --ioengine=libaio; ~/vmtouch/vmtouch /tmp/fiotest
> journal-test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B,
> (T) 4096B-4096B, ioengine=libaio, iodepth=8
> fio-2.19
> Starting 1 process
> Jobs: 1 (f=1): [m(1)][100.0%][r=316KiB/s,w=296KiB/s][r=79,w=74
> IOPS][eta 00m:00s]
> journal-test: (groupid=0, jobs=1): err= 0: pid=42842: Fri Apr 21 
> 19:33:21 2017
>    read: IOPS=64, BW=260KiB/s (266kB/s)(2680KiB/10308msec)
>   write: IOPS=65, BW=261KiB/s (267kB/s)(2688KiB/10308msec)
>   cpu          : usr=0.00%, sys=0.47%, ctx=934, majf=0, minf=9
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.3%, 8=99.5%, 16=0.0%, 32=0.0%, 
> >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
> >=64=0.0%
>      complete  : 0=0.0%, 4=99.9%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%, 
> >=64=0.0%
>      issued rwt: total=670,672,0, short=0,0,0, dropped=0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=8
> 
> Run status group 0 (all jobs):
>    READ: bw=260KiB/s (266kB/s), 260KiB/s-260KiB/s (266kB/s-266kB/s),
> io=2680KiB (2744kB), run=10308-10308msec
>   WRITE: bw=261KiB/s (267kB/s), 261KiB/s-261KiB/s (267kB/s-267kB/s),
> io=2688KiB (2753kB), run=10308-10308msec
> 
> Disk stats (read/write):
>   sda: ios=656/992, merge=0/167, ticks=10436/15916, in_queue=26376, 
> util=99.13%
>            Files: 1
>      Directories: 0
>   Resident Pages: 0/2560  0/10M  0%
>          Elapsed: 0.000192 seconds
> 
> /tmp is on an ext4 filesystem. Without direct I/O some or all of the
> file is cached when the I/O finishes. With direct I/O, none of the
> file is cached by the end so I'd say fio is correctly bypassing the
> cache.
> 
> However it's worth noting that while fio is running it will allocate
> shared memory (viewable with ipcs shm while fio is running) so it
> would be worth sending a follow up email saying whether that explains
> where the page cache memory went.

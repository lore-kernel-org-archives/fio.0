Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:36283 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754049AbdHUWQc (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Aug 2017 18:16:32 -0400
Received: by mail-ua0-f177.google.com with SMTP id k12so13761962uag.3
        for <fio@vger.kernel.org>; Mon, 21 Aug 2017 15:16:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f1fb2a4a-6c28-0d3a-4c51-d3e3a7fef101@dell.com>
References: <DE927C68B458BE418D582EC97927A9287FCAD035@ORSMSX113.amr.corp.intel.com>
 <FA2D9B8E-F7EB-48EA-A05B-E7F365A8767C@netapp.com> <DE927C68B458BE418D582EC97927A9287FCAD0D5@ORSMSX113.amr.corp.intel.com>
 <DE927C68B458BE418D582EC97927A9287FCADCEC@ORSMSX113.amr.corp.intel.com>
 <DE927C68B458BE418D582EC97927A9287FCB1765@ORSMSX113.amr.corp.intel.com>
 <BN3PR0401MB14574C48E4CBA2612091232C8F870@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CALjAwxgfN6rS8oLuxfVo868bXYdB_Z_EQNzPTjyD-8_AET6b_A@mail.gmail.com> <f1fb2a4a-6c28-0d3a-4c51-d3e3a7fef101@dell.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 21 Aug 2017 23:16:00 +0100
Message-ID: <CALjAwxixiMtWAZYkeTP4icOZQs0ziq=4ZmUkqoBGba6Wib162g@mail.gmail.com>
Subject: Re: IOPS Log Incorrect?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mikhail Terekhov <Mikhail.Terekhov@dell.com>
Cc: Jeff Furlong <jeff.furlong@wdc.com>, "Gruher, Joseph R" <joseph.r.gruher@intel.com>, neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Joseph,

Does the suggested fix solve the problem you were seeing too?

On 21 August 2017 at 23:10, Mikhail Terekhov <Mikhail.Terekhov@dell.com> wrote:
> It seems fixed the problem. Here the results for fio-2.99 and fio-2.99+patch
> for
> rotating media:
>
>  :/tmp>cat test299_iops.1.log
> 5000, 1448, 0, 0
> 10641, 180, 0, 0
> 15576, 160, 0, 0
> 20511, 204, 0, 0
> 25446, 222, 0, 0
> 30381, 126, 0, 0
> :/tmp>cat test299p1_iops.1.log
> 5000, 1746, 0, 0
> 10000, 1435, 0, 0
> 15000, 1478, 0, 0
> 20000, 1161, 0, 0
> 25000, 1291, 0, 0
> 30000, 1265, 0, 0
>
> On 08/21/17 17:12, Sitsofe Wheeler wrote:
>>
>> Hmm. How do things look with the following?
>>
>> diff --git a/time.c b/time.c
>> index edfe779..5e38aad 100644
>> --- a/time.c
>> +++ b/time.c
>> @@ -8,7 +8,7 @@ static unsigned long ns_granularity;
>>
>>   void timespec_add_msec(struct timespec *ts, unsigned int msec)
>>   {
>> -       unsigned long adj_nsec = 1000000 * msec;
>> +       unsigned long adj_nsec = 1000000UL * msec;
>>
>>          ts->tv_nsec += adj_nsec;
>>          if (adj_nsec >= 1000000000) {
>>
>> Perhaps because msec is an unsigned int and 1000000 fits in an
>> unsigned int the multiplication will wrap unexpectedly even though the
>> real answer fits in a (64 bit) unsigned long? Perhaps  adj_nsec needs
>> to be a uint64_t ?
>>
>> On 21 August 2017 at 20:33, Jeff Furlong <jeff.furlong@wdc.com> wrote:
>>>
>>> Looks like when we set log_avg_msec=4000 or less it works as expected.
>>> Also, the logged timestamps are very close to 4000 multiples.  When we set
>>> log_avg_msec=5000 or more the average is wrong, and also the logged
>>> timestamp has significant jitter from 5000 multiples.  Are we overflowing
>>> the log_avg_msec variable (32bits)?
>>>
>>> Regards,
>>> Jeff
>>>
>>> -----Original Message-----
>>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>>> Behalf Of Gruher, Joseph R
>>> Sent: Monday, August 21, 2017 11:11 AM
>>> To: neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>;
>>> fio@vger.kernel.org
>>> Subject: RE: IOPS Log Incorrect?
>>>
>>> Feature seems to work in FIO 2.15 through 2.20.  I couldn't test 2.21
>>> (keeps segfaulting when I try to run after compile) and then the feature is
>>> broken in the next release which is 2.99 and still broken in 3.0.
>>>
>>>> -----Original Message-----
>>>> From: Gruher, Joseph R
>>>> Sent: Thursday, August 17, 2017 5:16 PM
>>>> To: neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>;
>>>> fio@vger.kernel.org
>>>> Subject: RE: IOPS Log Incorrect?
>>>>
>>>> This feature seems to work in FIO 2.15:
>>>>
>>>> root@nvmfjt01:/home/nvmf/jrg9/chandler# fio 4k-rr-01-01-128.ini
>>>> job00: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio,
>>>> iodepth=128
>>>> fio-2.15
>>>> Starting 1 thread
>>>> Jobs: 1 (f=1): [r(1)] [78.8% done] [1804MB/0KB/0KB /s] [462K/0/0 iops]
>>>> [eta 00m:58s]
>>>> job00: (groupid=0, jobs=1): err= 0: pid=5341: Thu Aug 17 16:57:40 2017
>>>>    read : io=277967MB, bw=1789.6MB/s, iops=457984, runt=155375msec
>>>>      slat (usec): min=0, max=95, avg= 1.44, stdev= 0.91
>>>>      clat (usec): min=61, max=5168, avg=277.60, stdev=118.64
>>>>       lat (usec): min=62, max=5170, avg=279.12, stdev=118.63
>>>>      clat percentiles (usec):
>>>>       |  1.00th=[  129],  5.00th=[  155], 10.00th=[  173], 20.00th=[
>>>> 197],
>>>>       | 30.00th=[  215], 40.00th=[  235], 50.00th=[  255], 60.00th=[
>>>> 278],
>>>>       | 70.00th=[  306], 80.00th=[  342], 90.00th=[  406], 95.00th=[
>>>> 470],
>>>>       | 99.00th=[  636], 99.50th=[  716], 99.90th=[ 1176], 99.95th=[
>>>> 2096],
>>>>       | 99.99th=[ 2896]
>>>>      lat (usec) : 100=0.12%, 250=47.54%, 500=48.64%, 750=3.31%,
>>>> 1000=0.26%
>>>>      lat (msec) : 2=0.08%, 4=0.05%, 10=0.01%
>>>>    cpu          : usr=28.43%, sys=68.46%, ctx=736888, majf=0, minf=816
>>>>    IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%,
>>>>>
>>>>> =64=137.3%
>>>>
>>>>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>>>>
>>>>> =64=0.0%
>>>>
>>>>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>>>>
>>>>> =64=0.1%
>>>>
>>>>       issued    : total=r=71159403/w=0/d=0, short=r=0/w=0/d=0,
>>>> drop=r=0/w=0/d=0
>>>>       latency   : target=0, window=0, percentile=100.00%, depth=128
>>>> Run status group 0 (all jobs):
>>>>     READ: io=277967MB, aggrb=1789.6MB/s, minb=1789.6MB/s,
>>>> maxb=1789.6MB/s, mint=155375msec, maxt=155375msec Disk stats
>>>> (read/write):
>>>>    nvme0n1: ios=97645100/0, merge=0/0, ticks=24504996/0,
>>>> in_queue=24519280, util=99.95%
>>>>
>>>> root@nvmfjt01:/home/nvmf/jrg9/chandler# cat joe1x128_iops.1.log 20001,
>>>> 438712, 0, 0 39999, 455544, 0, 0 59999, 457418, 0, 0 79999, 462500, 0,
>>>> 0 99999, 462728, 0, 0 119999, 462893, 0, 0 139999, 462508, 0, 0
>>>>
>>>> root@nvmfjt01:/home/nvmf/jrg9/chandler# cat 4k-rr-01-01-128.ini
>>>> [global] bs=4k rw=randread
>>>> numjobs=1
>>>> iodepth=128
>>>> thread=1
>>>> ioengine=libaio
>>>> direct=1
>>>> ramp_time=60
>>>> norandommap=1
>>>> group_reporting=1
>>>> write_iops_log=joe1x128
>>>> log_avg_msec=20000
>>>> [job00]
>>>> filename=/dev/nvme0n1
>>>>
>>>> root@nvmfjt01:/home/nvmf/jrg9/chandler# uname -a Linux nvmfjt01
>>>> 4.12.7- 041207-generic #201708160856 SMP Wed Aug 16 12:59:25 UTC 2017
>>>> x86_64
>>>> x86_64 x86_64 GNU/Linux
>>>>
>>>> root@nvmfjt01:/home/nvmf/jrg9/chandler# fio --version
>>>> fio-2.15
>>>>
>>>>> -----Original Message-----
>>>>> From: Gruher, Joseph R
>>>>> Sent: Thursday, August 17, 2017 11:52 AM
>>>>> To: neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>;
>>>>> fio@vger.kernel.org
>>>>> Subject: RE: IOPS Log Incorrect?
>>>>>
>>>>> Sure.  That produces a very large log file where every entry is
>>>>> <timestamp>, 1, 0, 4096.  See example below.
>>>>>
>>>>>
>>>>> root@nvmfjt01:/home/nvmf/jrg9/chandler# cat 4k-rr-01.ini [global]
>>>>> bs=4k rw=randread
>>>>> numjobs=1
>>>>> iodepth=128
>>>>> ioengine=libaio
>>>>> direct=1
>>>>> runtime=3
>>>>> write_iops_log=joe2
>>>>>   [job00]
>>>>> filename=/dev/nvme0n1
>>>>>
>>>>>
>>>>> root@nvmfjt01:/home/nvmf/jrg9/chandler# fio 4k-rr-01.ini
>>>>> job00: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
>>>>> 4096B- 4096B, ioengine=libaio, iodepth=128
>>>>> fio-3.0
>>>>> Starting 1 process
>>>>> Jobs: 1 (f=1): [r(1)][100.0%][r=1330MiB/s,w=0KiB/s][r=340k,w=0
>>>>> IOPS][eta 00m:00s]
>>>>> job00: (groupid=0, jobs=1): err= 0: pid=3124: Thu Aug 17 11:49:47 2017
>>>>>     read: IOPS=317k, BW=1238MiB/s (1298MB/s)(3715MiB/3001msec)
>>>>>      slat (nsec): min=930, max=114792, avg=2418.97, stdev=1970.30
>>>>>      clat (usec): min=81, max=1210, avg=400.22, stdev=74.26
>>>>>       lat (usec): min=84, max=1220, avg=402.75, stdev=74.53
>>>>>      clat percentiles (usec):
>>>>>       |  1.00th=[  310],  5.00th=[  326], 10.00th=[  334], 20.00th=[
>>>>> 343],
>>>>>       | 30.00th=[  355], 40.00th=[  363], 50.00th=[  375], 60.00th=[
>>>>> 392],
>>>>>       | 70.00th=[  420], 80.00th=[  461], 90.00th=[  494], 95.00th=[
>>>>> 529],
>>>>>       | 99.00th=[  660], 99.50th=[  734], 99.90th=[  857], 99.95th=[
>>>>> 889],
>>>>>       | 99.99th=[ 1004]
>>>>>     bw (  MiB/s): min=  960, max= 1332, per=98.62%, avg=1220.89,
>>>>> stdev=160.84,
>>>>> samples=5
>>>>>     iops        : min=    1, max=    1, avg= 1.00, stdev= 0.00,
>>>>> samples=951085
>>>>>    lat (usec)   : 100=0.01%, 250=0.05%, 500=91.24%, 750=8.28%,
>>>>> 1000=0.42%
>>>>>    lat (msec)   : 2=0.01%
>>>>>    cpu          : usr=22.13%, sys=77.87%, ctx=61, majf=0, minf=3234
>>>>>    IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%,
>>>>> =64=99.9%
>>>>>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>>>>>
>>>>>> =64=0.0%
>>>>>
>>>>>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>>>>> 64=0.0%,
>>>>>>
>>>>>> =64=0.1%
>>>>>
>>>>>       issued rwt: total=951085,0,0, short=0,0,0, dropped=0,0,0
>>>>>       latency   : target=0, window=0, percentile=100.00%, depth=128
>>>>> Run status group 0 (all jobs):
>>>>>     READ: bw=1238MiB/s (1298MB/s), 1238MiB/s-1238MiB/s (1298MB/s-
>>>>> 1298MB/s), io=3715MiB (3896MB), run=3001-3001msec Disk stats
>>>>> (read/write):
>>>>>    nvme0n1: ios=951085/0, merge=0/0, ticks=121124/0, in_queue=120984,
>>>>> util=92.50%
>>>>>
>>>>>
>>>>> root@nvmfjt01:/home/nvmf/jrg9/chandler# head -n 10 joe2_iops.1.log
>>>>> 2, 1, 0,
>>>>> 4096 2, 1, 0, 4096 2, 1, 0, 4096 2, 1, 0, 4096 2, 1, 0, 4096 2, 1,
>>>>> 0,
>>>>> 4096 2, 1, 0,
>>>>> 4096 2, 1, 0, 4096 2, 1, 0, 4096 2, 1, 0, 4096
>>>>>
>>>>>
>>>>> root@nvmfjt01:/home/nvmf/jrg9/chandler# tail -n 10 joe2_iops.1.log
>>>>> 3000, 1, 0, 4096 3000, 1, 0, 4096 3000, 1, 0, 4096 3000, 1, 0, 4096
>>>>> 3000, 1, 0, 4096 3000, 1, 0, 4096 3000, 1, 0, 4096 3000, 1, 0, 4096
>>>>> 3000, 1, 0, 4096 3000, 1, 0,
>>>>> 4096
>>>>>
>>>>>
>>>>> Thanks,
>>>>> Joe
>>>>>
>>>>>> -----Original Message-----
>>>>>> From: neto from Brazil
>>>>>> [mailto:Antonio.Jose.Rodrigues.Neto@netapp.com]
>>>>>> Sent: Thursday, August 17, 2017 11:47 AM
>>>>>> To: Gruher, Joseph R <joseph.r.gruher@intel.com>;
>>>>>> fio@vger.kernel.org
>>>>>> Subject: Re: IOPS Log Incorrect?
>>>>>>
>>>>>> Hi Joseph,
>>>>>>
>>>>>> This is neto from Brazil
>>>>>>
>>>>>> How are you?
>>>>>>
>>>>>> Could you try to re-run without log_avg_msec=5000?
>>>>>>
>>>>>> Thanks,
>>>>>>
>>>>>> neto
>>>>>>
>>>>>> On 8/17/17, 2:38 PM, "fio-owner@vger.kernel.org on behalf of
>>>>>> Gruher, Joseph R" <fio-owner@vger.kernel.org on behalf of
>>>>>
>>>>> joseph.r.gruher@intel.com> wrote:
>>>>>>
>>>>>>      Hi, I'm using FIO 3.0 on Ubuntu 16.10 with 4.12.7 kernel (also
>>>>>> reproduced problem with default 4.8.0-59 kernel). I'm running a
>>>>>> 4KB random IO pattern against an Intel P3700 400GB NVMe SSD. I'm
>>>>>> trying to view the IOPS/BW over time using the write_bw_log and
>>>>>> write_iops_log parameters. FIO is writing the logs but the values
>>>>>> in the logs don't align with the summary for the run.  Here's a
>>>>>> simple example.  Notice FIO reports 398K IOPS for the run overall,
>>>>>> but the IOPS log file shows 383K for the first entry and then
>>>>>> values around 56K for the rest of the run, so
>>>>>
>>>>> one or the other must be incorrect (presumably the log file).
>>>>>>
>>>>>> The bandwidth log has a similar issue.
>>>>>>
>>>>>>
>>>>>>      root@nvmfjt01:/home/nvmf/jrg9/chandler# cat 4k-rr-01.ini
>>>>>>      [global]
>>>>>>      bs=4k
>>>>>>      rw=randread
>>>>>>      numjobs=1
>>>>>>      iodepth=128
>>>>>>      ioengine=libaio
>>>>>>      direct=1
>>>>>>      runtime=30
>>>>>>      write_iops_log=joe2
>>>>>>      log_avg_msec=5000
>>>>>>      [job00]
>>>>>>      filename=/dev/nvme0n1
>>>>>>
>>>>>>
>>>>>>      root@nvmfjt01:/home/nvmf/jrg9/chandler# fio 4k-rr-01.ini
>>>>>>      job00: (g=0): rw=randread, bs=(R) 4096B-4096B, (W)
>>>>>> 4096B-4096B,
>>>>>> (T) 4096B-4096B, ioengine=libaio, iodepth=128
>>>>>>      fio-3.0
>>>>>>      Starting 1 process
>>>>>>      Jobs: 1 (f=1): [r(1)][100.0%][r=1595MiB/s,w=0KiB/s][r=408k,w=0
>>>>>> IOPS][eta 00m:00s]
>>>>>>      job00: (groupid=0, jobs=1): err= 0: pid=2767: Thu Aug 17 10:34:09
>>>>>> 2017
>>>>>>      read: IOPS=398k, BW=1555MiB/s (1630MB/s)(45.6GiB/30001msec)
>>>>>>      slat (nsec): min=824, max=117534, avg=1682.36, stdev=1290.45
>>>>>>      clat (usec): min=96, max=2899, avg=319.29, stdev=69.36
>>>>>>      lat (usec): min=97, max=2900, avg=321.08, stdev=69.39
>>>>>>      clat percentiles (usec):
>>>>>>      | 1.00th=[ 221], 5.00th=[ 243], 10.00th=[ 255], 20.00th=[ 269],
>>>>>>      | 30.00th=[ 281], 40.00th=[ 289], 50.00th=[ 302], 60.00th=[ 318],
>>>>>>      | 70.00th=[ 334], 80.00th=[ 363], 90.00th=[ 412], 95.00th=[ 453],
>>>>>>      | 99.00th=[ 562], 99.50th=[ 611], 99.90th=[ 725], 99.95th=[ 775],
>>>>>>      | 99.99th=[ 906]
>>>>>>      bw ( MiB/s): min= 1081, max= 1594, per=99.96%, avg=1554.11,
>>>>>> stdev=68.33,
>>>>>> samples=59
>>>>>>      iops : min=56293, max=383046, avg=65603.75, stdev=54419.77,
>>>>>
>>>>> samples=36
>>>>>>
>>>>>>      lat (usec) : 100=0.01%, 250=7.73%, 500=89.82%, 750=2.38%,
>>>>>> 1000=0.07%
>>>>>>      lat (msec) : 2=0.01%, 4=0.01%
>>>>>>      cpu : usr=32.51%, sys=67.50%, ctx=105, majf=0, minf=153
>>>>>>      IO depths : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%,
>>>>>>>
>>>>>>> =64=100.0%
>>>>>>
>>>>>>      submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>>>>> =64=0.0%
>>>>>>      complete : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>>>>>> 64=0.0%,
>>>>>>>
>>>>>>> =64=0.1%
>>>>>>
>>>>>>      issued rwt: total=11941208,0,0, short=0,0,0, dropped=0,0,0
>>>>>>      latency : target=0, window=0, percentile=100.00%, depth=128
>>>>>>      Run status group 0 (all jobs):
>>>>>>      READ: bw=1555MiB/s (1630MB/s), 1555MiB/s-1555MiB/s (1630MB/s-
>>>>>> 1630MB/s), io=45.6GiB (48.9GB), run=30001-30001msec
>>>>>>      Disk stats (read/write):
>>>>>>      nvme0n1: ios=11890654/0, merge=0/0, ticks=1923076/0,
>>>>>> in_queue=1925204, util=99.69%
>>>>>>
>>>>>>
>>>>>>      root@nvmfjt01:/home/nvmf/jrg9/chandler# cat joe2_iops.1.log
>>>>>>      5000, 383046, 0, 0
>>>>>>      10640, 56412, 0, 0
>>>>>>      15576, 56410, 0, 0
>>>>>>      20511, 56425, 0, 0
>>>>>>      25446, 56394, 0, 0
>>>>>>      30040, 57131, 0, 0
>>>>>>
>>>>>>
>>>>>>      root@nvmfjt01:/home/nvmf/jrg9/chandler# fio --version
>>>>>>      fio-3.0
>>>>>>
>>>>>>
>>>>>>      root@nvmfjt01:/home/nvmf/jrg9/chandler# uname -a
>>>>>>      Linux nvmfjt01 4.12.7-041207-generic #201708160856 SMP Wed Aug
>>>>>> 16
>>>>>> 12:59:25 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

-- 
Sitsofe | http://sucs.org/~sits/

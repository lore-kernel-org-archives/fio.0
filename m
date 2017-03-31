Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:35795 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932545AbdCaGbr (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Mar 2017 02:31:47 -0400
Received: by mail-vk0-f44.google.com with SMTP id r69so80214066vke.2
        for <fio@vger.kernel.org>; Thu, 30 Mar 2017 23:31:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxhB2BdjfKZfYRCuykTFVzqSV=RPBwaTC8=vc_7X1RBZLQ@mail.gmail.com>
References: <CAOHuL9g1C3ust1x-ksye=EHtwh93MU29QdY=Box2CJsv=49DNw@mail.gmail.com>
 <CALjAwxhpJYusv_EK1zxEWVAdQG_KC14pHAzk9VFP0m3Owzsx+A@mail.gmail.com>
 <CAOHuL9jbUDE5QaaFikxQDBuP07UA4rbxxZHO5sTCgDrJAi_-1g@mail.gmail.com>
 <CALjAwxjqMM-bRnWrVJct0xTQw3erKenwDdHcxJ1HM9=YD5_ZrQ@mail.gmail.com>
 <CAOHuL9i8sT__sDBRV=+kQy6OJELHy3pRg3ZVAuD0N8ih_3V0ZQ@mail.gmail.com> <CALjAwxhB2BdjfKZfYRCuykTFVzqSV=RPBwaTC8=vc_7X1RBZLQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 31 Mar 2017 07:31:15 +0100
Message-ID: <CALjAwxg7QY002Z5mRkQLv8PvM9r++eDemM=t9Sm4egvM4tqXGw@mail.gmail.com>
Subject: Re: Clat min zero on Randread?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tarek <cashew250@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Oh, before I forget do you still see this problem with newer versions
of fio (2.18+)?

On 31 March 2017 at 07:27, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hmm those D2C and Q2C times are bigger than what fio is reporting! Was
> this with log_avg_msec unset?
>
> If you can make this happen over even shorter periods (a couple of
> seconds tops) it might be feasible to turn on fio debugging and change
> fio source to exit if it calculates a submission time of 0...
>
> On 30 March 2017 at 21:32, Tarek <cashew250@gmail.com> wrote:
>> Blktrace -> blkparse -> btt  vs. FIO doesn't match (D2C was on the
>> order of 10+ uS), fio 0uS. See details below
>>
>> Jobs: 1 (f=1): [w(1)][100.0%][r=0KiB/s,w=177MiB/s][r=0,w=45.4k
>> IOPS][eta 00m:00s]
>> random-0r-100w_4k_qd1_jobs_1: (groupid=0, jobs=1): err= 0: pid=22318:
>> Thu Mar 30 14:47:20 2017
>>   Description  : [Random R/W 0/100 QD1 BLK 4k Jobs 1]
>>   write: IOPS=43.2k, BW=168MiB/s (177MB/s)(1684MiB/10001msec)
>>     slat (usec): min=1, max=3579, avg= 1.73, stdev=11.37
>>     clat (usec): min=0, max=3322, avg=20.08, stdev=11.15
>>      lat (usec): min=19, max=3584, avg=21.90, stdev=15.84
>>
>>             D2C           MIN           AVG           MAX           N
>> --------------- ------------- ------------- ------------- -----------
>> fio               0.000016651   0.000018152   0.000045858      431084
>> systemd-udevd     0.000010843   0.000122841   0.000400713          76
>>
>>             Q2C           MIN           AVG           MAX           N
>> --------------- ------------- ------------- ------------- -----------
>> fio               0.000017209   0.000018905   0.000064686      431084
>> systemd-udevd     0.000011829   0.000126970   0.000406939          76
>
>>
>> On Mon, Mar 27, 2017 at 1:30 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>> Hi,
>>>
>>> Do you get the same effect when you don't set log_avg_msec? Do you
>>> know how far fio's timings are compared to blktrace?
>>>
>>> On 27 March 2017 at 15:36, Tarek <cashew250@gmail.com> wrote:
>>>> I don't have evidence to suggest that the min SLAT and CLAT are from
>>>> the same IO, speculation. Regardless, CLAT should not be 0 on any
>>>> device for a read. Nand read spec is 40uS. Flow is blkdiscard device,
>>>> precondition (seq fill twice, followed by 100GiB of random write),
>>>> then test. Any ideas?
>>>>
>>>> On Sat, Mar 25, 2017 at 3:29 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>>>> Hi,
>>>>>
>>>>> I don't know why the minimum clat is 0 usec (you might be able to
>>>>> investigate further by using blktrace on the device to see how much
>>>>> that disagrees with fio) but why do you believe that scenario happened
>>>>> on the exact same I/O(s) that had a 0 usec slat time? Do you have
>>>>> additional logs showing that was the case?
>>>>>
>>>>> On 24 March 2017 at 17:39, Tarek <cashew250@gmail.com> wrote:
>>>>>> Clat min is zero on a random read, how is that possible when NAND tR
>>>>>> spec is 20-60uS? Also isn't lat = slat + clat,  1 + 0 != 84
>>>>>>
>>>>>> fio-2.15
>>>>>> Starting 80 threads
>>>>>>
>>>>>> random-100r-0w_4k_qd1_jobs_16: (groupid=0, jobs=16): err= 0:
>>>>>> pid=22233: Tue Feb 21 15:41:33 2017
>>>>>>   Description  : [Random R/W 100/0 QD1 BLK 4k Jobs 16]
>>>>>>   read : io=1045.5GB, bw=609017KB/s, iops=152254, runt=1800001msec
>>>>>>     slat (usec): min=1, max=6583, avg= 2.06, stdev= 1.01
>>>>>>     clat (usec): min=0, max=8728, avg=102.38, stdev=21.43
>>>>>>      lat (usec): min=84, max=8730, avg=104.52, stdev=21.45
>>>>>>     clat percentiles (usec):
>>>>>>      |  1.00th=[   85],  5.00th=[   86], 10.00th=[   87], 20.00th=[   89],
>>>>>>      | 30.00th=[   91], 40.00th=[   98], 50.00th=[  101], 60.00th=[  102],
>>>>>>      | 70.00th=[  104], 80.00th=[  106], 90.00th=[  116], 95.00th=[  143],
>>>>>>      | 99.00th=[  175], 99.50th=[  185], 99.90th=[  225], 99.95th=[  239],
>>>>>>      | 99.99th=[  270]
>>>>>>
>>>>>>
>>>>>> Fio Config:
>>>>>> thread
>>>>>> bs=4k
>>>>>> ioengine=libaio
>>>>>> direct=1
>>>>>> buffered=0
>>>>>> log_avg_msec=1000
>>>>>> group_reporting=1
>>>>>> rw=randread
>>>>>> numjobs=16
>>>>>> iodepth=1
>>>>>> time_based
>>>>>> runtime=1800
>>>>>> refill_buffers
>>>>>> norandommap
>>>>>> filename=/dev/nvme0n1
>
> --
> Sitsofe | http://sucs.org/~sits/



-- 
Sitsofe | http://sucs.org/~sits/

Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:33686 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752607AbdC0Og0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 27 Mar 2017 10:36:26 -0400
Received: by mail-wr0-f178.google.com with SMTP id w43so47387475wrb.0
        for <fio@vger.kernel.org>; Mon, 27 Mar 2017 07:36:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxhpJYusv_EK1zxEWVAdQG_KC14pHAzk9VFP0m3Owzsx+A@mail.gmail.com>
References: <CAOHuL9g1C3ust1x-ksye=EHtwh93MU29QdY=Box2CJsv=49DNw@mail.gmail.com>
 <CALjAwxhpJYusv_EK1zxEWVAdQG_KC14pHAzk9VFP0m3Owzsx+A@mail.gmail.com>
From: Tarek <cashew250@gmail.com>
Date: Mon, 27 Mar 2017 09:36:08 -0500
Message-ID: <CAOHuL9jbUDE5QaaFikxQDBuP07UA4rbxxZHO5sTCgDrJAi_-1g@mail.gmail.com>
Subject: Re: Clat min zero on Randread?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

I don't have evidence to suggest that the min SLAT and CLAT are from
the same IO, speculation. Regardless, CLAT should not be 0 on any
device for a read. Nand read spec is 40uS. Flow is blkdiscard device,
precondition (seq fill twice, followed by 100GiB of random write),
then test. Any ideas?

On Sat, Mar 25, 2017 at 3:29 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> I don't know why the minimum clat is 0 usec (you might be able to
> investigate further by using blktrace on the device to see how much
> that disagrees with fio) but why do you believe that scenario happened
> on the exact same I/O(s) that had a 0 usec slat time? Do you have
> additional logs showing that was the case?
>
> On 24 March 2017 at 17:39, Tarek <cashew250@gmail.com> wrote:
>> Clat min is zero on a random read, how is that possible when NAND tR
>> spec is 20-60uS? Also isn't lat = slat + clat,  1 + 0 != 84
>>
>> fio-2.15
>> Starting 80 threads
>>
>> random-100r-0w_4k_qd1_jobs_16: (groupid=0, jobs=16): err= 0:
>> pid=22233: Tue Feb 21 15:41:33 2017
>>   Description  : [Random R/W 100/0 QD1 BLK 4k Jobs 16]
>>   read : io=1045.5GB, bw=609017KB/s, iops=152254, runt=1800001msec
>>     slat (usec): min=1, max=6583, avg= 2.06, stdev= 1.01
>>     clat (usec): min=0, max=8728, avg=102.38, stdev=21.43
>>      lat (usec): min=84, max=8730, avg=104.52, stdev=21.45
>>     clat percentiles (usec):
>>      |  1.00th=[   85],  5.00th=[   86], 10.00th=[   87], 20.00th=[   89],
>>      | 30.00th=[   91], 40.00th=[   98], 50.00th=[  101], 60.00th=[  102],
>>      | 70.00th=[  104], 80.00th=[  106], 90.00th=[  116], 95.00th=[  143],
>>      | 99.00th=[  175], 99.50th=[  185], 99.90th=[  225], 99.95th=[  239],
>>      | 99.99th=[  270]
>>
>>
>> Fio Config:
>> thread
>> bs=4k
>> ioengine=libaio
>> direct=1
>> buffered=0
>> log_avg_msec=1000
>> group_reporting=1
>> rw=randread
>> numjobs=16
>> iodepth=1
>> time_based
>> runtime=1800
>> refill_buffers
>> norandommap
>> filename=/dev/nvme0n1
>
> --
> Sitsofe | http://sucs.org/~sits/

Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38326 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750705AbdAWVWy (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Jan 2017 16:22:54 -0500
Received: by mail-wm0-f47.google.com with SMTP id r144so177275787wme.1
        for <fio@vger.kernel.org>; Mon, 23 Jan 2017 13:22:54 -0800 (PST)
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <CANvN+en2ihATNgrbgzwNXAK87wNh+6jXHinmg2-VmHon31AJzA@mail.gmail.com>
 <061acabe-dbd0-ae07-cd69-772eccd15b21@gmail.com>
 <CANvN+em0cjWRnQWccdORKFEJk0OSeQOrZq+XE6kzPmqMPB--4g@mail.gmail.com>
 <49ef9d71-8e52-26e4-76f7-ea03fb331a38@gmail.com>
 <CALjAwxjmW-NgWEcH7+nKNN8U_oUxFoYa23dui9wM6WDqiShWhw@mail.gmail.com>
 <15418080-0bf6-ab40-c05f-69a3fb3d9cc3@gmail.com>
 <CALjAwxhsvfH0-D=4U6nkjFg109Z1ZgVRsOx37X+Lb-EqTf_jOA@mail.gmail.com>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <6b2cacaf-2946-6046-51c2-b909c6ee0784@gmail.com>
Date: Mon, 23 Jan 2017 22:22:50 +0100
MIME-Version: 1.0
In-Reply-To: <CALjAwxhsvfH0-D=4U6nkjFg109Z1ZgVRsOx37X+Lb-EqTf_jOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Am 23.01.2017 um 21:24 schrieb Sitsofe Wheeler:
> On 23 January 2017 at 19:40, Tobias Oberstein
> <tobias.oberstein@gmail.com> wrote:
>> Am 23.01.2017 um 20:13 schrieb Sitsofe Wheeler:
>>>
>>> On 23 January 2017 at 18:33, Tobias Oberstein
>>> <tobias.oberstein@gmail.com> wrote:
>>>>
>>>> libaio is nowhere near what I get with engine=sync and high job counts.
>>>> Mmh.
>>>> Plus the strange behavior.
>>>
>>> Have you tried batching the IOs and controlling how much are you
>>> reaping at any one time? See
>>>
>>> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-iodepth_batch_submit
>>> for some of the options for controlling this...
>>
>> Thanks! Nice.
>>
>> For libaio, and with all the hints applied (no 4k sectors yet), I get (4k
>> randread)
>>
>> Individual NVMes: iops=7350.4K
>> MD (RAID-0) over NVMes: iops=4112.8K
>>
>> The going up and down of IOPS is gone.
>>
>> It's becoming more apparent I'd say, that tthere is a MD bottleneck though.
>
> If you're "just" trying for higher IOPS you can also try gtod_reduce
> (see http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-gtod_reduce
> ). This subsumes things like disable_lat but you'll get fewer and less
> accurate measurement stats back. With libaio userspace reap
> (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-userspace_reap
> ) can sometimes nudge numbers up but at the cost of CPU.
>

Using that option plus bumping to QD=64 and batch submit 16, I get

plain NVMes:   iops=7415.9K
MD over NVMes: iops=4112.4K

These are staggering numbers for sure!

In fact, the Intel P3608 4TB datasheet says: up to 850k random 4kB

Since we have 8 (physical) of these, the real world measurement (7.4 
mio) is even above the datasheet (6.8 mio).

I'd say: very good job Intel =)

The price of course is the CPU load to reach these numbers .. we have 
the 2nd largest Intel Xeon available

Intel(R) Xeon(R) CPU E7-8880 v4 @ 2.20GHz

and 4 of these .. and even that isn't enough to saturate these NVMe 
beasts while still having room to do useful work (PostgreSQL).

So we're gonna be CPU bound .. again - this is the 2nd iteration of such 
a box. The first one has 48 cores E7 v2 and 8 x P3700 2TB. Also CPU 
bound on PostgreSQL anyway .. with 3TB RAM.

Cheers,
/Tobias




randread-individual-nvmes: (groupid=0, jobs=128): err= 0: pid=37454: Mon 
Jan 23 22:12:30 2017
   read : io=869361MB, bw=28968MB/s, iops=7415.9K, runt= 30011msec
   cpu          : usr=6.14%, sys=64.55%, ctx=59170293, majf=0, minf=8320

randread-md-over-nvmes: (groupid=1, jobs=128): err= 0: pid=37582: Mon 
Jan 23 22:12:30 2017
   read : io=481982MB, bw=16064MB/s, iops=4112.4K, runt= 30004msec
   cpu          : usr=3.88%, sys=95.88%, ctx=14209, majf=0, minf=6784



[global]
group_reporting
size=30G
ioengine=libaio
iodepth=64
iodepth_batch_submit=16
thread=1
direct=1
time_based=1
randrepeat=0
norandommap=1
disable_lat=1
gtod_reduce=1
bs=4k
runtime=30

[randread-individual-nvmes]
stonewall
filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1:/dev/nvme4n1:/dev/nvme5n1:/dev/nvme6n1:/dev/nvme7n1:/dev/nvme8n1:/dev/nvme9n1:/dev/nvme10n1:/dev/nvme11n1:/dev/nvme12n1:/dev/nvme13n1:/dev/nvme14n1:/dev/nvme15n1
rw=randread
numjobs=128

[randread-md-over-nvmes]
stonewall
filename=/dev/md1
rw=randread
numjobs=128


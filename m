Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <51F16BCD.1000202@kernel.dk>
References: <CAF+0mvm8_89BhXRcs46d-AzyGunuVy3E32dcYi=kGThQkhAgfg@mail.gmail.com>
	<51F137D4.7000609@kernel.dk>
	<CAF+0mvnzF80RA8m2L9kZjrmT5OkuxYSwhGWOf+YXjOXv3RLCJA@mail.gmail.com>
	<51F16BCD.1000202@kernel.dk>
Date: Thu, 25 Jul 2013 12:19:27 -0700
Message-ID: <CAF+0mvkodcOjZ2yigxFSiq+Hjc7c5FYOOCP=j+ZthW-hCKzT+w@mail.gmail.com>
Subject: Re: Weird trim test results
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Thu, Jul 25, 2013 at 11:17 AM, Jens Axboe <axboe@kernel.dk> wrote:
> Please don't top post...
>
> On 07/25/2013 11:27 AM, Matthew Eaton wrote:
>> Hi Jens,
>>
>> I'm running Ubuntu 12.04.2, my kernel is:
>>
>> Linux matt-work 3.5.0-36-generic #57~precise1-Ubuntu SMP Thu Jun 20
>> 18:21:09 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
>>
>> Here is the output I got from blktrace / blkparse:
>>
>> Total (sdb):
>>  Reads Queued:         166,      664KiB     Writes Queued:
>> 3001,    12004KiB
>>  Read Dispatches:      166,      664KiB     Write Dispatches:
>> 3001,    12004KiB
>>  Reads Requeued:         0         Writes Requeued:         0
>>  Reads Completed:      166,      664KiB     Writes Completed:
>> 3001,     1500KiB
>>  Read Merges:            0,        0KiB     Write Merges:
>> 0,        0KiB
>>  PC Reads Queued:        0,        0KiB     PC Writes Queued:
>> 0,        0KiB
>>  PC Read Disp.:         22,        3KiB     PC Write Disp.:
>> 0,        0KiB
>>  PC Reads Req.:          0         PC Writes Req.:          0
>>  PC Reads Compl.:       10         PC Writes Compl.:        0
>>  IO unplugs:           166             Timer unplugs:           0
>
> That looks fine, it might just be coincidence that you are capped at
> ~100 IOPS. I don't think it's that unlikely that the this is the limit
> for you, your device might have a fixed overhead associated with a trim
> request. I'd have to look closer at your system to see if that's the
> case or not.
>
> --
> Jens Axboe
>

Sorry, I'm kind of new to mailing lists.  I'll test some different
drive / system configurations next.  Thanks for your help!


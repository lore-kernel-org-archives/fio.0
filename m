Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <51F137D4.7000609@kernel.dk>
References: <CAF+0mvm8_89BhXRcs46d-AzyGunuVy3E32dcYi=kGThQkhAgfg@mail.gmail.com>
	<51F137D4.7000609@kernel.dk>
Date: Thu, 25 Jul 2013 10:27:55 -0700
Message-ID: <CAF+0mvnzF80RA8m2L9kZjrmT5OkuxYSwhGWOf+YXjOXv3RLCJA@mail.gmail.com>
Subject: Re: Weird trim test results
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi Jens,

I'm running Ubuntu 12.04.2, my kernel is:

Linux matt-work 3.5.0-36-generic #57~precise1-Ubuntu SMP Thu Jun 20
18:21:09 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

Here is the output I got from blktrace / blkparse:

Total (sdb):
 Reads Queued:         166,      664KiB     Writes Queued:
3001,    12004KiB
 Read Dispatches:      166,      664KiB     Write Dispatches:
3001,    12004KiB
 Reads Requeued:         0         Writes Requeued:         0
 Reads Completed:      166,      664KiB     Writes Completed:
3001,     1500KiB
 Read Merges:            0,        0KiB     Write Merges:
0,        0KiB
 PC Reads Queued:        0,        0KiB     PC Writes Queued:
0,        0KiB
 PC Read Disp.:         22,        3KiB     PC Write Disp.:
0,        0KiB
 PC Reads Req.:          0         PC Writes Req.:          0
 PC Reads Compl.:       10         PC Writes Compl.:        0
 IO unplugs:           166             Timer unplugs:           0

On Thu, Jul 25, 2013 at 7:36 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 07/24/2013 02:22 PM, Matthew Eaton wrote:
>> Hi guys,
>>
>> I'm using this simple trim test on a raw SSD but getting very low
>> performance.  Bandwidth seems to be tied to the block size.  Am I
>> doing something wrong?
>
> What kernel are you on? This looks like a missing unplug issue. If you
> run a blktrace for a few seconds while the test is ongoing, the output
> of blkparse should reveal if you are seeing timer unplugs.
>
> --
> Jens Axboe
>


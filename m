Return-Path: <axboe@kernel.dk>
Message-ID: <551AF865.1070609@kernel.dk>
Date: Tue, 31 Mar 2015 13:41:25 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO still returning 0 and writing file after bogus arguments
References: <C0788AB690B48C4C8D95FA764A79D177240EE862@CFWEX01.americas.cray.com>
In-Reply-To: <C0788AB690B48C4C8D95FA764A79D177240EE862@CFWEX01.americas.cray.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Andy Moe <moea@cray.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/26/2015 04:20 PM, Andy Moe wrote:
> ### Description:
> FIO still seems to be returning zero and writing a file after bogus arguments have been provided.  In my particular case, it's returning zero when I try to write data to a file with the 'sg' engine.
>
> ### Environment:
> CentOS release 6.4 (Final)
> Linux iosr80-0.us.cray.com 2.6.32-358.el6.x86_64 #1 SMP Fri Feb 22 00:31:26 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
>
> ### FIO version:
> fio-2.2.6-15-g3765
>
> ### How to reproduce:
> Here is output demonstrating what I'm finding.
>
> [moea@iosr80-0 dev-tests]$ ls -l | grep outfile0
> [moea@iosr80-0 dev-tests]$ fio --filename outfile0 --rw=readwrite --ioengine=sg --blocksize=8m --size=128m --name=job0
> job0: (g=0): rw=rw, bs=8M-8M/8M-8M/8M-8M, ioengine=sg, iodepth=1
> fio-2.2.6-15-g3765
> Starting 1 process
> job0: Laying out IO file(s) (1 file(s) / 128MB)
> ioengine sg only works on block devices
>
>
> Run status group 0 (all jobs):
>
> Disk stats (read/write):
>      dm-3: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
>    sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
> [moea@iosr80-0 dev-tests]$ echo $?
> 0
> [moea@iosr80-0 dev-tests]$ ls -l outfile0
> -rw-r--r--. 1 moea moea 134217728 Mar 26 17:06 outfile0

That's because fio will lay out the files first, regardless of IO 
engine, before the engine opens them. So the file writing is really just 
an artifact of that. It could be fixed, but I really don't see much 
point to it.

It should not return 0, though, I checked in a fix for that just now.

-- 
Jens Axboe



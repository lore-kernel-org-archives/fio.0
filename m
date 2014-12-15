Return-Path: <axboe@kernel.dk>
Message-ID: <548E49E0.10503@kernel.dk>
Date: Sun, 14 Dec 2014 19:39:28 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Sequential Commands are essentially random when in mixed sequential/random
 workloads
References: <89470388ACB8A24491F3E64F24385FD75A4DC251@wdscexmb03> <548CC380.4070100@kernel.dk> <CANvN+enb9j_964d9=R-iOq79VCu7ZzjqSw7K6Oz-XNAx-n3aGg@mail.gmail.com>
In-Reply-To: <CANvN+enb9j_964d9=R-iOq79VCu7ZzjqSw7K6Oz-XNAx-n3aGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: Stephen Nichols <Stephen.Nichols@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/14/2014 08:20 AM, Andrey Kuzmin wrote:
> On Sun, Dec 14, 2014 at 1:53 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 12/12/2014 05:23 PM, Stephen Nichols wrote:
>>> Hi all,
>>>
>>> When using fio configuration below..
>>>
>>> [global]
>>> ioengine=libaio
>>> direct=1
>>> runtime=600
>>> bs=32k
>>> iodepth=8
>>> rw=randrw
>>> rwmixread=80
>>> percentage_random=100,0
>>>
>>> [drive1]
>>> filename=/dev/sda
>>>
>>>
>>> I am expecting to see 80% reads, 20% writes where all reads are random and all writes are sequential. I captured a bus trace of traffic to the disk and the bus trace reflected as much with one issue. The write commands are essentially random. Each write begins at a new random LBA. If 2 or more writes occur in a row, the LBA's are sequential based on the block size BUT I feel the heart of this feature would be to emulate a large file write during random access. With that in mind would it be possible for sequential reads or writes within mixed sequential/random workload to remember the last LBA accessed? In this scenario the writes would still only take up 20% of the workload but when a write did occur it should be the next sequential step from the last write.
>>>
>>>
>>> Snippet from the bus trace for reference
>>>
>>> Command                                           LBA
>>> Read FPDMA Queued:                  19F3F818
>>> Read FPDMA Queued:                  1CBE2740
>>> Write FPDMA Queued:                 24E35198
>>> Write FPDMA Queued:                 24E351A0
>>> Read FPDMA Queued:                  115A9E10
>>> Write FPDMA Queued:                 A3C1968
>>> Read FPDMA Queued:                  20B89488
>>> Write FPDMA Queued:                 336EE0D0
>>> Write FPDMA Queued:                 336EE0D8
>>>
>>>
>>>
>>> Let me know what you think, this feature may be working as intended but it seemed off to me.
>>
>> Would be easy enough to fix, we just need to track last offset per data
>> direction. Does the attached work for you? Totally untested, will test
>> on Monday.
>
> Looks like fixed.

Thanks for verifying, Andrey. After taking a second look, looks sane to 
me after all. Lucky punch!

Stephen, the fix has been committed, so if you just update to the latest 
git, it should hopefully work for you as well. Please report back when 
you have tested it.

-- 
Jens Axboe



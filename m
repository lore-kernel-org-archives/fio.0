Return-Path: <axboe@kernel.dk>
Message-ID: <548CC39A.3080104@kernel.dk>
Date: Sat, 13 Dec 2014 15:54:18 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Sequential Commands are essentially random when in mixed sequential/random
 workloads
References: <89470388ACB8A24491F3E64F24385FD75A4DC251@wdscexmb03> <CANvN+ekgXKivBooiEtpNKApmoWg=Dv-DwYbOKQ0WKcPLqUCnoQ@mail.gmail.com>
In-Reply-To: <CANvN+ekgXKivBooiEtpNKApmoWg=Dv-DwYbOKQ0WKcPLqUCnoQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, Stephen Nichols <Stephen.Nichols@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/13/2014 01:31 PM, Andrey Kuzmin wrote:
> On Sat, Dec 13, 2014 at 3:23 AM, Stephen Nichols
> <Stephen.Nichols@wdc.com> wrote:
>>
>> Hi all,
>>
>> When using fio configuration below..
>>
>> [global]
>> ioengine=libaio
>> direct=1
>> runtime=600
>> bs=32k
>> iodepth=8
>> rw=randrw
>> rwmixread=80
>> percentage_random=100,0
>>
>> [drive1]
>> filename=/dev/sda
>>
>>
>> I am expecting to see 80% reads, 20% writes where all reads are random and all writes are sequential. I captured a bus trace of traffic to the disk and the bus trace reflected as much with one issue. The write commands are essentially random. Each write begins at a new random LBA. If 2 or more writes occur in a row, the LBA's are sequential based on the block size BUT I feel the heart of this feature would be to emulate a large file write during random access. With that in mind would it be possible for sequential reads or writes within mixed sequential/random workload to remember the last LBA accessed? In this scenario the writes would still only take up 20% of the workload but when a write did occur it should be the next sequential step from the last write.
>>
>>
>> Snippet from the bus trace for reference
>>
>> Command                                           LBA
>> Read FPDMA Queued:                  19F3F818
>> Read FPDMA Queued:                  1CBE2740
>> Write FPDMA Queued:                 24E35198
>> Write FPDMA Queued:                 24E351A0
>> Read FPDMA Queued:                  115A9E10
>> Write FPDMA Queued:                 A3C1968
>> Read FPDMA Queued:                  20B89488
>> Write FPDMA Queued:                 336EE0D0
>> Write FPDMA Queued:                 336EE0D8
>>
>>
> 
> The problem is that, with non-trivial percentage_random, fio generates
> next sequential offset off the file's last position, but the latter is
> global, not per data direction. As a result, with the workload above,
> one gets the pattern where next write is sequential with respect to
> the last I/O, not the last write as, I believe, the expectation goes.

Yup, that is exactly the problem.

-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Message-ID: <542771CC.9090203@kernel.dk>
Date: Sat, 27 Sep 2014 20:26:20 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: If loops= is specified, zone state is unexpectedly retained across
 iterations.
References: <CAFFT=UkPhmUHD0EAH1_KDviB9909=NwqNSeCXWiOz=0Fp6phhA@mail.gmail.com> <CAFFT=Ukkh3E7tkJkVQ09VMiribNtTt+ZKi8w3VRf7ovS5xw4ww@mail.gmail.com>
In-Reply-To: <CAFFT=Ukkh3E7tkJkVQ09VMiribNtTt+ZKi8w3VRf7ovS5xw4ww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Akash Verma <akashv@google.com>, fio <fio@vger.kernel.org>
Cc: Allen Schade <aschade@google.com>
List-ID: <fio@vger.kernel.org>

On 2014-09-25 11:36, Akash Verma wrote:
> Adding Jens on cc.
>
> On Tue, Sep 23, 2014 at 6:02 PM, Akash Verma <akashv@google.com> wrote:
>> I'm wondering if this is desired behavior or accidental. If I use this
>> control file:
>>
>> [sdb-zoned-and-looped]
>> rw=write
>> bs=4k
>> size=24k
>> zonesize=12k
>> zonerange=512k
>> zoneskip=512k
>> ioengine=sync
>> direct=1
>> thread=1
>> loops=10
>> filename=/dev/sdb
>> write_iolog=sdb_iolog.txt
>>
>> sdb_iolog.txt shows:
>> fio version 2 iolog
>> /dev/sdb add
>> /dev/sdb open
>> /dev/sdb write 0 4096
>> /dev/sdb write 4096 4096
>> /dev/sdb write 8192 4096
>> /dev/sdb write 1048576 4096
>> /dev/sdb write 1052672 4096
>> /dev/sdb write 1056768 4096
>> /dev/sdb close
>> /dev/sdb open
>> /dev/sdb write 1048576 4096
>> /dev/sdb write 1052672 4096
>> /dev/sdb write 1056768 4096
>> /dev/sdb write 2097152 4096
>> /dev/sdb write 2101248 4096
>> /dev/sdb write 2105344 4096
>> ...
>>
>> I'd expect each iteration of the loop to be identical, rather than
>> resuming from the zone offset of the previous iteration. Would it be
>> okay to change this behavior?

Yeah I think that would be OK, basically all state is cleared between 
loops, so I'd consider that a bug. The whole point of a loop is that 
they are supposed to be identical.

-- 
Jens Axboe



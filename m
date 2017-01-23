Return-Path: <tobias.oberstein@gmail.com>
Return-Path: <tobias.oberstein@gmail.com>
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <CANvN+en2ihATNgrbgzwNXAK87wNh+6jXHinmg2-VmHon31AJzA@mail.gmail.com>
 <061acabe-dbd0-ae07-cd69-772eccd15b21@gmail.com>
 <CANvN+em0cjWRnQWccdORKFEJk0OSeQOrZq+XE6kzPmqMPB--4g@mail.gmail.com>
 <49ef9d71-8e52-26e4-76f7-ea03fb331a38@gmail.com>
 <CALjAwxjmW-NgWEcH7+nKNN8U_oUxFoYa23dui9wM6WDqiShWhw@mail.gmail.com>
 <15418080-0bf6-ab40-c05f-69a3fb3d9cc3@gmail.com>
 <CALjAwxhsvfH0-D=4U6nkjFg109Z1ZgVRsOx37X+Lb-EqTf_jOA@mail.gmail.com>
 <6b2cacaf-2946-6046-51c2-b909c6ee0784@gmail.com>
 <CANvN+emLjb9idri9r42V3W9ia6v0EDGdJYFfhzq6rAuzGWec8Q@mail.gmail.com>
 <CANvN+emJBzMeUmjBw5PBSZc66LmjG8-Pz+39dBeL5GseMCdo6g@mail.gmail.com>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <fca1cdb1-aa66-b21f-d1a0-029ba895d3f2@gmail.com>
Date: Tue, 24 Jan 2017 00:51:15 +0100
MIME-Version: 1.0
In-Reply-To: <CANvN+emJBzMeUmjBw5PBSZc66LmjG8-Pz+39dBeL5GseMCdo6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> The root cause behind the high cpu utilization is the IRQ load your eight
> NVMe drives generate, although context switching your 2048 threads also add
> a lot.

Indeed, the ctx switches and interrupts are in the millions/sec.

With engine=sync and numjobs=2048, I have

ctx_sw: 8828446
inter:  5780374

It's astonishing that this is even possible.

> To cope with the unsustainable interrupt rate, you might want to give a
> shot to the psync engine with RWF_HIPRI option set, which turns on polling
> mode in the block layer (Jens has been very much behind it, so he's the guy
> in the know of the details).
>
> Polling avoids interrupts at the price of the somewhat inflated latency,
> but reduces the cpu load noticeably, so it may turn out a good option for
> your box specifically. Notice you'll need preadv2/pwrirev2 syscall support
> in your kernel.

I have run an exhaustive number of 30 tests using the different engines, 
including pvsync2 + hipri.

Please find everything here

https://github.com/oberstet/scratchbox/blob/master/cruncher/sync-engines/README.md

and in the containing folder there.

Using pvsync2 + hipri indeed changes the picture .. but not to the better =(

The machine completely bogs down and the IOPS doesn't get higher.

Sidenote: would nice if FIO logged the total CPU and interrupt rates ..

Here is a screenshot while running pvsync2+hipri

http://picpaste.com/pics/Bildschirmfoto_vom_2017-01-23_23-52-10-55NJYHu2.1485215076.png

--

My current preliminary conclusions on this box / workload:

- running psync is much better than sync
- all engines "above" psync only bring minor perf. gains
- Linux MD (pure striping, RAID-0) comes with rougly 45% overhead
- saturing the storage subsystem consumes nearly all CPU

Cheers,
/Tobias

PS: I have a small time window left (days) until this box goes into 
further setup for production (which means, I cannot scratch the storage 
anymore) - if you have anything you want me to try, let me know. I do my 
best to get it tested. The hardware is probably not mainstream ..




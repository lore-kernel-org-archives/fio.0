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
 <fca1cdb1-aa66-b21f-d1a0-029ba895d3f2@gmail.com>
 <CANvN+emQ0AYPgT0e6KMKphDTZAY=cW6FyroLw=smReHGpd-=TA@mail.gmail.com>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <a0dc59e7-9c81-ab5d-45b6-d1d252179837@gmail.com>
Date: Tue, 24 Jan 2017 10:28:05 +0100
MIME-Version: 1.0
In-Reply-To: <CANvN+emQ0AYPgT0e6KMKphDTZAY=cW6FyroLw=smReHGpd-=TA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

> My current preliminary conclusions on this box / workload:
>
> - running psync is much better than sync
>
> So you likely have a convincing case for Postgres guys to switch over to
> pread/pwrite.

I will approach them, but I want to make sure I did all my homework first.

One question that bugs me:

the difference in performance between sync and psync engines only 
surface with MD, _not_ when running over individual devices.

---

I ran Linux perf with these results:

https://github.com/oberstet/scratchbox/blob/master/cruncher/sync-engines-perf/individual-nvmes-sync.md

https://github.com/oberstet/scratchbox/blob/master/cruncher/sync-engines-perf/individual-nvmes-psync.md

https://github.com/oberstet/scratchbox/blob/master/cruncher/sync-engines-perf/md-nvmes-sync.md

https://github.com/oberstet/scratchbox/blob/master/cruncher/sync-engines-perf/md-nvmes-psync.md

---

md-nvmes-sync shows the "issue":

Overhead  Command  Shared Object       Symbol
   73.48%  fio      [kernel.kallsyms]   [k] osq_lock


So while I think it would be good in general if PostgreSQL used 
pread/pwrite instead of lseek/read/write when available, I am afraid 
there might be a bottleneck in MD.

What do you think?

And if so, where should I raise this rgd MD? I have no clue where the 
hackers of MD hang out ..

Cheers,
/Tobias


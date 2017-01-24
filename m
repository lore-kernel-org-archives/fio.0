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
 <a0dc59e7-9c81-ab5d-45b6-d1d252179837@gmail.com>
 <CANvN+e=qsexdU6Pp4kKQXy-jQKixZhR-WWLQb=713NNAA0ziVg@mail.gmail.com>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <68e44114-5d14-a714-09a6-d80358d10118@gmail.com>
Date: Tue, 24 Jan 2017 23:51:52 +0100
MIME-Version: 1.0
In-Reply-To: <CANvN+e=qsexdU6Pp4kKQXy-jQKixZhR-WWLQb=713NNAA0ziVg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

> My current preliminary conclusions on this box / workload:
>>
>> - running psync is much better than sync
>>
>> So you likely have a convincing case for Postgres guys to switch over to
>> pread/pwrite.

I did raise it on the PG hackers mailing list, but I couldn't convince 
them =(

Pity, since there even was a patch in the past (the change seems to be 
easy, but was rejected).

They say, I would need to come up with a real world PostgreSQL database 
workload that shows this effect is above the noise level.

And since PostgreSQL is such a CPU hog anyway, and since I don't have 
time for a full research project, I leave it.

---

But, I did more FIO level benchmarking to compare the efficiency of 
different IO methods:

Here are more numbers that quantify the differences of the IO method used.

ioengine	sync	psync	vsync	pvsync	pvsync2	pvsync2+hipri
iodepth		1	1	1	1	1	1
numjobs		1024	1024	1024	1024	1024	1024
						
						
concurrency	1024	1024	1024	1024	1024	1024
iops (k)	9171	9390	9196	9473	9527	9516
user		7,7	9,3	8,6	9,0	9,3	2,6
system		86,8	77,0	85,8	76,3	77,3	97,4
total		94,5	86,3	94,4	85,3	86,6	100,0
						
iops/system	105,7	121,9	107,2	124,2	123,2	97,7


As can be seen, the kIOPS normalized to system CPU load (last line) for 
psync (pread/pwrite) is significantly higher than for sync 
(lseek/read/write).

Now here is AIO:

ioengine	libaio	libaio	libaio
iodepth		32	32	32
numjobs		128	64	32
			
			
concurrency	4096	2048	1024
iops (k)	9485,6	9479,4	8718,1
user		6,7	3,4	2,4
system		59,2	30,0	16,7
total		65,9	33,4	19,1
			
iops/system	160,2	316,0	522,0

The highest kIOPS/system is reached at a concurrency of 1024.

However, during my tests, I get this in kernel log:

[459346.155564] NMI watchdog: BUG: soft lockup - CPU#46 stuck for 22s! 
[swapper/46:0]
[461040.530959] NMI watchdog: BUG: soft lockup - CPU#26 stuck for 22s! 
[swapper/26:0]
[461044.279081] NMI watchdog: BUG: soft lockup - CPU#23 stuck for 22s! 
[swapper/23:0]

I wild guess: these lockups are actually deadlocks. AIO seems to be 
tricky for the kernel too.

Cheers,
/Tobias


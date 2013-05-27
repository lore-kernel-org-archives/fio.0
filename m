Return-Path: <sampath.rapaka@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130527133332.GH29680@kernel.dk>
References: <CAJqT0ix50Pr0+DEVVStAZxiAa6Xx=SGRwQQX9QXa0Jdu13HG2A@mail.gmail.com>
	<20130527133332.GH29680@kernel.dk>
Date: Mon, 27 May 2013 19:46:05 +0530
Message-ID: <CAJqT0izq6_VZ1n8wWR1px+WVDkM9uo+1Hrs=e3oS3HVkOEWMfg@mail.gmail.com>
Subject: Re: Any Delay Introduced by FIO between submission of Two IOs?
From: sampath rapaka <sampath.rapaka@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

hi jens

Firstly sorry for misplacing the logs in the above mail. Those are
excerpts from other test program.

Thanks for your clarification.

FIO Job File is some thing like this :

  3 [global]
  4 ioengine=libaio
  5 direct=1
  6 filename=/dev/md0
  7 blocksize=4k
  8 iodepth=${IoDepth}
  9 size=${Size}
 10 write_iops_log=total_iops_W9R1
 11
 12 [read1]
 13 rw=randread
 14 write_lat_log=read1_W9R1
 15
 16
 17 [write1]
 18 rw=randwrite
 19 write_lat_log=write1_W9R1
 20
 21 [write2]
 22 rw=randwrite
 23 write_lat_log=write2_W9R1


Below is the log from blktrace:


1163147   8,16   0   172181     2.386764602     0  C  WS 872560 + 8
[0]  >> This is where commit to 8,16 happens

1163148   8,16   0   172182     2.386767040     0  D  WS 2244224 + 8 [swapper/0]

1163149   8,32   0   269041     2.388917654     0  C  WS 4992504 + 8 [0]

1163150   8,32   0   269042     2.388923411     0  D  WS 3160896 + 8 [swapper/0]

1163151   9,0    0    20654     2.388933229 22220  Q  WS 4514832 + 8
[fio]  >> This is where new IO is Queued

1163152   8,16   3   159545     2.388938315 21059  Q  WS 4776976 + 8
[md0_raid1_slow0]

1163153   8,16   3   159546     2.388938804 21059  G  WS 4776976 + 8
[md0_raid1_slow0]

Gap between those lines seems to be big. So i was wondering whether
any Delay is introduced by FIO.

I have one more question in general though not related to above logs.
Increasing the nr_request value for a device(some thousands) results
in increase in Q-D values for a IO while  having  queue depth at 31?

echo 10000 > /sys/block/sdb/queue/nr_requests

echo 31 > /sys/block/sdb/device/queue_depth

regards
sampath

On Mon, May 27, 2013 at 7:03 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On Mon, May 27 2013, sampath rapaka wrote:
>> hi
>>
>> i have run couple of fio runs. i am running this over raid1 device. i
>> have captured blktrace for each run. I was going through the
>> blktraces. what i have observed is there instances where there is
>> commit happening to disk at say time stamp X. I was expecting a new IO
>> to be submitted at X+1 time stamp. but i see next IO is submitted at
>> time stamp Y.
>>
>> Y-X is more than 1. Is there any delay introduced from FIO between two
>> fios. or what could be the probable reasons to see such delay? let me
>> know if my understanding is wrong.
>>
>> Below is the excerpt from blktrace:
>>
>> 21378   8,32   3     9162     0.116015463     0  C  WS 574576152 + 8 [0]
>>  21379   8,16   3    10690     0.116020386     0  C  WS 574576152 + 8 [0]
>>  21380   9,0    0        1     0.120074779  8797  Q  WS 131300520 + 8 [fitness]
>>
>> from lines 21379(C) to 21380(Q) there is lots of delay for submission of new IO.
>>
>> So i was thinking in lines of any delay from FIO between submissions
>> of IO or they submit IO as soon as it is available.
>>
>> Question 2:
>> I have also observed larger delays in Q-D values. which is more than D-C value.
>>
>> What could be the possible reasons for this behavior ?
>
> Fio doesn't introduce any delays on purpose. What job file are you
> running?
>
> It could either be that fio is scheduled out or in other ways in a
> non-running state. Or perhaps fio is waiting for completions.
>
> Line 21380 above is something called 'fitness', what is that?
>
> --
> Jens Axboe
>


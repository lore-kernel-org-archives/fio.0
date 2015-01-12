Return-Path: <axboe@kernel.dk>
Message-ID: <54B45DBE.4000705@kernel.dk>
Date: Mon, 12 Jan 2015 16:50:22 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Log Bug with fio-2.1.14 and Higher Causing fio Jobs to Time Out
References: <CAFCBNRFzOw4rVnWpHWN=FfdhDYePKwP9xo7vWdKTPR+LSpyZwQ@mail.gmail.com>
In-Reply-To: <CAFCBNRFzOw4rVnWpHWN=FfdhDYePKwP9xo7vWdKTPR+LSpyZwQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: George T Seese <george.t.seese@seagate.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 01/09/2015 09:04 AM, George T Seese wrote:
> fio team,
> 
> I've found a bug that results in fio hanging at the end of a workload
> involving log generation, in this case specific to latency log
> generation. The bug appears in version 2.1.14, 2.2.4, and possibly
> others. I have tested these scripts with 2.0.9 and they work. Slightly
> different scripts work on 2.0.14 as well.
> 
> Error message and script file are copy-pasted below. The job that
> times out is not always the same job but, usually at least one does
> time out, it's worse with more targets.
> 
> fio: pid=37182, got signal=11
> fio: job '/dev/sdc' hasn't exited in 60 seconds, it appears to be
> stuck. Doing forceful exit of this job.
> 
> [global]
> bs=4k
> runtime=1800
> rw=randread
> ;thread=1
> direct=1
> ioengine=libaio
> ;offset=0
> ;randommap=1
> ;time_based=1
> bwavgtime=5000
> ;write_lat_log
> ;stonewall=1
> iodepth=1
> 
> ;TargetDriveMarker
> [/dev/sdc]
> filename=/dev/sdc
> write_lat_log=sdc
> 
> [/dev/sdd]
> filename=/dev/sdd
> write_lat_log=sdd

Thanks, I'll take a look at this.

-- 
Jens Axboe



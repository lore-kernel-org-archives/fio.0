Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <BLU402-EAS374F3B5890A9AA4FCE9E01DE0BB0@phx.gbl>
References: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl>
	<5429B424.7080903@kernel.dk>
	<BLU402-EAS1251A573D70EC1946D3C402E0BA0@phx.gbl>
	<5429C839.7090408@kernel.dk>
	<BLU402-EAS83A272EBBE7E3778E31EF8E0BA0@phx.gbl>
	<CALjAwxjEs_pcP3tHDSE76cdjC0JpRK_+xofshHTL0Lgch3J_OQ@mail.gmail.com>
	<542A1A21.4070406@kernel.dk>
	<BLU402-EAS3400F7B4A22E573A13F520CE0BB0@phx.gbl>
	<CALjAwxjcCm-Tm5kRf8SX0xYjj458fycVJ3SvOEPsOKaQUgiRDA@mail.gmail.com>
	<BLU402-EAS379961D4B53D8CE57017DC8E0BB0@phx.gbl>
	<CALjAwxhBMStNgdwqYVxcq4yDwJB+F+22Ef4Ra=oorCfeRBb6ew@mail.gmail.com>
	<BLU402-EAS374F3B5890A9AA4FCE9E01DE0BB0@phx.gbl>
Date: Tue, 30 Sep 2014 14:07:14 +0100
Message-ID: <CALjAwxiN0cg0adpYvHZaYwp=aOueNJph5QWtUVih_JtoejjFFQ@mail.gmail.com>
Subject: Re: Limit LBA Range
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jon Tango <cheerios123@outlook.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 30 September 2014 08:56, Jon Tango <cheerios123@outlook.com> wrote:
>
> On 30 September 2014 07:34, Jon Tango <cheerios123@outlook.com> wrote:
>>
>> The taskfile is this:
>
> I should have been more specific - you need to show both the _vdbench_ parameter file that you are comparing to in addition to showing your fio job file.
>
> Here you go :) VDBench uses percentages for specifying the LBA range.
>
> hd=localhost,clients=4,jvms=4
> sd=s1,lun=\\.\PhysicalDrive1,align=4096,range=(0,86)
> *
> sd=default,offset=4096,align=4096
> wd=wd1,sd=s1,rdpct=0,seekpct=100
> *
> rd=rd1,wd=wd1,iorate=max,forthreads=128,xfersize=4k,elapsed=18000,interval=1

I'm not familiar with vdbench but unpacking the above I'd guess the following:

Define a host definition of
Simulate 4 clients
Override the default process cloning logic and create 4 processes (via
4 JVMs) and run the random workload on each one
Run all process on the local machine

Define a storage definition with the name s1 with the following parameters:
Write to the device \\.\PhysicalDrive1
(Align I/O to 4k but this is redundant as alignment defaults to
xfersize according to the documentation for align=)
Use only the first 86% of the device
Use an sd name of s1 definition name of

Set the following for all future storage definitions:
Only start doing I/O 4096 bytes into the start of the device
(Align I/O to 4k but this is redundant as alignment defaults to
xfersize according to the documentation for align=)

(Since no storage definitions are defined after this point the above
looks redundant)

Define a workload definition called wd1 with the following parameters:
Use storage definition s1
Only do write I/O
Make every I/O go to a different address (100% random)

Define a run definition called rd1 with the following parameters:
Use a workload definition wd1
Run I/O as quickly as possible
Use an I/O depth of 128 by using 128 threads (per process?)
(Use a block size of 4KBytes but this is redundant as xfersize
defaults to 4KBytes according to the documentation for xfersize=)
Do the workload for 18000 seconds (5 hours)
Tell me what's happening every second

Here's what I think your fio workload does:

>  [global]
> name=4ktest
> filename=\\.\physicaldrive1
> direct=1
> numjobs=8
> norandommap
> ba=4k
> time_based
> size=745g
> log_avg_msec=100000
> group_reporting=1
> #########################################################
>
> [4K Precon]
> stonewall
> runtime=15000
> iodepth=32
> bs=4k
> rw=randwrite

Set these as globals to all jobs:
Use a name of 4ktest
Use the disk \\.\physicaldrive1
Write directly to the disk
Spawn each job eight times
Don't worry about trying to write writing all blocks evenly
(align I/O to 4Kbytes but this is redundant because blockalign=int
says it default to the blocksize minimum)
Quit based on time
Only do I/O between using the entirety of the first 745 GBytes of the device
Average stats over 100000 milliseconds
Display stats for jobs as a whole rather than individually

Define an individual job:
(stonewall is discarded because jobs are grouped by numjobs)
Run this job for 15000 seconds (4.1 hours)
Queue I/O up to a depth of 32
Use a block size of 4KBytes
Do random writes.

So I'd argue your vdbench and fio jobs are not doing the same thing.

1. Since you're on Windows fio only has access to threads not
processes whereas vdbench is able to make use of processes and
threads.
2. Your vdbench setup can submit up to a theoretical maximum I/O depth
of 512 whereas you are limiting your fio setup to a theoretical max
I/O depth of 256.
3. Your vdbench setup will not access the first block of your raw disk
(which is where the partition table lives which can trigger extra work
when written).
4. 86% of 850 is 731...
5. We don't know if the random distributions (used to choose the data
being written and the next location to write) that fio and vdbench use
are comparable.
6. Your vdbench is effectively able to submit I/O asynchronously
because it's coming from individual threads but you don't use the
windowsaio ioengine individual fio jobs do something similar.
7. You are running these jobs for different lengths of time.

If all you're trying to do is run a limited random job as quickly as
possible you may find there are simpler fio jobs that will get higher
throughput...

-- 
Sitsofe | http://sucs.org/~sits/


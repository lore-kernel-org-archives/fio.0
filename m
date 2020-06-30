Return-Path: <ykorman@gmail.com>
MIME-Version: 1.0
References: <cover.1592981060.git.ykorman@gmail.com> <9b74bba79ea8e70991754ac55dc4f65d44c6c347.1592981060.git.ykorman@gmail.com>
 <f79de251-712d-d26d-f2f2-112d2d55ea78@kernel.dk> <CAOdGBnHtynxPtR6AvR8SUNo7qUyF_pG9cQnm99yzwq-VM-rxpw@mail.gmail.com>
 <9297739f-6ad0-b53a-0edc-ea5a29cae114@kernel.dk> <cb8486ff-6242-b7eb-cee8-0d21b4f03c9d@kernel.dk>
In-Reply-To: <cb8486ff-6242-b7eb-cee8-0d21b4f03c9d@kernel.dk>
From: Yigal Korman <ykorman@gmail.com>
Date: Tue, 30 Jun 2020 23:08:32 +0300
Message-ID: <CAOdGBnEbETv0vxkydcWb4SG4trs8EvRng+2_V5YngLWzJMMMsA@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] configure: new --dynamic-libengines build option
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Tue, Jun 30, 2020 at 10:42 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 6/30/20 1:35 PM, Jens Axboe wrote:
> > On 6/30/20 1:25 PM, Yigal Korman wrote:
> >> On Tue, Jun 30, 2020 at 12:07 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>>
> >>> On 6/28/20 1:27 PM, Yigal Korman wrote:
> >>>> When enabled, some of the more dependency-heavy internal engines are
> >>>> converted to "plugin" engines, i.e. they are built into separate object
> >>>> files and are loaded by fio on demand.
> >>>> This helps downstream distros package these engines separately and not
> >>>> force a long list of package dependencies from the base fio package.
> >>>
> >>> How does this impact the performance of the engine? It'd be interesting
> >>> to run a test with something ala:
> >>>
> >>> fio --name=test --ioengine=null --size=100g --rw=randread --norandommap --gtod_reduce=1
> >>>
> >>> with the current build, then apply these patches (and turn the null engine
> >>> into an externally loadable engine, of course), and re-run the test case.
> >>>
> >>> For what it's worth, I like the change in general, as dependencies do
> >>> pile on. But I'd like to ensure that we're not taking a performance hit
> >>> for something like this.
> >>
> >> Great to hear.
> >>
> >> Here are the results of the run you suggested:
> >>
> >> current build (statically linked) -
> >>
> >> [root@host fio]# ./fio.static --name=test --ioengine=null --size=100g
> >> --rw=randread --norandommap --gtod_reduce=1
> >> test: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
> >> 4096B-4096B, ioengine=null, iodepth=1
> >> fio-3.20-70-g9888
> >> Starting 1 process
> >> Jobs: 1 (f=1): [r(1)][100.0%][r=3910MiB/s][r=1001k IOPS][eta 00m:00s]
> >> test: (groupid=0, jobs=1): err= 0: pid=155: Tue Jun 30 06:55:19 2020
> >>   read: IOPS=1000k, BW=3906MiB/s (4095MB/s)(100GiB/26219msec)
> >>    bw (  MiB/s): min= 3786, max= 3967, per=100.00%, avg=3909.96,
> >> stdev=38.59, samples=52
> >>    iops        : min=969293, max=1015596, avg=1000951.42,
> >> stdev=9879.80, samples=52
> >>   cpu          : usr=61.66%, sys=38.31%, ctx=103, majf=8, minf=5
> >>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
> >>      submit    : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> >>      complete  : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> >>      issued rwts: total=26214400,0,0,0 short=0,0,0,0 dropped=0,0,0,0
> >>      latency   : target=0, window=0, percentile=100.00%, depth=1
> >>
> >> Run status group 0 (all jobs):
> >>    READ: bw=3906MiB/s (4095MB/s), 3906MiB/s-3906MiB/s
> >> (4095MB/s-4095MB/s), io=100GiB (107GB), run=26219-26219msec
> >>
> >> With patches applied[0] -
> >>
> >> [root@host fio]# ./fio --name=test --ioengine=null --size=100g
> >> --rw=randread --norandommap --gtod_reduce=1
> >> test: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
> >> 4096B-4096B, ioengine=null, iodepth=1
> >> fio-3.20-70-g9888
> >> Starting 1 process
> >> Jobs: 1 (f=1): [r(1)][100.0%][r=3905MiB/s][r=1000k IOPS][eta 00m:00s]
> >> test: (groupid=0, jobs=1): err= 0: pid=158: Tue Jun 30 06:55:49 2020
> >>   read: IOPS=1006k, BW=3929MiB/s (4120MB/s)(100GiB/26060msec)
> >>    bw (  MiB/s): min= 3753, max= 3988, per=100.00%, avg=3933.86,
> >> stdev=45.93, samples=52
> >>    iops        : min=960962, max=1021038, avg=1007067.92,
> >> stdev=11758.92, samples=52
> >>   cpu          : usr=62.14%, sys=37.81%, ctx=117, majf=8, minf=5
> >>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
> >>      submit    : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> >>      complete  : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> >>      issued rwts: total=26214400,0,0,0 short=0,0,0,0 dropped=0,0,0,0
> >>      latency   : target=0, window=0, percentile=100.00%, depth=1
> >>
> >> Run status group 0 (all jobs):
> >>    READ: bw=3929MiB/s (4120MB/s), 3929MiB/s-3929MiB/s
> >> (4120MB/s-4120MB/s), io=100GiB (107GB), run=26060-26060msec
> >>
> >> I wasn't expecting dynamic linking to have a performance impact and
> >> the results seem to agree.
> >
> > That's nice to see. I'd probably add --cpus_allowed=0 to it for
> > better locality, and then run 10 tests back-to-back with each
> > just to be sure. There will be some fluctuations, but that should
> > be enough for me to feel comfortable.
> >
> > 1000K IOPS is pretty slow though, what are you running this on?
> > Pretty sure my laptop does 10x that.

Yeah, a tiny VM on my laptop for playing around with the package
manager, not a good candidate for perf testing.
I re-ran as you suggested on the host (i5-6200U @ 2.30GHz), see results here[0].

>
> Ran the testing here, and nothing statistically significant.

Yes, I got the same. Thanks!

Would you like a pull request for the patchset? (after I fix the last patch)

Regards,
Yigal

[0] https://gist.github.com/ykorman/da92200cd79b22f441b98a57ea28726c
>

>
> --
> Jens Axboe
>


Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Mon, 4 May 2020 15:15:58 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 3/7] zbd: introduce per-device "max_open_zones" limit
Message-ID: <20200504121558.GA19268@avx2>
References: <20200430124050.20146-1-adobriyan@gmail.com>
 <20200430124050.20146-3-adobriyan@gmail.com>
 <BY5PR04MB690042CF7A2990BE21B0DBCDE7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
 <20200501185208.GB32674@avx2>
 <BY5PR04MB690028920E402F350BD5FDD6E7A60@BY5PR04MB6900.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BY5PR04MB690028920E402F350BD5FDD6E7A60@BY5PR04MB6900.namprd04.prod.outlook.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Mon, May 04, 2020 at 01:41:14AM +0000, Damien Le Moal wrote:
> Alexey,
> 
> On 2020/05/02 3:52, Alexey Dobriyan wrote:
> > On Fri, May 01, 2020 at 01:34:32AM +0000, Damien Le Moal wrote:
> >> On 2020/04/30 21:41, Alexey Dobriyan wrote:
> >>> It is not possible to maintain equal per-thread iodepth. The way code
> >>> is written, "max_open_zones" acts as a global limit, and one thread
> >>> opens all "max_open_zones" for itself and others starve for available
> >>> zones and _exit_ prematurely.
> >>>
> >>> This config is guaranteed to make equal number of zone resets/IO now:
> >>> each thread generates identical pattern and doesn't intersect with other
> >>> threads:
> >>>
> >>> 	zonemode=zbd
> >>> 	zonesize=...
> >>> 	rw=write
> >>>
> >>> 	numjobs=N
> >>> 	offset_increment=M*zonesize
> >>>
> >>> 	[j]
> >>> 	size=M*zonesize
> >>>
> >>> Patch introduces "global_max_open_zones" which is per-device config
> >>> option. "max_open_zones" becomes per-thread limit. Both limits are
> >>> checked for each open zone so one thread can't starve others.
> >>
> >> It makes sense. Nice one.
> >>
> >> But the change as is will break existing test scripts (e.g. lots of SMR drives
> >> are being tested with this).
> > 
> > It won't break single-threaded ones, that's for sure.
> 
> Yes, but things like:
> 
> fio --ioengine=psync --rw=randwr --max_open_zones=128 --numjobs=32
> 
> will change behavior. With your change, instead of 32 threads writing randomly
> to a total of 128 zones, you will get 32 threads each writing randomly to 128
> zones, with a total of 32*128=4096 zones.
> 
> SMR drives and zonemode=zbd have now been around for a while and there are a lot
> of fio scripts deployed in production for system validation/tests, as well as in
> drive development for testing. If we can avoid breaking that, we absolutely must.
> 
> My proposal to keep max_open_zones as the per device maximum and introducing a
> thread_max_open_zones limit keeps backward compatibility with existing scripts
> while still allowing your change.
> 
> > 
> >> I think we can avoid this breakage simply: leave
> >> max_open_zones option definition as is and add "job_max_open_zones" or
> >> "thread_max_open_zones" option (no strong feelings about the name here, as long
> >> as it is explicit) to define the per thread maximum number of open zones. This
> >> new option could actually default to max_open_zones / numjobs if that is not 0.
> > 
> > I'd argue that such scripts are broken.
> 
> See the above example. It is a perfectly valid script, not broken at all.

It is broken in the sense that script doesn't test what's author thinks it tests.
max_open_zones= + numjobs= can only be used as random stress smoke test, nothing
more. Patch actually increases stress level :-)

I assume that if open zone command fails due to hardware limitations, thread can
and will exit just as easily.

> Varying the number of max_open_zones allows measuring the performance variation
> of a drive with the number of implicitly open zones. It is a common one that I
> have seen a lot in drive development and production. There are likely other
> valid ones too. Assuming that all current uses of max_open_zones with multi-jobs
> workloads are broken would be a mistake.
> 
> > 
> > If sustained numjobs*max_open_zones QD is desired than it is not
> > guaranteed as threads will simply exit at indeterminate times,
> > which break LBA space coverage as well.
> > 
> > Right now, numjobs= + max_open_zones= means "max open zones by at most
> > "numjobs" threads.
> 
> I understand that. And we should keep it that way for the reasons mentioned
> above. Modifying your change with the option thread_max_open_zones will nicely
> enhance. E.g.
> 
> fio --ioengine=libaio --iodepth=8 --rw=randwr --thread_max_open_zones=1 --numjobs=8
> 
> Will result in 8 threads writing a single randomly chosen zone at QD=8. And that
> is the same as your proposed:
> 
> fio --ioengine=libaio --iodepth=8 --rw=randwr --max_open_zones=1 --numjobs=8
> 
> but without breaking the existing meaning of max_open_zones as a per drive/file
> limit.
> 
> I totally agree with your change. It is a nice one. But let's preserve
> max_open_zones meaning as the per device limit. No need to change it.

OK I'll resend but I'll call it "job_max_open_zones".
It doesn't help that fio doesn't have a notion of per-file/device option.


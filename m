Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Fri, 1 May 2020 21:52:08 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 3/7] zbd: introduce per-device "max_open_zones" limit
Message-ID: <20200501185208.GB32674@avx2>
References: <20200430124050.20146-1-adobriyan@gmail.com>
 <20200430124050.20146-3-adobriyan@gmail.com>
 <BY5PR04MB690042CF7A2990BE21B0DBCDE7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BY5PR04MB690042CF7A2990BE21B0DBCDE7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, May 01, 2020 at 01:34:32AM +0000, Damien Le Moal wrote:
> On 2020/04/30 21:41, Alexey Dobriyan wrote:
> > It is not possible to maintain equal per-thread iodepth. The way code
> > is written, "max_open_zones" acts as a global limit, and one thread
> > opens all "max_open_zones" for itself and others starve for available
> > zones and _exit_ prematurely.
> > 
> > This config is guaranteed to make equal number of zone resets/IO now:
> > each thread generates identical pattern and doesn't intersect with other
> > threads:
> > 
> > 	zonemode=zbd
> > 	zonesize=...
> > 	rw=write
> > 
> > 	numjobs=N
> > 	offset_increment=M*zonesize
> > 
> > 	[j]
> > 	size=M*zonesize
> > 
> > Patch introduces "global_max_open_zones" which is per-device config
> > option. "max_open_zones" becomes per-thread limit. Both limits are
> > checked for each open zone so one thread can't starve others.
> 
> It makes sense. Nice one.
> 
> But the change as is will break existing test scripts (e.g. lots of SMR drives
> are being tested with this).

It won't break single-threaded ones, that's for sure.

> I think we can avoid this breakage simply: leave
> max_open_zones option definition as is and add "job_max_open_zones" or
> "thread_max_open_zones" option (no strong feelings about the name here, as long
> as it is explicit) to define the per thread maximum number of open zones. This
> new option could actually default to max_open_zones / numjobs if that is not 0.

I'd argue that such scripts are broken.

If sustained numjobs*max_open_zones QD is desired than it is not
guaranteed as threads will simply exit at indeterminate times,
which break LBA space coverage as well.

Right now, numjobs= + max_open_zones= means "max open zones by at most
"numjobs" threads.


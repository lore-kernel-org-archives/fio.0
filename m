Return-Path: <axboe@kernel.dk>
Date: Thu, 3 Mar 2016 09:18:28 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Specify range and distribution of accesses
Message-ID: <20160303161828.GC22164@kernel.dk>
References: <BN3PR0401MB145783CB3B39ADEEAED39523F7A70@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CANvN+e=rTzEnCybj3jFkxt0WCGbSP4R1YbTBKpF+QBv3H2swkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANvN+e=rTzEnCybj3jFkxt0WCGbSP4R1YbTBKpF+QBv3H2swkA@mail.gmail.com>
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: Jeff Furlong <jeff.furlong@hgst.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Sat, Feb 27 2016, Andrey Kuzmin wrote:
> On Fri, Feb 26, 2016 at 11:53 PM, Jeff Furlong <jeff.furlong@hgst.com> wrote:
> > Hi All,
> > I'm looking for a method to distribute access to certain ranges of a block device.  For example, the JESD219 workload (http://www.jedec.org/sites/default/files/docs/JESD219.pdf) specifies
> >
> > The workload shall be distributed across the SSD such that the following is achieved:
> > 1) 50% of accesses to first 5% of user LBA space (LBA group a)
> > 2) 30% of accesses to next 15% of user LBA space (LBA group b)
> > 3) 20% of accesses to remainder of user LBA space (LBA group c)
> >
> > I do not currently see any fio options to allow such usage.  Perhaps if --size or --iosize is updated to allow ranges/distributions, it may be possible?
> >
> > The JESD219 workload also specifies a distribution of block sizes, which can already be accomplished in fio with --bssplit, such as --bssplit=4k/10:64k/50:32k/40.  Perhaps extending that usage to --size or --iosize may solve the issue?
> >
> > The above link for the JESD219 workload includes a vdbench script to produce the desired workload, but I'm hesitant to think that vdbench does something that fio cannot.  Has anyone been able to specify ranges and distributions of accesses in any other way?  Thanks.
> >
> 
> To model skewed workloads, fio provides Zipf and Pareto offset
> distributions, although neither solves exactly your problem. At the
> same time, a specific feature you're looking for should be pretty
> straightforward to add. You might want to add a new sub-option under
> random_distribution to specify frequency/capacity percentage list,
> similar to the 'bssplit' block size frequency option, and code it
> following the example of the bssplit, with uniform distribution within
> the range chosen based on the frequency table yielding the actual
> offset.

Those are some good pointers, and that would be a good way to go about
it.

For temporary use through zipf/pareto, it's worth noting that fio hashes
the output so that even with a distribution theta that follows the above
access frequency, it would not honor the LBA part. That's trivially
fixable with just providing an option to disable block offset hashing.

-- 
Jens Axboe



Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35943 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab0CYWFd (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Mar 2010 18:05:33 -0400
Date: Thu, 25 Mar 2010 23:05:32 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: refill_buffers has high CPU utilization
Message-ID: <20100325220531.GC5768@kernel.dk>
References: <43F901BD926A4E43B106BF17856F0755A37180B3@orsmsx508.amr.corp.intel.com> <20100325211811.GA5768@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325211811.GA5768@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Veal, Bryan E" <bryan.e.veal@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, Mar 25 2010, Jens Axboe wrote:
> On Thu, Mar 25 2010, Veal, Bryan E wrote:
> > Hi all,
> > 
> > I'm experiencing really high CPU utilization with the refill_buffers option, presumably due to using rand() to generate all the data:
> > 
> > Output with zero_buffers:
> > zero_buffers: (g=0): rw=randwrite, bs=64K-64K/64K-64K, ioengine=psync, iodepth=1
> > ...
> > zero_buffers: (g=0): rw=randwrite, bs=64K-64K/64K-64K, ioengine=psync, iodepth=1
> > zero_buffers: (groupid=0, jobs=32): err= 0: pid=21556
> >   write: io=4600MB, bw=156966KB/s, iops=2452, runt= 30009msec
> >     clat (usec): min=378, max=139675, avg=13045.49, stdev=1468.67
> >     bw (KB/s) : min= 2609, max= 6677, per=3.11%, avg=4886.17, stdev=120.46
> >   cpu          : usr=0.30%, sys=1.87%, ctx=2452182, majf=0, minf=11463
> > 
> > Output with refill_buffers:
> > refill_buffers: (g=0): rw=randwrite, bs=64K-64K/64K-64K, ioengine=psync, iodepth=1
> > ...
> > refill_buffers: (g=0): rw=randwrite, bs=64K-64K/64K-64K, ioengine=psync, iodepth=1
> > refill_buffers: (groupid=0, jobs=32): err= 0: pid=21503
> >   write: io=4246MB, bw=144867KB/s, iops=2263, runt= 30010msec
> >     clat (usec): min=293, max=140908, avg=13969.29, stdev=1837.85
> >     bw (KB/s) : min= 1187, max= 6843, per=3.13%, avg=4535.65, stdev=204.58
> >   cpu          : usr=37.76%, sys=1.63%, ctx=2286876, majf=0, minf=29750
> > 
> > While it is useful to write random data, the overhead is prohibitively
> > expensive in high-throughput tests.  Would it be a better option to
> > allocate a large memory buffer, initialize it with random data, and
> > use random offsets within the buffer for data to write to the disk?
> 
> I think we should improve it, yes. I like the concept of the data being
> pseudo random and non-repetitive at least, since that is guaranteed not
> to be compressible. But it doesn't have to be cryptographically strong
> by any means, so it should be pretty easy to have a in-fio rand() that
> is fast yet good enough for the purpose. > 30% utilization just for
> generating random buffers at a fairly slow rate of ~140MB/sec is
> definitely excessive and not appropriate.
> 
> I'll see to fixing that.

I took a quick stab at it, and stole a rand implementation from
networking. Net result here on the laptop is that it's 3x faster, a null
write test goes from ~500MB/sec to ~1500MB/sec. I'd still like it to be
much faster than this, so perhaps some pre-generated data with a bit of
shuffling could still improve on this.

Can you rerun your above test and see what the result is like now, if
you pull or download the latest snapshot?

-- 
Jens Axboe


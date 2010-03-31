Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35817 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527Ab0CaRi6 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 31 Mar 2010 13:38:58 -0400
Date: Wed, 31 Mar 2010 19:38:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Do not delete cgroups upon completion of fio job
Message-ID: <20100331173856.GD23510@kernel.dk>
References: <20100331171931.GH14011@redhat.com> <20100331172600.GC23510@kernel.dk> <20100331173558.GI14011@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331173558.GI14011@redhat.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: fio@vger.kernel.org

On Wed, Mar 31 2010, Vivek Goyal wrote:
> On Wed, Mar 31, 2010 at 07:26:00PM +0200, Jens Axboe wrote:
> > On Wed, Mar 31 2010, Vivek Goyal wrote:
> > > Currently upon fio job completion, we delete the cgroups. But in the
> > > process we also loose important debugging information presetn in cgroup
> > > files. For example time information in blkio.time, sector information in
> > > blkio.sectors and how many a times a group was dequeued blkio.dequeue.
> > > Leaving the cgroups as it is, allows one to go and inspect those files
> > > after the fio job is complete.
> > > 
> > > Secondly, cgroups might have already been created by user before fio job
> > > started. In that case it is not very right to delete cgroups after job
> > > completion.
> > 
> > Confused, I was pretty sure that I added code back then to only delete
> > cgroups when they were created by fio. Checking, that is what it should
> > do - we only add the cgroup to the kill list, if we were the one to
> > create it. That was on purpose, since I did not want to leave them
> > around.
> 
> Sorry, I did not check properly. Upon retest, I see cgroups are not being 
> deleted if these were not created by fio.
> 
> > 
> > I'd suggest adding a specific option to NOT kill a cgroup. Or you could
> > have a post_exec option that tar's up the contents of that directory,
> > perhaps even formalized?
> 
> I think adding an option to not kill a cgroup looks good to me as I don't
> have to do some more scripting to tar and then untar and read cgroup debug
> files. 
> 
> I will send a patch for that option.

Agree, it's probably best. Plus it sort-of matches the unlink option
applied to files created. So I'd gladly take that.

-- 
Jens Axboe


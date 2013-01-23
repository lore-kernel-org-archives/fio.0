Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34497 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab3AWSVK (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 23 Jan 2013 13:21:10 -0500
Date: Wed, 23 Jan 2013 11:21:00 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: fio is being killed by the oom-killer after fio verify runs for
 some time ~13 hours
Message-ID: <20130123182100.GC30268@kernel.dk>
References: <CABYizFKetDGfE_fOARgbehmJo_uDTqy32bMTQTDVyny-Nk5riQ@mail.gmail.com>
 <20130111091010.GA32674@kernel.dk>
 <50F12401.8090606@kernel.dk>
 <CABYizFLj4LSJApybuRfUfCiuqhVNac0T733BcMnpUOAivWhi7A@mail.gmail.com>
 <20130118204040.GT3571@kernel.dk>
 <20130121212925.GA1300@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121212925.GA1300@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: brian arb <brianjamesarb@gmail.com>
Cc: fio@vger.kernel.org

On Mon, Jan 21 2013, Jens Axboe wrote:
> On Fri, Jan 18 2013, Jens Axboe wrote:
> > On Fri, Jan 18 2013, brian arb wrote:
> > > adding the option --verify_backlog=1024 resolved my issue.
> > > On a side note how would one determine what the optimum number is for this
> > > option?
> > 
> > It's easier if you know the internals... The version you are running
> > will store some metadata for each block written, for verification
> > purposes. Standard install is 80 bytes per block. So if you have a 2TB
> > disk and use 4K IO sizes, the memory required runs into the gigabytes.
> > Quite unfortunate, really, will be fixed up shortly.
> > 
> > In any case, with a backlog of just 1024, you wont use more than 80KB
> > memory for verifies. So you could easily size it larger. I'd improve the
> > option documentation, but I think it's better to just improve fio to not
> > require the stored meta data to be able to verify. It will be in the
> > 2.0.14 release.
> 
> Current -git has it implemented. If you do your normal verify workload
> but add --experimental_verify=1 to the options, it wont track meta data
> needed for verify, but rather just re-wind the various attributes to
> replay the workload for read and verify instead. Just tested it on one
> box here, bringing the needed memory down for a job from 25G to 1M. The
> worst part about the verify memory consumption was the slowly growing
> job, meaning that it could have the OOM consequences that you described
> for long running jobs. No allocations are taking place for IO when
> experimental_verify is set now.
> 
> Side note, this doesn't work for mixed write/trim workloads for now. We
> need a bit of extra tracking for that.

Final bits are in now, works for both trim and mixed workloads etc. So
to recap, testing now with minimal mem pressure does not need
verify_backlog= being set. Suggested new parameters:

--experimental_verify=1 --random_generator=lfsr

if you could try that and report back if things ran successfully, I
would much appreciate it.

-- 
Jens Axboe


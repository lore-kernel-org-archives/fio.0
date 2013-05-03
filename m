Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47609 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab3ECRip (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 3 May 2013 13:38:45 -0400
Date: Fri, 3 May 2013 19:38:26 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: random read generates zero filled file
Message-ID: <20130503173826.GX7800@kernel.dk>
References: <82C5A0D6-2960-41B7-89B6-1D8C72D011C0@ulb.ac.be>
 <20130503100839.GI7800@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130503100839.GI7800@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Michel Jansens <michel.jansens@ulb.ac.be>
Cc: fio@vger.kernel.org

On Fri, May 03 2013, Jens Axboe wrote:
> On Fri, May 03 2013, Michel Jansens wrote:
> > Hi,
> > 
> > I'm trying out FIO, and rand a random read job with a 12GB file.  It
> > seems that the "Laying out IO file(s) " process generates a
> > zero-filled file. This means that when compression is activated (on
> > ZFS), no reads actually happens.
> > 
> > I tried adding a "buffer_compress_percentage=10" section to tell
> > generated data should compress from only "10%" but this seems to apply
> > only to actual benchmark job, not the 'laying out file's.
> > 
> > Am I missing something?
> 
> No, it currently just fills zeroes. It's trivial to make it honor the
> usual buffer fill logic, though. With the below patch, it'll do what fio
> otherwise would have done to IO buffers during the benchmark run.

Since the followups didn't make it here, the below exposed a bug in the
compression logic where it would loop infinitely if compress_chunk
wasn't set too.

So we got a new feature, and a fix for an older bug as well. Commit is
here:

http://git.kernel.dk/?p=fio.git;a=commit;h=cc86c395fd9dd2002ec1edc0967b7c9453debdfb

-- 
Jens Axboe


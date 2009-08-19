Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:45308 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbZHSMvq (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Aug 2009 08:51:46 -0400
Date: Wed, 19 Aug 2009 14:51:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Large numbers of devices...
Message-ID: <20090819125147.GB12579@kernel.dk>
References: <1250530429.5341.98.camel@cail> <20090819090317.GW12579@kernel.dk> <1250686030.5589.1.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250686030.5589.1.camel@cail>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: fio@vger.kernel.org

On Wed, Aug 19 2009, Alan D. Brunelle wrote:
> On Wed, 2009-08-19 at 11:03 +0200, Jens Axboe wrote:
> 
> > 
> > Alan, I haven't run with that many files, so it's indeed possible that
> > there's an inherent limitiation in the file selection in fio. It's not
> > my best code, that part... If you have the time and inclination to jump
> > in there and find out what is going on, then that would be great!
> > 
> 
> OK, will do - I just wanted to check that the fio job-file looked OK. 

It looks fine, in fact if that is your setup, then you are not using the
multi file stuff. Your job files basically creates a process per device,
which should work fine as-is.

You can try and play with the iodepth batching control, iodepth_batch
and iodepth_batch_complete. They both default to 1, meaning that it'll
submit and complete 1 command at the time.

-- 
Jens Axboe


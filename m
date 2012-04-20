Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55282 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab2DTGlR (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 Apr 2012 02:41:17 -0400
Message-ID: <4F9104F9.2060308@kernel.dk>
Date: Fri, 20 Apr 2012 08:40:57 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: segfault runninng fio against 2048 jobs
References: <0FEAAA2D70C89D49A62173478A6C4A5D02DECC2A@XYUS-EX22.xyus.xyratex.com> <4F8E6BFD.10408@kernel.dk> <0FEAAA2D70C89D49A62173478A6C4A5D02DECCB6@XYUS-EX22.xyus.xyratex.com> <4F8F0A62.80101@kernel.dk> <0FEAAA2D70C89D49A62173478A6C4A5D02DECCD7@XYUS-EX22.xyus.xyratex.com>
In-Reply-To: <0FEAAA2D70C89D49A62173478A6C4A5D02DECCD7@XYUS-EX22.xyus.xyratex.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Roger Sibert <Roger_Sibert@xyratex.com>
Cc: fio@vger.kernel.org

On 04/18/2012 09:46 PM, Roger Sibert wrote:
> I verified the patch in fio-2.0.7-11-g7907 and that does indeed look to
> take care of the issue.  (Many thanks for that)
> 
> Also in follow up I changed the max job limit to 5120 and it seems to
> run properly against that as well.
> 
> Question though, is there any reason you have a REAL_MAX_JOBS in fio.h
> and then a FIO_MAX_JOBS in os.h.  First glance at it just shows that the
> init.c code uses FIO_MAX_JOBS in for the thread check and then later on
> it uses REAL_MAX_JOBS for the job check except that max_jobs is set
> equal to FIO_MAX_JOBS.  It may be that the answer to my question is the
> os-mac.h file which means you have a smaller thread count ... maybe then
> the result is just a small adjustment in the error print to show you
> have exceeded the max # of jobs and or max # of threads.

OSX has a seriously small max segment by default, hence the split and
smaller value there.

I should probably make the thread_data array be segmented, so that fio
could support an arbitrary number of jobs regardless of the max shm
segment size. So far it hasn't been a huge problem.

-- 
Jens Axboe


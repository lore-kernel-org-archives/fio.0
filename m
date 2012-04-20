Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40725 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab2DTO1Q (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 Apr 2012 10:27:16 -0400
Message-ID: <4F917240.6030003@kernel.dk>
Date: Fri, 20 Apr 2012 16:27:12 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: segfault runninng fio against 2048 jobs
References: <0FEAAA2D70C89D49A62173478A6C4A5D02DECC2A@XYUS-EX22.xyus.xyratex.com> <4F8E6BFD.10408@kernel.dk> <0FEAAA2D70C89D49A62173478A6C4A5D02DECCB6@XYUS-EX22.xyus.xyratex.com> <4F8F0A62.80101@kernel.dk> <0FEAAA2D70C89D49A62173478A6C4A5D02DECCD7@XYUS-EX22.xyus.xyratex.com> <4F9104F9.2060308@kernel.dk> <0FEAAA2D70C89D49A62173478A6C4A5D02DECDC6@XYUS-EX22.xyus.xyratex.com>
In-Reply-To: <0FEAAA2D70C89D49A62173478A6C4A5D02DECDC6@XYUS-EX22.xyus.xyratex.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Roger Sibert <Roger_Sibert@xyratex.com>
Cc: fio@vger.kernel.org

On 04/20/2012 04:21 PM, Roger Sibert wrote:
> I was thinking along the lines of adding a command, job_size_allowed =
> default, (l)arge, (xl)arge, (j)umbo with using those in where you do the
> check FIO_MAX_JOBS or REAL_MAX_JOBS.
> 
> Default=1
> Large=1.5
> XLarge=2
> Jumbo=3
> 
> char output[(REAL_MAX_JOBS*job_size_allowed) + 512], *p = output;
> 
> Sorry if the code is off/wrong, I have spent the last 5 days doing
> nothing but perl and bash scripting along with a twist of SQL so my
> brain is mush :P
> 
> I used to test RAID code for a living so I wasn't about to start digging
> since I don't know the code well enough which means that if I push in on
> one side something else will more than likely pop out on the other.
> 
> Looking at what your describing vs what I was thinking it sounds like
> your approach of setting it up to allow for a more dynamic range would
> be a more elegant approach that would serve better in the long run.

Yes, the point of doing segmented thread_data arrays would be to get rid
of any fio imposed constraint on the number of jobs that could be
supported. And do so without requiring tweaking of the shm segment size
on the OS in question.

-- 
Jens Axboe


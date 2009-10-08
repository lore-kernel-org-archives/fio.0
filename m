Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:55059 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbZJHGyy (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 8 Oct 2009 02:54:54 -0400
Date: Thu, 8 Oct 2009 08:54:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: "Fix wrong clock source in mutex" broke fio for me
Message-ID: <20091008065417.GN8703@kernel.dk>
References: <ada1vlfqan3.fsf@cisco.com> <20091007200128.GK8703@kernel.dk> <adak4z7osx8.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adak4z7osx8.fsf@cisco.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: fio@vger.kernel.org

On Wed, Oct 07 2009, Roland Dreier wrote:
> 
>  > I did a quick check, and at least newer revisions have it. Hmm I'm a bit
>  > torn on this, perhaps the safer option is just to revert the bad commit.
> 
> But presumably you made that commit because it fixed some platform?
> 
> The default clock for pthread_cond_timedwait() seems poorly specified,
> I'm not able to find any definitive statement about what it uses, and
> pthread_condattr_setclock() seems to be option in the pthreads spec.
> Seems to be a mess.
> 
> Anyway not sure what the best idea is....

I agree, in any case it's a lot more sane to specifically set the used
clock source. So lets just keep it as-is, if there's any fall out later
I'll deal with it.

-- 
Jens Axboe


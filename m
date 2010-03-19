Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58182 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab0CSHHL (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 19 Mar 2010 03:07:11 -0400
Date: Fri, 19 Mar 2010 08:07:10 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Tiny fio performance bug with debug enabled
Message-ID: <20100319070709.GL5768@kernel.dk>
References: <3D141235-660E-4F6D-8179-F106156B78A4@cs.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3D141235-660E-4F6D-8179-F106156B78A4@cs.cmu.edu>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David Andersen <dga@cs.cmu.edu>
Cc: fio@vger.kernel.org

On Thu, Mar 18 2010, David Andersen wrote:
> Hi, fio hackers:  
> 
> Version 285d451f5c3e034463ea49a5ba99e8e0eb1b83a2
> (snapshot from yesterday)
> 
> Tiny performance tweak with -DFIO_INC_DEBUG enabled but no debug flags specified (the default if building from source):  the dprint macro calls getpid() before checking to see whether or not it's going to actually do anything.  This causes a bit of a slowdown if you've built with debugging but aren't using it.  The fix is to simply swap them:
> 
> debug.h:
> 
> #define dprint(type, str, args...)                              \
>         do {                                                    \
>                 assert(type < FD_DEBUG_MAX);                    \
>                 if ((((1 << type)) & fio_debug) == 0)           \
>                         break;                                  \
>                 pid_t pid = getpid();                           \
> 
> I wasn't sure what the style guidelines were for non-initial declaration & assignment, though...
> 
> Reproducing:  run fio under 'perf';  observe 1.x% of time taken by getpid(). :)

Thanks, I'll commit a fix for that.

-- 
Jens Axboe


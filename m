Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36939 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab0BWJ2u (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 23 Feb 2010 04:28:50 -0500
Date: Tue, 23 Feb 2010 10:28:49 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Verification failures with mixed read/write case
Message-ID: <20100223092849.GP1025@kernel.dk>
References: <1266456009.19149.72.camel@cfslap.wizy.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266456009.19149.72.camel@cfslap.wizy.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Cc: fio@vger.kernel.org

On Thu, Feb 18 2010, Ricardo M. Correia wrote:
> (Please CC me in the reply, I'm not subscribed)
> 
> Hi,
> 
> I've been observing verification failures with the following
> configuration file:
> 
> -----------
> [global]
> ioengine=libaio
> iodepth=30
> rw=randrw
> bs=512-128k
> direct=1
> rwmixcycle=40
> verify=sha256
> verify_async=8
> 
> [/dev/sda2]
> --------------------
> 
> This happens on both RHEL5.4 and Ubuntu 9.10.
> 
> I was observing that with fio-1.36, but I just tried cloning fio from
> the git repo and I'm experiencing the same problem.
> 
> Any ideas of what might be wrong?
> 
> I found this email of a few months ago:
> http://www.spinics.net/lists/fio/msg00205.html
> 
> And I just verified that this patch is in my just-cloned git tree.

Mixed read-write workloads generally don't work well with verify. The
reason being that if you do verify && read, then fio will assume that
you want to verify previously written data. That should not happen for a
generated read as part of a mixed workload, I'll check what happens
here.

> Also, an unrelated issue is that fio complains about 'rwmixcycle' being
> deprecated but the man page doesn't specify what parameter I should be
> using instead.

The time based approach didn't work well for buffered writes, so it was
switched to an issue based count instead only. So you use
rwmixread/rwmixwrite to set the percentages.

-- 
Jens Axboe


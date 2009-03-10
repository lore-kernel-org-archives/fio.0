Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:53098 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbZCJTyL (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 10 Mar 2009 15:54:11 -0400
Date: Tue, 10 Mar 2009 20:54:08 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: I/O alignment
Message-ID: <20090310195408.GJ11787@kernel.dk>
References: <499e38d2.fWWZqp8SkMl4HRX/%jens.axboe@oracle.com> <4C6CAE54C846144981BCE6F26B203FFA1CB3F68AE8@GVW1098EXB.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6CAE54C846144981BCE6F26B203FFA1CB3F68AE8@GVW1098EXB.americas.hpqcorp.net>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Jenkins, Lee" <Lee.Jenkins@hp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Tue, Mar 10 2009, Jenkins, Lee wrote:
> Is there a way to control the alignment of I/O offsets? The HOWTO
> shows bsrange= and bs_unaligned=, but these seem to be related to the
> size of the I/O, not the offset.
> 
> In our lab testing it appears from blktrace dumps that I/Os are
> boundary-aligned based on the size of the I/O. For example, in a test
> of 64KB Random Reads all the I/O addresses were multiples of 64KB (128
> sectors). This alignment has a profound impact on I/O performance for
> certain disk array configurations. Ideally we'd like to be able to
> control the alignment to match our customers' run-time environment.

That is correct, fio will use your minimum block size as the alignment
block as well. This is needed for the random map and doing verifies, for
instance. But I see your point, being able to specifically set your
minimum alignment is indeed useful. It would have to be with the
'norandommap' option, at least that would be the easiest.

I'll add such an option for you tomorrow. Suggestions for option name
would be appreciated, I'm not very good with coming up with good names
:-)

-- 
Jens Axboe


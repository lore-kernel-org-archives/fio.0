Return-Path: <fio-owner@vger.kernel.org>
Received: from srv.wefi.net ([80.66.32.76]:40796 "EHLO srv.wefi.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756696Ab1IAUOD (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 Sep 2011 16:14:03 -0400
Subject: Re: Linux I/O stack design question
From: Werner Fischer <devlists@wefi.net>
In-Reply-To: <x494o0w1h15.fsf@segfault.boston.devel.redhat.com>
References: <1314880418.11001.6.camel@werner-t410>
	 <x494o0w1h15.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 22:14:00 +0200
Message-ID: <1314908040.2091.14.camel@werner-t410>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Jeff,

On Don, 2011-09-01 at 10:19 -0400, Jeff Moyer wrote:
> Werner Fischer <devlists@wefi.net> writes:
> > http://www.thomas-krenn.com/de/wikiDE/images/0/07/Linux-IO-Stack.png
> > Is this diagram correct or are there any errors in there?
> 
> That's a nice diagram.  :)
Thanks! ;-)

> A few of things of note:
> 1) O_DIRECT I/O can bypass the page cache
you are right, I'll add it.

> 2) request-based dm targets sit below the I/O scheduler (currently, that
>    just means dm-multipath)
Thanks, I'll correct this.

> 3) the fusion IO device driver can hook itself in where you put it, or
>    also up above the I/O scheduler (based on a module load option).
Oh wow, that sounds interesting. Does this mean that in this case (IO
device driver above the I/O scheduler) simply no I/O scheduler is used?

> 4) not sure if you want to cover I/O directly to the device (no file
>    system involved)
Yea, that sound reasonable. I'll add it.

So thanks a lot for your valuable feedback.
I will update the diagram according to your hints and let you know then.

Once the diagram is in a state that seems reasonable, I'll add it to
Wikipedia commons under some open license and include it in articles
where it makes sense (e.g.
http://en.wikipedia.org/wiki/Deadline_scheduler and so on)

Regards,
Werner



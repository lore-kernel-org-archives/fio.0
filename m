Return-Path: <devlists@wefi.net>
Subject: Re: Linux I/O stack design question
From: Werner Fischer <devlists@wefi.net>
In-Reply-To: <4E5FE840.9040706@kernel.dk>
References: <1314880418.11001.6.camel@werner-t410>
	 <x494o0w1h15.fsf@segfault.boston.devel.redhat.com>
	 <1314908040.2091.14.camel@werner-t410>  <4E5FE840.9040706@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 22:27:47 +0200
Message-ID: <1314908867.2091.23.camel@werner-t410>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Don, 2011-09-01 at 14:17 -0600, Jens Axboe wrote:
> On 2011-09-01 14:14, Werner Fischer wrote:
> >> 3) the fusion IO device driver can hook itself in where you put it, or
> >>    also up above the I/O scheduler (based on a module load option).
> > Oh wow, that sounds interesting. Does this mean that in this case (IO
> > device driver above the I/O scheduler) simply no I/O scheduler is used?
> 
> It'll hook in similarly to where stacked devices like md/dm do. So yes,
> it's bypassing the IO scheduler.
ok, i see.

> One note on that - this mode is going
> away in the future. 
Do you mean that this mode is going away in the future for the Fusion-io
driver or that generally no driver will be able to hook in there (also
the mtip32xx and nvmhci-express drivers you mention below)?

> You end up losing out on request merging, so write
> performance is hampered, for one.
> 
> The Micron pci-e mtip32xx driver does similarly, as does the
> nvmhci-express driver from Intel. IMHO it's largely due to
> inefficiencies in the IO stack, once we get those fixed, we should be
> getting back to the one true single IO mode for a driver.
With "one true single IO mode for a driver" you mean that every device
driver should sit and stay below the I/O scheduler?
Or do you mean that there should only be one single I/O scheduler? (in
the patch removing the anticipatory scheduler you suggested something
like this:
http://git.kernel.org/linus/492af6350a5ccf087e4964104a276ed358811458 )

> I consider the
> bypass setup a bit of a hack and work-around.

Regards,
Werner



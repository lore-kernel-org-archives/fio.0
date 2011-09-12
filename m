Return-Path: <devlists@wefi.net>
Subject: Re: Linux I/O stack design question
From: Werner Fischer <devlists@wefi.net>
In-Reply-To: <4E68B77D.10400@kernel.dk>
References: <1314880418.11001.6.camel@werner-t410>
	 <x494o0w1h15.fsf@segfault.boston.devel.redhat.com>
	 <1314908040.2091.14.camel@werner-t410>  <4E5FE840.9040706@kernel.dk>
	 <1314908867.2091.23.camel@werner-t410>  <4E5FF57A.1040908@kernel.dk>
	 <1315231292.2140.62.camel@werner-t410>  <4E68B77D.10400@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Sep 2011 08:36:36 +0200
Message-ID: <1315809396.2164.6.camel@werner-t410>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Florian Haas <f.g.haas@gmx.net>
List-ID: <fio@vger.kernel.org>

On Don, 2011-09-08 at 14:39 +0200, Jens Axboe wrote:
> On 2011-09-05 16:01, Werner Fischer wrote:
> > On Don, 2011-09-01 at 15:13 -0600, Jens Axboe wrote:
> >> [...]
> >> I mean that every device should plug in at the same place. There are
> >> definite up and down sides to plugging in at the stacking level and
> >> bypassing the IO scheduler. So you have to weight the pros and cons
> >> before doing that. We need to fix this. Drivers doing that lose out on
> >> other features in the name of a bit more performance, that's just not
> >> acceptable.
> > 
> > I have updated the diagram according to all of your hints:
> > http://www.thomas-krenn.com/de/wikiDE/images/0/07/Linux-IO-Stack.png
> > 
> > I had also some off-list discussion with Florian Haas, who convinced me
> > that the file systems are below of the page cache. I hope this is now
> > correct.
> 
> Not sure I'd agree with that, I'd place the page cache between the fs
> and the storage layer.
After some further off-list feedback from Christoph Hellwig I did some
updates on the block diagram, including moving the page cache from above
the fs layer to next to the fs layer (Christoph told me that the page
cache is a helper function for the file systems).
I also added SCSI mid layer, SCSI low layer, libata and so on:
http://www.thomas-krenn.com/de/wikiDE/images/0/07/Linux-IO-Stack.png

I'm looking forward to further feedback.

Thanks,
Werner




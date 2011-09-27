Return-Path: <ms@teamix.de>
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: Linux I/O stack design question
Date: Tue, 27 Sep 2011 16:06:57 +0200
References: <1314880418.11001.6.camel@werner-t410> <4E68B77D.10400@kernel.dk> <1315809396.2164.6.camel@werner-t410>
In-Reply-To: <1315809396.2164.6.camel@werner-t410>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271606.58334.ms@teamix.de>
To: Werner Fischer <devlists@wefi.net>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Florian Haas <f.g.haas@gmx.net>
List-ID: <fio@vger.kernel.org>

Hi Werner!

Am Montag, 12. September 2011 schrieb Werner Fischer:
> On Don, 2011-09-08 at 14:39 +0200, Jens Axboe wrote:
> > On 2011-09-05 16:01, Werner Fischer wrote:
> > > On Don, 2011-09-01 at 15:13 -0600, Jens Axboe wrote:
> > >> [...]
> > >> I mean that every device should plug in at the same place. There are
> > >> definite up and down sides to plugging in at the stacking level and
> > >> bypassing the IO scheduler. So you have to weight the pros and cons
> > >> before doing that. We need to fix this. Drivers doing that lose out on
> > >> other features in the name of a bit more performance, that's just not
> > >> acceptable.
> > > 
> > > I have updated the diagram according to all of your hints:
> > > http://www.thomas-krenn.com/de/wikiDE/images/0/07/Linux-IO-Stack.png
> > > 
> > > I had also some off-list discussion with Florian Haas, who convinced me
> > > that the file systems are below of the page cache. I hope this is now
> > > correct.
> > 
> > Not sure I'd agree with that, I'd place the page cache between the fs
> > and the storage layer.
> 
> After some further off-list feedback from Christoph Hellwig I did some
> updates on the block diagram, including moving the page cache from above
> the fs layer to next to the fs layer (Christoph told me that the page
> cache is a helper function for the file systems).
> I also added SCSI mid layer, SCSI low layer, libata and so on:
> http://www.thomas-krenn.com/de/wikiDE/images/0/07/Linux-IO-Stack.png
> 
> I'm looking forward to further feedback.

Not that I would like to use it, but where would dmraid sit? I think it would 
be a bit nearer to the SCSI low layer...

I am not quite used to the placement of the page cache, but if its merely a 
helper function for filesystems... Regarding performance measurements it makes 
a lot of difference. I think the current diagram hides the impact of using 
pagecache or not using it a bit. So maybe at least coloring it differently 
would give it a bit more visual weight.

Aside from that I find this very detailed and I learned quite a bit from just 
looking at it.

Can you make that image available as SVG too?

Thanks,
-- 
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90


Return-Path: <ms@teamix.de>
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: new developments
Date: Wed, 5 Oct 2011 14:15:41 +0200
References: <4E8967BC.3050404@kernel.dk>
In-Reply-To: <4E8967BC.3050404@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110051415.42260.ms@teamix.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Am Montag, 3. Oktober 2011 schrieben Sie:
> Hi,

Hi Jens!

> Those of you tracking git developments may have noticed that
> I created a client-server branch and did a bit of hacking
> in there. It's not complete yet, but it's the start of splitting
> fio into a frontend/backend setup, with the two communicating over
> via simple protocol over tcp/ip. This enables you to run fio
> servers on test machines, with the frontend being run on your
> desktop etc.

Nice.

Can it run with a unix socket for localhost?

> One thing that I think would be very cool is a gtk2 frontend.
> Something that allows you to simply click and select options
> and then run the job, with graphical representation of the
> ETA and final output.
> 
> If you have gtk development experience, or simply the desire
> to start this project for fio, then please do get in touch.
> Otherwise I'll start this myself, once I'm done with the
> basic frontend/backend funtionality.

And/Or Qt ;)

Thanks,
-- 
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90


Return-Path: <bengland@redhat.com>
Date: Tue, 24 May 2016 11:35:24 -0400 (EDT)
From: Ben England <bengland@redhat.com>
Message-ID: <852858719.65540595.1464104124345.JavaMail.zimbra@redhat.com>
In-Reply-To: <57447327.3010503@kernel.dk>
References: <12634496.Be1YEipj88@merkaba> <2097283958.65342663.1464088355308.JavaMail.zimbra@redhat.com> <196b983d-e6e1-2c2d-299e-de3b9cc742ff@gmail.com> <1549707390.65536830.1464103326492.JavaMail.zimbra@redhat.com> <57447327.3010503@kernel.dk>
Subject: Re: fiologparser.py
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Mark Nelson <mark.a.nelson@gmail.com>
Cc: Martin Steigerwald <ms@teamix.de>, fio@vger.kernel.org, Mark Nelson <mnelson@redhat.com>
List-ID: <fio@vger.kernel.org>

OK we'll remove the dependencies, I still want to have the -A option supported.
-ben

----- Original Message -----
> From: "Jens Axboe" <axboe@kernel.dk>
> To: "Ben England" <bengland@redhat.com>, "Mark Nelson" <mark.a.nelson@gmail.com>
> Cc: "Martin Steigerwald" <ms@teamix.de>, fio@vger.kernel.org, "Mark Nelson" <mnelson@redhat.com>
> Sent: Tuesday, May 24, 2016 11:28:39 AM
> Subject: Re: fiologparser.py
> 
> On 05/24/2016 09:22 AM, Ben England wrote:
> >
> >
> > ----- Original Message -----
> >> From: "Mark Nelson" <mark.a.nelson@gmail.com>
> >> To: "Ben England" <bengland@redhat.com>, "Martin Steigerwald"
> >> <ms@teamix.de>
> >> Cc: fio@vger.kernel.org, "Mark Nelson" <mnelson@redhat.com>, "Jens Axboe"
> >> <axboe@kernel.dk>
> >> Sent: Tuesday, May 24, 2016 10:04:14 AM
> >> Subject: Re: fiologparser.py
> >>
> >> Let's see if we can remove the numpy and scipy dependencies.  It looks
> >> like we are just using it for min/average/median/max/percentile
> >> calculations.  It would be nice if users didn't need anything other than
> >> argparse.
> >>
> >
> > Just curious, why is scipy a problem?  Is it because CBT isn't a
> > package so you don't get dependencies handled when you install it?  You
> > are correct, it's easy to remove the dependencies, I just didn't know it
> > was causing problems for people.  You can get percentiles from just
> > sorting the sample values and indexing into the array at the appropriate
> > offset, I was just trying to re-use existing classes.
> 
> It's not necessarily a problem, but the less dependencies you have, the
> easier it is for people to use. I do the same for fio, try to have as
> few external dependencies as possible. Remember, not everybody is
> running on Linux...
> 
> --
> Jens Axboe
> 
> 


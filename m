Return-Path: <ms@teamix.de>
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: fiologparser.py
Date: Wed, 25 May 2016 10:58:59 +0200
Message-ID: <2911112.R94pZHdCuf@merkaba>
In-Reply-To: <c54ab91f-ccc9-59a1-bf17-9b72b0525d78@gmail.com>
References: <12634496.Be1YEipj88@merkaba> <1678172793.65613994.1464122842521.JavaMail.zimbra@redhat.com> <c54ab91f-ccc9-59a1-bf17-9b72b0525d78@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
To: Mark Nelson <mark.a.nelson@gmail.com>
Cc: Ben England <bengland@redhat.com>, Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Mark Nelson <mnelson@redhat.com>
List-ID: <fio@vger.kernel.org>

On Dienstag, 24. Mai 2016 21:04:13 CEST Mark Nelson wrote:
> On 05/24/2016 03:47 PM, Ben England wrote:
> > Mark, I didn't notice the sample weighting code before.  Weighting of
> > samples might work for averaging, but it doesn't work for percentiles,
> > min or max provided by -A option.  I guess for min this won't be an iss=
ue
> > generally, since min-latency samples will probably fall entirely within=
 a
> > time interval.  But for max or higher percentiles it will *definitely* =
be
> > an issue.   For example, a really high latency sample could be the max
> > for a whole range of time intervals.
> I went back and reworked the print and per-interval functions so that
> they are part of a Printer class and Interval class respectively.  It
> cleaned the code up pretty nicely.  I was also able to integrate the
> "-A" code to use a lot of the existing statistics and formatting code.
> It now supports the "-d" flag for example.

While at it, Mark, could you also do the renaming to fiologparser?

Otherwise I=B4d prepare a patch, but then we risk a trivial merge conflict =
:)

Thanks,
Martin


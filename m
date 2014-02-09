Return-Path: <axboe@kernel.dk>
Date: Sun, 9 Feb 2014 13:57:44 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Fio 2.1.5 release upcoming
Message-ID: <20140209205744.GB2750@kernel.dk>
References: <20140206192135.GB3950@kernel.dk>
 <CAF+0mvnBvLVqijP+Atbh9SEjt0p6-e3hy4Q3QRMtb+swp72bTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+0mvnBvLVqijP+Atbh9SEjt0p6-e3hy4Q3QRMtb+swp72bTQ@mail.gmail.com>
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Sat, Feb 08 2014, Matthew Eaton wrote:
> On Thu, Feb 6, 2014 at 11:21 AM, Jens Axboe <axboe@kernel.dk> wrote:
> > Hi,
> >
> > I've been late on this release, originally wanted it out around
> > Christmas. But various issues here and there prevented that. However, I
> > now think we are getting pretty close. It'd be great if folks running on
> > non-linux systems could compile and ensure that everything is in working
> > order, because otherwise I'm going to assume that it is...
> >
> > Similarly, if you know of bugs (particularly regressions from previous
> > releases), speak up now so we can get them fixed before 2.1.5 is cut.
> >
> > I'll wait until Monday to tag the release.
> >
> > --
> > Jens Axboe
> >
> 
> Hi Jens,
> 
> I was messing around with the openfiles flag in one of my job files
> last week but was unable to get it to work.  Fio would keep defaulting
> to opening all files set by nrfiles, but I'm not sure if I was doing
> something wrong.  This was with fio 2.1.4 on linux.  Can you check on
> this?

It'd be easier if you include your job file / command line!

-- 
Jens Axboe



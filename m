Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:34558 "EHLO
	mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbcGYPAZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 25 Jul 2016 11:00:25 -0400
Received: by mail-qt0-f174.google.com with SMTP id u25so98367509qtb.1
        for <fio@vger.kernel.org>; Mon, 25 Jul 2016 08:00:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ9yE1C4zDwWU7-MY7imTD3SuwrKtSUztxdqw8i=NaR44nTOjQ@mail.gmail.com>
References: <CAJ9yE1D_J5hvq_=vJ_DbgYy5nrQM0bC_nMhRKziDWjnbw23i-w@mail.gmail.com>
 <19326c3d-bfdc-09ab-88ba-034206c7d4aa@gmail.com> <CAJ9yE1AqxZwwcMfZWjfuVQQaTe5oamNGHrvu92_L46eP=cQ4JA@mail.gmail.com>
 <5932bab0-6513-2bd4-5d13-4e14609d752c@gmail.com> <CAJ9yE1C4zDwWU7-MY7imTD3SuwrKtSUztxdqw8i=NaR44nTOjQ@mail.gmail.com>
From: Karl Cronburg <kcronbur@redhat.com>
Date: Mon, 25 Jul 2016 11:00:23 -0400
Message-ID: <CAJ9yE1BY44PczgzMTu5KHthC=3Ajxti_MRQgZetaNjwA=F3_NQ@mail.gmail.com>
Subject: Re: fiologparser
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mark Nelson <mark.a.nelson@gmail.com>
Cc: fio@vger.kernel.org, Ben England <bengland@redhat.com>

On Fri, Jul 15, 2016 at 9:02 AM, Karl Cronburg <kcronbur@redhat.com> wrote:
>
> On Thu, Jul 14, 2016 at 3:05 PM, Mark Nelson <mark.a.nelson@gmail.com> wrote:
> >
> >
> > On 07/14/2016 01:48 PM, Karl Cronburg wrote:
> >>
> >> On Thu, Jul 14, 2016 at 12:29 PM, Mark Nelson <mark.a.nelson@gmail.com>
> >> wrote:
> >>>
> >>>
> >>>
> >>> On 07/14/2016 10:35 AM, Karl Cronburg wrote:
> >>>>
> >>>>
> >>>> Hello all,
> >>>>
> >>>> I have written a new version of fiologparser and could use some feedback
> >>>> from anyone who uses the tool regularly. It is on branch fiologparser of
> >>>> my fork
> >>>> of fio:
> >>>>
> >>>> https://github.com/cronburg/fio/blob/fiologparser/tools/fiologparser.py
> >>>>
> >>>> It uses numpy and cython to speed up the data parsing and percentile
> >>>> calculations,
> >>>> while decreasing the memory footprint and making it scalable.
> >>>
> >>>
> >>>
> >>> I was really trying to avoid the extra dependencies. :/  That's why Ben's
> >>> last commit was reworked so we could avoid adding numpy as a dependency
> >>> in
> >>> the fio distribution (not that fio itself would need it, but it would be
> >>> really swell if none of the tools needed anything other than stock
> >>> python).
> >>>
> >>> How much improvement are you seeing and where is the speedup coming from?
> >>> I
> >>
> >>
> >> All the speedup is coming from using dedicated parsing libraries (pandas),
> >> numpy arrays (with vector math) instead of python lists, and streaming
> >> smaller
> >> portions of the data at a time into memory.
> >>
> >> On a single 39 MB latency log file it takes ~ a tenth of a second per
> >> interval to calculate
> >> percentiles for each interval whereas the one in wip-interval (with
> >> slight modification
> >> to stop a NoneType error) takes 5+ seconds per interval.
> >
> >
> > FWIW no optimizations were done at all in wip-interval.  We should be able
> > to speed it up quite a bit since it's doing quite a bit of work it probably
> > doesn't need to do every loop, though yours might still be faster.  I guess
> > the question is how fast do we need it and is it worth bringing in the extra
> > dependency.
> >
> >>
> >>> suspect we can get similar gains without needing to bring it in.  For now
> >>> though I really think we need to worry about correctness rather than
> >>> speed.
> >>
> >>
> >> I would think someone running python on a large data set would be more
> >> than
> >> willing to install something as widely used and supported as numpy. If
> >> anything
> >> numpy gives us better correctness guarantees and less technical debt.
> >
> >
> > If it does something that we can't easily do ourselves I could be convinced,
> > but it's a tradeoff I'd personally not want to make lightly. Ultimately it
> > should Jen's call though.
> >
> >>
> >> Who else is using / wants the percentiles fiologparser is calculating? If
> >> enough
> >> users are put-off by the dependencies I understand, the data scientist
> >> in me is just
> >> really sad that the exact thing numpy was built for is being
> >> re-engineered.
> >>
> >>> As such, does this version use a similar technique as what's in
> >>> wip-interval?
> >>
> >>
> >> Yes - weighted percentiles are calculated using the fraction of a
> >> sample falling in
> >> the given interval.
> >>
> >>>
> >>> https://github.com/markhpc/fio/commits/wip-interval
> >>>
> >>> If so, we should probably merge that first and make sure we have test
> >>> cases
> >>> for it to make sure the idea is sound.  If this is something new, it
> >>> would
> >>> be good to showcase that it's as good or better than wip-interval.  I
> >>> could
> >>> easily be convinced that it is, but let's demonstrate it.
> >>
> >>
> >> Will do - I'll make some test cases to see where wip-interval differs
> >> with this implementation.
> >> If anything I figure it's good to maintain both for now to see where
> >> our thinking differs - just looking
> >> at your code I wasn't even sure what numbers should be calculated, but
> >> now that I've implemented
> >> weighted latency percentiles myself I have a better idea what we want.
> >
> >
> > There's no guarantee that mine is correct either! :)  Hence why I didn't
> > want to submit a PR for it yet.  Having another set of eyes looking at it is
> > good.
> >
> > One thing I suspect may be contentious is when you are looking at sample
> > points that are averages from fio (like 100ms) and you have two samples that
> > are farther than 100ms apart, does that mean the interval is longer than
> > 100ms or that the interval is 100ms with a gap?  I assumed a longer than
> > 100ms interval, but this may be wrong.  Probably won't know without reading
> > the fio code.
>
> From looking at the code that assumption looks good to me. Namely here:
>
> https://github.com/axboe/fio/blob/master/stat.c#L2135
>
> the code checks to see if *at least* 100ms have passed since the last time we
> logged an average. So you effectively get an average sample as soon as you see
> the first IO request complete after the given time interval. This is
> also why the sample
> end times appear to drift forward in time with averaging, e.g.:
>
> 102, 2293, 0, 0
> 202, 1688, 0, 0
> 306, 1797, 0, 0
> 406, 2056, 0, 0
> 508, 1227, 0, 0
>

Mark,

I have a (pure python / no new dependencies) implementation now of the
weighted percentiles method as described on wikipedia
(https://en.wikipedia.org/wiki/Percentile#Weighted_percentile), with
test cases and verified against one of the "Linear Interpolation
Between Closest Ranks" examples with weights of all one - namely at
the bottom of this ipython notebook:

https://cronburg.com/fio/Weighted-Percentiles.html

Will make a PR to your wip-interval branch shortly. One thing I needed
to do was add a command line parameter to specify bandwidth vs
latency, because of the differing units / need to calculate start
times of samples based on these units for latency logs.

Another thing I noticed is for bandwidth files with both read/write
enabled we get a divide by zero error because of the way start / end
times are calculated. We'll need to segregate the data by r/w
direction in order to account for this. For example the first few
entries in a bw file:

74, 1, 0, 4096
74, 3, 1, 4096
930, 4, 0, 4096
930, 28, 1, 4096
1667, 81, 0, 4096
1667, 124, 1, 4096

-Karl-

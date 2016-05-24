Return-Path: <bengland@redhat.com>
Date: Tue, 24 May 2016 16:47:22 -0400 (EDT)
From: Ben England <bengland@redhat.com>
Message-ID: <1678172793.65613994.1464122842521.JavaMail.zimbra@redhat.com>
In-Reply-To: <a69a1cdc-6d92-d004-1361-69eea862bfa6@gmail.com>
References: <12634496.Be1YEipj88@merkaba> <2097283958.65342663.1464088355308.JavaMail.zimbra@redhat.com> <196b983d-e6e1-2c2d-299e-de3b9cc742ff@gmail.com> <1549707390.65536830.1464103326492.JavaMail.zimbra@redhat.com> <57447327.3010503@kernel.dk> <852858719.65540595.1464104124345.JavaMail.zimbra@redhat.com> <a69a1cdc-6d92-d004-1361-69eea862bfa6@gmail.com>
Subject: Re: fiologparser.py
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Mark Nelson <mark.a.nelson@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Martin Steigerwald <ms@teamix.de>, fio@vger.kernel.org, Mark Nelson <mnelson@redhat.com>
List-ID: <fio@vger.kernel.org>

Mark, I didn't notice the sample weighting code before.  Weighting of samples might work for averaging, but it doesn't work for percentiles, min or max provided by -A option.  I guess for min this won't be an issue generally, since min-latency samples will probably fall entirely within a time interval.  But for max or higher percentiles it will *definitely* be an issue.   For example, a really high latency sample could be the max for a whole range of time intervals.   

To compute percentiles, we can sort (by response time) the samples that *overlap the time interval* and then index into the python list something like this (ignoring boundary conditions):

 def get_percentile(list, percentile): 
   return sample_list[len(list) * percentile / 100]

min would be first array element in sample_list, 
max would be last array element in sample_list. 

And I'll definitely try using .sort instead of sorted(), thx Jeff.

make sense?

-ben


----- Original Message -----
> From: "Mark Nelson" <mark.a.nelson@gmail.com>
> To: "Ben England" <bengland@redhat.com>, "Jens Axboe" <axboe@kernel.dk>
> Cc: "Martin Steigerwald" <ms@teamix.de>, fio@vger.kernel.org, "Mark Nelson" <mnelson@redhat.com>
> Sent: Tuesday, May 24, 2016 12:20:19 PM
> Subject: Re: fiologparser.py
> 
> I've got a version that removes the dependency and appears to return the
> same values:
> 
> https://github.com/axboe/fio/pull/181
> 
> Going through the code though, it looks like the -A values are computed
> differently than in the other original functions.  In the original
> get_contribution function, all samples within the bounds are counted,
> along with samples that are only partially within the bounds.  Each
> sample is weighted based on the duration it overlapped with the sample
> period:
> 
> https://github.com/axboe/fio/blob/master/tools/fiologparser.py#L195-L198
> 
> for -A, only the samples that are totally within the bounds are counted,
> and are weighted equally despite how much of the period was spent in
> that sample:
> 
> https://github.com/axboe/fio/blob/master/tools/fiologparser.py#L173
> 
> Thus if you look at say the average from -a:
> 
> fiologparser.py -a *clat*
> 
> 1000, 11582.770
> 2000, 14033.844
> 3000, 17087.446
> 4000, 17946.245
> 5000, 14554.196
> 6000, 14407.804
> 7000, 15218.106
> 8000, 15157.951
> 
> the results are quite a bit different from -A:
> 
> fiologparser.py -A *clat* | tr -s "," " " | cut -f1,4 -d" "
> 
> 0.000000 11902.719298
> 1000.000000 13247.750000
> 2000.000000 14270.549020
> 3000.000000 15092.192308
> 4000.000000 14127.472727
> 5000.000000 12880.137931
> 6000.000000 15296.735849
> 7000.000000 14857.306122
> 8000.000000 14854.766667
> 
> Mark
> 
> 
> On 05/24/2016 10:35 AM, Ben England wrote:
> > OK we'll remove the dependencies, I still want to have the -A option
> > supported.
> > -ben
> >
> > ----- Original Message -----
> >> From: "Jens Axboe" <axboe@kernel.dk>
> >> To: "Ben England" <bengland@redhat.com>, "Mark Nelson"
> >> <mark.a.nelson@gmail.com>
> >> Cc: "Martin Steigerwald" <ms@teamix.de>, fio@vger.kernel.org, "Mark
> >> Nelson" <mnelson@redhat.com>
> >> Sent: Tuesday, May 24, 2016 11:28:39 AM
> >> Subject: Re: fiologparser.py
> >>
> >> On 05/24/2016 09:22 AM, Ben England wrote:
> >>>
> >>>
> >>> ----- Original Message -----
> >>>> From: "Mark Nelson" <mark.a.nelson@gmail.com>
> >>>> To: "Ben England" <bengland@redhat.com>, "Martin Steigerwald"
> >>>> <ms@teamix.de>
> >>>> Cc: fio@vger.kernel.org, "Mark Nelson" <mnelson@redhat.com>, "Jens
> >>>> Axboe"
> >>>> <axboe@kernel.dk>
> >>>> Sent: Tuesday, May 24, 2016 10:04:14 AM
> >>>> Subject: Re: fiologparser.py
> >>>>
> >>>> Let's see if we can remove the numpy and scipy dependencies.  It looks
> >>>> like we are just using it for min/average/median/max/percentile
> >>>> calculations.  It would be nice if users didn't need anything other than
> >>>> argparse.
> >>>>
> >>>
> >>> Just curious, why is scipy a problem?  Is it because CBT isn't a
> >>> package so you don't get dependencies handled when you install it?  You
> >>> are correct, it's easy to remove the dependencies, I just didn't know it
> >>> was causing problems for people.  You can get percentiles from just
> >>> sorting the sample values and indexing into the array at the appropriate
> >>> offset, I was just trying to re-use existing classes.
> >>
> >> It's not necessarily a problem, but the less dependencies you have, the
> >> easier it is for people to use. I do the same for fio, try to have as
> >> few external dependencies as possible. Remember, not everybody is
> >> running on Linux...
> >>
> >> --
> >> Jens Axboe
> >>
> >>
> 


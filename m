Return-Path: <mark.a.nelson@gmail.com>
Return-Path: <mark.a.nelson@gmail.com>
Subject: Re: fiologparser.py
References: <12634496.Be1YEipj88@merkaba>
 <2097283958.65342663.1464088355308.JavaMail.zimbra@redhat.com>
 <196b983d-e6e1-2c2d-299e-de3b9cc742ff@gmail.com>
 <1549707390.65536830.1464103326492.JavaMail.zimbra@redhat.com>
 <57447327.3010503@kernel.dk>
 <852858719.65540595.1464104124345.JavaMail.zimbra@redhat.com>
 <a69a1cdc-6d92-d004-1361-69eea862bfa6@gmail.com>
 <1678172793.65613994.1464122842521.JavaMail.zimbra@redhat.com>
From: Mark Nelson <mark.a.nelson@gmail.com>
Message-ID: <c54ab91f-ccc9-59a1-bf17-9b72b0525d78@gmail.com>
Date: Tue, 24 May 2016 21:04:13 -0500
MIME-Version: 1.0
In-Reply-To: <1678172793.65613994.1464122842521.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ben England <bengland@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Martin Steigerwald <ms@teamix.de>, fio@vger.kernel.org, Mark Nelson <mnelson@redhat.com>
List-ID: <fio@vger.kernel.org>



On 05/24/2016 03:47 PM, Ben England wrote:
> Mark, I didn't notice the sample weighting code before.  Weighting of samples might work for averaging, but it doesn't work for percentiles, min or max provided by -A option.  I guess for min this won't be an issue generally, since min-latency samples will probably fall entirely within a time interval.  But for max or higher percentiles it will *definitely* be an issue.   For example, a really high latency sample could be the max for a whole range of time intervals.

I went back and reworked the print and per-interval functions so that 
they are part of a Printer class and Interval class respectively.  It 
cleaned the code up pretty nicely.  I was also able to integrate the 
"-A" code to use a lot of the existing statistics and formatting code. 
It now supports the "-d" flag for example.

As part of that I took a stab at making a weighted implementation for 
percentiles (and as a result median).  The basic idea is to sort samples 
by value but then iterate over samples by weight to close in on the 
percentile boundary.  Once the samples that straddle the percentile 
boundary are found, take a weighted average of the two samples based 
inversely on their closeness to the boundary.

I do think it's really important to count samples with overlapping 
boundaries.  In the min case you otherwise disregard the min values that 
are spread over long time durations (ie when IOs stall).  In the max 
case, you potentially loose out on high throughput samples at edge 
boundaries.

I tried the old code and new code on a sample I had.  There's a pretty 
big difference in the number of samples utilized (or partially utilized) 
per interval.

old:

> start-time, samples, min, avg, median, 90%, 95%, 99%, max
> 0.000000, 8, 169631.000000, 321862.500000, 363155.000000, 417325.500000, 418426.250000, 419306.850000, 419527.000000
> 1000.000000, 8, 217273.000000, 324114.750000, 262548.000000, 449062.800000, 456610.900000, 462649.380000, 464159.000000
> 2000.000000, 8, 252437.000000, 351356.000000, 309912.500000, 468551.400000, 470426.700000, 471926.940000, 472302.000000
> 3000.000000, 8, 147123.000000, 315987.375000, 295690.500000, 451860.200000, 457549.100000, 462100.220000, 463238.000000
> 4000.000000, 8, 152847.000000, 325890.875000, 352656.000000, 442708.300000, 446184.150000, 448964.830000, 449660.000000
> 5000.000000, 7, 152547.000000, 333048.428571, 285577.000000, 465428.800000, 469807.900000, 473311.180000, 474187.000000

New:

> end-time, samples, min, avg, median, 90%, 95%, 99%, max
> 1000.000, 16, 169631.000, 321863.134, 298029.136, 451210.153, 455823.097, 457210.922, 457836.000
> 2000.000, 24, 184826.000, 341609.250, 285337.006, 462780.936, 465093.032, 465706.770, 466011.000
> 3000.000, 24, 88867.000, 312228.872, 298560.686, 466730.845, 469928.578, 471566.768, 472302.000
> 4000.000, 24, 88867.000, 309359.155, 278879.166, 458966.926, 462427.823, 462987.178, 463238.000
> 5000.000, 24, 137593.000, 326864.166, 317893.305, 449518.978, 455424.867, 459333.936, 461407.000
> 6000.000, 23, 131237.000, 340960.370, 319615.167, 460959.116, 468513.304, 472427.275, 474187.000

Code is here if anyone wants to critique/flame:

https://github.com/markhpc/fio/commit/19943e4dce34233bc776ed868d12c4c03b5f98ec

Mark

>
> To compute percentiles, we can sort (by response time) the samples that *overlap the time interval* and then index into the python list something like this (ignoring boundary conditions):
>
>  def get_percentile(list, percentile):
>    return sample_list[len(list) * percentile / 100]
>
> min would be first array element in sample_list,
> max would be last array element in sample_list.
>
> And I'll definitely try using .sort instead of sorted(), thx Jeff.
>
> make sense?
>
> -ben
>
>
> ----- Original Message -----
>> From: "Mark Nelson" <mark.a.nelson@gmail.com>
>> To: "Ben England" <bengland@redhat.com>, "Jens Axboe" <axboe@kernel.dk>
>> Cc: "Martin Steigerwald" <ms@teamix.de>, fio@vger.kernel.org, "Mark Nelson" <mnelson@redhat.com>
>> Sent: Tuesday, May 24, 2016 12:20:19 PM
>> Subject: Re: fiologparser.py
>>
>> I've got a version that removes the dependency and appears to return the
>> same values:
>>
>> https://github.com/axboe/fio/pull/181
>>
>> Going through the code though, it looks like the -A values are computed
>> differently than in the other original functions.  In the original
>> get_contribution function, all samples within the bounds are counted,
>> along with samples that are only partially within the bounds.  Each
>> sample is weighted based on the duration it overlapped with the sample
>> period:
>>
>> https://github.com/axboe/fio/blob/master/tools/fiologparser.py#L195-L198
>>
>> for -A, only the samples that are totally within the bounds are counted,
>> and are weighted equally despite how much of the period was spent in
>> that sample:
>>
>> https://github.com/axboe/fio/blob/master/tools/fiologparser.py#L173
>>
>> Thus if you look at say the average from -a:
>>
>> fiologparser.py -a *clat*
>>
>> 1000, 11582.770
>> 2000, 14033.844
>> 3000, 17087.446
>> 4000, 17946.245
>> 5000, 14554.196
>> 6000, 14407.804
>> 7000, 15218.106
>> 8000, 15157.951
>>
>> the results are quite a bit different from -A:
>>
>> fiologparser.py -A *clat* | tr -s "," " " | cut -f1,4 -d" "
>>
>> 0.000000 11902.719298
>> 1000.000000 13247.750000
>> 2000.000000 14270.549020
>> 3000.000000 15092.192308
>> 4000.000000 14127.472727
>> 5000.000000 12880.137931
>> 6000.000000 15296.735849
>> 7000.000000 14857.306122
>> 8000.000000 14854.766667
>>
>> Mark
>>
>>
>> On 05/24/2016 10:35 AM, Ben England wrote:
>>> OK we'll remove the dependencies, I still want to have the -A option
>>> supported.
>>> -ben
>>>
>>> ----- Original Message -----
>>>> From: "Jens Axboe" <axboe@kernel.dk>
>>>> To: "Ben England" <bengland@redhat.com>, "Mark Nelson"
>>>> <mark.a.nelson@gmail.com>
>>>> Cc: "Martin Steigerwald" <ms@teamix.de>, fio@vger.kernel.org, "Mark
>>>> Nelson" <mnelson@redhat.com>
>>>> Sent: Tuesday, May 24, 2016 11:28:39 AM
>>>> Subject: Re: fiologparser.py
>>>>
>>>> On 05/24/2016 09:22 AM, Ben England wrote:
>>>>>
>>>>>
>>>>> ----- Original Message -----
>>>>>> From: "Mark Nelson" <mark.a.nelson@gmail.com>
>>>>>> To: "Ben England" <bengland@redhat.com>, "Martin Steigerwald"
>>>>>> <ms@teamix.de>
>>>>>> Cc: fio@vger.kernel.org, "Mark Nelson" <mnelson@redhat.com>, "Jens
>>>>>> Axboe"
>>>>>> <axboe@kernel.dk>
>>>>>> Sent: Tuesday, May 24, 2016 10:04:14 AM
>>>>>> Subject: Re: fiologparser.py
>>>>>>
>>>>>> Let's see if we can remove the numpy and scipy dependencies.  It looks
>>>>>> like we are just using it for min/average/median/max/percentile
>>>>>> calculations.  It would be nice if users didn't need anything other than
>>>>>> argparse.
>>>>>>
>>>>>
>>>>> Just curious, why is scipy a problem?  Is it because CBT isn't a
>>>>> package so you don't get dependencies handled when you install it?  You
>>>>> are correct, it's easy to remove the dependencies, I just didn't know it
>>>>> was causing problems for people.  You can get percentiles from just
>>>>> sorting the sample values and indexing into the array at the appropriate
>>>>> offset, I was just trying to re-use existing classes.
>>>>
>>>> It's not necessarily a problem, but the less dependencies you have, the
>>>> easier it is for people to use. I do the same for fio, try to have as
>>>> few external dependencies as possible. Remember, not everybody is
>>>> running on Linux...
>>>>
>>>> --
>>>> Jens Axboe
>>>>
>>>>
>>


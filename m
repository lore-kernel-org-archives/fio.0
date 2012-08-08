Return-Path: <kyle.hailey@delphix.com>
MIME-Version: 1.0
In-Reply-To: <50182A1C.9040202@kernel.dk>
References: <CACiQ3FAhrVoXJDuBGLx8okyFLNMd1_J2mRkxz4kKJdTty5OoNA@mail.gmail.com>
 <50182A1C.9040202@kernel.dk>
From: Kyle Hailey <kyle.hailey@delphix.com>
Date: Wed, 8 Aug 2012 09:51:57 -0700
Message-ID: <CACiQ3FCLmXd5tJ9+CSQ6DnbFTjLw==vPiZdQnFrEpUGitCUF_w@mail.gmail.com>
Subject: Re: analyzing, visualizing, understanding and rating fio data
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

>> I'd encourage you to send some of that stuff in so that it
>> could be included with fio
Do you mean check this into the fio code base?
Maybe if the code gets more stablized. Still changing it a bit
and trying to document it better.
Would especially be interested in feedback the actual graph contents
from people

>> I'm assuming you are using the terse/minimal CSV output format, and
>> extracing values from that?
Actually formatted the data into an R data.frame
I could have tried a simple CSV output. Would be worth investigating
to see which makes more sense.


Put a new version of  the graph routine, graphit(),  on github.

https://github.com/khailey/fio_scripts/blob/master/fiop.r

Example graphs on

https://plus.google.com/photos/105986002174480058008/albums/5773655476406055489?authkey=CIvKiJnA2eXSbQ

A visual explanation of the graphs

https://plus.google.com/photos/105986002174480058008/albums/5773661884246310993

A Summary of Graph contents:

The charts are mainly for exploring the data as opposed to a polished
final graph showing I/O performance

A quick recap of the graphics:

 There are 3 graphs

    latency on log graph
    latency on base 10 graph
    throughput bar charts

On the log latency graph latency is shown for

    max latency - dashed red line
    average latency - solid black line
    95% latency - dash black line with grey fill between 95% and average
    99% latency - dash black line with light grey fill between 95% and
99% latency
    latency histogram - buckets represent % of I/Os for that
latency.Each bucket is drawn at the y axis height that represents that
latency. The buckets are also color coded to help more quickly
identify
    background color - for each load test the background , which is
really a barchart, is coded one of 3 colors.
    ... yellow - % of I/Os over 10ms
    ... green - % of I/Os under 10ms
    ... blue - % of I/Os under 1ms

the idea being that the graphs should have all green. If the
backgrounds are yellow then the I/Os are slow. If the backgrounds are
blue then the I/Os represent a certain about of cached reads as
opposed to physical spindle reads.

The second graph is latency on base 10 in order to more easily see the
slopes of the increasing I/O latency with load. On this second graph
is also a bar chart in the background. The bars are color coded

    dark red - latency increased and throughput decreases
    light red - latency increased but throughput also increased
    light blue - latency actually got faster (shouldn't happen but does)

Ideally the bars are so small they aren't visible which means latency
stays the same as load increases. The higher the bar the more the
latency changed between tests

The third chart is simply the throughput, ie the MB/s. These bars have
slices that represent the percentage of the I/O at the latency that
corresponds to that color. The colors are defined in the legend of the
top chart.

- Kyle


On Tue, Jul 31, 2012 at 11:55 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2012-07-28 01:58, Kyle Hailey wrote:
>> I've been testing out fio a bit and found it more flexible than the
>> other popular I/O benchmark tools such as Iozone and Bonnie++ and fio
>> has a more active user community.
>>
>> In order to easily run fio tests, I've written a wrapper script to go
>> through a series of tests.
>> In order to understand the output, I've written a wrapper script to
>> extract and format the results of multiple tests.
>> In order to try and understand the data I've written some graph routines in R.
>>
>> The output of the graph routines is visible here:
>>
>>      sites.google.com/site/oraclemonitor/i-o-graphics#TOC-Percentile-Latency
>>
>> The scripts to run the tests, extract the data and graph the data in R
>> are available here:
>>
>>       github.com/khailey/fio_scripts/blob/master/README.md
>
> Neat stuff!! I'd encourage you to send some of that stuff in so that it
> could be included with fio. The graphic scripts that fio ships with are
> some that I did fairly quickly, and they aren't super good.
>
>> My main question is how does one extract key metrics from fio  runs
>> and what steps does one take to understand and or rate the I/O
>> subsystems based on the data?
>
> I'm assuming you are using the terse/minimal CSV output format, and
> extracing values from that?
>
>> My area of interest is database I/O performance.  Databases have
>> certain typical I/O access profiles.
>> Most notably databases primarily do random I/O of a set size,
>> typically 8K (though this can vary from 2K to 32K).
>>
>> Looking at 1000s of database reports I typically see random I/O around
>> 6ms-8ms on solid
>> gear occasionally faster if some has some serious caching on the SAN
>> and occasionally
>> slower when the I/O subsystem is overtaxed, which fits into some
>> numbers I just grab from a
>> Google search:
>>
>> speed  rot_lat  seek     total
>> 10K    3ms      4.3ms    =  7.3
>> 15K    2ms      3.8ms    =  5.8
>>
>>
>> For rating I/O it seems easy to say something,  for random I/O, like
>>
>> < 5ms awesome
>> < 7ms good
>> < 9ms pretty good
>>> 9ms starting to have contention or slower gear
>>
>>
>> First I'm sure these numbers are debatable, but more importantly they
>> don't take into account throughput.
>> The latency of a single users should be the base latency and then
>> there should be a second value which the throughput that the I/O
>> subsystem can sustain with some close factor of that base latency.
>>
>> The above also doesn't take into account  wide distributions of
>> latency and outliers. For outliers, how important is it that the
>> 99.99% is far from average?  How concerning is it that the max is
>> multi-second when the average is good?
>
> It all depends on what you are running. For some workloads, it could be
> a huge problem, for others not so much. 99.99% is also extreme. At least
> for customers or use cases that I hear about, they are typically looking
> at some X latency value at, say, the 99% percentile and some absolute
> maximum that they can allow.
>
> --
> Jens Axboe
>



--
- Kyle

O: +1.415.341.3430
F: +1.650.494.1676
275 Middlefield Road, Suite 50
Menlo Park, CA 94025
http://www.delphix.com


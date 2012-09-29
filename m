Return-Path: <akashv@google.com>
MIME-Version: 1.0
In-Reply-To: <50669495.1080801@kernel.dk>
References: <CAFFT=U=WusZz8z+J93NvS8QEe=4NuDtiHHJ6_KJQ=gLAggdouA@mail.gmail.com>
 <50669495.1080801@kernel.dk>
From: Akash Verma <akashv@google.com>
Date: Sat, 29 Sep 2012 00:34:33 -0700
Message-ID: <CAFFT=UmwkrocLs+ts+By3FkdaS4tdbDRpCba8R_N=JBhTJoLsA@mail.gmail.com>
Subject: Re: Should group_reporting be clumping together different groups?
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

That's odd, because I understood it differently. I have gone through
the HOWTO again to be sure. Please bear with me; I'm copying
succeeding lines from the HOWTO from version 2.0.9:

new_group Start a new reporting group. If this option isn't given,
jobs in a file will be part of the same reporting group
unless separated by a stone wall (or if it's a group
by itself, with the numjobs option).

numjobs=int Create the specified number of clones of this job. May be
used to setup a larger number of threads/processes doing
the same thing. We regard that grouping of jobs as a
specific group.

group_reporting If 'numjobs' is set, it may be interesting to display
statistics for the group as a whole instead of for each
individual job. This is especially true of 'numjobs' is
large, looking at individual thread/process output quickly
becomes unwieldy. If 'group_reporting' is specified, fio
will show the final report per-group instead of per-job.

Is it just me? Reading that, I don't see any confusion about the
group_reporting flag being specifically for clumping together results
that would otherwise be discrete for each job clone because of
numjobs.

Even here, the description for new_group implies that jobs in a job
file are in the same reporting group, unless <condition 1> and
<condition 2>. But it seems to be the default behavior to not have
them in the same reporting group. For example, I used the file
included in the first email, but without numjobs and group_reporting.
Then I get one report for each job.

In my opinion, the current functionality is fine, but the
documentation isn't clear on it.

Thanks,
Akash

On Fri, Sep 28, 2012 at 11:26 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2012-09-29 04:11, Akash Verma wrote:
>> Let's say I use FIO with the following job file:
>>
>>
>> [group_1]
>> rw=randwrite
>> size=1024k
>> ioengine=libaio
>> time_based=1
>> runtime=10
>> direct=1
>> do_verify=0
>> numjobs=2
>> group_reporting=1
>>
>> [group_2]
>> rw=randread
>> size=1024k
>> ioengine=libaio
>> time_based=1
>> runtime=10
>> direct=1
>> numjobs=2
>> group_reporting=1
>>
>>
>> I get a single report, named after group_1 but actually including
>> results for group_2 as well. Since I'm using group_reporting with
>> numjobs, shouldn't I be getting two reports, one for group_1 and one
>> for group_2?
>>
>> I am able to get the desired functionality using:
>> new_group=1
>> under group_2, causing FIO to specifically treat that group as
>> separate for reporting purposes. However the current behavior still
>> doesn't conform with the description given for both group_reporting
>> and new_group.
>
> Hmm, I think it's perfectly aligned with what is described. The
> documentation states that jobs are part of the same group, except if:
>
> - They are separated by a stone wall, which implies starting a new
>   group.
>
> - or the new_group primitive is used explicitly.
>
> --
> Jens Axboe
>


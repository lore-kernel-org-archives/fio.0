Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:35365 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751243AbdB1SwT (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 28 Feb 2017 13:52:19 -0500
Received: by mail-ua0-f170.google.com with SMTP id 40so24099244uau.2
        for <fio@vger.kernel.org>; Tue, 28 Feb 2017 10:50:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CY4PR10MB1494958C30757B38661B3B4F8C560@CY4PR10MB1494.namprd10.prod.outlook.com>
References: <CY4PR10MB1494804E84709ACA355AE6AE8C530@CY4PR10MB1494.namprd10.prod.outlook.com>
 <CALjAwxjoaJpLoFxW9YO2C=RSnzbZK_pm9QadRJzLcJbBKkUkmA@mail.gmail.com> <CY4PR10MB1494958C30757B38661B3B4F8C560@CY4PR10MB1494.namprd10.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 28 Feb 2017 18:49:55 +0000
Message-ID: <CALjAwxhvLBAaYyJk9hTfUXVTWfdkHwLJ4-fKPqNOgZYPV7WbFg@mail.gmail.com>
Subject: Re: FIO log averaging issue with --write_bw_log and --write_iops_log
 using > 1000 log_avg_msec values
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chris Taylor <ctaylor@pivot3.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Re timing issues: do you mean because of
usec /= 1000;
on line 428? As mtime_since() returns milliseconds it would mean all
fractional millisecond amounts would be pushed downward so potentially
things could be be under by a millisecond. If that's what you're
thinking of I guess how bad that is depends on how much accuracy you
need and how much jitter there is within the system already. Perhaps
you can demonstrate a problem scenario so folks numerate than I will
see the problem too...

Re rounding problem - fair enough.

On 28 February 2017 at 00:47, Chris Taylor <ctaylor@pivot3.com> wrote:
> Hi Sitsofe,
> Looks like this is handled in commit be6bb2b72608d7efbec13d06c67446e229136afa.
> I am no longer able to reproduce the issue with latest version of FIO 2.17, with that change as usecs will now be 0.  Could this potentially cause some timing issues?
>
> Prior to that commit...
> The job below would result in bw_logs and iops_log that have skewed results both the add_iops_samples and add_bw_samples makes a call to mtime_since with start time as the _sample_time
> ./stat.c:2435:  spent = mtime_since(&td->bw_sample_time, t)
> ./stat.c:2510:  spent = mtime_since(&td->iops_sample_time, t);
>
> ./stat.c:2473:  timeval_add_msec(&td->bw_sample_time, td->o.bw_avg_time);
> ./stat.c:2548:  timeval_add_msec(&td->iops_sample_time, td->o.iops_avg_time);
>
> stat.c:2480:27: runtime error: unsigned integer overflow: 2000 - 18446744073708449 cannot be represented in type 'unsigned long'
> stat.c:2555:29: runtime error: unsigned integer overflow: 2000 - 18446744073708449 cannot be represented in type 'unsigned long'
>
> The overflow at stat.c:2265 is a different issue possibly a rounding problem with msec and usecs.

-- 
Sitsofe | http://sucs.org/~sits/

On 28 February 2017 at 00:47, Chris Taylor <ctaylor@pivot3.com> wrote:
> Hi Sitsofe,
> Looks like this is handled in commit be6bb2b72608d7efbec13d06c67446e229136afa.
> I am no longer able to reproduce the issue with latest version of FIO 2.17, with that change as usecs will now be 0.  Could this potentially cause some timing issues?
>
> Prior to that commit...
> The job below would result in bw_logs and iops_log that have skewed results both the add_iops_samples and add_bw_samples makes a call to mtime_since with start time as the _sample_time
> ./stat.c:2435:  spent = mtime_since(&td->bw_sample_time, t)
> ./stat.c:2510:  spent = mtime_since(&td->iops_sample_time, t);
>
> ./stat.c:2473:  timeval_add_msec(&td->bw_sample_time, td->o.bw_avg_time);
> ./stat.c:2548:  timeval_add_msec(&td->iops_sample_time, td->o.iops_avg_time);
>
> stat.c:2480:27: runtime error: unsigned integer overflow: 2000 - 18446744073708449 cannot be represented in type 'unsigned long'
> stat.c:2555:29: runtime error: unsigned integer overflow: 2000 - 18446744073708449 cannot be represented in type 'unsigned long'
>
> The overflow at stat.c:2265 is a different issue possibly a rounding problem with msec and usecs.
>
>
> Thanks,
> Chris
>
> On 23 February 2017 at 20:55, Chris Taylor <ctaylor@pivot3.com> wrote:
>> There is an issue in FIO when using the detailed bandwidth and iops logging with averaging over a period of time > 1 second.
>> It seems that usecs overflows which later causes negative time diff values resulting in skewed toward 0 results.
>> I have attached a potential fix that should prevent usecs from going beyond 1000000.
>
> Is this problem shown by the following job:
>
> ./fio --ioengine=null --write_bw_log=/dev/null --log_avg_msec=2000 --size=100M --runtime=10s --time_based --name=overflow
>
> Among Clang's undefined behaviour sanitizer output was this for the above:
> stat.c:2265:43: runtime error: unsigned integer overflow: 1999 - 2000 cannot be represented in type 'unsigned long'
> stat.c:2265:28: runtime error: unsigned integer overflow: 3999 -
> 4294967295 cannot be represented in type 'unsigned long'
>
>> diff --git a/time.c b/time.c
>> index f5dc049..c748bee 100644
>> --- a/time.c
>> +++ b/time.c
>> @@ -8,11 +8,18 @@ static unsigned long ns_granularity;
>>
>> void timeval_add_msec(struct timeval *tv, unsigned int msec) {
>> -       tv->tv_usec += 1000 * msec;
>> -       if (tv->tv_usec >= 1000000) {
>> -               tv->tv_usec -= 1000000;
>> -               tv->tv_sec++;
>> -       }
>> +       int adj_usec = 1000 * msec;
>> +       int adj_sec = 0;
>> +       tv->tv_usec +=  adj_usec;
>> +       if (adj_usec >= 1000000) {
>> +               adj_sec = adj_usec / 1000000;
>> +               tv->tv_usec -=  adj_sec * 1000000;
>> +               tv->tv_sec += adj_sec;
>> +    }
>> +    if (tv->tv_usec >= 1000000){
>> +            tv->tv_usec -= 1000000;
>> +            tv->tv_sec++;
>> +    }
>> }
>
> Is it still safe to use int if you're targeting a 32 bit platform?
> --
> Sitsofe | http://sucs.org/~sits/



-- 
Sitsofe | http://sucs.org/~sits/

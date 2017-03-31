Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:36565 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbdCaGfK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Mar 2017 02:35:10 -0400
Received: by mail-vk0-f44.google.com with SMTP id s68so80299610vke.3
        for <fio@vger.kernel.org>; Thu, 30 Mar 2017 23:35:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CY4PR10MB1494E32B79F27E052200698F8C280@CY4PR10MB1494.namprd10.prod.outlook.com>
References: <CY4PR10MB1494804E84709ACA355AE6AE8C530@CY4PR10MB1494.namprd10.prod.outlook.com>
 <CALjAwxjoaJpLoFxW9YO2C=RSnzbZK_pm9QadRJzLcJbBKkUkmA@mail.gmail.com>
 <CY4PR10MB1494958C30757B38661B3B4F8C560@CY4PR10MB1494.namprd10.prod.outlook.com>
 <CALjAwxhvLBAaYyJk9hTfUXVTWfdkHwLJ4-fKPqNOgZYPV7WbFg@mail.gmail.com> <CY4PR10MB1494E32B79F27E052200698F8C280@CY4PR10MB1494.namprd10.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 31 Mar 2017 07:34:38 +0100
Message-ID: <CALjAwxiwMA89bJHs9-_MN9eNNibJTtPUBqrMCN6LbMD+kF_Ddw@mail.gmail.com>
Subject: Re: FIO log averaging issue with --write_bw_log and --write_iops_log
 using > 1000 log_avg_msec values
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chris Taylor <ctaylor@pivot3.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Chris,

Sorry for the slow reply. So this change is to deal with the case
where the time being added is two more seconds in size?

On 2 March 2017 at 21:52, Chris Taylor <ctaylor@pivot3.com> wrote:
> Hi,
> I am less concerned about any possible timing issues as they are probably=
 miniscule and I can't think of the scenario where it would be a problem an=
d cause less accurate results to really be concerned about.
> Tests pretty much prove we are getting close to what we expect:
> fio --eta=3Dnever --ioengine=3Dlibaio --readwrite=3Dwrite --time_based=3D=
1 --runtime=3D60 --filename=3D/tmp/fio --size=3D1M --direct=3D1 --name=3Dte=
st --write_iops_log=3D/tmp/test --log_avg_msec=3D5500 --log_unix_epoch=3D1
> 1488489137632, 6413, 1, 0
> 1488489143131, 5503, 1, 0
> 1488489148631, 5585, 1, 0
> 1488489154131, 5883, 1, 0
> 1488489159631, 5726, 1, 0
> 1488489165131, 5331, 1, 0
> 1488489170631, 5772, 1, 0
> 1488489176131, 5661, 1, 0
> 1488489181631, 5970, 1, 0
> 1488489187131, 5776, 1, 0
> [5499, 5500, 5500, 5500, 5500, 5500, 5500, 5500, 5500]
>
> However, the problem still exists where in timeval_add_msec gets a value =
greater than 1000 msecs the tv->tv_usec it will grow beyond usecs (1000000)=
 and causes unexpected behavior.  Possibly this is the better fix to avoid =
other callers having to adjust for  the overflow in timeval_add_msecs?\
> diff --git a/time.c b/time.c
> index f5dc049..a318ad5 100644
> --- a/time.c
> +++ b/time.c
> @@ -9,10 +9,9 @@ static unsigned long ns_granularity;
>  void timeval_add_msec(struct timeval *tv, unsigned int msec)
>  {
>         tv->tv_usec +=3D 1000 * msec;
> -       if (tv->tv_usec >=3D 1000000) {
> -               tv->tv_usec -=3D 1000000;
> -               tv->tv_sec++;
> -       }
> +    tv->tv_sec +=3D tv->tv_usec / 1000000;
> +    tv->tv_usec %=3D 1000000;
> +
>  }
>
>  /*
> Running the same job as above with the change:
> 1488489763099, 5773, 1, 0
> 1488489768599, 5852, 1, 0
> 1488489774099, 5654, 1, 0
> 1488489779599, 5482, 1, 0
> 1488489785099, 5650, 1, 0
> 1488489790599, 5752, 1, 0
> 1488489796099, 5390, 1, 0
> 1488489801599, 5746, 1, 0
> 1488489807099, 5610, 1, 0
> 1488489812599, 5361, 1, 0
> [5500, 5500, 5500, 5500, 5500, 5500, 5500, 5500, 5500]
>
> Thanks,
> Chris
>
> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Tuesday, February 28, 2017 11:50 AM
> To: Chris Taylor <ctaylor@pivot3.com>
> Cc: fio@vger.kernel.org
> Subject: Re: FIO log averaging issue with --write_bw_log and --write_iops=
_log using > 1000 log_avg_msec values
>
> Hi,
>
> Re timing issues: do you mean because of usec /=3D 1000; on line 428? As =
mtime_since() returns milliseconds it would mean all fractional millisecond=
 amounts would be pushed downward so potentially things could be be under b=
y a millisecond. If that's what you're thinking of I guess how bad that is =
depends on how much accuracy you need and how much jitter there is within t=
he system already. Perhaps you can demonstrate a problem scenario so folks =
numerate than I will see the problem too...
>
> Re rounding problem - fair enough.
>
> On 28 February 2017 at 00:47, Chris Taylor <ctaylor@pivot3.com> wrote:
>> Hi Sitsofe,
>> Looks like this is handled in commit be6bb2b72608d7efbec13d06c67446e2291=
36afa.
>> I am no longer able to reproduce the issue with latest version of FIO 2.=
17, with that change as usecs will now be 0.  Could this potentially cause =
some timing issues?
>>
>> Prior to that commit...
>> The job below would result in bw_logs and iops_log that have skewed
>> results both the add_iops_samples and add_bw_samples makes a call to
>> mtime_since with start time as the _sample_time
>> ./stat.c:2435:  spent =3D mtime_since(&td->bw_sample_time, t)
>> ./stat.c:2510:  spent =3D mtime_since(&td->iops_sample_time, t);
>>
>> ./stat.c:2473:  timeval_add_msec(&td->bw_sample_time,
>> td->o.bw_avg_time);
>> ./stat.c:2548:  timeval_add_msec(&td->iops_sample_time,
>> td->o.iops_avg_time);
>>
>> stat.c:2480:27: runtime error: unsigned integer overflow: 2000 - 1844674=
4073708449 cannot be represented in type 'unsigned long'
>> stat.c:2555:29: runtime error: unsigned integer overflow: 2000 - 1844674=
4073708449 cannot be represented in type 'unsigned long'
>>
>> The overflow at stat.c:2265 is a different issue possibly a rounding pro=
blem with msec and usecs.
>
> --
> Sitsofe | http://sucs.org/~sits/
>
> On 28 February 2017 at 00:47, Chris Taylor <ctaylor@pivot3.com> wrote:
>> Hi Sitsofe,
>> Looks like this is handled in commit be6bb2b72608d7efbec13d06c67446e2291=
36afa.
>> I am no longer able to reproduce the issue with latest version of FIO 2.=
17, with that change as usecs will now be 0.  Could this potentially cause =
some timing issues?
>>
>> Prior to that commit...
>> The job below would result in bw_logs and iops_log that have skewed
>> results both the add_iops_samples and add_bw_samples makes a call to
>> mtime_since with start time as the _sample_time
>> ./stat.c:2435:  spent =3D mtime_since(&td->bw_sample_time, t)
>> ./stat.c:2510:  spent =3D mtime_since(&td->iops_sample_time, t);
>>
>> ./stat.c:2473:  timeval_add_msec(&td->bw_sample_time,
>> td->o.bw_avg_time);
>> ./stat.c:2548:  timeval_add_msec(&td->iops_sample_time,
>> td->o.iops_avg_time);
>>
>> stat.c:2480:27: runtime error: unsigned integer overflow: 2000 - 1844674=
4073708449 cannot be represented in type 'unsigned long'
>> stat.c:2555:29: runtime error: unsigned integer overflow: 2000 - 1844674=
4073708449 cannot be represented in type 'unsigned long'
>>
>> The overflow at stat.c:2265 is a different issue possibly a rounding pro=
blem with msec and usecs.
>>
>>
>> Thanks,
>> Chris
>>
>> On 23 February 2017 at 20:55, Chris Taylor <ctaylor@pivot3.com> wrote:
>>> There is an issue in FIO when using the detailed bandwidth and iops log=
ging with averaging over a period of time > 1 second.
>>> It seems that usecs overflows which later causes negative time diff val=
ues resulting in skewed toward 0 results.
>>> I have attached a potential fix that should prevent usecs from going be=
yond 1000000.
>>
>> Is this problem shown by the following job:
>>
>> ./fio --ioengine=3Dnull --write_bw_log=3D/dev/null --log_avg_msec=3D2000
>> --size=3D100M --runtime=3D10s --time_based --name=3Doverflow
>>
>> Among Clang's undefined behaviour sanitizer output was this for the abov=
e:
>> stat.c:2265:43: runtime error: unsigned integer overflow: 1999 - 2000 ca=
nnot be represented in type 'unsigned long'
>> stat.c:2265:28: runtime error: unsigned integer overflow: 3999 -
>> 4294967295 cannot be represented in type 'unsigned long'
>>
>>> diff --git a/time.c b/time.c
>>> index f5dc049..c748bee 100644
>>> --- a/time.c
>>> +++ b/time.c
>>> @@ -8,11 +8,18 @@ static unsigned long ns_granularity;
>>>
>>> void timeval_add_msec(struct timeval *tv, unsigned int msec) {
>>> -       tv->tv_usec +=3D 1000 * msec;
>>> -       if (tv->tv_usec >=3D 1000000) {
>>> -               tv->tv_usec -=3D 1000000;
>>> -               tv->tv_sec++;
>>> -       }
>>> +       int adj_usec =3D 1000 * msec;
>>> +       int adj_sec =3D 0;
>>> +       tv->tv_usec +=3D  adj_usec;
>>> +       if (adj_usec >=3D 1000000) {
>>> +               adj_sec =3D adj_usec / 1000000;
>>> +               tv->tv_usec -=3D  adj_sec * 1000000;
>>> +               tv->tv_sec +=3D adj_sec;
>>> +    }
>>> +    if (tv->tv_usec >=3D 1000000){
>>> +            tv->tv_usec -=3D 1000000;
>>> +            tv->tv_sec++;
>>> +    }
>>> }
>>
>> Is it still safe to use int if you're targeting a 32 bit platform?
>> --
>> Sitsofe | http://sucs.org/~sits/
>
>
>
> --
> Sitsofe | http://sucs.org/~sits/



--=20
Sitsofe | http://sucs.org/~sits/

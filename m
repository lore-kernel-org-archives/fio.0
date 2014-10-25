Return-Path: <michael.mattsson@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAE56cDuKKEvoOfc8wO8j45oEBzxPQPc6ohH_8jLobJRfQuokkA@mail.gmail.com>
References: <CAE56cDu7ctJfTLbFRUGh+VwyHdJ=_rtLYLL_b-kJ=YmeeGaopA@mail.gmail.com>
 <5447D0F5.7090403@kernel.dk> <CAE56cDsm7-FnX2wwhmryrf-6__ZppK353nvUuXpY-96mTkeHrA@mail.gmail.com>
 <CALjAwxh-McXiYRid+e0RDW3SxCwGDfLdUeOmvLVpzXPi20auNw@mail.gmail.com>
 <CAE56cDsQVo2gZRX7n3Y4Ny+=2N2mN9upAL4QtH_yrt0TgwYCDA@mail.gmail.com>
 <54491C12.3020205@kernel.dk> <CAE56cDuuJFyjampbAK7bYWqzSyFmDOqC1amndMu8QBS+dG13vw@mail.gmail.com>
 <CAE56cDvqnwvH6CArCRavd+gJhbzV8Fa4cVCQ_t0-OTbAiZuDzQ@mail.gmail.com>
 <544A7543.6040605@kernel.dk> <CAE56cDuKKEvoOfc8wO8j45oEBzxPQPc6ohH_8jLobJRfQuokkA@mail.gmail.com>
From: Michael Mattsson <michael.mattsson@gmail.com>
Date: Sat, 25 Oct 2014 09:24:53 -0700
Message-ID: <CAE56cDt4ZGDmdyNfNLP_CaoiGyt-quLzmAWrtUhP4TRzMa9QrA@mail.gmail.com>
Subject: Re: --status-interval output race
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

It seems I jumped the gun too early here. I've been running tests for
the last 24 hours and I just had one squirt across multiple clients
rendering the last tick unusable data.

Testing this at my scale with another output engine requires me to
rewrite my parsers and I might end up doing that but I'd hoped there
was a more simplistic workaround for this problem.

Thanks!
Michael

On Fri, Oct 24, 2014 at 12:22 PM, Michael Mattsson
<michael.mattsson@gmail.com> wrote:
> Hey,
> I took another stab at reshuffling output control and I've found a
> combo that works very consistently. By dropping --output and piping to
> tee instead I get an incredible high accuracy in my 'runtime' output.
> It only differs 1-2ms between a sample of ~500 runs. Before this was
> literally all over the place (+/- <1000ms).
>
> Could it be that output redirection is blocked when writing with with
> fio and asynchronously when piping to tee? Output is being written to
> an NFS mount which is subject to several layers of virtualization and
> may cause intermittent latency spikes and deliver my very inconsistent
> results. Thoughts?
>
> Anyhow, thank you for your work here and I owe you lunch!
>
> Regards
> Michael
>
> On Fri, Oct 24, 2014 at 8:50 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2014-10-24 09:44, Michael Mattsson wrote:
>>>
>>> Hey,
>>> Is there anything I can do to help you look at this issue?
>>
>>
>> Does it only happen for minimal output, or on "normal" or json output too?
>>
>> --
>> Jens Axboe
>>


Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:35964 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751339AbdGMTDg (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Jul 2017 15:03:36 -0400
Received: by mail-qt0-f171.google.com with SMTP id i2so45769391qta.3
        for <fio@vger.kernel.org>; Thu, 13 Jul 2017 12:03:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxgHOCfP-7=7V4bVRs5im0EbtXDbv3--P4wpaQNfFdb0eA@mail.gmail.com>
References: <CAKwzdDqKXE3VF=q-Ms3UwLLMjCUpnVZ_cgBwaY3W4sEx4r-X7Q@mail.gmail.com>
 <CALjAwxi0aH0JH-dpemwA7F4k=D3TdE+kwmZkke77S=zZmYjtog@mail.gmail.com>
 <CAKwzdDqC_Ha0FzBNQMZK6MBcaZQXBZpTP0kKe3a5T6UTpZoYdw@mail.gmail.com> <CALjAwxgHOCfP-7=7V4bVRs5im0EbtXDbv3--P4wpaQNfFdb0eA@mail.gmail.com>
From: abhishek koundal <akoundal@gmail.com>
Date: Thu, 13 Jul 2017 12:02:55 -0700
Message-ID: <CAKwzdDrT1+=sp+apFvqfokbgTXLMa+RQ3qg9aamrt+Wtx-b1rQ@mail.gmail.com>
Subject: Re: Mixed seq+random worload thread
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,
The main thing that i am trying to do is to model the storScor in
linux enviornment
(https://github.com/Microsoft/StorScore/blob/master/recipes/write_impact_check.rcp).
So there you can control the rate of the of the writes as per the %
that is required. While running that on windows i can see that i can
have different BS and rate defined for the runs achieving expected
output.

In the above mentioned case the RND_RD will be unconstrained (i.e.
full BW they can achieve) but writes will be slowed to x% of RND_RD.
In fio when
e.g.
SEQ_WR 10% and RND_RD 90%, with seq_wr rate capped at 10% of rnd rd
(if rnd_rd was 40m)
[SEQ_WR]
rate=4m
bs=128K
rw=write
flow=9
[RND_RD]
rate=40m
bs=4k
rw=randread
flow=-1
When i run this the output that comes back shows that SEQ_WR b/w is
capped ~ 4m but RND_RD also gets severely hit for the IOPS+BW as it
tried to put the total BW under <45m>. I want that RND_RD doesn't need
to be capped and should run to it closest potential like I am see in
storScor.
Really appreciate for the support and helping me understand the limitations.



On Wed, Jul 12, 2017 at 11:16 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> Please don't drop the fio mailing list CC / send email only to me as
> it ends up in the wrong folder for me and you remove the ability for
> others to answer your question or find it via search engines. Thanks!
>
> I think you're right - there would be an impact. However if SEQ_WR
> were to go really slow (say, 9 IOPS a second) how else can the ratio
> of SEQ_WR to RND_RD you requested be maintained other than by slowing
> down RND_RD? By definition haven't you also bound the rates together?
>
> On 12 July 2017 at 22:13, abhishek koundal <akoundal@gmail.com> wrote:
>> Looks like this wont be be able to control the rate if i want to just
>> for write. Looks like it will impact the rate for the reads also ,
>> what do you think?
>> [SEQ_WR]
>> rw=write
>> rate=0, 30m,0
>> flow=-1
>> [RND_RD]
>> rw=randread
>> flow=9
>>
>> On Sun, Jul 9, 2017 at 7:05 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>> Hi,
>>>
>>> On 7 July 2017 at 22:44, abhishek koundal <akoundal@gmail.com> wrote:
>>>>
>>>> Is there an easy way in FIO to have a mix workload which can do below
>>>> config in single operation mode:
>>>>
>>>> 90% SEQ_WR
>>>> 10% RND_RD
>>>
>>> I'd suggest using two threads to do this and then using flow
>>> (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-flow )
>>> to control how many turns each gets relative to the other:
>>>
>>> [SEQ_WR]
>>> rw=write
>>> flow=-1
>>> [RND_RD]
>>> rw=randread
>>> flow=9
>>>
>>> This should work OK because you have a pair (but be aware flow doesn't
>>> interact well with the number_ios option). If you need to balance more
>>> than pairs of threads you will probably want to write a new fio
>>> feature...
>
> --
> Sitsofe | http://sucs.org/~sits/



-- 
Life is too short for silly things so invest your time in some
productive outputs!!

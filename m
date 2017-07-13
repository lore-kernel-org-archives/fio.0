Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:34411 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbdGMGQj (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Jul 2017 02:16:39 -0400
Received: by mail-ua0-f179.google.com with SMTP id z22so27719912uah.1
        for <fio@vger.kernel.org>; Wed, 12 Jul 2017 23:16:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKwzdDqC_Ha0FzBNQMZK6MBcaZQXBZpTP0kKe3a5T6UTpZoYdw@mail.gmail.com>
References: <CAKwzdDqKXE3VF=q-Ms3UwLLMjCUpnVZ_cgBwaY3W4sEx4r-X7Q@mail.gmail.com>
 <CALjAwxi0aH0JH-dpemwA7F4k=D3TdE+kwmZkke77S=zZmYjtog@mail.gmail.com> <CAKwzdDqC_Ha0FzBNQMZK6MBcaZQXBZpTP0kKe3a5T6UTpZoYdw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 13 Jul 2017 07:16:07 +0100
Message-ID: <CALjAwxgHOCfP-7=7V4bVRs5im0EbtXDbv3--P4wpaQNfFdb0eA@mail.gmail.com>
Subject: Re: Mixed seq+random worload thread
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Please don't drop the fio mailing list CC / send email only to me as
it ends up in the wrong folder for me and you remove the ability for
others to answer your question or find it via search engines. Thanks!

I think you're right - there would be an impact. However if SEQ_WR
were to go really slow (say, 9 IOPS a second) how else can the ratio
of SEQ_WR to RND_RD you requested be maintained other than by slowing
down RND_RD? By definition haven't you also bound the rates together?

On 12 July 2017 at 22:13, abhishek koundal <akoundal@gmail.com> wrote:
> Looks like this wont be be able to control the rate if i want to just
> for write. Looks like it will impact the rate for the reads also ,
> what do you think?
> [SEQ_WR]
> rw=write
> rate=0, 30m,0
> flow=-1
> [RND_RD]
> rw=randread
> flow=9
>
> On Sun, Jul 9, 2017 at 7:05 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> Hi,
>>
>> On 7 July 2017 at 22:44, abhishek koundal <akoundal@gmail.com> wrote:
>>>
>>> Is there an easy way in FIO to have a mix workload which can do below
>>> config in single operation mode:
>>>
>>> 90% SEQ_WR
>>> 10% RND_RD
>>
>> I'd suggest using two threads to do this and then using flow
>> (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-flow )
>> to control how many turns each gets relative to the other:
>>
>> [SEQ_WR]
>> rw=write
>> flow=-1
>> [RND_RD]
>> rw=randread
>> flow=9
>>
>> This should work OK because you have a pair (but be aware flow doesn't
>> interact well with the number_ios option). If you need to balance more
>> than pairs of threads you will probably want to write a new fio
>> feature...

-- 
Sitsofe | http://sucs.org/~sits/

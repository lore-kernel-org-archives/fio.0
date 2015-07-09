Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:34446 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbbGIHAP (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 9 Jul 2015 03:00:15 -0400
Received: by ykcp133 with SMTP id p133so41887273ykc.1
        for <fio@vger.kernel.org>; Thu, 09 Jul 2015 00:00:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEg8mkyaAwXpzuJvS1t_CcWxDD+cgaPAG2qkhV-YND_Osthcnw@mail.gmail.com>
References: <CAEg8mkz7MdEjZHukGX4AiaMF4hGKVPYcX3U3xszqAjjSFYEL4Q@mail.gmail.com>
	<CAM8G_BLZCApz3TVWXMfuc4vub5eLOVXws1MShFb9J-FRKTdoCg@mail.gmail.com>
	<CAEg8mkwoP0QZDBZDgEQPa7Yvhyu105Yq-CfBV7WQ7bX4sXZ7Kw@mail.gmail.com>
	<CAKXScpVU3HdvKKNR+bipyt+wOsezirL+QV7sz+y=TAV_0vbX6w@mail.gmail.com>
	<CAEg8mkyaAwXpzuJvS1t_CcWxDD+cgaPAG2qkhV-YND_Osthcnw@mail.gmail.com>
Date: Thu, 9 Jul 2015 00:00:14 -0700
Message-ID: <CAKXScpWjpfLCk4zczN=cjD5cYMSoVOb0hekLg-1+xreMznyH=A@mail.gmail.com>
Subject: Re: ask a question about fio
From: "danielabuggie ." <danielabuggie@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: john gong <johngong0791@gmail.com>
Cc: "Kulkarni, Vasu" <vasu.kulkarni@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Unfortunately, I don't think there is an option then that will
precisely do what you are asking then.  Perhaps if you clarify more
about what you are looking to test someone can help you approximate it
better.

Some suggestions though for you to look into:
* Use a randrw process with percentage_random set to an appropriate
value to control roughly how many blocks would be read before seeking.

* Also a randrw process with bssplit set to a mix of small and large
blocks sizes would make "random" IO intermittently more sequential.

Daniel

On Wed, Jul 8, 2015 at 11:08 PM, john gong <johngong0791@gmail.com> wrote:
> hi Daniel,
>
> Thanks for your suggestion.
>
> "stonewall" can not solve my problem.  "stonewall" just enforce the
> processes which do the exact jobs run sequentially.
> But what I want to do is that all things be done in one process, not
> with one jobfile.
>
> B.R.
>
> On Thu, Jul 9, 2015 at 1:21 PM, danielabuggie . <danielabuggie@gmail.com> wrote:
>> So you want to run them all with one jobfile, but sequentially and not
>> simultaneously?
>>
>> In that case, stonewall is the option you want to add.
>>
>> Daniel
>>
>> On Wed, Jul 8, 2015 at 9:02 PM, john gong <johngong0791@gmail.com> wrote:
>>> hello  Kulkarni & Alireza,
>>>
>>> Thanks for your attentions.
>>> tiobench-example.fio will spawn 16 processes, each job consumes 4 processes.
>>> But what i want is all things defined in the job description be done
>>> in one process.
>>> For example, executes below job description
>>> --cut--
>>> [global]
>>> engine=sync
>>> filename=/data/test
>>> size=100m
>>> [job1]
>>> rw=write
>>> stonewall
>>> [job2]
>>> rw=read
>>> stonewall
>>> [job3]
>>> rw=randwrite
>>> stonewall
>>> [job4]
>>> rw=randread
>>> stonewall
>>> --cut--
>>>
>>> This job description can satisfy the demand of sequential execute, but
>>> they will be done in 4 different processes.
>>> What i want is all things be done in the same process sequentilly.
>>>
>>> B.R.
>>>
>>> John.Gong
>>>
>>>
>>>
>>>
>>>
>>>
>>> On Thu, Jul 9, 2015 at 11:19 AM, Kulkarni, Vasu <vasu.kulkarni@gmail.com> wrote:
>>>> Here's one example with 4 jobs which you can customize
>>>> https://github.com/axboe/fio/blob/master/examples/tiobench-example.fio
>>>>
>>>>
>>>> On Wed, Jul 8, 2015 at 6:55 PM, john gong <johngong0791@gmail.com> wrote:
>>>>> hello All,
>>>>>
>>>>> I wonder whether FIO can do below things in the same job?
>>>>> 1) sequential write
>>>>> 2) sequential read
>>>>> 3) randomly write
>>>>> 4) randomly read
>>>>>
>>>>> Namely FIO do not need to spawn other processes to do the things respectively.
>>>>> All things will be done in the same process.
>>>>>
>>>>> Thanks in advance!
>>>>>
>>>>> John.Gong
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>>
>>>> --
>>>> A ship is safer in a harbor.  But that's not what ships are built for.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

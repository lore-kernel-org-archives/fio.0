Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:34360 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbbGIECM (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 9 Jul 2015 00:02:12 -0400
Received: by ykcp133 with SMTP id p133so39306737ykc.1
        for <fio@vger.kernel.org>; Wed, 08 Jul 2015 21:02:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAM8G_BLZCApz3TVWXMfuc4vub5eLOVXws1MShFb9J-FRKTdoCg@mail.gmail.com>
References: <CAEg8mkz7MdEjZHukGX4AiaMF4hGKVPYcX3U3xszqAjjSFYEL4Q@mail.gmail.com>
	<CAM8G_BLZCApz3TVWXMfuc4vub5eLOVXws1MShFb9J-FRKTdoCg@mail.gmail.com>
Date: Thu, 9 Jul 2015 12:02:12 +0800
Message-ID: <CAEg8mkwoP0QZDBZDgEQPa7Yvhyu105Yq-CfBV7WQ7bX4sXZ7Kw@mail.gmail.com>
Subject: Re: ask a question about fio
From: john gong <johngong0791@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Kulkarni, Vasu" <vasu.kulkarni@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

hello  Kulkarni & Alireza,

Thanks for your attentions.
tiobench-example.fio will spawn 16 processes, each job consumes 4 processes.
But what i want is all things defined in the job description be done
in one process.
For example, executes below job description
--cut--
[global]
engine=sync
filename=/data/test
size=100m
[job1]
rw=write
stonewall
[job2]
rw=read
stonewall
[job3]
rw=randwrite
stonewall
[job4]
rw=randread
stonewall
--cut--

This job description can satisfy the demand of sequential execute, but
they will be done in 4 different processes.
What i want is all things be done in the same process sequentilly.

B.R.

John.Gong






On Thu, Jul 9, 2015 at 11:19 AM, Kulkarni, Vasu <vasu.kulkarni@gmail.com> wrote:
> Here's one example with 4 jobs which you can customize
> https://github.com/axboe/fio/blob/master/examples/tiobench-example.fio
>
>
> On Wed, Jul 8, 2015 at 6:55 PM, john gong <johngong0791@gmail.com> wrote:
>> hello All,
>>
>> I wonder whether FIO can do below things in the same job?
>> 1) sequential write
>> 2) sequential read
>> 3) randomly write
>> 4) randomly read
>>
>> Namely FIO do not need to spawn other processes to do the things respectively.
>> All things will be done in the same process.
>>
>> Thanks in advance!
>>
>> John.Gong
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> A ship is safer in a harbor.  But that's not what ships are built for.

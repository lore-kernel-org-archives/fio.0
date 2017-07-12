Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:35616 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752614AbdGLSUK (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 12 Jul 2017 14:20:10 -0400
Received: by mail-ua0-f177.google.com with SMTP id j53so19640575uaa.2
        for <fio@vger.kernel.org>; Wed, 12 Jul 2017 11:20:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMHrwcRV3dE2acjgeLxdYA1C6DrbhwEndymcZOD2CLi8XudKZQ@mail.gmail.com>
References: <CAMHrwcRkq0vEiuqgqgZwN7djaJDS6=U1f6QPRWH2YDQpWf588w@mail.gmail.com>
 <CALjAwxjpBN+JQcCZ4tK7G+m-091NJv083SKgwoD1_bQo1Ge0mw@mail.gmail.com> <CAMHrwcRV3dE2acjgeLxdYA1C6DrbhwEndymcZOD2CLi8XudKZQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 12 Jul 2017 19:19:34 +0100
Message-ID: <CALjAwxg45i2MmdrqiPii3g6Ojs+w_kpVF8rdOgJdZb=-9SDF4Q@mail.gmail.com>
Subject: Re: unexpected stonewall parsing led jobs separated by stonewall to
 run concurrently
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ido Ben-Tsion <idob@infinidat.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Would changing the HOWTO to say:
"Make the job containing the stonewall parameter wait for preceding
jobs in the job file to exit before starting."
be any clearer? What did you find that made you expect the original
behaviour and what did you find that made you change your
understanding?

On 12 July 2017 at 08:01, Ido Ben-Tsion <idob@infinidat.com> wrote:
> ok, I understand. I didn't think of stonewall as being part of a job.
> I thought of it as a separator between jobs, unrelated to any specific
> job. which is not what the documentation explains.
>
> On Wed, Jul 12, 2017 at 9:26 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> Hi,
>>
>> On 12 July 2017 at 06:13, Ido Ben-Tsion <idob@infinidat.com> wrote:
>>> fio version: fio-2.21-37-ga2c9
>>>
>>> fio file excerpt:
>>> [global]
>>> ioengine=sg
>>> invalidate=1
>>> ramp_time=5
>>> iodepth=16
>>> runtime=300
>>> time_based
>>> bs=64k
>>> norandommap
>>> loops=5
>>>
>>> [seq_read-2-jobs]
>>> rw=read
>>> numjobs=2
>>> stonewall
>>>
>>> [randread]
>>> rw=randread
>>> [seq_write]
>>> rw=write
>>> stonewall
>>> ...
>>>
>>> In the report, I see jobs with groupid 0 which are not supposed to be
>>> on same group:
>>> ...,jobname,groupid,...
>>> ...,seq_read-2-jobs,0,...
>>> ...,seq_read-2-jobs,0,...
>>> ...,randread,0,...
>>> ...,seq_write,1,...
>>
>> I'm not sure I follow - which jobs are wrong? Looking at the opening
>> sentence explanation (and the alternative name) for stonewall in the
>> HOWTO (http://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-stonewall
>> ) seems to describe the behaviour you're seeing.
>>
>> Can you be more explicit as to the problem?

-- 
Sitsofe | http://sucs.org/~sits/

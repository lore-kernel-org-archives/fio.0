Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35984 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933120AbdGLHB5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 12 Jul 2017 03:01:57 -0400
Received: by mail-oi0-f43.google.com with SMTP id x187so12140148oig.3
        for <fio@vger.kernel.org>; Wed, 12 Jul 2017 00:01:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxjpBN+JQcCZ4tK7G+m-091NJv083SKgwoD1_bQo1Ge0mw@mail.gmail.com>
References: <CAMHrwcRkq0vEiuqgqgZwN7djaJDS6=U1f6QPRWH2YDQpWf588w@mail.gmail.com>
 <CALjAwxjpBN+JQcCZ4tK7G+m-091NJv083SKgwoD1_bQo1Ge0mw@mail.gmail.com>
From: Ido Ben-Tsion <idob@infinidat.com>
Date: Wed, 12 Jul 2017 10:01:35 +0300
Message-ID: <CAMHrwcRV3dE2acjgeLxdYA1C6DrbhwEndymcZOD2CLi8XudKZQ@mail.gmail.com>
Subject: Re: unexpected stonewall parsing led jobs separated by stonewall to
 run concurrently
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

ok, I understand. I didn't think of stonewall as being part of a job.
I thought of it as a separator between jobs, unrelated to any specific
job. which is not what the documentation explains.

On Wed, Jul 12, 2017 at 9:26 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On 12 July 2017 at 06:13, Ido Ben-Tsion <idob@infinidat.com> wrote:
>> fio version: fio-2.21-37-ga2c9
>>
>> fio file excerpt:
>> [global]
>> ioengine=sg
>> invalidate=1
>> ramp_time=5
>> iodepth=16
>> runtime=300
>> time_based
>> bs=64k
>> norandommap
>> loops=5
>>
>> [seq_read-2-jobs]
>> rw=read
>> numjobs=2
>> stonewall
>>
>> [randread]
>> rw=randread
>> [seq_write]
>> rw=write
>> stonewall
>> ...
>>
>> In the report, I see jobs with groupid 0 which are not supposed to be
>> on same group:
>> ...,jobname,groupid,...
>> ...,seq_read-2-jobs,0,...
>> ...,seq_read-2-jobs,0,...
>> ...,randread,0,...
>> ...,seq_write,1,...
>
> I'm not sure I follow - which jobs are wrong? Looking at the opening
> sentence explanation (and the alternative name) for stonewall in the
> HOWTO (http://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-stonewall
> ) seems to describe the behaviour you're seeing.
>
> Can you be more explicit as to the problem?
>
> --
> Sitsofe | http://sucs.org/~sits/



-- 


Ido Ben-Tsion

Ackerstein Towers, A Tower, Fl.4
Hamenofim St. P.O.B 12696, Hertzelia Pituach, 46725
T +972.9.970.4000, F +972.9.970.4001
M +972.5X.XXX.XXXX
www.infinidat.com

Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:40794 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933236AbeCEJZy (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 5 Mar 2018 04:25:54 -0500
Received: by mail-ua0-f176.google.com with SMTP id c14so9924090uak.7
        for <fio@vger.kernel.org>; Mon, 05 Mar 2018 01:25:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANvN+e=Q8LYnG72VxEAKC6OW6L9SRtoP_e0yE14-1AUS0NDTLw@mail.gmail.com>
References: <CANvN+emXGM9D5Pv3xdx_=nqbzJ_rG8FqGNYJxxCkA38xK7EARQ@mail.gmail.com>
 <923FC40148D42D44A828D320CE66E06A9E094EC9@MX204CL01.corp.emc.com>
 <CANvN+ekYav7toZrFrLHVpMv=GWcL0kO7V4g7L=HXBmP7cjsQMw@mail.gmail.com>
 <CALjAwxhQOu4oQmsbD6ZoSu=k83XUHZ8i3+wjySOUqZqtCcSq3Q@mail.gmail.com> <CANvN+e=Q8LYnG72VxEAKC6OW6L9SRtoP_e0yE14-1AUS0NDTLw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 5 Mar 2018 09:25:23 +0000
Message-ID: <CALjAwxgBO8y6Am_pF2--OUkoRWZGWqfNZZS+XpvBXeq=dpK-3A@mail.gmail.com>
Subject: Re: Size and time-based jobs under the same config file
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@dell.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 5 March 2018 at 09:14, Andrey Kuzmin <andrey.v.kuzmin@gmail.com> wrote:
>
>
> On Mon, Mar 5, 2018, 12:11 Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>
>> Hi,
>>
>> On 4 March 2018 at 21:50, Andrey Kuzmin <andrey.v.kuzmin@gmail.com> wrote:
>> >
>> > I'm not using verify, so no idea re your question. That's the config
>> > in question, with some (irrelevant) omissions.
>>
>> Thanks for including this - without it answering this type of question
>> becomes a short in the dark.
>>
>> > [global]
>> > thread=1
>> > group_reporting=1
>> > direct=1
>> > verify=0
>> > ramp_time=0
>> >
>> > [precond]
>> > numjobs=1
>> > iodepth=128
>> > rw=write
>> > bs=128k
>> > size=4g
>> >
>> > [randrw]
>> > stonewall
>> > numjobs=4
>> > iodepth=32
>> > rw=randrw
>> > bs=4k
>> > runtime=1m
>> >>
>> >> -----Original Message-----
>> >> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>> >> Behalf Of Andrey Kuzmin
>> >>
>> >> I see a run of the subj resulting in the second, time-based job (which
>> >> is stonewalled to start after the size-based one) ending prematurely, with
>> >> its lifetime apparently consumed by the size-based job. This used to work
>> >> just a couple of years back ;). Am I missing something?
>>
>> runtime
>> (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-runtime
>> ) by itself sets the maximum amount of time a job will run for but it
>> can exit earlier for other reasons (e.g. file size has been done).
>> Perhaps you also wanted to add time_based
>> (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-time-based
>> ) ? That option says that the I/O should be looped if necessary until
>> runtime is exceeded.
>
>
> I believe it's the same with time_based, although I'll double check later
> today. May be the size-based one should use io_size instead of size?

io_size is for controlling the amount I/O done without also messing
with the start-end region (see
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-io-size
). In your case I'd be surprised if it made any difference in your
first job because you aren't changing the start offset and you're
doing sequential I/O...

-- 
Sitsofe | http://sucs.org/~sits/

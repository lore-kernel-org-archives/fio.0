Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:44114 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbeACRsB (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 3 Jan 2018 12:48:01 -0500
Received: by mail-wm0-f67.google.com with SMTP id t8so4017259wmc.3
        for <fio@vger.kernel.org>; Wed, 03 Jan 2018 09:48:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxgT9ZPYAZbBQbwuqfpmBPLHSfK_kqE2mKMaMOmyF_Q6HA@mail.gmail.com>
References: <CAPSTwmSgrDt1i2m0hzHpAh9ncM1vWWSQmjcOY6mkpik-c-vwxg@mail.gmail.com>
 <CALjAwxgT9ZPYAZbBQbwuqfpmBPLHSfK_kqE2mKMaMOmyF_Q6HA@mail.gmail.com>
From: Gnana Sekhar <kgsgnana2020@gmail.com>
Date: Wed, 3 Jan 2018 10:47:59 -0700
Message-ID: <CAPSTwmS=D=jJ=wXNZRc7QZr4kcCA31v+A-wsxGpz4XJgaxQ0_g@mail.gmail.com>
Subject: Re: LBA selection in FIO
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio@vger.kernel.org

Thanks for the response sitsofe

Basically I am looking to see if FIO has the below option
1. Pass the LBA count as an argument. From your explanation my
understanding is currently FIO doesn't have that option
2. On the buffer pattern I wasn't able to specify the buffer pattern
to be all 0(zero) but --buffer_pattern=1 works fine. Do I have to use
zero_buffers to fill buffers with zero and not buffer_pattern

For option1, if I cant pass LBA count, my plan is to
get LBA size of the drive,
multiply the LBA size with lba count which will give me the size in bytes
pass the size with --size=x b  where x is the size obtained in above step

Please let me know if there are some other efficient ways to achieve this

Regards,
Gnana

On Fri, Dec 29, 2017 at 4:12 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On 28 December 2017 at 23:17, Gnana Sekhar <kgsgnana2020@gmail.com> wrote:
>>
>> I am looking to see if FIO has options to pass LBA count and data
>> pattern as CLI arguments.
>
> The rw parameter can take a :<nr> parameter (see
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-readwrite
> ). The various zone options (e.g.
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-random-distribution
> , http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-zonesize
> ) can enable some types of repetition. It's hard to say if this is
> enough for your purposes though...
>
> If you have to precisely craft exact offsets and exact counts you
> could use an iolog replay file via the read_iolog option
> (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-read-iolog
> ). If your shell supports it you might be even able to craft the
> replay "file" on the fly (e.g. bash can use <() to do Process
> Substitution).
>
>> Data pattern means same pattern to the specified LBA range i.e.,
>> either all 1's or 0's etc.,
>
> If the data is identical in every block being written then perhaps
> buffer_pattern -
> http://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-buffer-pattern
> ?
>
>> Also will FIO be able to write to specified number of LBAs
>> irrespective of the LBA size
>
> I am struggling to understand this question. If you mean "can fio be
> told to write a specific number of blocks" then isn't this normally
> the blocksize (http://fio.readthedocs.io/en/latest/fio_man.html#block-size
> )?
>
> --
> Sitsofe | http://sucs.org/~sits/

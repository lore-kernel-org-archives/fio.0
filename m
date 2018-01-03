Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:43787 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbeACTS1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 3 Jan 2018 14:18:27 -0500
Received: by mail-ua0-f179.google.com with SMTP id l12so1695768uaa.10
        for <fio@vger.kernel.org>; Wed, 03 Jan 2018 11:18:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPSTwmS=D=jJ=wXNZRc7QZr4kcCA31v+A-wsxGpz4XJgaxQ0_g@mail.gmail.com>
References: <CAPSTwmSgrDt1i2m0hzHpAh9ncM1vWWSQmjcOY6mkpik-c-vwxg@mail.gmail.com>
 <CALjAwxgT9ZPYAZbBQbwuqfpmBPLHSfK_kqE2mKMaMOmyF_Q6HA@mail.gmail.com> <CAPSTwmS=D=jJ=wXNZRc7QZr4kcCA31v+A-wsxGpz4XJgaxQ0_g@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 3 Jan 2018 19:17:56 +0000
Message-ID: <CALjAwxj5oinoiFhFp18C8CmthwX_OP3231+PMHbAs8EHMQeHJw@mail.gmail.com>
Subject: Re: LBA selection in FIO
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gnana Sekhar <kgsgnana2020@gmail.com>
Cc: fio@vger.kernel.org

Hi Gnana,

On 3 January 2018 at 17:47, Gnana Sekhar <kgsgnana2020@gmail.com> wrote:
>
> Basically I am looking to see if FIO has the below option
> 1. Pass the LBA count as an argument. From your explanation my
> understanding is currently FIO doesn't have that option

Well I'm still unsure what LBA count means in this context. If my
blocks are 512 bytes big and I want a single write to cover LBA 0 - 3
then isn't the blocksize of 4k controlling the LBA count? Sorry to
keep asking I just don't understand the request.

> 2. On the buffer pattern I wasn't able to specify the buffer pattern
> to be all 0(zero) but --buffer_pattern=1 works fine. Do I have to use
> zero_buffers to fill buffers with zero and not buffer_pattern

Hmm! 0 is going to be interpreted as "this option is unset". Does 0x0 work?

> For option1, if I cant pass LBA count, my plan is to
> get LBA size of the drive,
> multiply the LBA size with lba count which will give me the size in bytes
> pass the size with --size=x b  where x is the size obtained in above step

Are you trying to do I/O "on the spot" (e.g. only do I/O to the exact
same region for the whole job)? If so you can

* Use offset (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-offset
) and size (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-size
) to limit the region you do I/O within
* Have blocksize use a value of <x> and the rw=read:<-x>
* Use rw_sequencer=identical and rw=read:<highnumberhere>
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-rw-sequencer
)

?

-- 
Sitsofe | http://sucs.org/~sits/

Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:35768 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751561AbdF0Lif (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 27 Jun 2017 07:38:35 -0400
Received: by mail-vk0-f45.google.com with SMTP id 191so14365410vko.2
        for <fio@vger.kernel.org>; Tue, 27 Jun 2017 04:38:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALKvLUkui5FbZfdKdv+R-dPHYjLrd9un7RdRa4W7uQJ-JPK-Ww@mail.gmail.com>
References: <CALKvLUk55=ZHf61_QSewXsUKgyv62wYqHmKXiUdD1DXg=otMOA@mail.gmail.com>
 <CAHndrBm=ytrMYEyrgTH8qWF+JFZ4edPdCdE=xprtb7E-O8Gq8Q@mail.gmail.com>
 <CALKvLUkmy93Tcoe58V5Sufb-Dmv=WhSns9TTzBZekDinoGtyGQ@mail.gmail.com> <CALKvLUkui5FbZfdKdv+R-dPHYjLrd9un7RdRa4W7uQJ-JPK-Ww@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 27 Jun 2017 12:38:03 +0100
Message-ID: <CALjAwxiuj4dzL6hrZHRQG5L=q2M2+gxcpu-f1tgRAV_YLd6nHw@mail.gmail.com>
Subject: Re: in what units is offset option?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Konstantin Ruvinsky <konstantin.ruvinsky@gmail.com>
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Konstantin,

Isn't that explanation there already:
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-offset
? Note that you need a recent fio (e.g. built from git) to get all the
latest features.

On 27 June 2017 at 09:53, Konstantin Ruvinsky
<konstantin.ruvinsky@gmail.com> wrote:
> Thank you! Can you please add the explanation about percentage and
> also about offset units in bytes to HOWTO? It is absent.
>
> On Tue, Jun 27, 2017 at 11:28 AM, Tomohiro Kusumi
> <kusumi.tomohiro@gmail.com> wrote:
>>
>> bytes or percentage.
>>
>> (I think it needs explanation on how to specify in percentage unless
>> already mentioned in howto)
>>
>> 2017-06-27 10:25 GMT+03:00 Konstantin Ruvinsky <konstantin.ruvinsky@gmail.com>:
>> > Hi,
>> >
>> >
>> >
>> > To be sure: in what units is the offset option -  In bytes, in block
>> > sizes or in units of block size?
>> >
>> >
>> >
>> > Thank you
>> >
>> > Konstantin
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe fio" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Sitsofe | http://sucs.org/~sits/

Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:53907 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbdJNHdj (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 14 Oct 2017 03:33:39 -0400
Received: by mail-vk0-f41.google.com with SMTP id c76so5326604vkd.10
        for <fio@vger.kernel.org>; Sat, 14 Oct 2017 00:33:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKwzdDo7ub14AmQBmJu9J5rOuSDnxEAVp1w2gkDo=5stkzS31A@mail.gmail.com>
References: <CAKwzdDo7ub14AmQBmJu9J5rOuSDnxEAVp1w2gkDo=5stkzS31A@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 14 Oct 2017 08:33:07 +0100
Message-ID: <CALjAwxh0Zrm0AviKpTMsTN8Mj27tdRB4=nVhTAh4r0j+P=unoA@mail.gmail.com>
Subject: Re: fio LBA span query
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 13 October 2017 at 21:31, abhishek koundal <akoundal@gmail.com> wrote:
>
> I want  to ensure that unique thread targeted the given LBA span, is
> there a way to achieve it using "raw" drive
>
> [thread1]
> size= LBA 0-50%
>
> [thread2]
> size= LBA 51-80%

Fio uses size and offset to constrain where I/O is done. With recent
fio versions you can use percentages with size and offset too, e.g.
offset=51% size=80% . See the documentation for size and offset -
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-size
and http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-offset
(there's sentence talking about range).

-- 
Sitsofe | http://sucs.org/~sits/

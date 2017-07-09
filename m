Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:36433 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750936AbdGIOGM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 9 Jul 2017 10:06:12 -0400
Received: by mail-ua0-f176.google.com with SMTP id g40so41529317uaa.3
        for <fio@vger.kernel.org>; Sun, 09 Jul 2017 07:06:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKwzdDqKXE3VF=q-Ms3UwLLMjCUpnVZ_cgBwaY3W4sEx4r-X7Q@mail.gmail.com>
References: <CAKwzdDqKXE3VF=q-Ms3UwLLMjCUpnVZ_cgBwaY3W4sEx4r-X7Q@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 9 Jul 2017 15:05:41 +0100
Message-ID: <CALjAwxi0aH0JH-dpemwA7F4k=D3TdE+kwmZkke77S=zZmYjtog@mail.gmail.com>
Subject: Re: Mixed seq+random worload thread
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 7 July 2017 at 22:44, abhishek koundal <akoundal@gmail.com> wrote:
>
> Is there an easy way in FIO to have a mix workload which can do below
> config in single operation mode:
>
> 90% SEQ_WR
> 10% RND_RD

I'd suggest using two threads to do this and then using flow
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-flow )
to control how many turns each gets relative to the other:

[SEQ_WR]
rw=write
flow=-1
[RND_RD]
rw=randread
flow=9

This should work OK because you have a pair (but be aware flow doesn't
interact well with the number_ios option). If you need to balance more
than pairs of threads you will probably want to write a new fio
feature...

-- 
Sitsofe | http://sucs.org/~sits/

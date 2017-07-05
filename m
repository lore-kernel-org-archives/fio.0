Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:34993 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750868AbdGEFZA (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Jul 2017 01:25:00 -0400
Received: by mail-vk0-f41.google.com with SMTP id 191so118857911vko.2
        for <fio@vger.kernel.org>; Tue, 04 Jul 2017 22:25:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKwzdDr12fxuw8UYPcoaR8a7U0v3k-DgZw26gdE2-xwbwFO9Yw@mail.gmail.com>
References: <CAKwzdDr12fxuw8UYPcoaR8a7U0v3k-DgZw26gdE2-xwbwFO9Yw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 5 Jul 2017 06:24:29 +0100
Message-ID: <CALjAwxgq92Tc5ka2FcNjJ=cDPpydOQA0_WdRq-3y791qh5tgPQ@mail.gmail.com>
Subject: Re: fio sequential workload with zoned distribution
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 5 July 2017 at 03:29, abhishek koundal <akoundal@gmail.com> wrote:
>
> I want to look at options of doing zoned access but using "sequential" workload.
> Does the below profile achieve that? I want to make sure that using
> the random_distribution wont cause the i/o to behave as random.
>
> rw=write
> random_distribution= 60/10:30/30:10/60
> i.e
> 60% seq wr = first 10% of drive
> 30% seq wr = next 30% of drive
> 10% seq wr = next 60% of drive

I don't think what you're described will work. Besides the mild syntax
issue (you need random_distribution=zoned:parameters as described over
on http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-random-distribution
) currently if you want the I/O to follow a distribution other than
uniform by definition it's at odds with being purely sequential - you
lack the ability to choose an area other than just after your last I/O
when you write a new I/O.

Conceptually this is tricky too - at what point would you choose the
next zone to work on? Do I keep overwriting a zone before moving on to
the next and repeating? That would make the leading parts of the zone
slightly hotter than rest if the I/Os don't divide evenly...

Unfortunately the parameter you're trying to use is called
*random*_distribution so it only affects random I/Os.

-- 
Sitsofe | http://sucs.org/~sits/

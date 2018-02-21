Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:34091 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752892AbeBULUm (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Feb 2018 06:20:42 -0500
Received: by mail-vk0-f46.google.com with SMTP id z190so718948vkg.1
        for <fio@vger.kernel.org>; Wed, 21 Feb 2018 03:20:42 -0800 (PST)
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 21 Feb 2018 11:20:11 +0000
Message-ID: <CALjAwxjUHo=ShAZrtPfLkQLRep3D8KEuByfrLkBNZUAeFqYuFA@mail.gmail.com>
Subject: Re: [ Inquire FIO-butterfly test ] method concept and flow , notice
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jacky Chen <jackyc423@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

(First up please don't send fio requests directly to me as they'll get
lost! Send them to the fio mailing list - see
https://github.com/axboe/fio/blob/fio-3.4/README#L58 for details.
Thanks!)

On 21 February 2018 at 11:00, Jacky Chen <jackyc423@gmail.com> wrote:
>
> One thing need your detail description related FIO butterfly test .
>
> On URL i saw some commit as below : "FIO-butterfly example test" .
>
> examples: add a butterfly seek job file

<snip>

> ============================== =====================
>
> I am interesting at this fio test method - butterfly test .
>
> Could you give me more detail description of "butterfly test" method  and
> how do I do this experiment on my platform ?
>
> On URL (https://github.com/axboe/fio/commit/8019f14b8f0538adffd8af39e06e5627b9c8773b ) i saw some commit as below : "FIO-butterfly example test" .

Could you elaborate further - what extra detail are you after beyond
what's already in the commit message?

To run a job like this on your platform take the example file and
modify the filename it runs against.

A quick note: if you're not familiar with fio and this is your first
time using it I'd strongly recommend you start with the basic example
in the HOWTO (see
http://fio.readthedocs.io/en/latest/fio_doc.html#job-file-format ) and
build your up from there rather than start with this particular
example.

-- 
Sitsofe | http://sucs.org/~sits/

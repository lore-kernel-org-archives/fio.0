Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:43999 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752514AbeDSPgt (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 19 Apr 2018 11:36:49 -0400
Received: by mail-ua0-f172.google.com with SMTP id s15so3717573uae.10
        for <fio@vger.kernel.org>; Thu, 19 Apr 2018 08:36:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <11c23a3e.3f51.162de5ddcdb.Coremail.shadow_lin@163.com>
References: <954d5ac.792464.162dbe00ee5.Coremail.shadow_lin@163.com>
 <CALjAwxhKMn093G99cAgpnALCDySTrWi8OWo4X6GXeonOUE+riw@mail.gmail.com> <11c23a3e.3f51.162de5ddcdb.Coremail.shadow_lin@163.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 19 Apr 2018 16:36:18 +0100
Message-ID: <CALjAwxi2yw7F4RFuW8Ej5qaFSzkLqtM2e7OJ9di1etCysjWb3g@mail.gmail.com>
Subject: Re: Re: how to understand latency when rate is set?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: shadow_lin <shadow_lin@163.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On 19 April 2018 at 15:45, shadow_lin <shadow_lin@163.com> >
> Hi Sitsofe,
>         Thank you for your insight.
>         I think the lat(along with slat,clat) in fio result means how long it takes to complete the whole io operation.

slat is submission latency alone. clat is completion latency alone.
lat is the total latency from the time it was submitted to the time it
came back completed. See the sections in
http://fio.readthedocs.io/en/latest/fio_doc.html#interpreting-the-output
for descriptions.

> So with 4m block it means how long it takes to submit the request and gets the comfirmation that the 4m block is
>  written into the disk.So I think with higher bandwidth the lat should be lower.Is my understanding correct?Wthout rate

I don't think your understanding is completely correct.

Something to be aware of: when you start using giant blocks sizes your
I/Os may have to be split up due to device (or system) constraints.
Generally speaking disks don't normally accept huge (say bigger than
2MByte) I/Os and if something tries to send them it is up to the
kernel to split them up (generating extra work). Typically there's an
optimal block size that the disk likes best and when you go bigger
than that you often go past the point of diminishing returns. I
mention this because if your 4MByte I/O is split up into 64 x 64KByte
pieces its latency is now the time for ALL the 64KByte pieces to come
back so because they all have to complete. You may also find this
effect means the depth of I/Os being sent down to the disk is
DIFFERENT to what fio is submitting. Take a look at the iostat command
output while your fio is running to see what size and depth of I/Os
the kernel is sending down.

Re throughput and latency: imagine the case where the system only has
one thing to do (one tiny I/O). It could be the case that this is
"easier" to complete than when 100 things have to all be done at once
(e.g. due to the overhead of switching between them all). You might
get a higher throughput doing 100 I/Os at once (all spare resources
are kept occupied) but at the cost that each I/O operation completes a
little bit slower - higher throughput but worse latency. Latency does
not have to go down just because throughput goes up...

-- 
Sitsofe | http://sucs.org/~sits/

Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35550 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbcEWPDI (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 23 May 2016 11:03:08 -0400
Received: by mail-lf0-f45.google.com with SMTP id e126so48337260lfg.2
        for <fio@vger.kernel.org>; Mon, 23 May 2016 08:03:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANo=J15Pt4+=G4dmq+hwUGH+3-OP4wWvqO44dbZLNOZaQYcmRQ@mail.gmail.com>
References: <CANo=J15Pt4+=G4dmq+hwUGH+3-OP4wWvqO44dbZLNOZaQYcmRQ@mail.gmail.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Mon, 23 May 2016 18:02:46 +0300
Message-ID: <CANvN+enHvuNd5TC=Qxte22k52qR3XdLzyeGxQ5OLihwOM0XDRQ@mail.gmail.com>
Subject: Re: testing thin provisioned block device
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tim Walker <tim.t.walker@seagate.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Mon, May 23, 2016 at 5:24 PM, Tim Walker <tim.t.walker@seagate.com> wrote:
> Hello-
>
> I need to do random writes/reads to some thin-provisioned block
> devices.  Writes are no problem, but I have to make sure the reads
> come from blocks that have already been written (or else the device
> synthesizes fill data).  Pre-filling the device is not desirable since
> they are 8-12 TiB, plus that isn't the way they are really used.
>
> IO at the block level is our customer's requirement, but I'd also be
> interested in the same concept at the file level, where fio randomly
> reads from files that it has randomly written.
>
> I'm sure I'm not the first person who has come up against this, but
> I've searched/Googled the best I can and have come up empty. Can
> somebody point me to the correct switches to force reads to be
> randomly selected from the blocks that have been written by that test
> sequence?

To my knowledge, there's no prebuilt configuration to read only those blocks
that have been written before.

At the same time, when randommap is on, FIO keeps track of the blocks written,
so it may be possible to limit the read generation to those by adding
a bit of code.

Regards,
Andrey

>
> Thanks in advance.
>
> Best regards,
> -Tim
>
> --
> Tim Walker
> Product Design Systems Engineering, Seagate Technology
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

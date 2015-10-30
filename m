Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36102 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331AbbJ3Oej (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 30 Oct 2015 10:34:39 -0400
Received: by wicfx6 with SMTP id fx6so11899350wic.1
        for <fio@vger.kernel.org>; Fri, 30 Oct 2015 07:34:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56333CD3.40101@htec.rs>
References: <56333CD3.40101@htec.rs>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Fri, 30 Oct 2015 17:34:18 +0300
Message-ID: <CANvN+ekXBgL5qJZBU4qNbyFkzY3BS+6KmGqr3dWgoWdSjKcF4A@mail.gmail.com>
Subject: Re: FIO IO units block size setting function
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: vmokric <vojislav.mokric@htec.rs>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Oct 30, 2015 at 12:48 PM, vmokric <vojislav.mokric@htec.rs> wrote:
> Hello,
>
> can someone point me to FIO function which performs IO units block size
> settings? If I, e.g. pass "bs=8k", where does it actually ends up?

It goes through the parser into setting up the per-process/thread
I/O pattern, look under struct thread_options definition.

>
> I have searched ioctl commands, but couldn't figure out actual function.
>

ioctl has more or less nothing to do with this as it pops up only when fio
deals with a block device and wants to learn its size (look under filesetup.c
and os/os-linux.h).

Regards,
Andrey

> I would really appreciate any help, since I need some guidelines within
> perplexed world of Linux IO system.
>
> Regards
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

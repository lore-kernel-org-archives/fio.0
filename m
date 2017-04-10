Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:35945 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751780AbdDJTol (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 10 Apr 2017 15:44:41 -0400
Received: by mail-io0-f179.google.com with SMTP id l7so108360272ioe.3
        for <fio@vger.kernel.org>; Mon, 10 Apr 2017 12:44:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <72a0d7083a3e46b4a4369c19d73c62fc@bowex36b.micron.com>
References: <72a0d7083a3e46b4a4369c19d73c62fc@bowex36b.micron.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Mon, 10 Apr 2017 22:44:20 +0300
Message-ID: <CANvN+ekzXJLBYU+N0b-UCg=StSQDeoPRgYpD8TyS_WB_xLgSbw@mail.gmail.com>
Subject: Re: Adding IO engine
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Deyoung Hong (dhong)" <dhong@micron.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Mon, Apr 10, 2017 at 8:45 PM, Deyoung Hong (dhong) <dhong@micron.com> wr=
ote:
> Hi Jens,
>
> I have a couple basic questions:
>
> 1)  If I want to submit a new IO engine with fio and it has a dependency =
on an external library, how does that work when fio is compiled?  Please al=
so point me to info how to submit a new IO engine to be packaged with fio?
>
> 2)  I've seen cases where the ->iomem_alloc() function (i.e. for a custom=
 IO engine) is invoked first by fio before ->get_file_size() or ->setup(). =
 This causes an issue since IO memory allocation can have dependency on cer=
tain initialization (for the custom IO engine) that is done in ->get_file_s=
ize().   I just wonder if that's an fio bug or how it should be?

It sounds more like a misconception re iomem_{alloc,free} API. It is
about buffers I/O goes to/from, not files. As an example (and the root
cause behind the API proposal), I wanted to be able to allocate
buffers in DMAable memory as my engine required that to interact with
hardware directly.

Being unrelated to files by design, buffer initialization occurs way
before file setup as it did in fio before iomem_* API was introduced.

Regards,
Andrey



>   My current work around is to check in ->iomem_alloc() each time and do =
initializion first if has not.
>
> Thanks,
> Deyoung
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

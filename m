Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:35951 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751082AbdDDGRf (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 4 Apr 2017 02:17:35 -0400
Received: by mail-vk0-f41.google.com with SMTP id s68so163821076vke.3
        for <fio@vger.kernel.org>; Mon, 03 Apr 2017 23:17:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <62746C96-1A2C-4D10-9A5F-ACA6092086CA@cisco.com>
References: <62746C96-1A2C-4D10-9A5F-ACA6092086CA@cisco.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 4 Apr 2017 07:17:04 +0100
Message-ID: <CALjAwxjNw9AzSi1wFAZTsO94g-svQKRS+LNg_zetbQ8jgneFPg@mail.gmail.com>
Subject: Re: Error handling in fio_libaio_event()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Scott Forman (scforman)" <scforman@cisco.com>
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Scott,

You might find https://www.fsl.cs.sunysb.edu/~vass/linux-aio.txt useful...

On 4 April 2017 at 01:48, Scott Forman (scforman) <scforman@cisco.com> wrot=
e:
>
> In looking further at fio_libaio_event(), I am wondering if it is possibl=
e to get the errno value if one of the events have an error (i.e. if ev->re=
s !=3D io_u->xfer_buflen).

Note this handles one type of error - the case where the I/O was
accepted at submission time but for some reason when it completed it
was short or too long(?). As alluded to, errors can also be returned
at submission time. It's also sensible to check that io_getevents
hasn't errored too.

> I see that io_u->error is set to =E2=80=93ev->res if ev->res is greater t=
han io_u->xfer_buflen.  But since my io_u->xfer_buflen is a large value, I =
am guessing that this is not the errno value that caused the error.  Is tha=
t true?

This isn't a true errno but rather is a synthesized fio error - I
guess this is fio checking that it hasn't asked to store more than it
allocated space for and trying to indicate that it's an error if this
were to happen.

> Also, if ev->res is less than io_u->xfer_buflen, then io_u->resid is set =
to (io_u->xfer_buflen - ev->res).  Does that mean that there will be anothe=
r attempt to write out the io_u->resid bytes?

Not necessarily. For example what happens if you perform a write that
goes past the end of the file - would you want to retry that even
though it returned back as being short? Is the fact it came back short
a definite error?

--=20
Sitsofe | http://sucs.org/~sits/

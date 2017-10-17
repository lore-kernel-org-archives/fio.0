Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:46708 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751935AbdJQFtT (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 17 Oct 2017 01:49:19 -0400
Received: by mail-ua0-f179.google.com with SMTP id w45so373549uac.3
        for <fio@vger.kernel.org>; Mon, 16 Oct 2017 22:49:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <F4AD05DA-7571-4A39-A2EC-4C1DB2BE2436@cisco.com>
References: <62746C96-1A2C-4D10-9A5F-ACA6092086CA@cisco.com>
 <CALjAwxjNw9AzSi1wFAZTsO94g-svQKRS+LNg_zetbQ8jgneFPg@mail.gmail.com> <F4AD05DA-7571-4A39-A2EC-4C1DB2BE2436@cisco.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 17 Oct 2017 06:48:48 +0100
Message-ID: <CALjAwxihtXT+QEO6J=Yzhb06jij6z6+nOJgL23VbMkWnQk1myQ@mail.gmail.com>
Subject: Re: Error handling in fio_libaio_event()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Scott Forman (scforman)" <scforman@cisco.com>
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 17 October 2017 at 00:44, Scott Forman (scforman) <scforman@cisco.com> w=
rote:
>
> I am running into a new problem when I check for write errors after calli=
ng io_getevents() that I am hoping you can help me out with.
>
> Comparing it to your function fio_libaio_event() in engines/libaio.c, I a=
m finding that  (ev->res !=3D io_u->xfer_buflen) and that (ev->res > io_u->=
xfer_buflen).   The value of ev->res, which I believe is the result of the =
write, is equal to the value of the count parameter passed to io_prep_pwrit=
e(), so it seems like the write succeeded.

This sounds strange - a long write? I'd expect ev->res to be less than
or equal to the length of the buffer you passed in for that I/O but
you're saying that it's greater? Are you sure you've got the ev->res
you're looking at matches to the I/O you're checking against? Or was
that a typo?

> So I was surprised to find the io_u->xfer_buflen value (or in my case, th=
e struct iocb.u.c.nbytes value) less than what it was set to in io_prep_pwr=
ite().  Do you know what might be causing this?

If ev->res is LESS than io_u->xfer_buflen then you have a short I/O
which happens when less I/O than you wanted is serviced. I actually
gave an example of when this could happen originally:

> On 4/3/17, 11:17 PM, "Sitsofe Wheeler" <sitsofe@gmail.com> wrote:
>
>     On 4 April 2017 at 01:48, Scott Forman (scforman) <scforman@cisco.com=
> wrote:
>     >
>     > In looking further at fio_libaio_event(), I am wondering if it is p=
ossible to get the errno value if one of the events have an error (i.e. if =
ev->res !=3D io_u->xfer_buflen).
>
[...]
>
>     > Also, if ev->res is less than io_u->xfer_buflen, then io_u->resid i=
s set to (io_u->xfer_buflen - ev->res).  Does that mean that there will be =
another attempt to write out the io_u->resid bytes?
>
>     Not necessarily. For example what happens if you *perform a write tha=
t
>     goes past the end of the file* [emphasis added] - would you want to r=
etry that even
>     though it returned back as being short? Is the fact it came back shor=
t
>     a definite error?

You may also find https://github.com/littledan/linux-aio handy if very
C++ oriented.

--=20
Sitsofe | http://sucs.org/~sits/

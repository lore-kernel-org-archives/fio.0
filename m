Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f49.google.com ([209.85.128.49]:38399 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfLSD2O (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 18 Dec 2019 22:28:14 -0500
Received: by mail-wm1-f49.google.com with SMTP id u2so4100527wmc.3
        for <fio@vger.kernel.org>; Wed, 18 Dec 2019 19:28:13 -0800 (PST)
MIME-Version: 1.0
References: <CA+zhgFSzBaH3q8TGZCet4WujqYBNqNA_kH3HavLoQY8FsmKFcQ@mail.gmail.com>
 <AT5PR8401MB116994768647E0EF0490F80DAB920@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <CA+zhgFRJJ6JiWe46+UPDkfDddUDxCTJcOTPUtJnA-y6rKcvN6w@mail.gmail.com>
In-Reply-To: <CA+zhgFRJJ6JiWe46+UPDkfDddUDxCTJcOTPUtJnA-y6rKcvN6w@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 19 Dec 2019 03:27:47 +0000
Message-ID: <CALjAwxhuNDowJbesAjgPVoj67h5tfLj-OAcWdA0go30Qy95+Gg@mail.gmail.com>
Subject: Re: unaligned IO and starting LBA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: smitha sunder <sundersmitha@gmail.com>
Cc: "Elliott, Robert (Servers)" <elliott@hpe.com>, fio <fio@vger.kernel.org>

On Thu, 17 Oct 2019 at 13:49, smitha sunder <sundersmitha@gmail.com> wrote:
>
> Hi Robert,
>
> Since I want to use blocksize_unaligned=3D1 , I had to get rid of direct=
=3D1 :
>
> Per man page :
> blocksize_unaligned, bs_unaligned
> If set, any size in blocksize_range may be used. This typically won't
> work with direct I/O, as that normally requires sector alignment.
>
> # fio --name=3Djob1 --filename=3D/dev/nvme0n1  --rw=3Drandwrite
> --ioengine=3Dlibaio  --number_ios=3D1 --debug=3Dio --bs_unaligned=3D1
> --bs=3D1029 --direct=3D1
> fio: set debug option io
> fio: bs_unaligned may not work with raw io

> On Wed, Oct 16, 2019 at 8:12 AM Elliott, Robert (Servers)
> <elliott@hpe.com> wrote:
> >
> > > -----Original Message-----
> > > From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On=
 Behalf Of smitha sunder
> > > Sent: Tuesday, October 15, 2019 4:37 PM
> > > To: fio <fio@vger.kernel.org>
> > > Subject: unaligned IO and starting LBA
> > >
> > > Hello,
> > >
> > > I have a 512 byte formatted nvme drive and I want to send an unaligne=
d
> > > IO and here=E2=80=99s the fio command line I am using , fio version f=
io-3.7
> > >
> > > # fio --name=3Djob1 --filename=3D/dev/nvme0n1  --rw=3Drandwrite
> > > --ioengine=3Dlibaio  --number_ios=3D1 --debug=3Dio --bs_unaligned=3D1
> > > --bs=3D1029

A blocksize of 1029 is neither a multiple of 4096 nor 512! You simply
can't send I/O that is not aligned (and is not a multiple) of the
device's logical block size down to a device so something will have to
"fix" things for you.

> > > Shouldn=E2=80=99t I see D7BD7CE as the starting LBA for the write bas=
ed on the
> > > above offset (0x1af7af9cec) ?
> >
> > Without direct=3D1 you're exercising the OS page cache logic,
> > not directly accessing the drive.

Robert's right - when you have buffering going on the linux kernel
will quietly do a read-modify-write (two reads assuming it didn't
already have those blocks in memory, a modify, then two writes)
because you straddled a block.

--=20
Sitsofe | http://sucs.org/~sits/


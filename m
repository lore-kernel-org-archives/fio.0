Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf1-f41.google.com ([209.85.167.41]:43666 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfJPRos (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 16 Oct 2019 13:44:48 -0400
Received: by mail-lf1-f41.google.com with SMTP id u3so18193263lfl.10
        for <fio@vger.kernel.org>; Wed, 16 Oct 2019 10:44:46 -0700 (PDT)
MIME-Version: 1.0
References: <CA+zhgFSzBaH3q8TGZCet4WujqYBNqNA_kH3HavLoQY8FsmKFcQ@mail.gmail.com>
 <AT5PR8401MB116994768647E0EF0490F80DAB920@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <AT5PR8401MB116994768647E0EF0490F80DAB920@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: smitha sunder <sundersmitha@gmail.com>
Date: Wed, 16 Oct 2019 10:18:26 -0700
Message-ID: <CA+zhgFRJJ6JiWe46+UPDkfDddUDxCTJcOTPUtJnA-y6rKcvN6w@mail.gmail.com>
Subject: Re: unaligned IO and starting LBA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc: fio <fio@vger.kernel.org>

Hi Robert,

Since I want to use blocksize_unaligned=3D1 , I had to get rid of direct=3D=
1 :

Per man page :
blocksize_unaligned, bs_unaligned
If set, any size in blocksize_range may be used. This typically won't
work with direct I/O, as that normally requires sector alignment.

# fio --name=3Djob1 --filename=3D/dev/nvme0n1  --rw=3Drandwrite
--ioengine=3Dlibaio  --number_ios=3D1 --debug=3Dio --bs_unaligned=3D1
--bs=3D1029 --direct=3D1
fio: set debug option io
fio: bs_unaligned may not work with raw io

Thanks
smitha

On Wed, Oct 16, 2019 at 8:12 AM Elliott, Robert (Servers)
<elliott@hpe.com> wrote:
>
>
>
> > -----Original Message-----
> > From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On B=
ehalf Of smitha sunder
> > Sent: Tuesday, October 15, 2019 4:37 PM
> > To: fio <fio@vger.kernel.org>
> > Subject: unaligned IO and starting LBA
> >
> > Hello,
> >
> >
> >
> > I have a 512 byte formatted nvme drive and I want to send an unaligned
> > IO and here=E2=80=99s the fio command line I am using , fio version fio=
-3.7
> >
> > # fio --name=3Djob1 --filename=3D/dev/nvme0n1  --rw=3Drandwrite
> > --ioengine=3Dlibaio  --number_ios=3D1 --debug=3Dio --bs_unaligned=3D1
> > --bs=3D1029
> ...
> > Shouldn=E2=80=99t I see D7BD7CE as the starting LBA for the write based=
 on the
> > above offset (0x1af7af9cec) ?
>
> Without direct=3D1 you're exercising the OS page cache logic,
> not directly accessing the drive.
>


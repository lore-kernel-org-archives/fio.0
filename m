Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f44.google.com ([209.85.221.44]:40963 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfDSUiz (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 19 Apr 2019 16:38:55 -0400
Received: by mail-wr1-f44.google.com with SMTP id c12so1985687wrt.8
        for <fio@vger.kernel.org>; Fri, 19 Apr 2019 13:38:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAKRObaZ5N=trawpfu3fj8xAP6+3mLHp8Lgo0DZ6Aac56O6epww@mail.gmail.com>
In-Reply-To: <CAKRObaZ5N=trawpfu3fj8xAP6+3mLHp8Lgo0DZ6Aac56O6epww@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 19 Apr 2019 10:32:14 +0100
Message-ID: <CALjAwxgiednQRtcv7HYssQ0Xqw1x24gPd+sN5OKA7F4aqsiOuA@mail.gmail.com>
Subject: Re: Help with HTTP engine with S3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Surendar Chandra <surendar@acm.org>
Cc: fio <fio@vger.kernel.org>, Lars Marowsky-Bree <lmb@suse.com>

CC'ing Lars (original author of that ioengine).

On Sat, 30 Mar 2019 at 22:52, Surendar Chandra <surendar@acm.org> wrote:
>
> I=E2=80=99m following the example script to use http driver for S3. My wr=
ite script is:
>
> [create]
> filename=3D/data.dat
> rw=3Dreadwrite
> bs=3D2m
> size=3D50g
> io_size=3D10m
>
> The PUT goes to /data.dat_0_2097152 signifying offset (0) and
> xfer_buflen of 2M. Except, AWS seems to create the file
> /data.dat_0_2097152. How do I make AWS understand this format?
> Shouldn=E2=80=99t we be using RANGE requests?
>
> Thanks much

--=20
Sitsofe | http://sucs.org/~sits/


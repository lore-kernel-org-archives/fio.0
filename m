Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk1-f179.google.com ([209.85.222.179]:45507 "EHLO
        mail-qk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbgCWTVB (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Mar 2020 15:21:01 -0400
Received: by mail-qk1-f179.google.com with SMTP id c145so16557180qke.12
        for <fio@vger.kernel.org>; Mon, 23 Mar 2020 12:21:00 -0700 (PDT)
MIME-Version: 1.0
From: Kurt Dorsey <batlin@gmail.com>
Date: Mon, 23 Mar 2020 14:20:48 -0500
Message-ID: <CAJzzwJzVBEmff7xkV6-RUEAwnaF8b87Uj_YqvG9GHE1X4wu+UA@mail.gmail.com>
Subject: SG Engine 520 format alignment issue
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello all, I am doing some 520byte per sector testing and utilizing
the sg engine.  so far it is working ok (doesn't seem to be able to
have iodepth > 16 but that is workable with jobs...)

I am running into an issue with 32K block sizes though.
If I want to run 4K transfers  I will transfer 520*8 =3D 4,160bytes
16K =3D 520*32 =3D  16,640 bytes
32K =3D 520*64 =3D 33,280 bytes
Unfortunately 33,280 fails with "read/write not sector aligned"

Checking the code engines/sg.c
static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
{
        struct sg_io_hdr *hdr =3D &io_u->hdr;
        struct sg_options *o =3D td->eo;
        struct sgio_data *sd =3D td->io_ops_data;
        unsigned long long nr_blocks, lba;
        int offset;

        if (io_u->xfer_buflen & (sd->bs - 1)) {
                log_err("read/write not sector aligned\n");
                return EINVAL;
        }


Issue is with how it is calculating whether the transfer size is
aligned or not. It all works for 512/4096 aligned IO yet it breaks
down when doing 520 bytes aligned IO
Chart below shows different block sizes
519:          10 0000 0111 (sd->bs - 1)
1040:     =E2=80=AD   100 0001 0000=E2=80=AC & (sd->bs - 1) =3D 1
4160:     1 0000 0100 0000 & (sd->bs - 1) =3D 0 OK
8320:    10 0000 1000 0000=E2=80=AC & (sd->bs - 1) =3D 0 OK
16640:  =E2=80=AD100 0001 0000 0000=E2=80=AC & (sd->bs - 1) =3D 0 OK
33280: =E2=80=AD1000 0010 0000 0000=E2=80=AC & (sd->bs - 1) =3D 1

It actually doesn't work for anything below 4160 and block sizes
between 33280 and 66,560

It can be fixed by changing the following
if (io_u->xfer_buflen & (sd->bs - 1)) {
to
if (io_u->xfer_buflen % sd->bs  !=3D 0 ) {

I am sure there is a better way but it works for me.  Is there anyway
to get this change in (or something similar)?

Thank you,
Kurt


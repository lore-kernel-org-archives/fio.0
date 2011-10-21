Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56477 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab1JUFt3 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 21 Oct 2011 01:49:29 -0400
Received: by ggnb1 with SMTP id b1so3539338ggn.19
        for <fio@vger.kernel.org>; Thu, 20 Oct 2011 22:49:29 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 20 Oct 2011 22:49:29 -0700
Message-ID: <CAHwYU7uw-Jg5wkZ_NTpyT1cFgAe0G2pYQaUOjef3Bx_0sXb2YA@mail.gmail.com>
Subject: Bug in io_u buf calculaiton.
From: Jagadish Kumar <jagadish.mukku@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,
following are the details of the bug in fio.

This bug in fio can show up as corruption of data when performing verify.

Description:
----------------

if=EF=BF=BD the product of block size and queudepth is greater than 4GB, io=
_u
buffer will not
be assigned properly due to overflow.

fio --bsrange=3D256k-4m --ioengine=3Dlibaio --iodepth=3D2064 --direct=3D1
--name=3Djob3 --offset=3D2GB --size=3D14GB --rw=3Dwrite
--verify_pattern=3D0xdeadbeef --filename=3D/dev/sdb

can show false corruption.

Version:
-----------
1.58

Explanation:
-----------------

in a loop fio tries to assign the data buffer to each i/o request.


static int init_io_u(struct thread_data *td)
{
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDstr=
uct io_u *io_u;
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDuns=
igned int max_bs;
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDint=
 cl_align, i, max_units;
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDcha=
r *p;
...
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BDp =3D td->orig_buffer;
...
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BDfor (i =3D 0; i < max_units; i++) {
...
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDio_u->buf =3D p + max_bs * i;
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD}
}

at max_bs=3D4M i=3D1024, the integer overflows and the addresses are being
used again.
i,e i/o request 1024 will have the same data buffer as that of i/o request =
0.

This is seen from fio debug log.

mem 11164 io_u alloc 0x219f530, index 0
mem 11164 io_u 0x219f530, mem 0x7f09bb62d000
mem 11164 io_u alloc 0x219f820, index 1
mem 11164 io_u 0x219f820, mem 0x7f09bba2d000


mem 11164 io_u alloc 0x225b530, index 1024
mem 11164 io_u 0x225b530, mem 0x7f09bb62d000
mem 11164 io_u alloc 0x225b820, index 1025
mem 11164 io_u 0x225b820, mem 0x7f09bba2d000

the fix is as follows:

=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDio_u->buf=
 =3D p + (unsigned long long)max_bs * i;

thanks,
-jagadish

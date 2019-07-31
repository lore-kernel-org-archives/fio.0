Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f45.google.com ([209.85.221.45]:33038 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728136AbfGaUrE (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 31 Jul 2019 16:47:04 -0400
Received: by mail-wr1-f45.google.com with SMTP id n9so71227001wru.0
        for <fio@vger.kernel.org>; Wed, 31 Jul 2019 13:47:03 -0700 (PDT)
MIME-Version: 1.0
References: <CABaL7QE7Lra-dV7JVgq3fnPLXp2BJXtw=cOWau6mBS94TQBEbg@mail.gmail.com>
 <CABaL7QEHarULAC-SVmdMxy8V8i3P3UNMxUx1rbCyqc7SfcsbSw@mail.gmail.com>
In-Reply-To: <CABaL7QEHarULAC-SVmdMxy8V8i3P3UNMxUx1rbCyqc7SfcsbSw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 31 Jul 2019 21:46:36 +0100
Message-ID: <CALjAwxjSnJqduYZC=BRmkj_aHXxv4dpb5n=7bxBFpPLDJM+Srw@mail.gmail.com>
Subject: Re: FIO Windows Documentation
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Adam Congdon <cac8907@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Wed, 31 Jul 2019 at 16:22, Adam Congdon <cac8907@gmail.com> wrote:
>
> Hi!
>
>
> FIO is a wonderful tool. Great work!!

Jens, you've got a fan! :-)

> In the documentation (readme + fio.1 files) is this description:
>
>
>
> =E2=80=9COn Windows, disk devices are accessed as `\\\\.\\PhysicalDrive0'=
 for
>
> the first device, `\\\\.\\PhysicalDrive1' for the second etc.=E2=80=9D

When I look at a rendered man page (i.e. man ./fio.1 on the command
line) I see the number of backslashes that you say work:

              On Windows, disk devices are  accessed  as  `\\.\PhysicalDriv=
e0'
              for  the  first device, `\\.\PhysicalDrive1' for the second e=
tc.

From a raw file perspective
(https://github.com/axboe/fio/blob/master/fio.1#L565 ), in Groff
backslashes need escaping so as not to represent the start of escape
sequences and double backslash is a valid way to do this in many
cases: https://www.gnu.org/software/groff/manual/html_node/Escapes.html
.

I can't see the text you refer to in the README but the HOWTO is
restructured text (http://docutils.sourceforge.net/rst.html (actually
it's sphinx (http://www.sphinx-doc.org/en/master/ ) flavoured
restructured text)). While you can read it "raw" (e.g.
https://github.com/axboe/fio/blob/a15abb450459195ce72d515dc564f07f7726bf5f/=
HOWTO#L787
) you will see all sorts of markup in it and that includes every
backslash needing escaping. When I look over at
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-filename
I see the number of backslashes that you say work.

>
>
>
> This is predicated by this description:
>
> =E2=80=9CEach colon and backslash in the wanted path must be escaped with=
 a '\\'
>
> character.=E2=80=9D
>
>
>
> In the case of Windows (Server 2019), the extra =E2=80=98\\=E2=80=99 is n=
ot required.
> My (successful) job file appears as such:
>
> [readtest]
> blocksize=3D1M
> filename=3D\\.\PhysicalDrive1
> rw=3Dread
> direct=3D0
> #raw=3D1
> buffered=3D0
> #size=3D1G
> thread=3D1
>
>
>
> I would be grateful that the documentation be updated accordingly.

Can you point to where you see something wrong? Could it be that
whatever is rendering the documentation is flawed?
>
>
>
> Thank you!
>
> Adam

--=20
Sitsofe | http://sucs.org/~sits/


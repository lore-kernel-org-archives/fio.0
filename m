Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ed1-f52.google.com ([209.85.208.52]:47039 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733152AbfHHNp4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Aug 2019 09:45:56 -0400
Received: by mail-ed1-f52.google.com with SMTP id z51so3351640edz.13
        for <fio@vger.kernel.org>; Thu, 08 Aug 2019 06:45:55 -0700 (PDT)
MIME-Version: 1.0
References: <CABaL7QE7Lra-dV7JVgq3fnPLXp2BJXtw=cOWau6mBS94TQBEbg@mail.gmail.com>
 <CABaL7QEHarULAC-SVmdMxy8V8i3P3UNMxUx1rbCyqc7SfcsbSw@mail.gmail.com> <CALjAwxjSnJqduYZC=BRmkj_aHXxv4dpb5n=7bxBFpPLDJM+Srw@mail.gmail.com>
In-Reply-To: <CALjAwxjSnJqduYZC=BRmkj_aHXxv4dpb5n=7bxBFpPLDJM+Srw@mail.gmail.com>
From: Adam Congdon <cac8907@gmail.com>
Date: Thu, 8 Aug 2019 09:45:18 -0400
Message-ID: <CABaL7QFD+gVgg+bWidSSgip0_PVAQb9Z=kDvMg3V2z+xbsptuQ@mail.gmail.com>
Subject: Re: FIO Windows Documentation
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hello!

Thank you for the reply! As it turns out, it's simply to program(s) I
was using to view the text. I checked a couple of ways. First, I used
GitHub desktop to clone the repository. Then I searched it with
Notepad++ and also grep (Windows Linux subsystem).

Everything you said makes perfect sense. My apologies for wasting your
time! Thank you for the clarification and the great tool!

Cheers!
Adam

On Wed, Jul 31, 2019 at 4:47 PM Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> Hi,
>
> On Wed, 31 Jul 2019 at 16:22, Adam Congdon <cac8907@gmail.com> wrote:
> >
> > Hi!
> >
> >
> > FIO is a wonderful tool. Great work!!
>
> Jens, you've got a fan! :-)
>
> > In the documentation (readme + fio.1 files) is this description:
> >
> >
> >
> > =E2=80=9COn Windows, disk devices are accessed as `\\\\.\\PhysicalDrive=
0' for
> >
> > the first device, `\\\\.\\PhysicalDrive1' for the second etc.=E2=80=9D
>
> When I look at a rendered man page (i.e. man ./fio.1 on the command
> line) I see the number of backslashes that you say work:
>
>               On Windows, disk devices are  accessed  as  `\\.\PhysicalDr=
ive0'
>               for  the  first device, `\\.\PhysicalDrive1' for the second=
 etc.
>
> From a raw file perspective
> (https://github.com/axboe/fio/blob/master/fio.1#L565 ), in Groff
> backslashes need escaping so as not to represent the start of escape
> sequences and double backslash is a valid way to do this in many
> cases: https://www.gnu.org/software/groff/manual/html_node/Escapes.html
> .
>
> I can't see the text you refer to in the README but the HOWTO is
> restructured text (http://docutils.sourceforge.net/rst.html (actually
> it's sphinx (http://www.sphinx-doc.org/en/master/ ) flavoured
> restructured text)). While you can read it "raw" (e.g.
> https://github.com/axboe/fio/blob/a15abb450459195ce72d515dc564f07f7726bf5=
f/HOWTO#L787
> ) you will see all sorts of markup in it and that includes every
> backslash needing escaping. When I look over at
> https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-filename
> I see the number of backslashes that you say work.
>
> >
> >
> >
> > This is predicated by this description:
> >
> > =E2=80=9CEach colon and backslash in the wanted path must be escaped wi=
th a '\\'
> >
> > character.=E2=80=9D
> >
> >
> >
> > In the case of Windows (Server 2019), the extra =E2=80=98\\=E2=80=99 is=
 not required.
> > My (successful) job file appears as such:
> >
> > [readtest]
> > blocksize=3D1M
> > filename=3D\\.\PhysicalDrive1
> > rw=3Dread
> > direct=3D0
> > #raw=3D1
> > buffered=3D0
> > #size=3D1G
> > thread=3D1
> >
> >
> >
> > I would be grateful that the documentation be updated accordingly.
>
> Can you point to where you see something wrong? Could it be that
> whatever is rendering the documentation is flawed?
> >
> >
> >
> > Thank you!
> >
> > Adam
>
> --
> Sitsofe | http://sucs.org/~sits/


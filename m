Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ed1-f52.google.com ([209.85.208.52]:37191 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbfGaOiY (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 31 Jul 2019 10:38:24 -0400
Received: by mail-ed1-f52.google.com with SMTP id w13so65967076eds.4
        for <fio@vger.kernel.org>; Wed, 31 Jul 2019 07:38:23 -0700 (PDT)
MIME-Version: 1.0
References: <CABaL7QE7Lra-dV7JVgq3fnPLXp2BJXtw=cOWau6mBS94TQBEbg@mail.gmail.com>
In-Reply-To: <CABaL7QE7Lra-dV7JVgq3fnPLXp2BJXtw=cOWau6mBS94TQBEbg@mail.gmail.com>
From: Adam Congdon <cac8907@gmail.com>
Date: Wed, 31 Jul 2019 10:37:46 -0400
Message-ID: <CABaL7QEHarULAC-SVmdMxy8V8i3P3UNMxUx1rbCyqc7SfcsbSw@mail.gmail.com>
Subject: Fwd: FIO Windows Documentation
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi!


FIO is a wonderful tool. Great work!!


In the documentation (readme + fio.1 files) is this description:



=E2=80=9COn Windows, disk devices are accessed as `\\\\.\\PhysicalDrive0' f=
or

the first device, `\\\\.\\PhysicalDrive1' for the second etc.=E2=80=9D



This is predicated by this description:

=E2=80=9CEach colon and backslash in the wanted path must be escaped with a=
 '\\'

character.=E2=80=9D



In the case of Windows (Server 2019), the extra =E2=80=98\\=E2=80=99 is not=
 required.
My (successful) job file appears as such:

[readtest]
blocksize=3D1M
filename=3D\\.\PhysicalDrive1
rw=3Dread
direct=3D0
#raw=3D1
buffered=3D0
#size=3D1G
thread=3D1



I would be grateful that the documentation be updated accordingly.



Thank you!

Adam


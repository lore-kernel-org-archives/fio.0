Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:47099 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407367AbeHATQR (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Aug 2018 15:16:17 -0400
Received: by mail-vk0-f44.google.com with SMTP id b14-v6so9696830vke.13
        for <fio@vger.kernel.org>; Wed, 01 Aug 2018 10:29:34 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Wed, 1 Aug 2018 20:06:10 +0300
Message-ID: <CANvN+ekqnT6YZ2LHPMzbF5hX4kSy+Tog9=8_+hoG+pz+JOrxsw@mail.gmail.com>
Subject: Multi-threaded verification in the partitiioned device case
Content-Type: multipart/alternative; boundary="000000000000e27a8e057262b654"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

--000000000000e27a8e057262b654
Content-Type: text/plain; charset="UTF-8"

As far as I understand, verification in the multi-threaded (num_jobs > 1)
case is neither supported nor recommended.

I wonder if it also holds for the case of a multiple-threaded job being run
against a partitioned (using FIO's offset split machinery) device, with
thread per partition. Partitioning like this should very much avoid  any
inter-thread overlap, and seems to be safe to run in verify mode. I will
appreciate a comment on whether the simple reasoning above holds, or
something extra still needs to be done.

Regards,
Andrey
-- 

Regards,
Andrey

--000000000000e27a8e057262b654
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">As far as I understand,=C2=A0verification in the=C2=A0<spa=
n style=3D"font-size:small;text-decoration-style:initial;text-decoration-co=
lor:initial;float:none;display:inline">multi-threaded (num_jobs &gt; 1) cas=
e is neither supported nor recommended.</span><div><br><div><div>I wonder i=
f it also holds for the case of a multiple-threaded job being run against a=
 partitioned (using FIO&#39;s offset split machinery) device, with thread p=
er partition. Partitioning like this should very much avoid=C2=A0 any inter=
-thread overlap, and seems to be safe to run in verify mode. I will appreci=
ate a comment on whether the simple reasoning above holds, or something ext=
ra still needs to be done.</div><div><div><span style=3D"font-size:small;te=
xt-decoration-style:initial;text-decoration-color:initial;float:none;displa=
y:inline"></span><br clear=3D"all"><div><div dir=3D"ltr" class=3D"m_4495116=
673590232243gmail_signature" data-smartmail=3D"gmail_signature">Regards,<br=
>Andrey<br></div></div></div></div></div></div></div><span>
</span>-- <br><div dir=3D"ltr" class=3D"gmail_signature" data-smartmail=3D"=
gmail_signature"><p dir=3D"ltr">Regards,<br>
Andrey</p>
</div>

--000000000000e27a8e057262b654--

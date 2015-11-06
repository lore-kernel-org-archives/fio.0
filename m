Return-Path: <martin.steigerwald@teamix.de>
From: Martin Steigerwald <ms@teamix.de>
Subject: relationship of fio versus gfio
Date: Fri, 6 Nov 2015 09:54:42 +0100
Message-ID: <6266593.Pst2hzQaXB@merkaba>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

=EF=BB=BFHello Jens, hello fio community.

During package review of my new fio package my reviewer raised the question=
 of=20
the relationship between gfio and fio. I already also wondered about it=20
before.

Can gfio be used on a system, without fio installed? My guess would be yes:=
 As=20
fio could be running on another machine as a server.

Also currently I have it that gfio is linked against the same libraries as=
=20
fio. Is a complete fio engine included in gfio?

Thanks,

--=20
Martin Steigerwald  | Consultant / Trainer

teamix GmbH
S=C3=BCdwestpark 43
90449 N=C3=BCrnberg

Tel.:  +49 911 30999 55 | Fax: +49 911 30999 99
mail: martin.steigerwald@teamix.de | web:  http://www.teamix.de | blog: htt=
p://blog.teamix.de

Amtsgericht N=C3=BCrnberg, HRB 18320 | Gesch=C3=A4ftsf=C3=BChrer: Oliver K=
=C3=BCgow, Richard M=C3=BCller

teamix Support Hotline: +49 911 30999-112
=20
 *** Besuchen Sie uns vom 16.-19.11.2015 auf der NetApp Insight im CityCube=
 in Berlin auf Stand A5. ***



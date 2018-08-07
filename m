Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pg1-f175.google.com ([209.85.215.175]:45193 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389269AbeHGQ4q (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Aug 2018 12:56:46 -0400
Received: by mail-pg1-f175.google.com with SMTP id f1-v6so7937280pgq.12
        for <fio@vger.kernel.org>; Tue, 07 Aug 2018 07:42:08 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: get err 5
From: Michael Green <mishagreen@gmail.com>
In-Reply-To: <CAKTzs3TSLPkwMVsfza-8iYBK9Kx1iZcuK3yM5bFmHemNKbAWGg@mail.gmail.com>
Date: Tue, 7 Aug 2018 07:42:05 -0700
Content-Transfer-Encoding: quoted-printable
Message-Id: <528BAB45-2297-4048-BA11-6C626A762420@gmail.com>
References: <CAKTzs3R0S8q=tCkNZ99xqpJpjcAjDCphdSV_GvBbGKRA3GWOUw@mail.gmail.com>
 <CAB-428kzrUriC9SKetP+YJRdFefQRv0-=DVfeMyyFOiXim8svA@mail.gmail.com>
 <CALjAwxhYwwTZwb25uo6g8WZmQO3zTprjQr4ztvmdpKei-NEVRA@mail.gmail.com>
 <CAB-428=uXP5L5AMrEq0ERRdOwFsRsnVw_vzJve8=S2VndgpCDg@mail.gmail.com>
 <CAKTzs3TsUT4y7X9gEAExwg3yVLL5eLrYS0S9tZtgO7P75ZV9Bw@mail.gmail.com>
 <CALjAwxhCdWxR8iyEvgApT20ZQBY1ued6Vo-ZTnP537uzpCqhNQ@mail.gmail.com>
 <CAKTzs3TSLPkwMVsfza-8iYBK9Kx1iZcuK3yM5bFmHemNKbAWGg@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?utf-8?B?2KLYsdi0INiu2KfZiNix24wg2LHYp9iv?= <arash.khavary@gmail.com>
Cc: fio <fio@vger.kernel.org>

The abort command below can only come come from the SCSI layer and =
therefore is unlikely to be a FIO issue.
Are you able to perform simple dd read/write commands to the device? Are =
you able to partition or format it?

Michael

> On Aug 7, 2018, at 2:26 AM, =E2=81=A8=D8=A2=D8=B1=D8=B4 =D8=AE=D8=A7=D9=88=
=D8=B1=DB=8C =D8=B1=D8=A7=D8=AF=E2=81=A9 <=E2=81=A8arash.khavary@gmail.com=
=E2=81=A9> wrote:
>=20
> No every time error on 2 or 3 different disk, and its not follow the
> pattern or same disk maybe error on 2 disk maybe 3.
>=20
>=20
> in dmesg just log:
> [94930.551379] qla2xxx [0000:02:00.0]-801c:13: Abort command issued
> nexus=3D13:0:1 --  1 2002.
> =D8=AC91373.328470] ICMPv6 checksum failed [fe80::2046:fd22:d246:7474 =
> ff02::1]
>=20


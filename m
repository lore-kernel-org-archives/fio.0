Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f52.google.com ([209.85.222.52]:38336 "EHLO
        mail-ua1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729489AbeHNK6H (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Aug 2018 06:58:07 -0400
Received: by mail-ua1-f52.google.com with SMTP id o11-v6so12194710uak.5
        for <fio@vger.kernel.org>; Tue, 14 Aug 2018 01:12:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAKTzs3R0S8q=tCkNZ99xqpJpjcAjDCphdSV_GvBbGKRA3GWOUw@mail.gmail.com>
 <CAB-428kzrUriC9SKetP+YJRdFefQRv0-=DVfeMyyFOiXim8svA@mail.gmail.com>
 <CALjAwxhYwwTZwb25uo6g8WZmQO3zTprjQr4ztvmdpKei-NEVRA@mail.gmail.com>
 <CAB-428=uXP5L5AMrEq0ERRdOwFsRsnVw_vzJve8=S2VndgpCDg@mail.gmail.com>
 <CAKTzs3TsUT4y7X9gEAExwg3yVLL5eLrYS0S9tZtgO7P75ZV9Bw@mail.gmail.com>
 <CALjAwxhCdWxR8iyEvgApT20ZQBY1ued6Vo-ZTnP537uzpCqhNQ@mail.gmail.com> <CAKTzs3Rz8YnSR_v61jcweBwKgFFZ11CNniT7PTnvtWcFyHLCqw@mail.gmail.com>
In-Reply-To: <CAKTzs3Rz8YnSR_v61jcweBwKgFFZ11CNniT7PTnvtWcFyHLCqw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 14 Aug 2018 09:11:35 +0100
Message-ID: <CALjAwxjuXs70qnAhJyU4BT4juca7uXqnqp6+mqhruX9DBzcTCA@mail.gmail.com>
Subject: Re: get err 5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?2KLYsdi0INiu2KfZiNix24wg2LHYp9iv?= <arash.khavary@gmail.com>
Cc: Alireza Haghdoost <haghdoost@gmail.com>, fio <fio@vger.kernel.org>

You mentioned that you're getting messages like this:

> [94930.551379] qla2xxx [0000:02:00.0]-801c:13: Abort command issued nexus=
=3D13:0:1 --  1 2002.

As previously mentioned if your disk controller is aborting commands
you need to find out why
- it's not really a userspace generated issue. Until you know why
that's happening all that will happen is that the abort will bubble
all the
way back up to whatever sent the I/O as an error.

=E2=80=AAOn Tue, 14 Aug 2018 at 05:23, =E2=80=AB=D8=A2=D8=B1=D8=B4 =D8=AE=
=D8=A7=D9=88=D8=B1=DB=8C =D8=B1=D8=A7=D8=AF=E2=80=AC=E2=80=8E
<arash.khavary@gmail.com> wrote:=E2=80=AC
>
> I check in deep in terminal when FIO is running i got this error:
>
> fio: io_u error on file /dev/sdg: Input/output error: write
> offset=3D241038262272, buflen=3D4194304
> fio: io_u error on file /dev/sdg: Input/output error: write
> offset=3D241042456576, buflen=3D4194304
> fio: io_u error on file /dev/sdg: Input/output error: write
> offset=3D246167896064, buflen=3D4194304
> fio: io_u error on file /dev/sdg: Input/output error: write
> offset=3D246172090368, buflen=3D4194304
>
>
>
> 2018-08-07 5:28 GMT+00:00 Sitsofe Wheeler <sitsofe@gmail.com>:
> > On 7 August 2018 at 04:57, =D8=A2=D8=B1=D8=B4 =D8=AE=D8=A7=D9=88=D8=B1=
=DB=8C =D8=B1=D8=A7=D8=AF <arash.khavary@gmail.com> wrote:
> >>
> >> Unfortunately my problem not solved, I change Blocksize but got arror =
again
> >>
> >> fio: io_u error on file /dev/sdc: Input/output error: write
> >> offset=3D1677721600, buflen=3D4194304
> >
> > Is there anything suspicious in dmesg? If you cut the number of
> > sections down to one does it still happen? Is it alway against the
> > same disk?
> >
> > --
> > Sitsofe | http://sucs.org/~sits/
>
>
>
> --
> =D8=A8=D8=A7 =D8=B9=D8=B1=D8=B6 =D8=A7=D8=AD=D8=AA=D8=B1=D8=A7=D9=85 =D8=
=AE=D8=A7=D9=88=D8=B1=DB=8C =D8=B1=D8=A7=D8=AF - =D8=A2=D8=B1=D8=B4



--
Sitsofe | http://sucs.org/~sits/


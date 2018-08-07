Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lj1-f169.google.com ([209.85.208.169]:41183 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbeHGIa3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Aug 2018 04:30:29 -0400
Received: by mail-lj1-f169.google.com with SMTP id y17-v6so12464473ljy.8
        for <fio@vger.kernel.org>; Mon, 06 Aug 2018 23:17:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxhCdWxR8iyEvgApT20ZQBY1ued6Vo-ZTnP537uzpCqhNQ@mail.gmail.com>
References: <CAKTzs3R0S8q=tCkNZ99xqpJpjcAjDCphdSV_GvBbGKRA3GWOUw@mail.gmail.com>
 <CAB-428kzrUriC9SKetP+YJRdFefQRv0-=DVfeMyyFOiXim8svA@mail.gmail.com>
 <CALjAwxhYwwTZwb25uo6g8WZmQO3zTprjQr4ztvmdpKei-NEVRA@mail.gmail.com>
 <CAB-428=uXP5L5AMrEq0ERRdOwFsRsnVw_vzJve8=S2VndgpCDg@mail.gmail.com>
 <CAKTzs3TsUT4y7X9gEAExwg3yVLL5eLrYS0S9tZtgO7P75ZV9Bw@mail.gmail.com> <CALjAwxhCdWxR8iyEvgApT20ZQBY1ued6Vo-ZTnP537uzpCqhNQ@mail.gmail.com>
From: =?UTF-8?B?2KLYsdi0INiu2KfZiNix24wg2LHYp9iv?= 
        <arash.khavary@gmail.com>
Date: Tue, 7 Aug 2018 06:17:43 +0000
Message-ID: <CAKTzs3SUsXsotzrRqJArHtBRrqTAmoOVPA6tVwDJqAA6V43J4g@mail.gmail.com>
Subject: Re: get err 5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Alireza Haghdoost <haghdoost@gmail.com>, fio <fio@vger.kernel.org>

No every time error on 2 or 3 different disk, and its not follow the
pattern or same disk maybe error on 2 disk maybe 3.


in dmesg just log:
[94930.551379] qla2xxx [0000:02:00.0]-801c:13: Abort command issued
nexus=3D13:0:1 --  1 2002.
=D8=AC91373.328470] ICMPv6 checksum failed [fe80::2046:fd22:d246:7474 > ff0=
2::1]


to answer you question about If you cut the number of sections down to
one does it still happen? i not understand whats your meaning please
told whats i changed ?


2018-08-07 5:28 GMT+00:00 Sitsofe Wheeler <sitsofe@gmail.com>:
>
> On 7 August 2018 at 04:57, =D8=A2=D8=B1=D8=B4 =D8=AE=D8=A7=D9=88=D8=B1=DB=
=8C =D8=B1=D8=A7=D8=AF <arash.khavary@gmail.com> wrote:
> >
> > Unfortunately my problem not solved, I change Blocksize but got arror a=
gain
> >
> > fio: io_u error on file /dev/sdc: Input/output error: write
> > offset=3D1677721600, buflen=3D4194304
>
> Is there anything suspicious in dmesg? If you cut the number of
> sections down to one does it still happen? Is it alway against the
> same disk?
>
> --
> Sitsofe | http://sucs.org/~sits/




--=20
=D8=A8=D8=A7 =D8=B9=D8=B1=D8=B6 =D8=A7=D8=AD=D8=AA=D8=B1=D8=A7=D9=85 =D8=AE=
=D8=A7=D9=88=D8=B1=DB=8C =D8=B1=D8=A7=D8=AF - =D8=A2=D8=B1=D8=B4

Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:34400 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbeHGLno (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Aug 2018 07:43:44 -0400
Received: by mail-ua0-f178.google.com with SMTP id r15-v6so6858547uao.1
        for <fio@vger.kernel.org>; Tue, 07 Aug 2018 02:30:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKTzs3QfN1FTrBuedprcw-TfAoHrgo8552VKWSOY=3K1p2WgHw@mail.gmail.com>
References: <CAKTzs3R0S8q=tCkNZ99xqpJpjcAjDCphdSV_GvBbGKRA3GWOUw@mail.gmail.com>
 <CAB-428kzrUriC9SKetP+YJRdFefQRv0-=DVfeMyyFOiXim8svA@mail.gmail.com>
 <CALjAwxhYwwTZwb25uo6g8WZmQO3zTprjQr4ztvmdpKei-NEVRA@mail.gmail.com>
 <CAB-428=uXP5L5AMrEq0ERRdOwFsRsnVw_vzJve8=S2VndgpCDg@mail.gmail.com>
 <CAKTzs3TsUT4y7X9gEAExwg3yVLL5eLrYS0S9tZtgO7P75ZV9Bw@mail.gmail.com>
 <CALjAwxhCdWxR8iyEvgApT20ZQBY1ued6Vo-ZTnP537uzpCqhNQ@mail.gmail.com> <CAKTzs3QfN1FTrBuedprcw-TfAoHrgo8552VKWSOY=3K1p2WgHw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 7 Aug 2018 10:29:46 +0100
Message-ID: <CALjAwxh18XNHYKRPvPoPaFBU+=CNChGUPYkSEX3-Ot93fuHzVg@mail.gmail.com>
Subject: Re: get err 5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?2KLYsdi0INiu2KfZiNix24wg2LHYp9iv?= <arash.khavary@gmail.com>
Cc: Alireza Haghdoost <haghdoost@gmail.com>, fio <fio@vger.kernel.org>

(I've just replied to your first message - I think you sent this
multiple times...)

On 7 August 2018 at 06:36, =D8=A2=D8=B1=D8=B4 =D8=AE=D8=A7=D9=88=D8=B1=DB=
=8C =D8=B1=D8=A7=D8=AF <arash.khavary@gmail.com> wrote:
> No, every time error on 2 or 3 different disk, and its not follow the
> pattern or same disk maybe error on 2 disk maybe 3.
>
>
> in dmesg just log:
> `[94930.551379] qla2xxx [0000:02:00.0]-801c:13: Abort command issued
> nexus=3D13:0:1 --  1 2002.`

If there's always the above it looks like your disk controller is
aborting commands. If this turns out to be the cause then you'll need
to investigate why your controller is getting unhappy (which is beyond
what I can help you with) - maybe something can't handle the load?

> to answer you question about " If you cut the number of sections down to =
one
> does it still happen?" i not understand whats your meaning please told wh=
ats
> i changed ?

Make your job file as small as possible (e.g. remove job6 and see if
the problem still happens, then remove job5 and see if it still
happens etc).

--=20
Sitsofe | http://sucs.org/~sits/

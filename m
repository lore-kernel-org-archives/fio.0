Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:46755 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbeHGHlW (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Aug 2018 03:41:22 -0400
Received: by mail-ua0-f174.google.com with SMTP id u11-v6so14746560uan.13
        for <fio@vger.kernel.org>; Mon, 06 Aug 2018 22:28:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKTzs3TsUT4y7X9gEAExwg3yVLL5eLrYS0S9tZtgO7P75ZV9Bw@mail.gmail.com>
References: <CAKTzs3R0S8q=tCkNZ99xqpJpjcAjDCphdSV_GvBbGKRA3GWOUw@mail.gmail.com>
 <CAB-428kzrUriC9SKetP+YJRdFefQRv0-=DVfeMyyFOiXim8svA@mail.gmail.com>
 <CALjAwxhYwwTZwb25uo6g8WZmQO3zTprjQr4ztvmdpKei-NEVRA@mail.gmail.com>
 <CAB-428=uXP5L5AMrEq0ERRdOwFsRsnVw_vzJve8=S2VndgpCDg@mail.gmail.com> <CAKTzs3TsUT4y7X9gEAExwg3yVLL5eLrYS0S9tZtgO7P75ZV9Bw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 7 Aug 2018 06:28:15 +0100
Message-ID: <CALjAwxhCdWxR8iyEvgApT20ZQBY1ued6Vo-ZTnP537uzpCqhNQ@mail.gmail.com>
Subject: Re: get err 5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?2KLYsdi0INiu2KfZiNix24wg2LHYp9iv?= <arash.khavary@gmail.com>
Cc: Alireza Haghdoost <haghdoost@gmail.com>, fio <fio@vger.kernel.org>

On 7 August 2018 at 04:57, =D8=A2=D8=B1=D8=B4 =D8=AE=D8=A7=D9=88=D8=B1=DB=
=8C =D8=B1=D8=A7=D8=AF <arash.khavary@gmail.com> wrote:
>
> Unfortunately my problem not solved, I change Blocksize but got arror aga=
in
>
> fio: io_u error on file /dev/sdc: Input/output error: write
> offset=3D1677721600, buflen=3D4194304

Is there anything suspicious in dmesg? If you cut the number of
sections down to one does it still happen? Is it alway against the
same disk?

--=20
Sitsofe | http://sucs.org/~sits/

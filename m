Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f48.google.com ([209.85.222.48]:44696 "EHLO
        mail-ua1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729560AbeHNRY0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Aug 2018 13:24:26 -0400
Received: by mail-ua1-f48.google.com with SMTP id k25-v6so13363111uao.11
        for <fio@vger.kernel.org>; Tue, 14 Aug 2018 07:37:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAKTzs3R0S8q=tCkNZ99xqpJpjcAjDCphdSV_GvBbGKRA3GWOUw@mail.gmail.com>
 <CAB-428kzrUriC9SKetP+YJRdFefQRv0-=DVfeMyyFOiXim8svA@mail.gmail.com>
 <CALjAwxhYwwTZwb25uo6g8WZmQO3zTprjQr4ztvmdpKei-NEVRA@mail.gmail.com>
 <CAB-428=uXP5L5AMrEq0ERRdOwFsRsnVw_vzJve8=S2VndgpCDg@mail.gmail.com>
 <CAKTzs3TsUT4y7X9gEAExwg3yVLL5eLrYS0S9tZtgO7P75ZV9Bw@mail.gmail.com>
 <CALjAwxhCdWxR8iyEvgApT20ZQBY1ued6Vo-ZTnP537uzpCqhNQ@mail.gmail.com> <CAKTzs3Rz8YnSR_v61jcweBwKgFFZ11CNniT7PTnvtWcFyHLCqw@mail.gmail.com>
In-Reply-To: <CAKTzs3Rz8YnSR_v61jcweBwKgFFZ11CNniT7PTnvtWcFyHLCqw@mail.gmail.com>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Tue, 14 Aug 2018 09:36:23 -0500
Message-ID: <CAB-428=gbv=12NZoAi6xoW1WcHtBwO5HjKj9m-1fBaOcWdojGA@mail.gmail.com>
Subject: Re: get err 5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?2KLYsdi0INiu2KfZiNix24wg2LHYp9iv?= <arash.khavary@gmail.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio <fio@vger.kernel.org>

=E2=80=AAOn Mon, Aug 13, 2018 at 11:23 PM =E2=80=AB=D8=A2=D8=B1=D8=B4 =D8=
=AE=D8=A7=D9=88=D8=B1=DB=8C =D8=B1=D8=A7=D8=AF=E2=80=AC=E2=80=8E
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

Remove all numjobs=3D* from your job file and see what happen.


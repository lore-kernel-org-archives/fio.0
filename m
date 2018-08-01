Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:38564 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729769AbeHAISc (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Aug 2018 04:18:32 -0400
Received: by mail-ua0-f196.google.com with SMTP id o11-v6so11976808uak.5
        for <fio@vger.kernel.org>; Tue, 31 Jul 2018 23:34:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKTzs3R0S8q=tCkNZ99xqpJpjcAjDCphdSV_GvBbGKRA3GWOUw@mail.gmail.com>
References: <CAKTzs3R0S8q=tCkNZ99xqpJpjcAjDCphdSV_GvBbGKRA3GWOUw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 1 Aug 2018 07:33:55 +0100
Message-ID: <CALjAwxh05QQRb1zLe_zkdbymHnjHOh-qaTPrXTwbMNJK4wXSKg@mail.gmail.com>
Subject: Re: get err 5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?2KLYsdi0INiu2KfZiNix24wg2LHYp9iv?= <arash.khavary@gmail.com>
Cc: fio <fio@vger.kernel.org>

On 1 August 2018 at 06:31, =D8=A2=D8=B1=D8=B4 =D8=AE=D8=A7=D9=88=D8=B1=DB=
=8C =D8=B1=D8=A7=D8=AF <arash.khavary@gmail.com> wrote:
> Hi i got this error when test FIO sequential write every time, in sequent=
ial
> read, random read, random write not got this.
>
> my Linux distro is CentOS Linux release 7.5.1804 (Core)
> and my kernel version is 3.10.0-327.10.1.el7.x86_64
>
> My output is:
>
> job1: (g=3D0): rw=3Dwrite, bs=3D(R) 4096KiB-4096KiB, (W) 4096KiB-4096KiB,=
 (T)
> 4096KiB-4096KiB, ioengine=3Dlibaio, iodepth=3D16

[snip]

>
> My parameter is :
>
>
> [global]
> readwrite=3Dwrite
> blocksize=3D4m
> direct=3D1

[snip]

>
> [job1]
> numjobs=3D3
> filename=3D/dev/sdb
>
>
> [job2]
> numjobs=3D2
> filename=3D/dev/sdc
>
>
> [job3]
> numjobs=3D3
> filename=3D/dev/sdd
>
>
> [job4]
> numjobs=3D3
> filename=3D/dev/sde
>
>
> [job5]
> numjobs=3D2
> filename=3D/dev/sdf
>
>
> [job6]
> numjobs=3D3
> filename=3D/dev/sdg

[snip]

> Why get err 5?
> thanks

So you have 6 separate  jobs and the jobs specify numjobs. If we add
all the numjobs together we get 16. You specify a giant blocksize (4
megabytes) which is strangely big unless you are doing unless you're
doing extreme NVMe testing. You also specify an iodepth of 16. So 16 *
16 * 4 =3D 1024 megabytes of I/O buffers - are you sure you're not
causing yourself to hit memory issues?

--=20
Sitsofe | http://sucs.org/~sits/

Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:35072 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163121AbcKAGHN (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 1 Nov 2016 02:07:13 -0400
Received: by mail-ua0-f169.google.com with SMTP id 12so121647849uas.2
        for <fio@vger.kernel.org>; Mon, 31 Oct 2016 23:07:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKZcxgdhYey+dbUN7T5mW=Ghfw34=OtNrocJxqDH8k4fQ1tTJw@mail.gmail.com>
References: <CAKZcxgdhYey+dbUN7T5mW=Ghfw34=OtNrocJxqDH8k4fQ1tTJw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 1 Nov 2016 06:07:12 +0000
Message-ID: <CALjAwxjVK5v+JNo2Ww9m3cfwCyjiEMVzjdrYUpMsht2Q2j1AOA@mail.gmail.com>
Subject: Re: fio assert
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jaze Lee <jazeltq@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 1 November 2016 at 03:12, Jaze Lee <jazeltq@gmail.com> wrote:
> Hello,
>    I found that when rate_iops used with write_lat_log=EF=BC=8C it will b=
e
> high probability
> that the fio will assert. The below is the core dump.
>
> (gdb) bt
> #0  0x00007f3c3ccd25f7 in raise () from /lib64/libc.so.6
> #1  0x00007f3c3ccd3ce8 in abort () from /lib64/libc.so.6
> #2  0x00007f3c3cccb566 in __assert_fail_base () from /lib64/libc.so.6
> #3  0x00007f3c3cccb612 in __assert_fail () from /lib64/libc.so.6
> #4  0x000000000042249c in get_cur_log (iolog=3D0x7f3c390bb8b0) at stat.c:=
2004
> #5  __add_log_sample (iolog=3Diolog@entry=3D0x7f3c390bb8b0,
> val=3Dval@entry=3D1, ddir=3Dddir@entry=3DDDIR_WRITE, bs=3Dbs@entry=3D4096=
, t=3D1024,
> offset=3Doffset@entry=3D972521472)
>     at stat.c:2019

Could you include the job file / command line that reproduces the
issue and the version of fio you were using?

--=20
Sitsofe | http://sucs.org/~sits/

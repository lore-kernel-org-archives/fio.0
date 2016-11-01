Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:32924 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965414AbcKADMs (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Oct 2016 23:12:48 -0400
Received: by mail-oi0-f54.google.com with SMTP id 128so72195315oih.0
        for <fio@vger.kernel.org>; Mon, 31 Oct 2016 20:12:48 -0700 (PDT)
MIME-Version: 1.0
From: Jaze Lee <jazeltq@gmail.com>
Date: Tue, 1 Nov 2016 11:12:47 +0800
Message-ID: <CAKZcxgdhYey+dbUN7T5mW=Ghfw34=OtNrocJxqDH8k4fQ1tTJw@mail.gmail.com>
Subject: fio assert
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,
   I found that when rate_iops used with write_lat_log=EF=BC=8C it will be
high probability
that the fio will assert. The below is the core dump.

(gdb) bt
#0  0x00007f3c3ccd25f7 in raise () from /lib64/libc.so.6
#1  0x00007f3c3ccd3ce8 in abort () from /lib64/libc.so.6
#2  0x00007f3c3cccb566 in __assert_fail_base () from /lib64/libc.so.6
#3  0x00007f3c3cccb612 in __assert_fail () from /lib64/libc.so.6
#4  0x000000000042249c in get_cur_log (iolog=3D0x7f3c390bb8b0) at stat.c:20=
04
#5  __add_log_sample (iolog=3Diolog@entry=3D0x7f3c390bb8b0,
val=3Dval@entry=3D1, ddir=3Dddir@entry=3DDDIR_WRITE, bs=3Dbs@entry=3D4096, =
t=3D1024,
offset=3Doffset@entry=3D972521472)
    at stat.c:2019
#6  0x0000000000422767 in __add_log_sample (offset=3D972521472,
t=3D<optimized out>, bs=3D4096, ddir=3DDDIR_WRITE, val=3D1,
iolog=3D0x7f3c390bb8b0) at stat.c:2099
#7  add_log_sample (td=3Dtd@entry=3D0x7f3c1de55000, iolog=3D0x7f3c390bb8b0,
val=3D1, ddir=3D<optimized out>, bs=3D4096, offset=3D972521472) at stat.c:2=
131
#8  0x000000000042ef14 in add_log_sample (offset=3D<optimized out>,
bs=3D<optimized out>, ddir=3D<optimized out>, val=3D<optimized out>,
iolog=3D<optimized out>,
    td=3D0x7f3c1de55000) at stat.c:2269
#9  add_slat_sample (td=3D0x7f3c1de55000, ddir=3D<optimized out>,
usec=3D<optimized out>, bs=3D<optimized out>, offset=3D<optimized out>) at
stat.c:2270
#10 0x000000000043e976 in io_u_queued (td=3D<optimized out>,
io_u=3D<optimized out>) at io_u.c:2002
#11 0x000000000045a6ba in io_queue_event (td=3Dtd@entry=3D0x7f3c1de55000,
io_u=3Dio_u@entry=3D0x7f3c04046200, ret=3Dret@entry=3D0x7f3c0e950c30,
    ddir=3Dddir@entry=3DDDIR_WRITE,
bytes_issued=3Dbytes_issued@entry=3D0x7f3c0e950c60,
from_verify=3Dfrom_verify@entry=3D0,
comp_time=3Dcomp_time@entry=3D0x7f3c0e950ce0)
    at backend.c:545
#12 0x000000000045d4af in do_io (bytes_done=3D<synthetic pointer>,
td=3D0x7f3c1de55000) at backend.c:1010
#13 thread_main (data=3D<optimized out>) at backend.c:1714
#14 0x00007f3c3d269dc5 in start_thread () from /lib64/libpthread.so.0
#15 0x00007f3c3cd9321d in clone () from /lib64/libc.so.6



it points to https://github.com/axboe/fio/blob/master/stat.c#L2004
This line will judge whether nr_samples is bigger than max_samples.
I do not have time to dig into deeper.  Can someone explain more about
the bug, and is there a fix to this?

Thanks a lot.




--=20
=E8=B0=A6=E8=B0=A6=E5=90=9B=E5=AD=90

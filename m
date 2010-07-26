Return-Path: <bart.vanassche@gmail.com>
MIME-Version: 1.0
From: Bart Van Assche <bvanassche@acm.org>
Sender: "bart.vanassche@gmail.com" <bart.vanassche@gmail.com>
Date: Mon, 26 Jul 2010 08:17:14 -0600
Subject: fio crash after running an I/O stress test for about half an hour
Message-ID: <AANLkTimztvyqQPY3dF14awaKKQSm=RMe0Hc6J55O_CAd@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <JAxboe@fusionio.com>
List-ID: <fio@vger.kernel.org>

Hello,

When I run the fio command below, fio triggers a segmentation fault
after about half an hour. Is this a known issue ?

fio version 1.41.6 (git repository last commit date 2010-07-09).

fio --verify=3Dmd5 -rw=3Drandwrite --size=3D10M --bs=3D4k --loops=3D1000000
--iodepth=3D64 --group_reporting --sync=3D1 --direct=3D1 --norandommap
--ioengine=3Dpsync --directory=3D/mnt --name=3Dtest --thread --numjobs=3D80

(gdb) bt
#0=A0 0x0000000000412373 in log_io_piece (td=3D0x7f7d83e95ec0,
io_u=3D0x6f5140) at log.c:184
#1=A0 0x000000000041b58b in io_completed (td=3D0x7f7d83e95ec0,
io_u=3D0x6f5140, icd=3D0x7f7d77e0df90) at io_u.c:1111
#2=A0 0x000000000041b93d in io_u_sync_complete (td=3D0x7f7d83e95ec0,
io_u=3D0x6f5140, bytes=3D0x7f7d77e0e070) at io_u.c:1174
#3=A0 0x0000000000409ccb in do_io (td=3D<value optimized out>) at fio.c:651
#4=A0 thread_main (td=3D<value optimized out>) at fio.c:1132
#5=A0 0x00007f7d8569f65d in start_thread (arg=3D<value optimized out>) at
pthread_create.c:297
#6=A0 0x00007f7d84baae1d in clone () from /lib64/libc.so.6
#7=A0 0x0000000000000000 in ?? ()
(gdb) list
179=A0=A0=A0=A0 {
180=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct rb_node **p, *parent;
181=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct io_piece *ipo, *__ipo;
182
183=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ipo =3D malloc(sizeof(struct io_pie=
ce));
184=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ipo->file =3D io_u->file;
185=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ipo->offset =3D io_u->offset;
186=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ipo->len =3D io_u->buflen;
187
188=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /*

Valgrind reports the following for a run with --loops=3D10 and --numjobs=3D=
1:

=3D=3D14843=3D=3D 606,080 (407,040 direct, 199,040 indirect) bytes in 6,360
blocks are definitely lost in loss record 9 of 9
=3D=3D14843=3D=3D=A0=A0=A0 at 0x4C24528: malloc (vg_replace_malloc.c:236)
=3D=3D14843=3D=3D=A0=A0=A0 by 0x41236A: log_io_piece (log.c:183)
=3D=3D14843=3D=3D=A0=A0=A0 by 0x41B58A: io_completed (io_u.c:1111)
=3D=3D14843=3D=3D=A0=A0=A0 by 0x41B93C: io_u_sync_complete (io_u.c:1174)
=3D=3D14843=3D=3D=A0=A0=A0 by 0x409CCA: thread_main (fio.c:651)
=3D=3D14843=3D=3D=A0=A0=A0 by 0x4E3065C: start_thread (pthread_create.c:297=
)
=3D=3D14843=3D=3D=A0=A0=A0 by 0x597AE1C: clone (in /lib64/libc-2.10.1.so)

Bart.


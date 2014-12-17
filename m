Return-Path: <Elliott@hp.com>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: fio main thread got stuck over the weekend
Date: Wed, 17 Dec 2014 03:52:49 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402959410CC6@G4W3202.americas.hpqcorp.net>
References: <20140811154423.GE7486@beardog.cce.hp.com>
 <20140811160418.GG7486@beardog.cce.hp.com> <53F79442.6010500@kernel.dk>
 <20140822190924.GQ19666@beardog.cce.hp.com> <53F795E0.3090806@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B40295940B8A0@G4W3202.americas.hpqcorp.net>
 <548BC55F.9020706@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B40295940EEC5@G4W3202.americas.hpqcorp.net>
 <548F1C65.2070501@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B40295940F1BF@G4W3202.americas.hpqcorp.net>
 <548F40A8.3010405@kernel.dk> <548F452D.7040401@kernel.dk>
 <548F495F.7090200@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B40295940F830@G4W3202.americas.hpqcorp.net>
 <5490B574.3000502@kernel.dk>
In-Reply-To: <5490B574.3000502@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Tuesday, 16 December, 2014 4:43 PM
...
>=20
> I think I figured out what was going in, another user reported a similar
> issue. Since you have it running, can you try and gdb attach to one of
> the fio jobs? Then add a breakpoint in backend.c:__update_tv_cache(),
> and print td->tv_cache after each call. Just do that a handful of times,
> enough so we can see if it's incrementing or if it's stuck at the same
> value.
>=20

That is a static inline function, and its caller do_verify
also got inlined.  I tried a breakpoint by line number in
thread_main; although IOs resumed, it doesn't trigger.


(gdb) b backend.c:1536
Breakpoint 2 at 0x44c67b: file backend.c, line 1536.
(gdb) cont


objdump -drS around that address is:


        check_update_rusage(td);

        if (td->error)
  44c66e:       83 bb 90 4e 00 00 00    cmpl   $0x0,0x4e90(%rbx)
  44c675:       0f 84 0d 01 00 00       je     44c788 <thread_main+0x1538>

                fio_gettime(&td->start, NULL);

                do_verify(td, verify_bytes);

                fio_mutex_down(stat_mutex);
  44c67b:       48 8b 3d 16 a4 2d 00    mov    0x2da416(%rip),%rdi        #=
 726a98 <stat_mutex>
  44c682:       e8 a9 40 fe ff          callq  430730 <fio_mutex_down>
                td->ts.runtime[DDIR_READ] +=3D mtime_since_now(&td->start);
  44c687:       4c 8b bb 44 4c 00 00    mov    0x4c44(%rbx),%r15
  44c68e:       48 89 ef                mov    %rbp,%rdi
  44c691:       e8 9a e0 fb ff          callq  40a730 <mtime_since_now>
                fio_gettime(&td->start, NULL);
  44c696:       31 f6                   xor    %esi,%esi
  44c698:       48 89 ef                mov    %rbp,%rdi
                fio_gettime(&td->start, NULL);

                do_verify(td, verify_bytes);

                fio_mutex_down(stat_mutex);
                td->ts.runtime[DDIR_READ] +=3D mtime_since_now(&td->start);
  44c69b:       4c 01 f8                add    %r15,%rax
  44c69e:       48 89 83 44 4c 00 00    mov    %rax,0x4c44(%rbx)
                fio_gettime(&td->start, NULL);
  44c6a5:       e8 56 de fb ff          callq  40a500 <fio_gettime>
                fio_mutex_up(stat_mutex);
  44c6aa:       48 8b 3d e7 a3 2d 00    mov    0x2da3e7(%rip),%rdi        #=
 726a98 <stat_mutex>
  44c6b1:       e8 0a 40 fe ff          callq  4306c0 <fio_mutex_up>


I printed that value for thread 2, let it run for
a few seconds, then printed again, in case that helps
(tv_usec increments, but tv_sec does not).


(gdb) thread 2
[Switching to thread 2 (Thread 0x7fa92bf87700 (LWP 6733))]#0  0x00000036576=
00667 in io_submit () from /lib64/libaio.so.1
(gdb) bt
#0  0x0000003657600667 in io_submit () from /lib64/libaio.so.1
#1  0x0000000000457058 in fio_libaio_commit (td=3D0x7fa9a0dd1860) at engine=
s/libaio.c:255
#2  0x000000000040b395 in td_io_commit (td=3D0x7fa9a0dd1860) at ioengines.c=
:396
#3  0x000000000040bea1 in td_io_queue (td=3D0x7fa9a0dd1860, io_u=3D0x7fa8e4=
01c980) at ioengines.c:343
#4  0x000000000044a75d in do_io (td=3D0x7fa9a0dd1860) at backend.c:792
#5  0x000000000044c209 in thread_main (data=3D0x7fa9a0dd1860) at backend.c:=
1504
#6  0x0000003974c079d1 in start_thread () from /lib64/libpthread.so.0
#7  0x00000039748e8b7d in clone () from /lib64/libc.so.6
(gdb) print td
No symbol "td" in current context.
(gdb) select-frame 5
(gdb) print td->tv_cache
$51 =3D {tv_sec =3D 1099511, tv_usec =3D 641885}
(gdb) cont
Continuing.
^C
Program received signal SIGINT, Interrupt.
[Switching to Thread 0x7fa9a99b1720 (LWP 6508)]
0x00000039748acced in nanosleep () from /lib64/libc.so.6
(gdb) thread 2
[Switching to thread 2 (Thread 0x7fa92bf87700 (LWP 6733))]#0  0x00000036576=
00667 in io_submit () from /lib64/libaio.so.1
(gdb) bt
#0  0x0000003657600667 in io_submit () from /lib64/libaio.so.1
#1  0x0000000000457058 in fio_libaio_commit (td=3D0x7fa9a0dd1860) at engine=
s/libaio.c:255
#2  0x000000000040b47a in td_io_getevents (td=3D0x7fa9a0dd1860, min=3D<valu=
e optimized out>, max=3D<value optimized out>, t=3D<value optimized out>) a=
t ioengines.c:238
#3  0x000000000042b442 in io_u_queued_complete (td=3D0x7fa9a0dd1860, min_ev=
ts=3D<value optimized out>, bytes=3D0x7fa92bf86d00) at io_u.c:1793
#4  0x000000000044a45e in do_io (td=3D0x7fa9a0dd1860) at backend.c:889
#5  0x000000000044c209 in thread_main (data=3D0x7fa9a0dd1860) at backend.c:=
1504
#6  0x0000003974c079d1 in start_thread () from /lib64/libpthread.so.0
#7  0x00000039748e8b7d in clone () from /lib64/libc.so.6
(gdb) select-frame 5
(gdb) print td->tv_cache
$52 =3D {tv_sec =3D 1099511, tv_usec =3D 971364}


and again after about a minute:
(gdb) cont
Continuing.
^C
Program received signal SIGINT, Interrupt.
[Switching to Thread 0x7fa9a99b1720 (LWP 6508)]
0x00000039748acced in nanosleep () from /lib64/libc.so.6
(gdb) thread 2
[Switching to thread 2 (Thread 0x7fa92bf87700 (LWP 6733))]#0  0x00000036576=
00667 in io_submit () from /lib64/libaio.so.1
(gdb) bt
#0  0x0000003657600667 in io_submit () from /lib64/libaio.so.1
#1  0x0000000000457058 in fio_libaio_commit (td=3D0x7fa9a0dd1860) at engine=
s/libaio.c:255
#2  0x000000000040b395 in td_io_commit (td=3D0x7fa9a0dd1860) at ioengines.c=
:396
#3  0x000000000040bea1 in td_io_queue (td=3D0x7fa9a0dd1860, io_u=3D0x7fa8e4=
01fe80) at ioengines.c:343
#4  0x000000000044a75d in do_io (td=3D0x7fa9a0dd1860) at backend.c:792
#5  0x000000000044c209 in thread_main (data=3D0x7fa9a0dd1860) at backend.c:=
1504
#6  0x0000003974c079d1 in start_thread () from /lib64/libpthread.so.0
#7  0x00000039748e8b7d in clone () from /lib64/libc.so.6
(gdb) select-frame 5
(gdb) print td->tv_cache
$53 =3D {tv_sec =3D 1099511, tv_usec =3D 578033}




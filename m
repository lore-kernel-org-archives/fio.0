Return-Path: <Elliott@hp.com>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: fio main thread got stuck over the weekend
Date: Mon, 15 Dec 2014 19:39:15 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295940F1BF@G4W3202.americas.hpqcorp.net>
References: <20140811154423.GE7486@beardog.cce.hp.com>
 <20140811160418.GG7486@beardog.cce.hp.com> <53F79442.6010500@kernel.dk>
 <20140822190924.GQ19666@beardog.cce.hp.com> <53F795E0.3090806@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B40295940B8A0@G4W3202.americas.hpqcorp.net>
 <548BC55F.9020706@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B40295940EEC5@G4W3202.americas.hpqcorp.net>
 <548F1C65.2070501@kernel.dk>
In-Reply-To: <548F1C65.2070501@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



> it's just 18.9 minutes. Total runtime is summed after the fact. The one
> I think is interesting is the first thread, that is the one that should
> be printing eta stats. And it seems to be stuck:
>=20
>  >    212 Thread 0x7fa9a086e700 (LWP 6509)  0x0000003974c0b98e in
> pthread_cond_timedwait@@GLIBC_2.3.2 () from /lib64/libpthread.so.0
>=20
> can you do a bt on that? This looks like it _might_ be an issue that was
> fixed recently with stats. Are you running fio with any output or status
> options?
>=20

No output options.

(gdb) thread 212
[Switching to thread 212 (Thread 0x7fa9a086e700 (LWP 6509))]#0  0x000000397=
4c0b98e in pthread_cond_timedwait@@GLIBC_2.3.2 () from /lib64/libpthread.so=
.0
(gdb) bt
#0  0x0000003974c0b98e in pthread_cond_timedwait@@GLIBC_2.3.2 () from /lib6=
4/libpthread.so.0
#1  0x0000000000449381 in helper_thread_main (data=3D<value optimized out>)=
 at backend.c:2127
#2  0x0000003974c079d1 in start_thread () from /lib64/libpthread.so.0
#3  0x00000039748e8b7d in clone () from /lib64/libc.so.6
(gdb) select-frame 1
(gdb) info local
ts =3D {tv_sec =3D 1418658662, tv_nsec =3D 980074000}
tv =3D {tv_sec =3D 1418658662, tv_usec =3D 730074}
ret =3D <value optimized out>
(gdb) print helper_exit
$36 =3D 0
(gdb) print nr_thread
$37 =3D 224
(gdb) print nr_process
$38 =3D 0

(gdb) thread 1
[Switching to thread 1 (Thread 0x7fa9a99b1720 (LWP 6508))]#0  0x00000039748=
acced in nanosleep () from /lib64/libc.so.6
(gdb) bt
#0  0x00000039748acced in nanosleep () from /lib64/libc.so.6
#1  0x00000039748e1e64 in usleep () from /lib64/libc.so.6
#2  0x000000000044d019 in do_usleep () at backend.c:1841
#3  run_threads () at backend.c:2083
#4  0x000000000044d8ab in fio_backend () at backend.c:2199
#5  0x000000397481ed1d in __libc_start_main () from /lib64/libc.so.6
#6  0x000000000040a199 in _start ()
 (gdb) select-frame 3
 (gdb) info local
td =3D <value optimized out>
i =3D <value optimized out>
todo =3D <value optimized out>
nr_running =3D 210
m_rate =3D 0
t_rate =3D 0
nr_started =3D <value optimized out>
spent =3D <value optimized out>
(gdb) print thread_number
$39 =3D 224

so run_threads() is probably in this loop waiting for 210 threads to quit:
        while (nr_running) {
                reap_threads(&nr_running, &t_rate, &m_rate);
                do_usleep(10000);
        }

Given:

(gdb) thread 2
[Switching to thread 2 (Thread 0x7fa92bf87700 (LWP 6733))]#0  0x00000036576=
00667 in io_submit () from /lib64/libaio.so.1
(gdb) print td->error
No symbol "td" in current context.
(gdb) bt
#0  0x0000003657600667 in io_submit () from /lib64/libaio.so.1
#1  0x0000000000457058 in fio_libaio_commit (td=3D0x7fa9a0dd1860) at engine=
s/libaio.c:255
#2  0x000000000040b395 in td_io_commit (td=3D0x7fa9a0dd1860) at ioengines.c=
:396
#3  0x000000000040bea1 in td_io_queue (td=3D0x7fa9a0dd1860, io_u=3D0x7fa8e4=
015400) at ioengines.c:343
#4  0x000000000044a75d in do_io (td=3D0x7fa9a0dd1860) at backend.c:792
#5  0x000000000044c209 in thread_main (data=3D0x7fa9a0dd1860) at backend.c:=
1504
#6  0x0000003974c079d1 in start_thread () from /lib64/libpthread.so.0
#7  0x00000039748e8b7d in clone () from /lib64/libc.so.6
(gdb) select-frame 5
(gdb) print td->error
$40 =3D 0
(gdb) print td->terminate
$41 =3D 0
(gdb) print td->done
$42 =3D 0
(gdb) print td->o.time_based
$43 =3D 1
(gdb) print o->create_only
$47 =3D 0

I guess the threads are not leaving this loop in thread_main():=20
        while (keep_running(td)) {
        ...
        }

static int keep_running(struct thread_data *td)
{
        unsigned long long limit;

        if (td->done)
                return 0;
        if (td->o.time_based)
                return 1;
...

After the runtime has elapsed, should td->done or td->terminate
get set?


The jobfile is:
[global]
direct=3D1
ioengine=3Dlibaio
norandommap
randrepeat=3D0
bs=3D512
iodepth=3D96
numjobs=3D1
numjobs=3D14
runtime=3D216000
time_based=3D1
group_reporting
thread
gtod_reduce=3D1
iodepth_batch=3D14
iodepth_batch_complete=3D14
iodepth_low=3D14
userspace_reap=3D1
cpus_allowed=3D0-13
cpus_allowed_policy=3Dsplit
rw=3Drandread

[drive_b]
filename=3D/dev/sdb

[drive_c]
filename=3D/dev/sdc

[drive_d]
filename=3D/dev/sdd

[drive_e]
filename=3D/dev/sde

[drive_f]
filename=3D/dev/sdf

[drive_g]
filename=3D/dev/sdg

[drive_h]
filename=3D/dev/sdh

[drive_i]
filename=3D/dev/sdi

[drive_j]
filename=3D/dev/sdj

[drive_k]
filename=3D/dev/sdk

[drive_l]
filename=3D/dev/sdl

[drive_m]
filename=3D/dev/sdm

[drive_n]
filename=3D/dev/sdn

[drive_o]
filename=3D/dev/sdo

[drive_p]
filename=3D/dev/sdp

[drive_q]
filename=3D/dev/sdq





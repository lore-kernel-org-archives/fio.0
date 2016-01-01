Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <VI1PR05MB1343810AF909BB41065666C9B1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB13437814C9CD31D2CECE7398B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<56840F80.4060903@kernel.dk>
	<VI1PR05MB13435F5190D9D9A17C59315BB1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<5684A8F1.6010105@kernel.dk>
	<VI1PR05MB13439C4033DED096900CDF30B1FE0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<CANvN+ekwjftjYq=8KFiefRAFmUvZF1qpJ9Y6ohFBdMHH6TEAQg@mail.gmail.com>
	<VI1PR05MB13433A1D09C1C60B66E2ABBFB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<CANvN+e=X09zp=HRme4Wwad2_HhmNkOQkL8zXGWozuVWCm+NMYg@mail.gmail.com>
	<VI1PR05MB1343810AF909BB41065666C9B1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
Date: Fri, 1 Jan 2016 17:04:17 +0300
Message-ID: <CANvN+e=cxWLEnu3Ve7RQKTh4TQubWMzkt0fkZ_AyKbNPAt21QQ@mail.gmail.com>
Subject: RE: fio-2c2c93d and with a lot of numjobs causing fio Jobs to Time Out
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Content-Type: multipart/alternative; boundary=089e01176ba34bb8120528463ff8
To: Thierry BERTAUD <tbertaud@conforama.fr>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

--089e01176ba34bb8120528463ff8
Content-Type: text/plain; charset=UTF-8

On Jan 1, 2016 17:00, "Thierry BERTAUD" <tbertaud@conforama.fr> wrote:
>
> Andrey,
>
> > It's best to run make clean, configure --disable-optimizations, and
then make. Also, check if you have libpthreads-debug installed so that gdb
tracks libpthread symbols.
>
> I have tyhe pthread debug library:
>    # find / -name "libpth*"
>    /usr/ccs/lib/inst_updt/libpthdebug.a
>    /usr/ccs/lib/libp/libpthread.a
>    /usr/ccs/lib/libp/libpthreads.a
>    /usr/ccs/lib/libp/libpthreads_compat.a
>    /usr/ccs/lib/libpthdebug.a             <==== here
>    /usr/ccs/lib/libpthread.a
>    /usr/ccs/lib/libpthreads.a
>    /usr/ccs/lib/libpthreads_compat.a
>    /usr/ccs/lib/libt/libpthread.a
>    /usr/ccs/lib/libt/libpthreads.a
>    /usr/ccs/lib/libt/libpthreads_compat.a
>    /usr/ccs/lib/perf/libpthread.a
>    /usr/ccs/lib/perf/libpthreads.a
>    /usr/ccs/lib/perf/libpthreads_compat.a
>    /usr/lib/libpthdebug.a              <==== here
>    /usr/lib/libpthread.a
>    /usr/lib/libpthreads.a
>    /usr/lib/libpthreads_compat.a
>    #
>
> The tools procstack (from man: Prints the hexadecimal addresses and
symbolic names for all the threads in the process) from ibmprocstack can
read the thread:
>    # ldd /usr/bin/procstack
>    /usr/bin/procstack needs:
>             /usr/lib/libc.a(shr_64.o)
>             /usr/lib/libptools.a(shr64.o)
>             /unix
>             /usr/lib/libcrypt.a(shr_64.o)
>             /usr/lib/libpthreads.a(shr_xpg5_64.o)
>             /usr/lib/libC.a(shr_64.o)
>             /usr/lib/libodm.a(shr_64.o)
>             /usr/lib/libtrace.a(shr_64.o)
>             /usr/lib/libC.a(shrcore_64.o)
>             /usr/lib/libC.a(ansicore_64.o)
>    #
>
> Below output from procstak:
>    # procstack 8913040
>    8913040: /home/padmin/fio/fio-5f3bd0f/fio myfio.fio
>    ---------- tid# 84803767 (pthread ID:      1) ----------
>    0xd051d470  _p_nsleep(??, ??) + 0x10
>    0xd011f3e4  nsleep(??, ??) + 0xe4
>    0xd011ee34  usleep(??) + 0xd4
>    0x1006922c  run_threads(??) + 0xaf0
>    0x10069640  fio_backend(??) + 0x174
>    0x100004c0  main(??, ??, ??) + 0xd8
>    0x100001b8  __start() + 0x68
>    ---------- tid# 110231691 (pthread ID:    258) ----------
>    0xd0119598  __ioctl(??, ??, ??, ??, ??) + 0xb8
>    0xd0119bbc  ioctl(0x1, 0x5800, 0x0, 0x0, 0x0, 0x4, 0x0, 0x3009f6a8) +
0x3c
>    0xd0118f24  isatty(??) + 0x24
>    0x100625d8  calc_thread_status(??, ??) + 0xb8
>    0x10064828  print_thread_status() + 0x58
>    0x10064b8c  helper_thread_main(??) + 0x120
>    0xd0505c0c  _pthread_body(??) + 0xec
>    #
>
> Does the output from procstak is useful?

It's the default thread that sleeps in the run_threads loop, check one of
the i/o threads.

> How to configure 'configure' or 'make' to use the /usr/lib/libpthdebug.a ?
>
GDB should pick up the right one itself when you build fio with
optimization disabled.

Regards,
A.
> Regards,
> Thierry
>
>

--089e01176ba34bb8120528463ff8
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
On Jan 1, 2016 17:00, &quot;Thierry BERTAUD&quot; &lt;<a href=3D"mailto:tbe=
rtaud@conforama.fr">tbertaud@conforama.fr</a>&gt; wrote:<br>
&gt;<br>
&gt; Andrey,<br>
&gt;<br>
&gt; &gt;=C2=A0It&#39;s best to run make clean, configure --disable-optimiz=
ations, and then make. Also, check if you have libpthreads-debug installed =
so that gdb tracks libpthread symbols.<br>
&gt;<br>
&gt; I have tyhe pthread debug library:<br>
&gt; =C2=A0 =C2=A0# find / -name &quot;libpth*&quot;<br>
&gt; =C2=A0 =C2=A0/usr/ccs/lib/inst_updt/libpthdebug.a<br>
&gt; =C2=A0 =C2=A0/usr/ccs/lib/libp/libpthread.a<br>
&gt; =C2=A0 =C2=A0/usr/ccs/lib/libp/libpthreads.a<br>
&gt; =C2=A0 =C2=A0/usr/ccs/lib/libp/libpthreads_compat.a<br>
&gt; =C2=A0 =C2=A0/usr/ccs/lib/libpthdebug.a=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0&lt;=3D=3D=3D=3D here<br>
&gt; =C2=A0 =C2=A0/usr/ccs/lib/libpthread.a<br>
&gt; =C2=A0 =C2=A0/usr/ccs/lib/libpthreads.a<br>
&gt; =C2=A0 =C2=A0/usr/ccs/lib/libpthreads_compat.a<br>
&gt; =C2=A0 =C2=A0/usr/ccs/lib/libt/libpthread.a<br>
&gt; =C2=A0 =C2=A0/usr/ccs/lib/libt/libpthreads.a<br>
&gt; =C2=A0 =C2=A0/usr/ccs/lib/libt/libpthreads_compat.a<br>
&gt; =C2=A0 =C2=A0/usr/ccs/lib/perf/libpthread.a<br>
&gt; =C2=A0 =C2=A0/usr/ccs/lib/perf/libpthreads.a<br>
&gt; =C2=A0 =C2=A0/usr/ccs/lib/perf/libpthreads_compat.a<br>
&gt; =C2=A0 =C2=A0/usr/lib/libpthdebug.a=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &lt;=3D=3D=3D=3D here<br>
&gt; =C2=A0 =C2=A0/usr/lib/libpthread.a<br>
&gt; =C2=A0 =C2=A0/usr/lib/libpthreads.a<br>
&gt; =C2=A0 =C2=A0/usr/lib/libpthreads_compat.a<br>
&gt; =C2=A0 =C2=A0#<br>
&gt;<br>
&gt; The tools procstack (from man: Prints the hexadecimal addresses and sy=
mbolic names for all the threads in the process) from ibmprocstack can read=
 the thread:<br>
&gt; =C2=A0 =C2=A0# ldd /usr/bin/procstack<br>
&gt; =C2=A0 =C2=A0/usr/bin/procstack needs:<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /usr/lib/libc.a(shr_64.o)<br=
>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /usr/lib/libptools.a(shr64.o=
)<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /unix<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /usr/lib/libcrypt.a(shr_64.o=
)<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /usr/lib/libpthreads.a(shr_x=
pg5_64.o)<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /usr/lib/libC.a(shr_64.o)<br=
>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /usr/lib/libodm.a(shr_64.o)<=
br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /usr/lib/libtrace.a(shr_64.o=
)<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /usr/lib/libC.a(shrcore_64.o=
)<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /usr/lib/libC.a(ansicore_64.=
o)<br>
&gt; =C2=A0 =C2=A0#<br>
&gt;<br>
&gt; Below output from procstak:<br>
&gt; =C2=A0 =C2=A0# procstack 8913040<br>
&gt; =C2=A0 =C2=A08913040: /home/padmin/fio/fio-5f3bd0f/fio myfio.fio<br>
&gt; =C2=A0 =C2=A0---------- tid# 84803767 (pthread ID:=C2=A0 =C2=A0 =C2=A0=
 1) ----------<br>
&gt; =C2=A0 =C2=A00xd051d470=C2=A0 _p_nsleep(??, ??) + 0x10<br>
&gt; =C2=A0 =C2=A00xd011f3e4=C2=A0 nsleep(??, ??) + 0xe4<br>
&gt; =C2=A0 =C2=A00xd011ee34=C2=A0 usleep(??) + 0xd4<br>
&gt; =C2=A0 =C2=A00x1006922c=C2=A0 run_threads(??) + 0xaf0<br>
&gt; =C2=A0 =C2=A00x10069640=C2=A0 fio_backend(??) + 0x174<br>
&gt; =C2=A0 =C2=A00x100004c0=C2=A0 main(??, ??, ??) + 0xd8<br>
&gt; =C2=A0 =C2=A00x100001b8=C2=A0 __start() + 0x68<br>
&gt; =C2=A0 =C2=A0---------- tid# 110231691 (pthread ID:=C2=A0 =C2=A0 258) =
----------<br>
&gt; =C2=A0 =C2=A00xd0119598=C2=A0 __ioctl(??, ??, ??, ??, ??) + 0xb8<br>
&gt; =C2=A0 =C2=A00xd0119bbc=C2=A0 ioctl(0x1, 0x5800, 0x0, 0x0, 0x0, 0x4, 0=
x0, 0x3009f6a8) + 0x3c<br>
&gt; =C2=A0 =C2=A00xd0118f24=C2=A0 isatty(??) + 0x24<br>
&gt; =C2=A0 =C2=A00x100625d8=C2=A0 calc_thread_status(??, ??) + 0xb8<br>
&gt; =C2=A0 =C2=A00x10064828=C2=A0 print_thread_status() + 0x58<br>
&gt; =C2=A0 =C2=A00x10064b8c=C2=A0 helper_thread_main(??) + 0x120<br>
&gt; =C2=A0 =C2=A00xd0505c0c=C2=A0 _pthread_body(??) + 0xec<br>
&gt; =C2=A0 =C2=A0#<br>
&gt;<br>
&gt; Does the output from procstak is useful?</p>
<p dir=3D"ltr">It&#39;s the default thread that sleeps in the run_threads l=
oop, check one of the i/o threads.</p>
<p dir=3D"ltr">&gt; How to configure &#39;configure&#39; or &#39;make&#39; =
to use the /usr/lib/libpthdebug.a ?<br>
&gt;<br>
GDB should pick up the right one itself when you build fio with optimizatio=
n disabled.</p>
<p dir=3D"ltr">Regards,<br>
A.<br>
&gt; Regards,<br>
&gt; Thierry<br>
&gt;<br>
&gt; =C2=A0 =C2=A0</p>

--089e01176ba34bb8120528463ff8--


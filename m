Return-Path: <tbertaud@conforama.fr>
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: fio-2c2c93d and with a lot of numjobs causing fio Jobs to Time
 Out
Date: Fri, 1 Jan 2016 14:00:12 +0000
Message-ID: <VI1PR05MB1343810AF909BB41065666C9B1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB13437814C9CD31D2CECE7398B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<56840F80.4060903@kernel.dk>
	<VI1PR05MB13435F5190D9D9A17C59315BB1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<5684A8F1.6010105@kernel.dk>
	<VI1PR05MB13439C4033DED096900CDF30B1FE0@VI1PR05MB1343.eurprd05.prod.outlook.com>
	<CANvN+ekwjftjYq=8KFiefRAFmUvZF1qpJ9Y6ohFBdMHH6TEAQg@mail.gmail.com>
	<VI1PR05MB13433A1D09C1C60B66E2ABBFB1FF0@VI1PR05MB1343.eurprd05.prod.outlook.com>,<CANvN+e=X09zp=HRme4Wwad2_HhmNkOQkL8zXGWozuVWCm+NMYg@mail.gmail.com>
In-Reply-To: <CANvN+e=X09zp=HRme4Wwad2_HhmNkOQkL8zXGWozuVWCm+NMYg@mail.gmail.com>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Andrey,

>=A0It's best to run make clean, configure --disable-optimizations, and the=
n make. Also, check if you have libpthreads-debug installed so that gdb tra=
cks libpthread symbols.

I have tyhe pthread debug library:
   # find / -name "libpth*"
   /usr/ccs/lib/inst_updt/libpthdebug.a
   /usr/ccs/lib/libp/libpthread.a
   /usr/ccs/lib/libp/libpthreads.a
   /usr/ccs/lib/libp/libpthreads_compat.a
   /usr/ccs/lib/libpthdebug.a             <=3D=3D=3D=3D here
   /usr/ccs/lib/libpthread.a
   /usr/ccs/lib/libpthreads.a
   /usr/ccs/lib/libpthreads_compat.a
   /usr/ccs/lib/libt/libpthread.a
   /usr/ccs/lib/libt/libpthreads.a
   /usr/ccs/lib/libt/libpthreads_compat.a
   /usr/ccs/lib/perf/libpthread.a
   /usr/ccs/lib/perf/libpthreads.a
   /usr/ccs/lib/perf/libpthreads_compat.a
   /usr/lib/libpthdebug.a              <=3D=3D=3D=3D here
   /usr/lib/libpthread.a
   /usr/lib/libpthreads.a
   /usr/lib/libpthreads_compat.a
   #

The tools procstack (from man: Prints the hexadecimal addresses and symboli=
c names for all the threads in the process) from ibmprocstack can read the =
thread:
   # ldd /usr/bin/procstack
   /usr/bin/procstack needs:
            /usr/lib/libc.a(shr_64.o)
            /usr/lib/libptools.a(shr64.o)
            /unix
            /usr/lib/libcrypt.a(shr_64.o)
            /usr/lib/libpthreads.a(shr_xpg5_64.o)
            /usr/lib/libC.a(shr_64.o)
            /usr/lib/libodm.a(shr_64.o)
            /usr/lib/libtrace.a(shr_64.o)
            /usr/lib/libC.a(shrcore_64.o)
            /usr/lib/libC.a(ansicore_64.o)
   #

Below output from procstak:
   # procstack 8913040
   8913040: /home/padmin/fio/fio-5f3bd0f/fio myfio.fio
   ---------- tid# 84803767 (pthread ID:      1) ----------
   0xd051d470  _p_nsleep(??, ??) + 0x10
   0xd011f3e4  nsleep(??, ??) + 0xe4
   0xd011ee34  usleep(??) + 0xd4
   0x1006922c  run_threads(??) + 0xaf0
   0x10069640  fio_backend(??) + 0x174
   0x100004c0  main(??, ??, ??) + 0xd8
   0x100001b8  __start() + 0x68
   ---------- tid# 110231691 (pthread ID:    258) ----------
   0xd0119598  __ioctl(??, ??, ??, ??, ??) + 0xb8
   0xd0119bbc  ioctl(0x1, 0x5800, 0x0, 0x0, 0x0, 0x4, 0x0, 0x3009f6a8) + 0x=
3c
   0xd0118f24  isatty(??) + 0x24
   0x100625d8  calc_thread_status(??, ??) + 0xb8
   0x10064828  print_thread_status() + 0x58
   0x10064b8c  helper_thread_main(??) + 0x120
   0xd0505c0c  _pthread_body(??) + 0xec
   #=20

Does the output from procstak is useful?
How to configure 'configure' or 'make' to use the /usr/lib/libpthdebug.a ?

Regards,
Thierry

    =


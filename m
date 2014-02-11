Return-Path: <Elliott@hp.com>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: Mutex destruction, invalid memory accesses, leaks
Date: Tue, 11 Feb 2014 15:30:24 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029548A66EB@G9W0745.americas.hpqcorp.net>
References: <20140206192135.GB3950@kernel.dk>
 <20140207034439.GA17588@sucs.org> <52F505A8.30004@kernel.dk>
 <20140209195042.GA17058@sucs.org> <52F927AC.6020007@cran.org.uk>
 <20140210202245.GA6747@sucs.org> <20140210205659.GC4096@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B4029548A645A@G9W0745.americas.hpqcorp.net>
 <20140211070719.GA1187@sucs.org>
In-Reply-To: <20140211070719.GA1187@sucs.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

That specific command line does also crash on my Windows 2008 R2 system.  I=
t does not crash if I drop --ioengine=3Dsync.

---
Rob Elliott    HP Server Storage




> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Sitsofe Wheeler
> Sent: Tuesday, 11 February, 2014 1:07 AM
> To: Elliott, Robert (Server Storage)
> Cc: Jens Axboe; Bruce Cran; fio@vger.kernel.org
> Subject: Re: Mutex destruction, invalid memory accesses, leaks
>=20
> On Tue, Feb 11, 2014 at 12:12:54AM +0000, Elliott, Robert (Server Storage=
)
> wrote:
> >
> > > -----Original Message-----
> > > From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org]
> On
> > > Behalf Of Jens Axboe
> > >
> > > Actually, the previous wont work, and I don't see how to make it work=
.
> > > Please try the below instead. Or just re-pull, I'll check it in now.
> > >
> > The latest pulled version with this change works on my Windows Server
> 2008 R2 system that was crashing with 2-1.4.
>=20
> Still a problem here:
>=20
> $ git rev-parse HEAD
> ea66e04fe1a803f6a9ddf31cb999641d4396d67c
> $ ./fio.exe --version
> fio-2.1.4-48-gea66
> $ gdb --args ./fio.exe --debug=3Dall --filename=3Dfiojob --thread --size=
=3D512 --
> rw=3Dre
> ad --bs=3D512 --ioengine=3Dsync --verify_pattern=3D0xdeadbeef --
> name=3Dfiojobname
> GNU gdb (GDB) 7.6.50.20130728-cvs (cygwin-special)
> <snip>
> Reading symbols from /home/Sitsofe Wheeler/fio/fio.exe...done.
> (gdb) ru
> Starting program: /home/Sitsofe Wheeler/fio/fio.exe --debug=3Dall --
> filename=3Dfioj
> b --thread --size=3D512 --rw=3Dread --bs=3D512 --ioengine=3Dsync --
> verify_pattern=3D0xdead
> beef --name=3Dfiojobname
> [New Thread 1756.0xbe0]
> [New Thread 1756.0x8e8]
> fio: set all debug options
> io       1756  load ioengine windowsaio
> parse    1756  handle_option=3Dfilename, ptr=3Dfiojob
> parse    1756  __handle_option=3Dfilename, type=3D5, ptr=3Dfiojob
> file     1756  add file fiojob
> file     1756  resize file array to 1 files
> file     1756  file 01F40008 "fiojob" added at 0
> parse    1756  handle_option=3Dthread, ptr=3D(null)
> parse    1756  __handle_option=3Dthread, type=3D10, ptr=3D(null)
> parse    1756    ret=3D0, out=3D1
> parse    1756  handle_option=3Dsize, ptr=3D512
> parse    1756  __handle_option=3Dsize, type=3D3, ptr=3D512
> parse    1756    ret=3D0, out=3D512
> parse    1756  handle_option=3Drw, ptr=3Dread
> parse    1756  __handle_option=3Drw, type=3D1, ptr=3Dread
> parse    1756  handle_option=3Dbs, ptr=3D512
> parse    1756  __handle_option=3Dbs, type=3D7, ptr=3D512
> parse    1756    ret=3D0, out=3D512
> parse    1756  handle_option=3Dioengine, ptr=3Dsync
> parse    1756  __handle_option=3Dioengine, type=3D5, ptr=3Dsync
> io       1756  free ioengine windowsaio
> io       1756  load ioengine sync
> parse    1756  handle_option=3Dverify_pattern, ptr=3D0xdeadbeef
> parse    1756  __handle_option=3Dverify_pattern, type=3D1, ptr=3D0xdeadbe=
ef
> file     1756  dup files: 1
> io       1756  load ioengine sync
> parse    1756  handle_option=3Dname, ptr=3Dfiojobname
> parse    1756  __handle_option=3Dname, type=3D5, ptr=3Dfiojobname
> fiojobname: (g=3D0): rw=3Dread, bs=3D512-512/512-512/512-512, ioengine=3D=
sync,
> iodepth=3D1
> parse    1756  free options
> fio-2.1.4-48-gea66
> time     1756  cycles[0]=3D2593
> time     1756  cycles[1]=3D2593
> time     1756  cycles[2]=3D2593
> time     1756  cycles[3]=3D2593
> time     1756  cycles[4]=3D2594
> time     1756  cycles[5]=3D2592
> time     1756  cycles[6]=3D2593
> time     1756  cycles[7]=3D2593
> time     1756  cycles[8]=3D2593
> time     1756  cycles[9]=3D2593
> time     1756  cycles[10]=3D2593
> time     1756  cycles[11]=3D2593
> time     1756  cycles[12]=3D2593
> time     1756  cycles[13]=3D2593
> time     1756  cycles[14]=3D2593
> time     1756  cycles[15]=3D2593
> time     1756  cycles[16]=3D2593
> time     1756  cycles[17]=3D2593
> time     1756  cycles[18]=3D2593
> time     1756  cycles[19]=3D2593
> time     1756  cycles[20]=3D2593
> time     1756  cycles[21]=3D2593
> time     1756  cycles[22]=3D2593
> time     1756  cycles[23]=3D2593
> time     1756  cycles[24]=3D2593
> time     1756  cycles[25]=3D2593
> time     1756  cycles[26]=3D2593
> time     1756  cycles[27]=3D2593
> time     1756  cycles[28]=3D2593
> time     1756  cycles[29]=3D2593
> time     1756  cycles[30]=3D2593
> time     1756  cycles[31]=3D2593
> time     1756  cycles[32]=3D2593
> time     1756  cycles[33]=3D2593
> time     1756  cycles[34]=3D2593
> time     1756  cycles[35]=3D2593
> time     1756  cycles[36]=3D2593
> time     1756  cycles[37]=3D2593
> time     1756  cycles[38]=3D2593
> time     1756  cycles[39]=3D2593
> time     1756  cycles[40]=3D2593
> time     1756  cycles[41]=3D2593
> time     1756  cycles[42]=3D2593
> time     1756  cycles[43]=3D2593
> time     1756  cycles[44]=3D2593
> time     1756  cycles[45]=3D2593
> time     1756  cycles[46]=3D2593
> time     1756  cycles[47]=3D2593
> time     1756  cycles[48]=3D2593
> time     1756  cycles[49]=3D2593
> time     1756  avg: 2594
> time     1756  mean=3D2593.572000, S=3D0.042769
> time     1756  inv_cycles_per_usec=3D6467
> mutex    1756  wait on startup_mutex
> mutex    1756  done waiting on startup_mutex
> Starting 1 thread
> [New Thread 1756.0x1a0]
>=20
> Program received signal SIGSEGV, Segmentation fault.
> 0x0043e1de in pthread_mutex_unlock (m=3D0x4f80000)
>     at /usr/src/debug/mingw64-i686-winpthreads-3.1.0-1/src/mutex.c:392
> (gdb) thread apply all bt
>=20
> Thread 3 (Thread 1756.0x1a0):
> #0  0x775dfd91 in ntdll!ZwDelayExecution ()
>    from /cygdrive/c/Windows/system32/ntdll.dll
> #1  0x775dfd91 in ntdll!ZwDelayExecution ()
>    from /cygdrive/c/Windows/system32/ntdll.dll
> #2  0x76933bc8 in SleepEx () from
> /cygdrive/c/Windows/syswow64/KERNELBASE.dll
> #3  0x00000000 in ?? ()
>=20
> Thread 2 (Thread 1756.0x8e8):
> #0  0x775dfd91 in ntdll!ZwDelayExecution ()
>    from /cygdrive/c/Windows/system32/ntdll.dll
> #1  0x775dfd91 in ntdll!ZwDelayExecution ()
>    from /cygdrive/c/Windows/system32/ntdll.dll
> #2  0x76933bc8 in SleepEx () from
> /cygdrive/c/Windows/syswow64/KERNELBASE.dll
> #3  0x00000000 in ?? ()
>=20
> Thread 1 (Thread 1756.0xbe0):
> #0  0x0043e1de in pthread_mutex_unlock (m=3D0x4f80000)
>     at /usr/src/debug/mingw64-i686-winpthreads-3.1.0-1/src/mutex.c:392
> #1  0x0041bc48 in fio_mutex_up (mutex=3D0x4f80000) at mutex.c:153
> #2  0x00433c84 in run_threads () at backend.c:1885
> #3  0x00434005 in fio_backend () at backend.c:1998
> #4  0x00449a14 in main (argc=3D10, argv=3D0x9a28b0, envp=3D0x9a19a0) at f=
io.c:50
>=20
> --
> Sitsofe | http://sucs.org/~sits/
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


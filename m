Return-Path: <fio-owner@vger.kernel.org>
Received: from exprod5og103.obsmtp.com ([64.18.0.145]:38423 "HELO
	exprod5og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750952AbaAICiO convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 8 Jan 2014 21:38:14 -0500
From: Todd Dworshak <todd.dworshak@avid.com>
Subject: RE: fio 2.1.4 intermittently crashes on windows
Date: Thu, 9 Jan 2014 02:32:13 +0000
Message-ID: <0C4FACE8A034424CB177F7934C49B4ED080FFDF8@WAL-MBS04.global.avidww.com>
References: <0C4FACE8A034424CB177F7934C49B4ED080FE9AF@WAL-MBS04.global.avidww.com>
 <52BE337F.10106@cran.org.uk>
 <0C4FACE8A034424CB177F7934C49B4ED080FFDA8@WAL-MBS04.global.avidww.com>,<94D0CD8314A33A4D9D801C0FE68B402954872E64@G4W3202.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402954872E64@G4W3202.americas.hpqcorp.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, 'Bruce Cran' <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Sounds like we are hitting the same issue.  I am encountering the crash on a Windows 7 box, which pairs up with your crash on Server 2008 R2 (both being basically the same OS).

________________________________________
From: Elliott, Robert (Server Storage) [Elliott@hp.com]
Sent: Wednesday, January 08, 2014 8:07 PM
To: Todd Dworshak; 'Bruce Cran'; fio@vger.kernel.org
Subject: RE: fio 2.1.4 intermittently crashes on windows

I've seen something similar:
- 2.1.1 on a Windows Server 2008 R2 system: OK
- 2.1.4 on a Windows Server 2008 R2 system: crash
- 2.1.4 on a Windows Server 2012 system: OK

This is this error for 2.1.4 on Windows Server 2008 R2:
    Faulting application name: fio.exe, version: 0.0.0.0, time stamp: 0x5294c1a1
    Faulting module name: ntdll.dll, version: 6.1.7601.18247, time stamp: 0x521eaf24
    Exception code: 0xc0000026  (STATUS_INVALID_DISPOSITION)
    Fault offset: 0x00000000000cd7e8
    Faulting process id: 0x103c
    Faulting application start time: 0x01cf0bc5133c13bf
    Faulting application path: c:\program files\fio\fio.exe
    Faulting module path: C:\Windows\SYSTEM32\ntdll.dll

Running it under cygwin gdb with the same gdb commands, I get:

Starting program: /cygdrive/c/program files/fio/fio --filename=rob.tmp --size=128m --direct=1 --rw=r
andread --refill_buffers --norandommap --randrepeat=0 --bs=4k --iodepth=16 --numjobs=16 --runtime=60
 --group_reporting --name=4ktest --time_based
[New Thread 4760.0xe88]
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread'
 option to get rid of this warning.
4ktest: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=windowsaio, iodepth=16
...
4ktest: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=windowsaio, iodepth=16
fio-2.1.4
[New Thread 4760.0x4c4]
Starting 16 threads
[New Thread 4760.0x1050]
[New Thread 4760.0xf40]
[New Thread 4760.0x1334]
[New Thread 4760.0x948]
[New Thread 4760.0x2b8]
[New Thread 4760.0x11e8]
[New Thread 4760.0x1280]
[New Thread 4760.0x1114]
[New Thread 4760.0xea8]
[New Thread 4760.0x87c]
[New Thread 4760.0xeac]
[New Thread 4760.0x12c8]
[New Thread 4760.0x1190]
[New Thread 4760.0xebc]
[New Thread 4760.0xd48]
[New Thread 4760.0x918]
Jobs: 0 (f=0)
Program received signal SIGSEGV, Segmentation fault.
0x0000000064943236 in pthread_mutex_unlock ()
   from /cygdrive/c/program files/fio/libwinpthread-1.dll
(gdb) bt
#0  0x0000000064943236 in pthread_mutex_unlock ()
   from /cygdrive/c/program files/fio/libwinpthread-1.dll
#1  0x0000000000000001 in ?? ()
#2  0x0000000000421599 in fio_mutex_up (mutex=0x2f5b10) at mutex.c:151
#3  0x0000000000437ce0 in run_threads () at backend.c:1812
#4  0x000000000043809d in fio_backend () at backend.c:1925
#5  0x0000000000449411 in main (argc=<optimized out>, argv=<optimized out>, envp=<optimized out>)
    at fio.c:50
#6  0x00000000004013a5 in __tmainCRTStartup ()
    at /usr/src/debug/mingw64-x86_64-runtime-3.0.0-1/crt/crtexe.c:332
#7  0x00000000004014d8 in mainCRTStartup ()
    at /usr/src/debug/mingw64-x86_64-runtime-3.0.0-1/crt/crtexe.c:212
(gdb) f 2
#2  0x0000000000421599 in fio_mutex_up (mutex=0x2f5b10) at mutex.c:151
151     mutex.c: No such file or directory.
(gdb) p mutex
$1 = (struct fio_mutex *) 0x2f5b10
(gdb) p *mutex
$2 = {lock = 0x1bab1f00d, cond = 0x100000000, value = 0, waiters = 0, magic = 172}

---
Rob Elliott    HP Server Storage





> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Todd Dworshak
> Sent: Wednesday, 08 January, 2014 4:02 PM
> To: 'Bruce Cran'; fio@vger.kernel.org
> Subject: RE: fio 2.1.4 intermittently crashes on windows
>
> I ran fio in gdb and got the crash.  The stack trace is below.  Not sure if this is a
> bug in libwinpthread-1.dll or in the way fio is calling it.
>
> Program received signal SIGSEGV, Segmentation fault.
> 0x0000000064943236 in pthread_mutex_unlock ()
>    from /cygdrive/c/program files/fio/libwinpthread-1.dll
> (gdb) bt
> #0  0x0000000064943236 in pthread_mutex_unlock ()
>    from /cygdrive/c/program files/fio/libwinpthread-1.dll
> #1  0x0000000000000009 in ?? ()
> #2  0x0000000000421599 in fio_mutex_up (mutex=0x79a2b0) at mutex.c:151
> #3  0x0000000000437ce0 in run_threads () at backend.c:1812
> #4  0x000000000043809d in fio_backend () at backend.c:1925
> #5  0x0000000000449411 in main (argc=<optimized out>, argv=<optimized
> out>,
>     envp=<optimized out>) at fio.c:50
> #6  0x00000000004013a5 in __tmainCRTStartup ()
>     at /usr/src/debug/mingw64-x86_64-runtime-3.0.0-1/crt/crtexe.c:332
> #7  0x00000000004014d8 in mainCRTStartup ()
>     at /usr/src/debug/mingw64-x86_64-runtime-3.0.0-1/crt/crtexe.c:212
> (gdb) f 2
> #2  0x0000000000421599 in fio_mutex_up (mutex=0x79a2b0) at mutex.c:151
> 151     mutex.c: No such file or directory.
> (gdb) p mutex
> $1 = (struct fio_mutex *) 0x79a2b0
> (gdb) p *mutex
> $2 = {lock = 0x1bab1f00d, cond = 0x100000000, value = 0, waiters = 0,
>   magic = 280}
>
> -----Original Message-----
> From: Bruce Cran [mailto:bruce@cran.org.uk]
> Sent: Friday, December 27, 2013 9:12 PM
> To: Todd Dworshak; fio@vger.kernel.org
> Subject: Re: fio 2.1.4 intermittently crashes on windows
>
> On 12/27/2013 6:42 PM, Todd Dworshak wrote:
> > I am having trouble with fio intermittently crashing on Windows 7.
> >
> > Version is fio 2.1.4 64 bit, downloaded from Windows build site.
> >
> > Has anyone else seen this?  If I give it fewer files in the job description, it
> seems to be less prone to crashing.  Since it crashes in pthreads, it looks like
> this may be some kind of threading bug.
>
> I'll try to replicate the problem here, but in the meantime it would be useful
> if you could try running fio under the Cygwin build of gdb to capture a stack
> trace in fio.exe.
>
> --
> Bruce
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
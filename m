Return-Path: <fio-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:10982 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaAJQrE convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 10 Jan 2014 11:47:04 -0500
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: fio 2.1.4 intermittently crashes on windows
Date: Fri, 10 Jan 2014 16:46:05 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402954874EEC@G4W3202.americas.hpqcorp.net>
References: <0C4FACE8A034424CB177F7934C49B4ED080FE9AF@WAL-MBS04.global.avidww.com>
 <52BE337F.10106@cran.org.uk>
 <0C4FACE8A034424CB177F7934C49B4ED080FFDA8@WAL-MBS04.global.avidww.com>
 <94D0CD8314A33A4D9D801C0FE68B402954872E64@G4W3202.americas.hpqcorp.net>
 <20140109063709.GA1704@sucs.org>
 <94D0CD8314A33A4D9D801C0FE68B4029548744AD@G4W3202.americas.hpqcorp.net>
 <20140110052116.GA19356@sucs.org> <52CF8F08.40605@cran.org.uk>
In-Reply-To: <52CF8F08.40605@cran.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>, Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

1. In addition to updating the README, I think os/windows/install.wxs needs to reference libwinpthread-1.dll instead of pthreadGC2.dll, since the wrong .dll is being copied to c:\program files\fio alongside fio.exe.  I re-installed the original 2.1.4 binary, saved that file to a different directory, installed the newly built 2.1.4 with the added assert (whose installation process deletes libwinpthread-1.dll), and put that file back, and it runs.

os/windows/install.wxs:         <ComponentRef Id="pthreadGC2.dll"/>

2. This is where I put the assert in mutex.c:
void fio_mutex_up(struct fio_mutex *mutex)
{
	assert(mutex->magic == FIO_MUTEX_MAGIC);

	pthread_mutex_lock(&mutex->lock);
	read_barrier();
assert(mutex->magic == FIO_MUTEX_MAGIC);	// robrob this is line 150
	if (!mutex->value && mutex->waiters)
		pthread_cond_signal(&mutex->cond);
	mutex->value++;
	pthread_mutex_unlock(&mutex->lock);
}

3. The assert does not trigger, and the same crash occurs as before.

C:\Users\Administrator\fio>c:\cygwin64\bin\gdb -args "c:/program files/fio/fio.exe" --filename=rob.t
mp --size=128m --direct=1 --rw=randread --refill_buffers --norandommap --randrepeat=0 --bs=4k --iode
pth=16 --numjobs=16 --runtime=60 --group_reporting --name=4ktest --time_based
GNU gdb (GDB) 7.6.50.20130728-cvs (cygwin-special)
Copyright (C) 2013 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-pc-cygwin".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word".
..
Reading symbols from /cygdrive/c/program files/fio/fio.exe...done.
 (gdb) run
Starting program: /cygdrive/c/program files/fio/fio.exe --filename=rob.tmp --size=128m --direct=1 --rw=randread --refill_buffers --norandommap --randrepeat=0 --bs=4k --iodepth=16 --numjobs=16 --runtime=60 --group_reporting --name=4ktest --time_based
[New Thread 3428.0x13e0]
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread'
 option to get rid of this warning.
4ktest: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=windowsaio, iodepth=16
...
4ktest: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=windowsaio, iodepth=16
fio-2.1.4
[New Thread 3428.0x10a4]
Starting 16 threads
[New Thread 3428.0x1104]
[New Thread 3428.0x1254]
[New Thread 3428.0xde8]
[New Thread 3428.0xeec]
[New Thread 3428.0xe58]
[New Thread 3428.0x13e8]
[New Thread 3428.0x4b8]
[New Thread 3428.0x13e4]
[New Thread 3428.0x7bc]
[New Thread 3428.0x1358]
[New Thread 3428.0x2f0]
[New Thread 3428.0x8dc]
[New Thread 3428.0x38c]
[New Thread 3428.0x133c]
[New Thread 3428.0x2c8]
[New Thread 3428.0x13c0]
Jobs: 0 (f=0)
Program received signal SIGSEGV, Segmentation fault.
0x0000000064943236 in pthread_mutex_unlock ()
   from /cygdrive/c/program files/fio/libwinpthread-1.dll
(gdb) bt
#0  0x0000000064943236 in pthread_mutex_unlock ()
   from /cygdrive/c/program files/fio/libwinpthread-1.dll
#1  0x000000000000000f in ?? ()
#2  0x0000000000422f79 in fio_mutex_up (mutex=0x305b70) at mutex.c:152
#3  0x0000000000438d71 in run_threads () at backend.c:1812
#4  0x000000000043918d in fio_backend () at backend.c:1925
#5  0x000000000044ba31 in main (argc=<optimized out>, argv=<optimized out>, envp=<optimized out>)
    at fio.c:50
#6  0x00000000004013c5 in __tmainCRTStartup ()
    at /usr/src/debug/mingw64-x86_64-runtime-3.0.0-1/crt/crtexe.c:332
#7  0x00000000004014e8 in mainCRTStartup ()
    at /usr/src/debug/mingw64-x86_64-runtime-3.0.0-1/crt/crtexe.c:212
(gdb) f 2
#2  0x0000000000422f79 in fio_mutex_up (mutex=0x305b70) at mutex.c:152
152                     pthread_cond_signal(&mutex->cond);
(gdb) p mutex
$1 = (struct fio_mutex *) 0x305b70
(gdb) p *mutex
$2 = {lock = 0x1bab1f00d, cond = 0x100000000, value = 0, waiters = 0, magic = 176}
(gdb)



> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Bruce Cran
> Sent: Friday, 10 January, 2014 12:11 AM
> To: Sitsofe Wheeler; Elliott, Robert (Server Storage)
> Cc: fio@vger.kernel.org
> Subject: Re: fio 2.1.4 intermittently crashes on windows
> 
> 
> On 1/9/2014 10:21 PM, Sitsofe Wheeler wrote:
> > On Fri, Jan 10, 2014 at 12:37:33AM +0000, Elliott, Robert (Server Storage)
> wrote:
> >> I installed Cygwin gcc, mingwg64*, make, and a few other packages...
> >>
> >> The built fio.exe ends up complaining about a missing libpthread1-1.dll.
> >>
> >> Where do I find that?  README says where to get pthreadGC2.dll, but
> >> that's apparently not the right file any more.  Browsing up on that
> >> FTP site doesn't show it nearby.
> > You're right - the README is out of date. If you (re)run your Cygwin
> > setup exe then you can use its package browser to install
> > mingw[...]-winpthreads .
> 
> 
> Sorry - Cygwin switched from pthreads-win32 to winpthreads a couple of
> months ago and I forgot to update the README during the last set of
> changesets.
> 
> --
> Bruce Cran
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

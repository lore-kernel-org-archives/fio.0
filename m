Return-Path: <fio-owner@vger.kernel.org>
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:38066 "HELO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757036AbaAHWEM convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 8 Jan 2014 17:04:12 -0500
From: Todd Dworshak <todd.dworshak@avid.com>
Subject: RE: fio 2.1.4 intermittently crashes on windows
Date: Wed, 8 Jan 2014 22:02:04 +0000
Message-ID: <0C4FACE8A034424CB177F7934C49B4ED080FFDA8@WAL-MBS04.global.avidww.com>
References: <0C4FACE8A034424CB177F7934C49B4ED080FE9AF@WAL-MBS04.global.avidww.com>
 <52BE337F.10106@cran.org.uk>
In-Reply-To: <52BE337F.10106@cran.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 'Bruce Cran' <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>

I ran fio in gdb and got the crash.  The stack trace is below.  Not sure if this is a bug in libwinpthread-1.dll or in the way fio is calling it.

Program received signal SIGSEGV, Segmentation fault.
0x0000000064943236 in pthread_mutex_unlock ()
   from /cygdrive/c/program files/fio/libwinpthread-1.dll
(gdb) bt
#0  0x0000000064943236 in pthread_mutex_unlock ()
   from /cygdrive/c/program files/fio/libwinpthread-1.dll
#1  0x0000000000000009 in ?? ()
#2  0x0000000000421599 in fio_mutex_up (mutex=0x79a2b0) at mutex.c:151
#3  0x0000000000437ce0 in run_threads () at backend.c:1812
#4  0x000000000043809d in fio_backend () at backend.c:1925
#5  0x0000000000449411 in main (argc=<optimized out>, argv=<optimized out>,
    envp=<optimized out>) at fio.c:50
#6  0x00000000004013a5 in __tmainCRTStartup ()
    at /usr/src/debug/mingw64-x86_64-runtime-3.0.0-1/crt/crtexe.c:332
#7  0x00000000004014d8 in mainCRTStartup ()
    at /usr/src/debug/mingw64-x86_64-runtime-3.0.0-1/crt/crtexe.c:212
(gdb) f 2
#2  0x0000000000421599 in fio_mutex_up (mutex=0x79a2b0) at mutex.c:151
151     mutex.c: No such file or directory.
(gdb) p mutex
$1 = (struct fio_mutex *) 0x79a2b0
(gdb) p *mutex
$2 = {lock = 0x1bab1f00d, cond = 0x100000000, value = 0, waiters = 0,
  magic = 280}

-----Original Message-----
From: Bruce Cran [mailto:bruce@cran.org.uk] 
Sent: Friday, December 27, 2013 9:12 PM
To: Todd Dworshak; fio@vger.kernel.org
Subject: Re: fio 2.1.4 intermittently crashes on windows

On 12/27/2013 6:42 PM, Todd Dworshak wrote:
> I am having trouble with fio intermittently crashing on Windows 7.
>
> Version is fio 2.1.4 64 bit, downloaded from Windows build site.
>
> Has anyone else seen this?  If I give it fewer files in the job description, it seems to be less prone to crashing.  Since it crashes in pthreads, it looks like this may be some kind of threading bug.

I'll try to replicate the problem here, but in the meantime it would be useful if you could try running fio under the Cygwin build of gdb to capture a stack trace in fio.exe.

--
Bruce

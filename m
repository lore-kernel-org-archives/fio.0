Return-Path: <sits@sucs.org>
Date: Tue, 11 Feb 2014 07:07:20 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Mutex destruction, invalid memory accesses, leaks
Message-ID: <20140211070719.GA1187@sucs.org>
References: <20140206192135.GB3950@kernel.dk>
 <20140207034439.GA17588@sucs.org>
 <52F505A8.30004@kernel.dk>
 <20140209195042.GA17058@sucs.org>
 <52F927AC.6020007@cran.org.uk>
 <20140210202245.GA6747@sucs.org>
 <20140210205659.GC4096@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B4029548A645A@G9W0745.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029548A645A@G9W0745.americas.hpqcorp.net>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Tue, Feb 11, 2014 at 12:12:54AM +0000, Elliott, Robert (Server Storage) wrote:
> 
> > -----Original Message-----
> > From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> > Behalf Of Jens Axboe
> > 
> > Actually, the previous wont work, and I don't see how to make it work.
> > Please try the below instead. Or just re-pull, I'll check it in now.
> > 
> The latest pulled version with this change works on my Windows Server 2008 R2 system that was crashing with 2-1.4.

Still a problem here:

$ git rev-parse HEAD
ea66e04fe1a803f6a9ddf31cb999641d4396d67c
$ ./fio.exe --version
fio-2.1.4-48-gea66
$ gdb --args ./fio.exe --debug=all --filename=fiojob --thread --size=512 --rw=re
ad --bs=512 --ioengine=sync --verify_pattern=0xdeadbeef --name=fiojobname
GNU gdb (GDB) 7.6.50.20130728-cvs (cygwin-special)
<snip>
Reading symbols from /home/Sitsofe Wheeler/fio/fio.exe...done.
(gdb) ru
Starting program: /home/Sitsofe Wheeler/fio/fio.exe --debug=all --filename=fioj
b --thread --size=512 --rw=read --bs=512 --ioengine=sync --verify_pattern=0xdead
beef --name=fiojobname
[New Thread 1756.0xbe0]
[New Thread 1756.0x8e8]
fio: set all debug options
io       1756  load ioengine windowsaio
parse    1756  handle_option=filename, ptr=fiojob
parse    1756  __handle_option=filename, type=5, ptr=fiojob
file     1756  add file fiojob
file     1756  resize file array to 1 files
file     1756  file 01F40008 "fiojob" added at 0
parse    1756  handle_option=thread, ptr=(null)
parse    1756  __handle_option=thread, type=10, ptr=(null)
parse    1756    ret=0, out=1
parse    1756  handle_option=size, ptr=512
parse    1756  __handle_option=size, type=3, ptr=512
parse    1756    ret=0, out=512
parse    1756  handle_option=rw, ptr=read
parse    1756  __handle_option=rw, type=1, ptr=read
parse    1756  handle_option=bs, ptr=512
parse    1756  __handle_option=bs, type=7, ptr=512
parse    1756    ret=0, out=512
parse    1756  handle_option=ioengine, ptr=sync
parse    1756  __handle_option=ioengine, type=5, ptr=sync
io       1756  free ioengine windowsaio
io       1756  load ioengine sync
parse    1756  handle_option=verify_pattern, ptr=0xdeadbeef
parse    1756  __handle_option=verify_pattern, type=1, ptr=0xdeadbeef
file     1756  dup files: 1
io       1756  load ioengine sync
parse    1756  handle_option=name, ptr=fiojobname
parse    1756  __handle_option=name, type=5, ptr=fiojobname
fiojobname: (g=0): rw=read, bs=512-512/512-512/512-512, ioengine=sync, iodepth=1
parse    1756  free options
fio-2.1.4-48-gea66
time     1756  cycles[0]=2593
time     1756  cycles[1]=2593
time     1756  cycles[2]=2593
time     1756  cycles[3]=2593
time     1756  cycles[4]=2594
time     1756  cycles[5]=2592
time     1756  cycles[6]=2593
time     1756  cycles[7]=2593
time     1756  cycles[8]=2593
time     1756  cycles[9]=2593
time     1756  cycles[10]=2593
time     1756  cycles[11]=2593
time     1756  cycles[12]=2593
time     1756  cycles[13]=2593
time     1756  cycles[14]=2593
time     1756  cycles[15]=2593
time     1756  cycles[16]=2593
time     1756  cycles[17]=2593
time     1756  cycles[18]=2593
time     1756  cycles[19]=2593
time     1756  cycles[20]=2593
time     1756  cycles[21]=2593
time     1756  cycles[22]=2593
time     1756  cycles[23]=2593
time     1756  cycles[24]=2593
time     1756  cycles[25]=2593
time     1756  cycles[26]=2593
time     1756  cycles[27]=2593
time     1756  cycles[28]=2593
time     1756  cycles[29]=2593
time     1756  cycles[30]=2593
time     1756  cycles[31]=2593
time     1756  cycles[32]=2593
time     1756  cycles[33]=2593
time     1756  cycles[34]=2593
time     1756  cycles[35]=2593
time     1756  cycles[36]=2593
time     1756  cycles[37]=2593
time     1756  cycles[38]=2593
time     1756  cycles[39]=2593
time     1756  cycles[40]=2593
time     1756  cycles[41]=2593
time     1756  cycles[42]=2593
time     1756  cycles[43]=2593
time     1756  cycles[44]=2593
time     1756  cycles[45]=2593
time     1756  cycles[46]=2593
time     1756  cycles[47]=2593
time     1756  cycles[48]=2593
time     1756  cycles[49]=2593
time     1756  avg: 2594
time     1756  mean=2593.572000, S=0.042769
time     1756  inv_cycles_per_usec=6467
mutex    1756  wait on startup_mutex
mutex    1756  done waiting on startup_mutex
Starting 1 thread
[New Thread 1756.0x1a0]

Program received signal SIGSEGV, Segmentation fault.
0x0043e1de in pthread_mutex_unlock (m=0x4f80000)
    at /usr/src/debug/mingw64-i686-winpthreads-3.1.0-1/src/mutex.c:392
(gdb) thread apply all bt

Thread 3 (Thread 1756.0x1a0):
#0  0x775dfd91 in ntdll!ZwDelayExecution ()
   from /cygdrive/c/Windows/system32/ntdll.dll
#1  0x775dfd91 in ntdll!ZwDelayExecution ()
   from /cygdrive/c/Windows/system32/ntdll.dll
#2  0x76933bc8 in SleepEx () from /cygdrive/c/Windows/syswow64/KERNELBASE.dll
#3  0x00000000 in ?? ()

Thread 2 (Thread 1756.0x8e8):
#0  0x775dfd91 in ntdll!ZwDelayExecution ()
   from /cygdrive/c/Windows/system32/ntdll.dll
#1  0x775dfd91 in ntdll!ZwDelayExecution ()
   from /cygdrive/c/Windows/system32/ntdll.dll
#2  0x76933bc8 in SleepEx () from /cygdrive/c/Windows/syswow64/KERNELBASE.dll
#3  0x00000000 in ?? ()

Thread 1 (Thread 1756.0xbe0):
#0  0x0043e1de in pthread_mutex_unlock (m=0x4f80000)
    at /usr/src/debug/mingw64-i686-winpthreads-3.1.0-1/src/mutex.c:392
#1  0x0041bc48 in fio_mutex_up (mutex=0x4f80000) at mutex.c:153
#2  0x00433c84 in run_threads () at backend.c:1885
#3  0x00434005 in fio_backend () at backend.c:1998
#4  0x00449a14 in main (argc=10, argv=0x9a28b0, envp=0x9a19a0) at fio.c:50

-- 
Sitsofe | http://sucs.org/~sits/


Return-Path: <sits@sucs.org>
Date: Wed, 12 Feb 2014 06:32:36 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Mutex destruction, invalid memory accesses, leaks
Message-ID: <20140212063228.GA8423@sucs.org>
References: <52F505A8.30004@kernel.dk>
 <20140209195042.GA17058@sucs.org>
 <52F927AC.6020007@cran.org.uk>
 <20140210202245.GA6747@sucs.org>
 <20140210205659.GC4096@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B4029548A645A@G9W0745.americas.hpqcorp.net>
 <20140211070719.GA1187@sucs.org>
 <94D0CD8314A33A4D9D801C0FE68B4029548A66EB@G9W0745.americas.hpqcorp.net>
 <20140211153846.GB19057@kernel.dk>
 <20140211225131.GA8849@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211225131.GA8849@sucs.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

OK linking against a hand built winpthreads (with -O1 in CFLAGS and
LDFLAGS):

$ gdb --args ./fio.exe --debug=all --filename=fiojob --thread --size=512 --rw=read --bs=512 --ioengine=sync --verify_pattern=0xdeadbeef --name=fiojobname                     GNU gdb (GDB) 7.6.50.20130728-cvs (cygwin-special)
Copyright (C) 2013 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "i686-pc-cygwin".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word".
..
Reading symbols from /home/Sitsofe Wheeler/fio/fio.exe...done.
(gdb) ru
Starting program: /home/Sitsofe Wheeler/fio/fio.exe --debug=all --filename=fiojob --thread --size=512 --rw=read --bs=512 --ioengine=sync --verify_pattern=0xdeadbeef --name=fiojobname
[New Thread 1224.0xeb8]
[New Thread 1224.0xf8c]
fio: set all debug options
io       1224  load ioengine windowsaio
parse    1224  handle_option=filename, ptr=fiojob
parse    1224  __handle_option=filename, type=5, ptr=fiojob
file     1224  add file fiojob
file     1224  resize file array to 1 files
file     1224  file 02130008 "fiojob" added at 0
parse    1224  handle_option=thread, ptr=(null)
parse    1224  __handle_option=thread, type=10, ptr=(null)
parse    1224    ret=0, out=1
parse    1224  handle_option=size, ptr=512
parse    1224  __handle_option=size, type=3, ptr=512
parse    1224    ret=0, out=512
parse    1224  handle_option=rw, ptr=read
parse    1224  __handle_option=rw, type=1, ptr=read
parse    1224  handle_option=bs, ptr=512
parse    1224  __handle_option=bs, type=7, ptr=512
parse    1224    ret=0, out=512
parse    1224  handle_option=ioengine, ptr=sync
parse    1224  __handle_option=ioengine, type=5, ptr=sync
io       1224  free ioengine windowsaio
io       1224  load ioengine sync
parse    1224  handle_option=verify_pattern, ptr=0xdeadbeef
parse    1224  __handle_option=verify_pattern, type=1, ptr=0xdeadbeef
file     1224  dup files: 1
io       1224  load ioengine sync
parse    1224  handle_option=name, ptr=fiojobname
parse    1224  __handle_option=name, type=5, ptr=fiojobname
fiojobname: (g=0): rw=read, bs=512-512/512-512/512-512, ioengine=sync, iodepth=1
parse    1224  free options
fio-2.1.4-48-gea66
time     1224  cycles[0]=2593
time     1224  cycles[1]=2593
time     1224  cycles[2]=2593
time     1224  cycles[3]=2592
time     1224  cycles[4]=2593
time     1224  cycles[5]=2758
time     1224  cycles[6]=2594
time     1224  cycles[7]=2594
time     1224  cycles[8]=2593
time     1224  cycles[9]=2598
time     1224  cycles[10]=2592
time     1224  cycles[11]=2593
time     1224  cycles[12]=2593
time     1224  cycles[13]=2593
time     1224  cycles[14]=2593
time     1224  cycles[15]=3518
time     1224  cycles[16]=2593
time     1224  cycles[17]=2593
time     1224  cycles[18]=2593
time     1224  cycles[19]=2593
time     1224  cycles[20]=2593
time     1224  cycles[21]=2593
time     1224  cycles[22]=2593
time     1224  cycles[23]=2593
time     1224  cycles[24]=2593
time     1224  cycles[25]=2593
time     1224  cycles[26]=2593
time     1224  cycles[27]=2593
time     1224  cycles[28]=2593
time     1224  cycles[29]=2593
time     1224  cycles[30]=2592
time     1224  cycles[31]=2593
time     1224  cycles[32]=2593
time     1224  cycles[33]=2593
time     1224  cycles[34]=2593
time     1224  cycles[35]=2593
time     1224  cycles[36]=2593
time     1224  cycles[37]=2593
time     1224  cycles[38]=2593
time     1224  cycles[39]=2593
time     1224  cycles[40]=2593
time     1224  cycles[41]=2593
time     1224  cycles[42]=2593
time     1224  cycles[43]=2593
time     1224  cycles[44]=2593
time     1224  cycles[45]=2593
time     1224  cycles[46]=2593
time     1224  cycles[47]=2593
time     1224  cycles[48]=2593
time     1224  cycles[49]=2593
time     1224  avg: 2593
time     1224  mean=2615.262000, S=26.484294
time     1224  inv_cycles_per_usec=6470
mutex    1224  wait on startup_mutex
mutex    1224  done waiting on startup_mutex
Starting 1 thread
[New Thread 1224.0xc40]

Program received signal SIGSEGV, Segmentation fault.
mutex_unref (m=m@entry=0x830000, r=r@entry=0) at src/mutex.c:42
42        mutex_t *m_ = (mutex_t *)*m;
(gdb) bt
#0  mutex_unref (m=m@entry=0x830000, r=r@entry=0) at src/mutex.c:42
#1  0x00438e3f in pthread_mutex_unlock (m=m@entry=0x830000) at
src/mutex.c:392
#2  0x004188a4 in fio_mutex_up (mutex=0x830000) at mutex.c:153
#3  0x0042f5b4 in run_threads () at backend.c:1885
#4  0x0042f790 in fio_backend () at backend.c:1998
#5  0x00438afe in main (argc=10, argv=0x3d28a0, envp=0x3d1998) at
fio.c:50
(gdb) print *m
Cannot access memory at address 0x830000
(gdb) list
37      static pthread_spinlock_t mutex_global_static = PTHREAD_SPINLOCK_INITIALIZER;
38
39      static WINPTHREADS_ATTRIBUTE((noinline)) int
40      mutex_unref (pthread_mutex_t *m, int r)
41      {
42        mutex_t *m_ = (mutex_t *)*m;
43        pthread_spin_lock (&mutex_global);
44      #ifdef WINPTHREAD_DBG
45        assert((m_->valid == LIFE_MUTEX) && (m_->busy > 0));
46      #endif
(gdb) up
#1  0x00438e3f in pthread_mutex_unlock (m=m@entry=0x830000) at src/mutex.c:392
392       return mutex_unref(m,0);
(gdb) list pthread_mutex_unlock
334       r = pthread_mutex_lock_intern(m, (ct > t ? 0 : (t - ct)));
335       return  r;
336     }
337
338     int pthread_mutex_unlock(pthread_mutex_t *m)
339     {
340       mutex_t *_m;
341       int r = mutex_ref_unlock(m);
342
343       if(r) {
(gdb)
344     #if 0
345         printf("thread %d, la pool, no user unset in mutex %p\n", GetCurrentThreadId(), m);
346     #endif
347         return r;
348       }
349
350       _m = (mutex_t *)*m;
351
352       if (_m->type == PTHREAD_MUTEX_NORMAL)
353       {
(gdb)
354         if (!COND_LOCKED(_m))
355           {
356     #if 0
357               printf("thread %d, mutex %p never locked, actually :p\n", GetCurrentThreadId(), m);
358     #endif
359               return mutex_unref(m, EPERM);
360           }
361       }
362       else if (!COND_LOCKED(_m) || !COND_OWNER(_m)) {
363     #if 0
(gdb)
364         printf("thread %d, mutex %p never locked or not owner, actually :p\n", GetCurrentThreadId(), m);
365     #endif
366         return mutex_unref(m,EPERM);
367       }
368
369       if (_m->type == PTHREAD_MUTEX_RECURSIVE)
370       {
371         if(InterlockedDecrement(&_m->count)) {
372     #if 0
373               printf("thread %d, mutex %p decreasing recursive\n", GetCurrentThreadId(), m);
(gdb)
374     #endif
375               return mutex_unref(m,0);
376             }
377       }
378     #if 0
379       printf("thread %d,unsetting owner of mutex %p\n", GetCurrentThreadId(), m);
380     #endif
381       UNSET_OWNER(_m);
382
383       if (_m->h != NULL && !ReleaseSemaphore(_m->h, 1, NULL)) {
(gdb)
384             SET_OWNER(_m);
385     #if 0
386             printf("Error, not released! thread %d, setting owner of mutex m\n", GetCurrentThreadId(), m);
387     #endif
388         /* restore our own bookkeeping */
389         return mutex_unref(m,EPERM);
390       }
391
392       return mutex_unref(m,0);
393     }
(gdb)
394
395     static WINPTHREADS_ATTRIBUTE((noinline)) int
396     _mutex_trylock(pthread_mutex_t *m)
397     {
398       int r = 0;
399       mutex_t *_m = (mutex_t *)*m;
400
401       if (_m->type != PTHREAD_MUTEX_NORMAL)
402       {
403         if (COND_LOCKED(_m))
(gdb) info locals
_m = 0x3d45d0
r = <optimized out>
(gdb) print m
$1 = (pthread_mutex_t *) 0x830000

On Tue, Feb 11, 2014 at 10:51:49PM +0000, Sitsofe Wheeler wrote:
> I can't tell if this is just a gdb quirk because I haven't hand built
> winpthreads but:
> 
> Program received signal SIGSEGV, Segmentation fault.
> 0x0043e1de in pthread_mutex_unlock (m=0x790000) at
> /usr/src/debug/mingw64-i686-winpthreads-3.1.0-1/src/mutex.c:392
> (gdb) list
> Line number 392 out of range;
> /usr/src/debug/mingw64-i686-winpthreads-3.1.0-1/src/mutex.c has 228
> lines.
> 
> As Elliott mentioned the windowaio engine doesn't exhibit this problem
> (but perhaps it causes different thread scheduling?)...
> 
> On Tue, Feb 11, 2014 at 08:38:46AM -0700, Jens Axboe wrote:
> > Interesting. The mutex issue should be fixed, I'm puzzled why it isn't.
> > And especially if the sync ioengine has something to do with it. Can
> > either of you dump the source around:
> > 
> >   at
> >   /usr/src/debug/mingw64-i686-winpthreads-3.1.0-1/src/mutex.c:392
> > 
> > perhaps that will clear things up a bit more?
> > 
> > On Tue, Feb 11 2014, Elliott, Robert (Server Storage) wrote:
> > > That specific command line does also crash on my Windows 2008 R2 system.  It does not crash if I drop --ioengine=sync.
> > > 
> > > > -----Original Message-----
> > > > From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> > > > Behalf Of Sitsofe Wheeler
> > > > 
> > > > $ gdb --args ./fio.exe --debug=all --filename=fiojob --thread --size=512 --
> > > > rw=re
> > > > ad --bs=512 --ioengine=sync --verify_pattern=0xdeadbeef --
> > > > name=fiojobname

-- 
Sitsofe | http://sucs.org/~sits/


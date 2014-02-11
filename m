Return-Path: <sits@sucs.org>
Date: Tue, 11 Feb 2014 22:51:49 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Mutex destruction, invalid memory accesses, leaks
Message-ID: <20140211225131.GA8849@sucs.org>
References: <20140207034439.GA17588@sucs.org>
 <52F505A8.30004@kernel.dk>
 <20140209195042.GA17058@sucs.org>
 <52F927AC.6020007@cran.org.uk>
 <20140210202245.GA6747@sucs.org>
 <20140210205659.GC4096@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B4029548A645A@G9W0745.americas.hpqcorp.net>
 <20140211070719.GA1187@sucs.org>
 <94D0CD8314A33A4D9D801C0FE68B4029548A66EB@G9W0745.americas.hpqcorp.net>
 <20140211153846.GB19057@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211153846.GB19057@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

I can't tell if this is just a gdb quirk because I haven't hand built
winpthreads but:

Program received signal SIGSEGV, Segmentation fault.
0x0043e1de in pthread_mutex_unlock (m=0x790000) at
/usr/src/debug/mingw64-i686-winpthreads-3.1.0-1/src/mutex.c:392
(gdb) list
Line number 392 out of range;
/usr/src/debug/mingw64-i686-winpthreads-3.1.0-1/src/mutex.c has 228
lines.

As Elliott mentioned the windowaio engine doesn't exhibit this problem
(but perhaps it causes different thread scheduling?)...

On Tue, Feb 11, 2014 at 08:38:46AM -0700, Jens Axboe wrote:
> Interesting. The mutex issue should be fixed, I'm puzzled why it isn't.
> And especially if the sync ioengine has something to do with it. Can
> either of you dump the source around:
> 
>   at
>   /usr/src/debug/mingw64-i686-winpthreads-3.1.0-1/src/mutex.c:392
> 
> perhaps that will clear things up a bit more?
> 
> On Tue, Feb 11 2014, Elliott, Robert (Server Storage) wrote:
> > That specific command line does also crash on my Windows 2008 R2 system.  It does not crash if I drop --ioengine=sync.
> > 
> > > -----Original Message-----
> > > From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> > > Behalf Of Sitsofe Wheeler
> > > 
> > > $ gdb --args ./fio.exe --debug=all --filename=fiojob --thread --size=512 --
> > > rw=re
> > > ad --bs=512 --ioengine=sync --verify_pattern=0xdeadbeef --
> > > name=fiojobname

-- 
Sitsofe | http://sucs.org/~sits/


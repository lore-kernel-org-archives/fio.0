Return-Path: <sits@sucs.org>
Date: Mon, 10 Feb 2014 09:55:57 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Mutex destruction, invalid memory accesses, leaks
Message-ID: <20140210095557.GA3300@sucs.org>
References: <20140206192135.GB3950@kernel.dk>
 <20140207034439.GA17588@sucs.org>
 <52F505A8.30004@kernel.dk>
 <20140209195042.GA17058@sucs.org>
 <52F7E9D9.4040208@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F7E9D9.4040208@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Sun, Feb 09, 2014 at 01:49:29PM -0700, Jens Axboe wrote:
> On 2014-02-09 12:50, Sitsofe Wheeler wrote:
> >
> >Yes it's still happening with -git from a moment ago. What is stopping a
> >sleeping thread from holding a mutex that is destroyed and then waking
> >up on it after the memory has been unmapped?
> 
> If you look at the particular use case, it looks like this:
> 
> [io thread]		[main thread]
> mutex_down(mutex);
> 			mutex_up(mutex);
> mutex_kill(mutex);
> 
> and mutex isn't used after that kill. The trace you sent looks like
> the io thread doing down successfully (which it should not), then
> proceeding to killing the mutex. The main thread then runs into
> problems attempting to up a mute that has been freed. Hence why I
> think this is an issue in the windows pthread mutexes, that should
> not happen.

OK, I'll need to think on this a bit more but I have to admit I've never
seen this issue on Linux (but then again I don't tend to use thread mode
that much on Linux).

> >Here's the Dr Memory output:
> >Error #1: UNADDRESSABLE ACCESS: reading 2 byte(s)
> ># 6 KERNEL32.dll!BaseThreadInitThunk
> 
> I'll take a look at these. How did you invoke fio for the above report?

Firstly you MUST build the 32 bit version of fio - Dr Memory currently
does not work on 64 bit binaries. After downloading and installing the
latest Dr Memory exe from
https://code.google.com/p/drmemory/downloads/list :
CFLAGS="-fno-inline -fno-omit-frame-pointer" ./configure --build-32bit-win --extra-cflags="-fno-inline -fno-omit-frame-pointer"
make -j 4
'/cygdrive/c/Users/Sitsofe/Documents/DrMemory-Windows-1.6.1-2/DrMemory-Windows-1.6.1-2/bin/drmemory.exe' -brief -- ./fio.exe --debug=all --thread --filename=fiojob --size=512 --rw=read --bs=512 --ioengine=sync --verify_pattern=0xdeadbeef --name=fiojobname

A word of warning, cygwin's error_start environment variable and
dumper.exe do not support 64 bit binaries. For some reason this seems to
include 32 bit binaries built using a w64-mingw.

On a side note I'm sorry to report that AddressSanitizer is not
available in mingw's gcc 4.8.2 nor is it available in cygwin's current
clang (3.1-3). If you try to use the prebuilt Windows clang builds
floating around you will find they expect the MS Visual Studio's linker
and even with fiddling those versions of clang refuse to compile fio. In
fact on Windows fio can't be compiled with the 32 bit pc-mingw32
compiler - you have to use w64-mingw or you will find lots of functions
(like rand_r) can't be found. I suspect this also means that fio can't
currently be built with Visual Studio...

-- 
Sitsofe | http://sucs.org/~sits/


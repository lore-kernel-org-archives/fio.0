Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37831 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbfJ0Ueg (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 27 Oct 2019 16:34:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id e11so7765893wrv.4
        for <fio@vger.kernel.org>; Sun, 27 Oct 2019 13:34:33 -0700 (PDT)
MIME-Version: 1.0
References: <BY5PR21MB14922563C2166CDB9268784FDF6D0@BY5PR21MB1492.namprd21.prod.outlook.com>
 <CALjAwxhqfLCVN+q7NJ+KVWxg5CAsyM+AZizdmUDoaH9z12Rkfg@mail.gmail.com>
In-Reply-To: <CALjAwxhqfLCVN+q7NJ+KVWxg5CAsyM+AZizdmUDoaH9z12Rkfg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 27 Oct 2019 20:34:06 +0000
Message-ID: <CALjAwxjpiTfdUupdPOZnbb_cK=Y0rP1GwnVy1rqbYFw8pZhG5g@mail.gmail.com>
Subject: Re: build issue
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Astolfo Rueda <astolfor@microsoft.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Rebecca Cran <rebecca@bluestop.org>

Hi,

On Sat, 19 Oct 2019 at 08:11, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> Hi,
>
> On Fri, 18 Oct 2019 at 23:18, Astolfo Rueda <astolfor@microsoft.com> wrote:
> >
> > Hello I am trying to build FIO and I get these errors.
> > The server is windows 10, with latest Cygwin.
> >
> > What am I doing wrong?
>
> You're not doing anything wrong from what I can see - it looks like
> sounds like some sort of compiler issue...
>
> > Thanks
> > Astolfo
> >
> >
> > /tmp/ccQfIUjv.s: Assembler messages:
> > /tmp/ccQfIUjv.s:1188: Error: invalid register for .seh_savexmm
> > make: *** [Makefile:376: filehash.o] Error 1
> > make: *** Waiting for unfinished jobs....
> > /tmp/ccZfFBQo.s: Assembler messages:
> > /tmp/ccZfFBQo.s:3812: Error: invalid register for .seh_savexmm
> > /tmp/ccZfFBQo.s:3814: Error: invalid register for .seh_savexmm
> > /tmp/ccZfFBQo.s:3816: Error: invalid register for .seh_savexmm
> > /tmp/ccZfFBQo.s:3818: Error: invalid register for .seh_savexmm
> > /tmp/ccZfFBQo.s:3820: Error: invalid register for .seh_savexmm
> > /tmp/ccZfFBQo.s:3822: Error: invalid register for .seh_savexmm
> > /tmp/ccZfFBQo.s:3824: Error: invalid register for .seh_savexmm
> > /tmp/ccZfFBQo.s:3826: Error: invalid register for .seh_savexmm
> > /tmp/ccZfFBQo.s:3828: Error: invalid register for .seh_savexmm
> > /tmp/ccZfFBQo.s:3830: Error: invalid register for .seh_savexmm
> > /tmp/ccZfFBQo.s:3832: Error: invalid register for .seh_savexmm
> > /tmp/ccZfFBQo.s:3834: Error: invalid register for .seh_savexmm
> > make: *** [Makefile:379: options.o] Error 1
>
> Hmm. This might be down to a compatibility issue between
> x86_64-w64-mingw32-gcc and Windows when using AVX512 (and whether fio
> defaults to compiling with such options will depend on the compilation
> environment). If you do
>
> ./configure --extra-cflags="-fno-asynchronous-unwind-tables"
> make -j
>
> etc. are things any better?

So I've managed to find a recent Xeon server with Windows VM and I see
the compile errors you describe on it too. Doing
make clean
./configure --extra-cflags="-fno-asynchronous-unwind-tables"
make -j

fixes the "invalid register for .seh_savexmm" error for me. Another
workaround is to disable the generation of problematic AVX
instructions:
make clean
./configure --extra-cflags="-mno-avx512f"
make -j

but the binary made might be ever so slightly slower (and you'd need
incredibly fast disks and when I did a quick check with the null
ioengine I actually found the non-AVX512 version of fio was faster in
my VM...).

It looks like this is the "gcc/mingw-gcc fails to align the stack
properly to Windows' requirements when using AVX 512 instructions"
issue:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=65782
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=54412
https://stackoverflow.com/questions/30928265/mingw64-is-incapable-of-32-byte-stack-alignment-required-for-avx-on-windows-x64
https://stackoverflow.com/questions/43152633/invalid-register-for-seh-savexmm-in-cygwin

-- 
Sitsofe | http://sucs.org/~sits/


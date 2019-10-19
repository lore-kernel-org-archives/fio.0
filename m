Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f54.google.com ([209.85.128.54]:35848 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfJSHMK (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 19 Oct 2019 03:12:10 -0400
Received: by mail-wm1-f54.google.com with SMTP id m18so8064843wmc.1
        for <fio@vger.kernel.org>; Sat, 19 Oct 2019 00:12:09 -0700 (PDT)
MIME-Version: 1.0
References: <BY5PR21MB14922563C2166CDB9268784FDF6D0@BY5PR21MB1492.namprd21.prod.outlook.com>
In-Reply-To: <BY5PR21MB14922563C2166CDB9268784FDF6D0@BY5PR21MB1492.namprd21.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 19 Oct 2019 08:11:42 +0100
Message-ID: <CALjAwxhqfLCVN+q7NJ+KVWxg5CAsyM+AZizdmUDoaH9z12Rkfg@mail.gmail.com>
Subject: Re: build issue
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Astolfo Rueda <astolfor@microsoft.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On Fri, 18 Oct 2019 at 23:18, Astolfo Rueda <astolfor@microsoft.com> wrote:
>
> Hello I am trying to build FIO and I get these errors.
> The server is windows 10, with latest Cygwin.
>
> What am I doing wrong?

You're not doing anything wrong from what I can see - it looks like
sounds like some sort of compiler issue...

> Thanks
> Astolfo
>
>
> /tmp/ccQfIUjv.s: Assembler messages:
> /tmp/ccQfIUjv.s:1188: Error: invalid register for .seh_savexmm
> make: *** [Makefile:376: filehash.o] Error 1
> make: *** Waiting for unfinished jobs....
> /tmp/ccZfFBQo.s: Assembler messages:
> /tmp/ccZfFBQo.s:3812: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3814: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3816: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3818: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3820: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3822: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3824: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3826: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3828: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3830: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3832: Error: invalid register for .seh_savexmm
> /tmp/ccZfFBQo.s:3834: Error: invalid register for .seh_savexmm
> make: *** [Makefile:379: options.o] Error 1

Hmm. This might be down to a compatibility issue between
x86_64-w64-mingw32-gcc and Windows when using AVX512 (and whether fio
defaults to compiling with such options will depend on the compilation
environment). If you do

./configure --extra-cflags="-fno-asynchronous-unwind-tables"
make -j

etc. are things any better?

-- 
Sitsofe | http://sucs.org/~sits/


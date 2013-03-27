Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vb0-f41.google.com ([209.85.212.41]:50227 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab3C0D5H (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 26 Mar 2013 23:57:07 -0400
Received: by mail-vb0-f41.google.com with SMTP id l22so5031331vbn.28
        for <fio@vger.kernel.org>; Tue, 26 Mar 2013 20:57:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGpXXZ+CSFx7tnWjgUibNEgth_9kM4qTP_ptW+kTFeDCfoC08w@mail.gmail.com>
References: <CAGpXXZ+CSFx7tnWjgUibNEgth_9kM4qTP_ptW+kTFeDCfoC08w@mail.gmail.com>
Date: Wed, 27 Mar 2013 14:57:07 +1100
Message-ID: <CAKCZDgkX1JPo6_+cUzAU3bCo_ceawyd64Ki08BVZS7y4Uoooqg@mail.gmail.com>
Subject: Re: FIO 2.0.14 - getting a compile error on opensuse
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: fio@vger.kernel.org

On 26 March 2013 05:44, Greg Freemyer <greg.freemyer@gmail.com> wrote:
> But this is the basic error which happens on the first gcc call.
>
> [   48s] gcc -o gettime.o -std=gnu99 -Wwrite-strings -Wall
> -fomit-frame-pointer -fmessage-length=0 -grecord-gcc-switches -O2
> -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables
> -fasynchronous-unwind-tables -DBITS_PER_LONG=32
> -DFIO_VERSION='"fio-2.0.14"' -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG -c
> gettime.c

Something has happened to the CFLAGS -- you're missing -D_GNU_SOURCE
which is needed for the definition of CPU_ZERO.

I can get the same behaviour with:
   make EXTFLAGS=
but then I got confused looking at the Makefile. I don't understand
how that ever works, since EXTFLAGS is used before it's defined.


    -- Aaron

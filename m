Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:27430 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab1DWKGp (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 23 Apr 2011 06:06:45 -0400
Date: Sat, 23 Apr 2011 11:06:36 +0100
From: Bruce Cran <bruce@cran.org.uk>
Subject: Re: [BUG] [PATCH] Undefined symbols: "_posix_memalign" on Mac OS X
Message-ID: <20110423110636.00004ef3@unknown>
In-Reply-To: <BANLkTiktKRjW235qUUFAMES88BbQXNc5cw@mail.gmail.com>
References: <BANLkTiktKRjW235qUUFAMES88BbQXNc5cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Filip Sneppe <filip.sneppe@gmail.com>
Cc: fio@vger.kernel.org

On Sat, 23 Apr 2011 05:57:26 +0200
Filip Sneppe <filip.sneppe@gmail.com> wrote:
 
> (I am not subscribed to this list, nor am I a Unix developer).
> 
> I wanted to give fio a try on my OS X 10.5.8 machine, but
> this is the error I received when compiling:
> 
>     CC helpers.o
>     CC engines/posixaio.o
>     DEP depend
>     CC fio
> Undefined symbols:
>   "_posix_memalign", referenced from:
>       _thread_main in fio.o
> ld: symbol(s) not found
> collect2: ld returned 1 exit status
> make: *** [fio] Error 1
> 
> After some googling, I learned that OS X doesn't
> provide _posix_memalign, and that apparently it's not
> needed on this platform. I "fixed" my compile problem with the
> attached patch. You may find it useful to write a better fix for this.

I think Apple have added it in 10.6, but obviously fio needs to run on
older versions too.

-- 
Bruce Cran

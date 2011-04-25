Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:48881 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758500Ab1DYLm5 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 25 Apr 2011 07:42:57 -0400
Message-ID: <4DB55E3C.1040305@fusionio.com>
Date: Mon, 25 Apr 2011 13:42:52 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [BUG] [PATCH] Undefined symbols: "_posix_memalign" on Mac OS  X
References: <BANLkTiktKRjW235qUUFAMES88BbQXNc5cw@mail.gmail.com> <20110423110636.00004ef3@unknown>
In-Reply-To: <20110423110636.00004ef3@unknown>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: Filip Sneppe <filip.sneppe@gmail.com>, fio@vger.kernel.org

On 2011-04-23 12:06, Bruce Cran wrote:
> On Sat, 23 Apr 2011 05:57:26 +0200
> Filip Sneppe <filip.sneppe@gmail.com> wrote:
>  
>> (I am not subscribed to this list, nor am I a Unix developer).
>>
>> I wanted to give fio a try on my OS X 10.5.8 machine, but
>> this is the error I received when compiling:
>>
>>     CC helpers.o
>>     CC engines/posixaio.o
>>     DEP depend
>>     CC fio
>> Undefined symbols:
>>   "_posix_memalign", referenced from:
>>       _thread_main in fio.o
>> ld: symbol(s) not found
>> collect2: ld returned 1 exit status
>> make: *** [fio] Error 1
>>
>> After some googling, I learned that OS X doesn't
>> provide _posix_memalign, and that apparently it's not
>> needed on this platform. I "fixed" my compile problem with the
>> attached patch. You may find it useful to write a better fix for this.
> 
> I think Apple have added it in 10.6, but obviously fio needs to run on
> older versions too.

Solaris has a helper, too. Does 10.6 have memalign or another
alternative function?

-- 
Jens Axboe


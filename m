Return-Path: <axboe@kernel.dk>
Message-ID: <5433F8C1.1030100@kernel.dk>
Date: Tue, 07 Oct 2014 08:29:21 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: YACC y.tab.c Usage: /usr/bin/yacc [options] filename
References: <D0587E1A.51DBE%Antonio.Jose.Rodrigues.Neto@netapp.com> <CADzpL0TJm=qM8UXFriQmH3t6c8BOHCJY7O-w+mtQspE-sLg4gg@mail.gmail.com> <D05885C8.51DCC%Antonio.Jose.Rodrigues.Neto@netapp.com> <CADzpL0RsVUsRD25Rr0MokhXVCVa30OXa1RzCLK6X3nKhYn_u=Q@mail.gmail.com> <D0588B95.51DDD%Antonio.Jose.Rodrigues.Neto@netapp.com> <CADzpL0TS_5vnOR-VHrgXRhaeef71stgNtqdYAEotqFisLtejQg@mail.gmail.com> <54333D69.7060304@kernel.dk> <CADzpL0SQ56xmwT5umYu+OdCMu5YwaV6vngruLzpPyoEu=_iy+w@mail.gmail.com> <54334D63.70909@kernel.dk> <D05964A6.51EA6%Antonio.Jose.Rodrigues.Neto@netapp.com> <D05967DE.51EB1%Antonio.Jose.Rodrigues.Neto@netapp.com> <5433F5FF.60508@kernel.dk>
In-Reply-To: <5433F5FF.60508@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>, Stephen Cameron <stephenmcameron@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/07/2014 08:17 AM, Jens Axboe wrote:
>> Please see below:
>>
>> Nossa Senhora:fio neto$ make V=1 t/dedupe
>> gcc  -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement -O3 -g
>> -ffast-math  -D_GNU_SOURCE -include config-host.h -DBITS_PER_LONG=64
>> -DFIO_VERSION='"fio-2.1.13-31-g15e3"' -o t/dedupe  -ll -lz  -lm  -lpthread
>> -ldl
>> Undefined symbols for architecture x86_64:
>>   "_yylex", referenced from:
>>       _main in libl.a(libmain.o)
>> ld: symbol(s) not found for architecture x86_64
>> clang: error: linker command failed with exit code 1 (use -v to see
>> invocation)
>> make: *** [t/dedupe] Error 1
>>
>> Any idea how to fix it?
> 
> It's only supported on Linux right now, it will be built automatically
> there. Not really a design problem, it's just that it has the Linux
> method for getting the size of a block device hard wired. I can fix that
> pretty quickly.

I changed it to use the fio supplied blockdev_size(), so it should work
on all platforms now:

http://git.kernel.dk/?p=fio.git;a=commit;h=d08a6886fa57f819682f05548d284a079a99e77d

Pull, make clean, and make again. Should work on OSX and others now.

-- 
Jens Axboe



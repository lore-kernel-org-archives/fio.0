Return-Path: <axboe@kernel.dk>
Subject: Re: fio-f1480f9: AIX 6.1 build KO against gcc function overlap
References: <VI1PR05MB1343197BD54DC24EA6A2AF65B1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681C3ED.2000708@kernel.dk>
 <VI1PR05MB1343C677E9AD2577F510184DB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681C9E2.3040006@kernel.dk>
 <VI1PR05MB13430153F93BD34C56DFB4CAB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681D0A8.8030507@kernel.dk>
 <VI1PR05MB1343AD6DF9BD33ED9A3C0C88B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681D65A.10200@kernel.dk>
 <VI1PR05MB134330236BC82EF62F5219C0B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5682A81A.8010008@kernel.dk>
Date: Tue, 29 Dec 2015 08:34:50 -0700
MIME-Version: 1.0
In-Reply-To: <VI1PR05MB134330236BC82EF62F5219C0B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Thierry BERTAUD <tbertaud@conforama.fr>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/28/2015 05:56 PM, Thierry BERTAUD wrote:
> Jens,
>
>> Fixed that new dependency, try pulling again :-)
> Yes fixed, i just have some warning.
> ----
> t/dedupe.c: In function 'dedupe_check':
> t/dedupe.c:97:2: warning: 'bytes' may be used uninitialized in this function [-Wmaybe-uninitialized]
>    return (ret & ~((uint64_t)blocksize - 1));
>    ^
> t/dedupe.c:87:22: note: 'bytes' was declared here
>     unsigned long long bytes;
>                        ^

That's the aix compiler being a bit too dumb to realize that 'bytes' is 
only used for a zero return of that function. You can safely ignore 
that, I can add a small patch to get rid of it.

>      CC t/debug.o
> ----
>
> What's the advantage to use 'lex/yacc for arithmetic'?

That you can have arithmetical expressions in your job files, that's all 
it provides.

> I disabled it in configure because i can't build and haved the following:
> ---
>     LEX lex.yy.c
> 0: Warning: 1285-300 The o flag is not valid.
> 0: Error: 1285-331 Cannot read input file lex.yy.c
> Makefile:300: recipe for target 'lex.yy.c' failed
> gmake: *** [lex.yy.c] Error 1

Hmm, I'll see if I can add a check in configure for whether or not lex 
requires -o to specify an output file. For now, just use --disable-lex.

-- 
Jens Axboe



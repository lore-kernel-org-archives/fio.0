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
 <5682A81A.8010008@kernel.dk>
 <VI1PR05MB134366A0B6A8833617A18D4FB1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <VI1PR05MB1343AFE71D15E197D549461FB1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <56834ED5.40506@kernel.dk> <568356A8.1040904@kernel.dk>
 <VI1PR05MB13431E57B67F7322189A74E2B1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5684089C.7000201@kernel.dk>
Date: Wed, 30 Dec 2015 09:38:52 -0700
MIME-Version: 1.0
In-Reply-To: <VI1PR05MB13431E57B67F7322189A74E2B1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Thierry BERTAUD <tbertaud@conforama.fr>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/30/2015 01:36 AM, Thierry BERTAUD wrote:
> Jens,
>
>> Unless I botched it, it should disable lex on AIX now, unless you
>> explicitly attempt to enable with --enable-lex.
>
> I built against fio-de26b82 and now lex its disable by default. Tha'ts OK  (cf full output below).
>
> Concerning error with  --enable-lex, i think is due that option '-o' is not valid so lex doon't generate the file leyx.yy.c => don't find it after.
> ---
> MTD                           no
> 0: Warning: 1285-300 The o flag is not valid.
> 0: Error: 1285-331 Cannot read input file lex.yy.c
> lex/yacc for arithmetic       yes
> ---
> If i read configure:
>      +1505
>      +1506  # Check if lex fails using -o
>      +1507  if test "$arith" = "yes" ; then
>      +1508  $LEX -o lex.yy.c exp/expression-parser.l 2> /dev/null
>      +1509  if test "$?" = "0" ; then
>      +1510    lex_use_o="yes"
>      +1511  else
>      +1512    lex_use_o="no"
>      +1513  fi
>      +1514  fi
>      +1515
>      +1516  echo "lex/yacc for arithmetic       $arith"
>
> Could you update test condition, if OS is AIX to use "less exp/expression-parser.l" and other case "-o lex.yy.c exp/expression-parser.l"
>     # lex exp/expression-parser.l; echo $?;ls -l lex.yy.c
>     0
>     -rw-r--r--    1 root     staff         48081 Dec 30 09:34 lex.yy.c

But that's what the lex_use_o should control. If lex is enabled, we'll 
output CONFIG_LEX_USE_O=y if lex should use -o and nothing if it should 
not. If CONFIG_LEX_USE_O is in config-host.mak, then the Makefile target 
will use -o. If not, then it should not. But maybe I screwed it up. 
Testing here:

axboe@xps13:/home/axboe/git/fio $ grep USE_O config-host.mak
CONFIG_LEX_USE_O=y
axboe@xps13:/home/axboe/git/fio $ make V=1 lex.yy.c
lex -o lex.yy.c exp/expression-parser.l

which looks correct. I'll manually kill CONFIG_LEX_USE_O=y from 
config-host.mak, and retry:

axboe@xps13:/home/axboe/git/fio $ rm lex.yy.c
axboe@xps13:/home/axboe/git/fio $ grep USE_O config-host.mak
axboe@xps13:/home/axboe/git/fio $ make V=1 lex.yy.c
lex exp/expression-parser.l
axboe@xps13:/home/axboe/git/fio $ ls -al lex.yy.c
-rw-r--r-- 1 axboe axboe 51991 Dec 30 09:37 lex.yy.c

so that logic does look correct. Maybe the configure check for the error 
return of lex -o isn't working. Do you have CONFIG_LEX_USE_O in your 
config-host.mak, if you run configure --enable-lex?

-- 
Jens Axboe



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
 <56834ED5.40506@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <568356A8.1040904@kernel.dk>
Date: Tue, 29 Dec 2015 20:59:36 -0700
MIME-Version: 1.0
In-Reply-To: <56834ED5.40506@kernel.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Thierry BERTAUD <tbertaud@conforama.fr>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/29/2015 08:26 PM, Jens Axboe wrote:
> On 12/29/2015 02:10 PM, Thierry BERTAUD wrote:
>> Hello Jens,
>>
>>>> Hmm, I'll see if I can add a check in configure for whether or not lex
>>>> requires -o to specify an output file. For now, just use --disable-lex.
>>> OK, i continue to just use: --disable-yes.
>>> If you add a check in configure later, i'll try a ./configure to
>>> confirm you that's fine in AIX.
>>
>> I build against fio-63bda37 (configure: if lex requires/fails with -o
>> for output)
>> With configure, i have this:
>> ____
>> MTD                           no
>> 0: Warning: 1285-300 The o flag is not valid.
>> 0: Error: 1285-331 Cannot read input file lex.yy.c
>> lex/yacc for arithmetic       yes
>
> Might have to do rm lex.yy.c before running configure. If you do, does
> it then work? If not, then we'll just have to have AIX default to lex
> off, I'm afraid. We can automate that as well in configure.

Unless I botched it, it should disable lex on AIX now, unless you 
explicitly attempt to enable with --enable-lex.

-- 
Jens Axboe



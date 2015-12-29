Return-Path: <axboe@kernel.dk>
Subject: Re: fio-f1480f9: AIX 6.1 build KO against gcc function overlap
References: <VI1PR05MB1343197BD54DC24EA6A2AF65B1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681C3ED.2000708@kernel.dk>
 <VI1PR05MB1343C677E9AD2577F510184DB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681C9E2.3040006@kernel.dk>
 <VI1PR05MB13430153F93BD34C56DFB4CAB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5681D0A8.8030507@kernel.dk>
Date: Mon, 28 Dec 2015 17:15:36 -0700
MIME-Version: 1.0
In-Reply-To: <VI1PR05MB13430153F93BD34C56DFB4CAB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Thierry BERTAUD <tbertaud@conforama.fr>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/28/2015 05:01 PM, Thierry BERTAUD wrote:
> Jens,
>
>> Thanks - I think it's just a missed include in lib/pattern.c - if you
>> pull current -git, both that and the send_file() issue should be fixed.
>> Can you test?
> I tested (fio-a328eb9) these both issue are fixed but i have this against getopt.h that doesn't exist on AIX.
> -----
>      CC oslib/getopt_long.o
> oslib/getopt_long.c:17:20: fatal error: getopt.h: No such file or directory
>   #include "getopt.h"
>                      ^
> compilation terminated.
> Makefile:289: recipe for target 'oslib/getopt_long.o' failed
> gmake: *** [oslib/getopt_long.o] Error 1

Looks like I screwed up that part in the lib/oslib move. Committed a 
fix, hopefully that should resolve all of them.

-- 
Jens Axboe



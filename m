Return-Path: <axboe@kernel.dk>
Subject: Re: fio-f1480f9: AIX 6.1 build KO against gcc function overlap
References: <VI1PR05MB1343197BD54DC24EA6A2AF65B1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681C3ED.2000708@kernel.dk>
 <VI1PR05MB1343C677E9AD2577F510184DB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681C9E2.3040006@kernel.dk>
 <VI1PR05MB13430153F93BD34C56DFB4CAB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681D0A8.8030507@kernel.dk>
 <VI1PR05MB1343AD6DF9BD33ED9A3C0C88B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5681D65A.10200@kernel.dk>
Date: Mon, 28 Dec 2015 17:39:54 -0700
MIME-Version: 1.0
In-Reply-To: <VI1PR05MB1343AD6DF9BD33ED9A3C0C88B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Thierry BERTAUD <tbertaud@conforama.fr>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/28/2015 05:30 PM, Thierry BERTAUD wrote:
> Jens,
>
>> Looks like I screwed up that part in the lib/oslib move. Committed a
>> fix, hopefully that should resolve all of them.
> I tested against fio-f87cc56 but i have now this issue:
> ------
> ld: 0711-317 ERROR: Undefined symbol: .strcasestr
> ld: 0711-345 Use the -bloadmap or -bnoquiet option to obtain more information.
> collect2: error: ld returned 8 exit status
> Makefile:373: recipe for target 't/fio-genzipf' failed
> gmake: *** [t/fio-genzipf] Error 1

Fixed that new dependency, try pulling again :-)

-- 
Jens Axboe



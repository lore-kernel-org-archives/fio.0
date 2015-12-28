Return-Path: <axboe@kernel.dk>
Subject: Re: fio-f1480f9: AIX 6.1 build KO against gcc function overlap
References: <VI1PR05MB1343197BD54DC24EA6A2AF65B1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681C3ED.2000708@kernel.dk>
 <VI1PR05MB1343C677E9AD2577F510184DB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5681C9E2.3040006@kernel.dk>
Date: Mon, 28 Dec 2015 16:46:42 -0700
MIME-Version: 1.0
In-Reply-To: <VI1PR05MB1343C677E9AD2577F510184DB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Thierry BERTAUD <tbertaud@conforama.fr>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/28/2015 04:34 PM, Thierry BERTAUD wrote:
> Hello Jens,
>
> I attached the config.log
>
>>> lib/pattern.c: In function 'parse_number':
>>> lib/pattern.c:77:3: warning: implicit declaration of function 'strcasestr' [-Wimplicit-function-declaration]
>>>      _end = strcasestr(beg, "0x");
>>>      ^
>>> lib/pattern.c:77:8: warning: assignment makes pointer from integer without a cast [enabled by default]
>>>      _end = strcasestr(beg, "0x");
>>
>> Can you send the config.log file?

Thanks - I think it's just a missed include in lib/pattern.c - if you 
pull current -git, both that and the send_file() issue should be fixed. 
Can you test?


-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Subject: Re: [BUG] parse.c: val_too_large incorrectly handling overly large
 FIO_OPT_INT values
References: <1110AE83-BA4F-46FF-B9C7-662960EC0EAD@raithlin.com>
 <CS1PR8401MB1237EA8EA748EE36A0A77958ABA20@CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM>
 <71EAE271-4053-4834-B391-8DA9BA5ABFF8@raithlin.com>
 <CS1PR8401MB123731B508F674F08ABE3FFBABB40@CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d14882de-2d0b-f7f9-7681-567536409be7@kernel.dk>
Date: Fri, 22 May 2020 12:59:32 -0600
MIME-Version: 1.0
In-Reply-To: <CS1PR8401MB123731B508F674F08ABE3FFBABB40@CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Servers)" <elliott@hpe.com>, Stephen Bates <sbates@raithlin.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: David Sloan <David.Sloan@eideticom.com>
List-ID: <fio@vger.kernel.org>

On 5/22/20 12:27 PM, Elliott, Robert (Servers) wrote:
> 
>>> Fundamentally, this argument needs to support larger than
>>>    32-bit values. Persistent memory devices easily exceed that
>>>    bandwidth too.
>>>
>>>    Other arguments like "size" already take large values into an
>>>    unsigned long long. So, just changing this for "rate" and
>>>    "rate_min" might suffice:
>>>                    .type   = FIO_OPT_INT,
>>>    to
>>>                    .type   = FIO_OPT_STR_VAL,
>>
>> Yup but there are two issues here:
>>
>> 1. (This bug report) The range handling of all FIO_OPT_INT arguments
>> is broken.
>>
>> 2. rate (and min_rate) should support values bigger than 4G.
>>
>> I am working on a PR/patch for item 2 [1]. Looking for guidance on
>> item 1.
>>
> 
> Should at least item 2 go into 3.20?

Should already be in the repo.

-- 
Jens Axboe



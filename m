Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v3 0/4] Sync fio(1) man page with HOWTO (remaining
 sections)
References: <20170814153026.44260-1-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <2178e124-b31a-4346-aa98-3e35e81ee722@kernel.dk>
Date: Mon, 14 Aug 2017 13:06:09 -0600
MIME-Version: 1.0
In-Reply-To: <20170814153026.44260-1-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 08/14/2017 09:30 AM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> 2017-08-14 17:59 GMT+03:00 Jens Axboe <axboe@kernel.dk>:
>>> Sync fio(1) man page with HOWTO (remaining sections)
>>> http://www.spinics.net/lists/fio/msg06158.html
>>
>> Patch #1 is throwing rejects now, I pulled in a few fixes this morning.
>> Since those are big hunks, can you double check and send a v3? Bad
>> timing, sorry...
> 
> Sure, sorry I didn't notice you committed changes, while I made v2 a few hours ago.
> 
> These are v3 of below series of patches, which resolves above merge conflicts
> with recently committed 997b5680d139ce82c2034ba3a0d602cfd778b89b
> which added serialize_overlap= to fio.1 and HOWTO.
> 
> [PATCH 0/4] Sync fio(1) man page with HOWTO (remaining sections)
> http://www.spinics.net/lists/fio/msg06158.html

Applied, thanks!

-- 
Jens Axboe



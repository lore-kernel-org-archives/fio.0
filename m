Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] lib/ffz: remove dead store
References: <20170607235336.48859-1-daniel.verkamp@intel.com>
 <CALjAwxjj9BbH-p1m4R+x6LE94zcDrY_Enxie=90n=LZ3R0wo3g@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <11035061-7104-29c8-745b-75a26e373569@kernel.dk>
Date: Tue, 27 Jun 2017 07:25:10 -0600
MIME-Version: 1.0
In-Reply-To: <CALjAwxjj9BbH-p1m4R+x6LE94zcDrY_Enxie=90n=LZ3R0wo3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Daniel Verkamp <daniel.verkamp@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 06/26/2017 11:17 PM, Sitsofe Wheeler wrote:
> On 8 June 2017 at 00:53, Daniel Verkamp <daniel.verkamp@intel.com> wrote:
>> 'word' is written in the last 'if' block but never read again.
>>
>> This is harmless, but scan-build (clang-analyzer) flags it as a warning.
>>
>> Signed-off-by: Daniel Verkamp <daniel.verkamp@intel.com>
>> ---
>>  lib/ffz.h | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/lib/ffz.h b/lib/ffz.h
>> index e2c1b8e..b98dad6 100644
>> --- a/lib/ffz.h
>> +++ b/lib/ffz.h
>> @@ -28,7 +28,6 @@ static inline int ffs64(uint64_t word)
>>                 r += 2;
>>         }
>>         if (!(word & 1)) {
>> -               word >>= 1;
>>                 r += 1;
>>         }
>>
>> --
>> 2.9.4
> 
> Any thoughts on this one Jens (just checking it didn't slip through the net)?

It did, thanks for bringing it to my attention - applied, thanks Daniel.

-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Message-ID: <54D4E7D6.9080007@kernel.dk>
Date: Fri, 06 Feb 2015 09:12:06 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: verify_only broken? (was RE: )
References: <5A8251503902B84E89CE171AD126BCFB2DE5BD27@NTXBOIMBX01.micron.com>
In-Reply-To: <5A8251503902B84E89CE171AD126BCFB2DE5BD27@NTXBOIMBX01.micron.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Justin Eno (jeno)" <jeno@micron.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 02/04/2015 02:58 PM, Justin Eno (jeno) wrote:
> On Wed, Jan 28, 2015 at 14:39:29, Justin Eno (jeno) <jeno@micron.com> wrote:
>> Hi Jens,
>>
>> It appears do_dry_run(), i.e., verify_only, is broken by the last
>> update to backend.c
>>
>> I have attached a working patch, though you may prefer a different approach.
>>
>> Thanks,
>> Justin
>
> I just realized that I sent this original message without a subject. Perhaps it was dropped for that reason.
>
> I've re-attached the same patch. If it was NAKed, please just let me know and I will work on an alternative.
>
> Also, do you prefer inline or attached patches?

Thanks, didn't see the original. I prefer attached patches, that has a 
lower risk of some mailer or MTA corrupting it along the way. But unless 
it's a huge patch, it's not a big deal.

I have applied your patch.

-- 
Jens Axboe



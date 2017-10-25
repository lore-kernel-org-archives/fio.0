Return-Path: <axboe@kernel.dk>
Subject: Re: "nice" parameter bug (-19 to 20) and out of range message bug
References: <b7782a91-a5a0-458a-d931-768d13fdb4ac@bluestop.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f9ea3407-26b9-6e98-43c4-955322aee84f@kernel.dk>
Date: Wed, 25 Oct 2017 12:07:21 -0700
MIME-Version: 1.0
In-Reply-To: <b7782a91-a5a0-458a-d931-768d13fdb4ac@bluestop.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bluestop.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/25/2017 12:02 PM, Rebecca Cran wrote:
> If I set the job parameter "nice" to -20 in Linux using FIO 3.1, I get 
> the warning:
> 
> min value out of range: 18446744073709551596 (4294967277 min)
> 
> The error is clearly wrong, but in options.c the min and max values are 
> also: 'nice' ranges from -20 to 19, whereas FIO allows -19 to 20.

Yeah that looks like a bug, care to send a patch?

I'll fix the parser min value reporting, that's also a bug... Should be
signed.

-- 
Jens Axboe



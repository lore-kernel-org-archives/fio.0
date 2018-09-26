Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
Message-ID: <1537976181.35256.2.camel@gmail.com>
Subject: Re: [PATCH 2/2] zbd: Remove unused function and variable
From: Bart Van Assche <bart.vanassche@gmail.com>
Date: Wed, 26 Sep 2018 08:36:21 -0700
In-Reply-To: <20180926064226.2590-1-damien.lemoal@wdc.com>
References: <20180926064226.2590-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset="UTF-7"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On Wed, 2018-09-26 at 15:42 +-0900, Damien Le Moal wrote:
+AD4 -/+ACo Check whether the value of zbd+AF8-info.sectors+AF8-with+AF8-data is correct. +ACo-/
+AD4 -static void check+AF8-swd(const struct thread+AF8-data +ACo-td, const struct fio+AF8-file +ACo-f)
+AD4 -+AHs
+AD4 -+ACM-if 0
+AD4 -	struct fio+AF8-zone+AF8-info +ACo-zb, +ACo-ze, +ACo-z+ADs
+AD4 -	uint64+AF8-t swd+ADs
+AD4 -
+AD4 -	zb +AD0 +ACY-f-+AD4-zbd+AF8-info-+AD4-zone+AF8-info+AFs-zbd+AF8-zone+AF8-idx(f, f-+AD4-file+AF8-offset)+AF0AOw
+AD4 -	ze +AD0 +ACY-f-+AD4-zbd+AF8-info-+AD4-zone+AF8-info+AFs-zbd+AF8-zone+AF8-idx(f, f-+AD4-file+AF8-offset +-
+AD4 -						  f-+AD4-io+AF8-size)+AF0AOw
+AD4 -	swd +AD0 0+ADs
+AD4 -	for (z +AD0 zb+ADs z +ADw ze+ADs z+-+-) +AHs
+AD4 -		pthread+AF8-mutex+AF8-lock(+ACY-z-+AD4-mutex)+ADs
+AD4 -		swd +-+AD0 z-+AD4-wp - z-+AD4-start+ADs
+AD4 -	+AH0
+AD4 -	pthread+AF8-mutex+AF8-lock(+ACY-f-+AD4-zbd+AF8-info-+AD4-mutex)+ADs
+AD4 -	assert(f-+AD4-zbd+AF8-info-+AD4-sectors+AF8-with+AF8-data +AD0APQ swd)+ADs
+AD4 -	pthread+AF8-mutex+AF8-unlock(+ACY-f-+AD4-zbd+AF8-info-+AD4-mutex)+ADs
+AD4 -	for (z +AD0 zb+ADs z +ADw ze+ADs z+-+-)
+AD4 -		pthread+AF8-mutex+AF8-unlock(+ACY-z-+AD4-mutex)+ADs
+AD4 -+ACM-endif
+AD4 -+AH0

I'd like to keep this code. This code has been proven to be very valuable
while debugging to verify the code that updates f-+AD4-zbd+AF8-info-+AD4-sectors+AF8-with+AF8-data.

Bart.


Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd: relocate Coverity annotation
References: <20210130033524.9142-1-dmitry.fomichev@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ba235659-6b5c-6cd3-5e25-3b2c0a07e2a5@kernel.dk>
Date: Fri, 29 Jan 2021 22:07:49 -0700
MIME-Version: 1.0
In-Reply-To: <20210130033524.9142-1-dmitry.fomichev@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Dmitry Fomichev <dmitry.fomichev@wdc.com>, Bart Van Assche <bvanassche@acm.org>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

On 1/29/21 8:35 PM, Dmitry Fomichev wrote:
> The Coverity annotation added earlier to suppress a false positive
> about missing unlock in zbd_adjust_block() didn't work because it
> was placed not before the return statement, but earlier in the code.
> 
> Move the annotation to the right place to avoid the warning.

Not a fan of these annotations in general, especially when they
are specific to a single code analyzer. But since we already have
them... Applied.

-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v3] zbd: Fix test scripts
References: <20180905080237.21887-1-damien.lemoal@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <6f8e2641-8324-d767-4136-ed43984d5bd8@kernel.dk>
Date: Wed, 5 Sep 2018 08:36:43 -0600
MIME-Version: 1.0
In-Reply-To: <20180905080237.21887-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

On 9/5/18 2:02 AM, Damien Le Moal wrote:
> Fix handling of the path to the test-zbd-support script to avoid an
> error when the tests are run directly when in fio/t/zbd using the
> command "./run-against...".

Thanks, applied.

Where are we on the other zbd fixes? I want to cut a new version
fairly soon, but I don't want to do that with fixes still pending.

-- 
Jens Axboe



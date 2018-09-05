Return-Path: <bvanassche@acm.org>
Subject: Re: [PATCH v3] zbd: Fix test scripts
References: <20180905080237.21887-1-damien.lemoal@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <2262a0bf-0737-9a1c-4645-e41d506e6666@acm.org>
Date: Wed, 5 Sep 2018 07:21:23 -0700
MIME-Version: 1.0
In-Reply-To: <20180905080237.21887-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 09/05/18 01:02, Damien Le Moal wrote:
> Fix handling of the path to the test-zbd-support script to avoid an
> error when the tests are run directly when in fio/t/zbd using the
> command "./run-against...".
 Reviewed-by: Bart Van Assche <bvanassche@acm.org>



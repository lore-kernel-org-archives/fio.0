Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd: Restore check_swd()
References: <20180927021648.28313-1-damien.lemoal@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <40ca898f-febc-b403-74ec-f7df39c0bb7f@kernel.dk>
Date: Thu, 27 Sep 2018 21:53:26 -0600
MIME-Version: 1.0
In-Reply-To: <20180927021648.28313-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

On 9/26/18 8:16 PM, Damien Le Moal wrote:
> As check_swd() is useful for debugging, revert its removal done with
> commit d60be7d51cbb ("zbd: Remove unused function and variable").

The problem with dead code is that it's often forgotten when
other changes are made, and then it doesn't even compile or
work anymore.

I'd be happier if this was dependent on some debug static
bool instead, ala:

static bool zbd_debug;

And then have check_swd() do

if (!zbd_debug)
    return;

instead of hiding everything behind an #if 0.

-- 
Jens Axboe



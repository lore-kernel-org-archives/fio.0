Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
Subject: Re: [PATCH] zbd: Restore check_swd()
References: <20180927021648.28313-1-damien.lemoal@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <fb8016bd-5000-db0b-bf62-53f91c67cbfe@acm.org>
Date: Thu, 27 Sep 2018 20:41:52 -0700
MIME-Version: 1.0
In-Reply-To: <20180927021648.28313-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 9/26/18 7:16 PM, Damien Le Moal wrote:
> As check_swd() is useful for debugging, revert its removal done with
> commit d60be7d51cbb ("zbd: Remove unused function and variable").

Thanks!

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


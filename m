Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2 5/7] Verify the absence of holes in struct jobs_eta at
 compile time
References: <20190814022038.30941-1-bvanassche@acm.org>
 <20190814022038.30941-6-bvanassche@acm.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <6522e88b-3a3e-9330-3c7e-6e6463790635@kernel.dk>
Date: Tue, 13 Aug 2019 20:54:12 -0600
MIME-Version: 1.0
In-Reply-To: <20190814022038.30941-6-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 8/13/19 8:20 PM, Bart Van Assche wrote:
> This helps to verify the correctness of a later patch that will modify
> this structure.

I'm fine with this solution (for packed vs unpacked), but we already
have compiletime_assert() for these kinds of checked. Sorry, forgot
to mention that first time around.

-- 
Jens Axboe



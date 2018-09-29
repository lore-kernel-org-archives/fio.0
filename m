Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/6] Restore the check_swd() function in the ZBD code
References: <20180928215133.35222-1-bvanassche@acm.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e2b0420a-4c62-4bda-6134-a6b4331e0f1f@kernel.dk>
Date: Sat, 29 Sep 2018 15:17:25 -0600
MIME-Version: 1.0
In-Reply-To: <20180928215133.35222-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 9/28/18 3:51 PM, Bart Van Assche wrote:
> Hi Jens,
> 
> The fio changes included in this patch series are as follows:
> - The check_swd() function has been restored in such a way that the compiler
>   can verify the syntactical correctness of the code.
> - A new function zbd_process_swd() has been introduced to avoid duplicated
>   code.
> - The robustness of the ZBD test scripts has been improved.
> 
> Please consider these patches for the upstream fio repository.

Thanks Bart, applied.

-- 
Jens Axboe



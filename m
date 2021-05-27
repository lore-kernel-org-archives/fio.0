Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v3 1/2] zbd: add missing client/server support for option
 max_open_zones
References: <20210527111222.122783-1-Niklas.Cassel@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ec2b5ad9-4772-c833-78e7-df19fa5d7ce7@kernel.dk>
Date: Thu, 27 May 2021 16:05:14 -0600
MIME-Version: 1.0
In-Reply-To: <20210527111222.122783-1-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 5/27/21 5:12 AM, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Ensure that we convert the max_open_zones option for client/server.
> 
> Use __cpu_to_le32()/__le32_to_cpu() rather than
> cpu_to_le32()/le32_to_cpu(), since max_open_zones is defined
> as int rather than unsigned int in thread_options.h.

Applied 1-2, thanks.

-- 
Jens Axboe



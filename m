Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] t/zbd: Improve pass condition of test case #49
References: <20200722092633.350291-1-shinichiro.kawasaki@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <bb7b29e6-ddce-3ac3-7ea4-6c8709b26de8@kernel.dk>
Date: Wed, 22 Jul 2020 07:38:40 -0600
MIME-Version: 1.0
In-Reply-To: <20200722092633.350291-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Hans Holmberg <hans.holmberg@wdc.com>
List-ID: <fio@vger.kernel.org>

On 7/22/20 3:26 AM, Shin'ichiro Kawasaki wrote:
> The test case #49 runs write workloads with verify option. It checks read
> bytes for verify, but it does not check written bytes. To make test pass
> condition more accurate, add check of the written bytes.

Applied,  thanks.

-- 
Jens Axboe



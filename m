Return-Path: <bvanassche@acm.org>
Subject: Re: [PATCH v2] zbd: Fix test scripts
References: <20180903080247.10517-1-damien.lemoal@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <f17b4d9e-a250-e657-7479-59b982398c5c@acm.org>
Date: Mon, 3 Sep 2018 08:05:23 -0700
MIME-Version: 1.0
In-Reply-To: <20180903080247.10517-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 09/03/18 01:02, Damien Le Moal wrote:
> -"$(dirname "$0")"/test-zbd-support "$@" /dev/nullb0
> +${scriptdir}/test-zbd-support "$@" /dev/nullb0
> [ ... ]
> -"$(dirname "$0")"/test-zbd-support "$@" /dev/nullb0
> +${scriptdir}/test-zbd-support "$@" /dev/nullb0

Have you verified the new versions of these scripts with shellcheck? I
think that these two changes each introduce a new shellcheck warning.
Please keep the number of shellcheck warnings as low as possible.

Thanks,

Bart.





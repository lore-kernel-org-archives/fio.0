Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] fix windows cpu count
References: <MWHPR04MB03206DB9864943065BA28C218FCF0@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <dd487a15-5bf3-1f0b-c8af-c625e322b625@kernel.dk>
Date: Fri, 2 Nov 2018 10:54:37 -0600
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB03206DB9864943065BA28C218FCF0@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 11/2/18 10:44 AM, Jeff Furlong wrote:
> This patch resolves c479640d6208236744f0562b1e79535eec290e2b where the
> CPU count returns max possible supported CPUs, and instead returns
> current active CPUs.

I'd like to apply this patch, but your mailer has completely
botched it up. It's damaging white space (turning tabs into
spaces), and breaking up lines that it thinks are too long.

-- 
Jens Axboe



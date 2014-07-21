Return-Path: <axboe@kernel.dk>
Message-ID: <53CD5EA6.4090706@kernel.dk>
Date: Mon, 21 Jul 2014 20:40:38 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [fio-2.1.9] verify and bssplit do not work together
References: <CAMHSBOXb0f9iZFLiJSXPiT+8yXe8QbF-bS_4KA1c1+=Wps_K_A@mail.gmail.com> <53C8D124.60202@kernel.dk> <53CCCF60.9090208@kernel.dk> <CAMHSBOW1g2y9nCMQs=qJ-ggWZEG_MiG27BgpttPFsk1tdUQy5g@mail.gmail.com>
In-Reply-To: <CAMHSBOW1g2y9nCMQs=qJ-ggWZEG_MiG27BgpttPFsk1tdUQy5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Gwendal Grignou <gwendal@chromium.org>
Cc: Puthikorn Voravootivat <puthik@chromium.org>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-07-21 19:49, Gwendal Grignou wrote:
> Jens,
>
> Without the patch, experimental_verify=1 produced more error, it looks
> like every 64k.
>
> With the patch above, fio behaves as expected: do_verify and
> experimental_verify works for mixed writes.
>
> There is still a problem when bs is mixed and one argument is less
> than the verify interval.
> For instance:
> bssplit=4k/50:1M/50
> ...
> verify_interval=64k
>
>
> But looking at the code, it won't be possible to fix, because we can
> not guarantee to always have 16 4K write contiguous.

As mentioned in the original email, it's a parser fix. verify_interval 
cannot be less than the minimum block size, fio will just have to catch 
that and adjust / error out.

> Thanks for the patch.

It's committed, so generally available now.

-- 
Jens Axboe



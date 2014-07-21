Return-Path: <axboe@kernel.dk>
Message-ID: <53CD7874.7010203@kernel.dk>
Date: Mon, 21 Jul 2014 22:30:44 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [fio-2.1.9] verify and bssplit do not work together
References: <CAMHSBOXb0f9iZFLiJSXPiT+8yXe8QbF-bS_4KA1c1+=Wps_K_A@mail.gmail.com> <53C8D124.60202@kernel.dk> <53CCCF60.9090208@kernel.dk> <CAMHSBOW1g2y9nCMQs=qJ-ggWZEG_MiG27BgpttPFsk1tdUQy5g@mail.gmail.com> <53CD5EA6.4090706@kernel.dk> <53CD616D.1030908@kernel.dk> <CAMHSBOV1Vm4Ds1th+OB-JQ6h7kiN8VKR9E4+7aiiN2F=fbjVaw@mail.gmail.com>
In-Reply-To: <CAMHSBOV1Vm4Ds1th+OB-JQ6h7kiN8VKR9E4+7aiiN2F=fbjVaw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Gwendal Grignou <gwendal@chromium.org>
Cc: Puthikorn Voravootivat <puthik@chromium.org>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-07-21 22:24, Gwendal Grignou wrote:
> Jens,
>   I still see some verify errors when I set 'experimental_verify=1'
>
> verify: bad magic header 977c, wanted acca at file /tmp/test offset
> 15478784, length 429437046
> verify: bad magic header 8aac, wanted acca at file /tmp/test offset
> 28082176, length 302426815
> verify: bad magic header c8ad, wanted acca at file /tmp/test offset
> 30408704, length 318473336
> verify: bad magic header 3791, wanted acca at file /tmp/test offset
> 65024000, length 74750452
>
> However, without this line, there are no verify errors anymore.
>
> The fio file is:
> [stress]
> filename=/tmp/test
> size=107374182
>
> readwrite=randrw
> bssplit=4k/50:1M/50
> ;bs=64k
>
> do_verify=1
> experimental_verify=1
> verify=meta
> verify_interval=64k
> verify_dump=1
> continue_on_error=verify

I'll look into the experimental_verify bit - there's a reason it's 
experimental :-). But the hope is to make that the method for 
verification, so I'll look into what goes wrong there. It might be 
highlighting problems elsewhere (like accidental overwrites, due to the 
mixed block sizes).

-- 
Jens Axboe



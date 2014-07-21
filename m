Return-Path: <gwendal@google.com>
MIME-Version: 1.0
Sender: gwendal@google.com
In-Reply-To: <53CD616D.1030908@kernel.dk>
References: <CAMHSBOXb0f9iZFLiJSXPiT+8yXe8QbF-bS_4KA1c1+=Wps_K_A@mail.gmail.com>
 <53C8D124.60202@kernel.dk> <53CCCF60.9090208@kernel.dk> <CAMHSBOW1g2y9nCMQs=qJ-ggWZEG_MiG27BgpttPFsk1tdUQy5g@mail.gmail.com>
 <53CD5EA6.4090706@kernel.dk> <53CD616D.1030908@kernel.dk>
From: Gwendal Grignou <gwendal@chromium.org>
Date: Mon, 21 Jul 2014 13:24:29 -0700
Message-ID: <CAMHSBOV1Vm4Ds1th+OB-JQ6h7kiN8VKR9E4+7aiiN2F=fbjVaw@mail.gmail.com>
Subject: Re: [fio-2.1.9] verify and bssplit do not work together
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Gwendal Grignou <gwendal@chromium.org>, Puthikorn Voravootivat <puthik@chromium.org>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Jens,
 I still see some verify errors when I set 'experimental_verify=1'

verify: bad magic header 977c, wanted acca at file /tmp/test offset
15478784, length 429437046
verify: bad magic header 8aac, wanted acca at file /tmp/test offset
28082176, length 302426815
verify: bad magic header c8ad, wanted acca at file /tmp/test offset
30408704, length 318473336
verify: bad magic header 3791, wanted acca at file /tmp/test offset
65024000, length 74750452

However, without this line, there are no verify errors anymore.

The fio file is:
[stress]
filename=/tmp/test
size=107374182

readwrite=randrw
bssplit=4k/50:1M/50
;bs=64k

do_verify=1
experimental_verify=1
verify=meta
verify_interval=64k
verify_dump=1
continue_on_error=verify


Thanks a lot,
Gwendal.

On Mon, Jul 21, 2014 at 11:52 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-07-21 20:40, Jens Axboe wrote:
>>>
>>> But looking at the code, it won't be possible to fix, because we can
>>> not guarantee to always have 16 4K write contiguous.
>>
>>
>> As mentioned in the original email, it's a parser fix. verify_interval
>> cannot be less than the minimum block size, fio will just have to catch
>> that and adjust / error out.
>
>
> Attach should fix that - untested...
>
> --
> Jens Axboe
>


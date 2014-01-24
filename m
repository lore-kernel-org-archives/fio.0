Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <20140124185855.GF7483@kernel.dk>
References: <1379451974-16100-1-git-send-email-jcasse@chromium.org>
	<CANEJEGt0OQCGi_7u68+m-7Rth2ykbaYJt+K17krd_YQCf=f96Q@mail.gmail.com>
	<20140124185855.GF7483@kernel.dk>
Date: Fri, 24 Jan 2014 12:27:25 -0800
Message-ID: <CANEJEGvKT8EKwgJTiMDbM9iFuDs4L2hjK=DkO8jSfwxcKvvY2Q@mail.gmail.com>
Subject: Re: [PATCH] Adds check for numberio during verify phase.
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Grant Grundler <grundler@chromium.org>, FIO_list <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

[dropping jcasse since this account was deleted after his internship ended]

On Fri, Jan 24, 2014 at 10:58 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On Fri, Jan 24 2014, Grant Grundler wrote:
>> Jens, Ping?
>> You think you can still integrate the three patches from Juan?
>
> I think that would be manageable. But really a new feature (or feature
> modification) like this should be accompanies by a job file example for
> it. Care to provide one?

Yes. Do you mind cloning a git repo?

Specifically this file is what chromium.org is using:
https://chromium.googlesource.com/chromiumos/third_party/autotest/+/master/client/site_tests/hardware_StorageFio/8k_async_randwrite

The git repo is hosted here:
    https://chromium.googlesource.com/chromiumos/third_party/autotest/

Use git clone to pull the entire repo:
    git clone https://chromium.googlesource.com/chromiumos/third_party/autotest

cheers,
grant


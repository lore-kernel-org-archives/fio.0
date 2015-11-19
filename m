Return-Path: <axboe@kernel.dk>
Subject: Re: RBD client cache
References: <CADr68WZZqpVAeS-EuUgc5eOz=XoyrcCWCTymx58WBEAger442A@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <564E318C.3060602@kernel.dk>
Date: Thu, 19 Nov 2015 13:31:08 -0700
MIME-Version: 1.0
In-Reply-To: <CADr68WZZqpVAeS-EuUgc5eOz=XoyrcCWCTymx58WBEAger442A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Rosenboom <j.rosenboom@x-ion.de>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/19/2015 08:37 AM, Jens Rosenboom wrote:
> A couple of releases ago, ceph has changed the default value for
>
> rbd cache writethrough until flush
>
> from false to true. As the fio rbd backend currently does not emit the
> necessary fsync to trigger writeback mode, this implies that tests
> will run in writethrough, possibly giving a significantly reduced
> performance when compared to other clients, e.g. when running fio
> within a qemu-based instance accessing the same RBD volume.
>
> Would it make sense for fio to simply issue a rbd_flush after each
> rbd_open at https://github.com/axboe/fio/blob/master/engines/rbd.c#L138
> ? Or do you think that this would need a dedicated flag to be enabled?

I'd probably make that an rbd engine option, ala flush_on_open or 
something like that.

-- 
Jens Axboe



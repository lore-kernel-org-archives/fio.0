Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] fio:remove raw device support
References: <b49454cd-40a4-c4ae-7fce-91e95c1abfc4@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f1f6966c-5a54-ac40-94a3-ef1ee9ac58d5@kernel.dk>
Date: Tue, 3 Aug 2021 12:21:42 -0600
MIME-Version: 1.0
In-Reply-To: <b49454cd-40a4-c4ae-7fce-91e95c1abfc4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <esandeen@redhat.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 8/3/21 11:23 AM, Eric Sandeen wrote:
> As of Linux kernel commit 603e4922f1c ("remove the raw driver"),
> linux/raw.h is gone, and raw device support no longer exists.
> Because of this, fio can no longer build against the current Linux
> kernel headers.
> 
> So, remove raw device support from fio as well.

Thanks, applied.

-- 
Jens Axboe



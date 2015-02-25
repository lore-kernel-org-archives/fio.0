Return-Path: <axboe@kernel.dk>
Message-ID: <54EE37F8.6090909@kernel.dk>
Date: Wed, 25 Feb 2015 14:00:40 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] fix implicit function declaration on Android
References: <CAJgzZoqb=+nFdbFjAv6Tbx6x-Gdqz-+nvHJpEuZXK4iBrqUsSA@mail.gmail.com>
In-Reply-To: <CAJgzZoqb=+nFdbFjAv6Tbx6x-Gdqz-+nvHJpEuZXK4iBrqUsSA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: enh <enh@google.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 02/20/2015 12:00 PM, enh wrote:
> there's no fio_set_sched_idle in os/os-android.h. copy the one from
> os/os-linux.h.
> 
> current Android also has posix_madvise.

Applied, thanks.

-- 
Jens Axboe



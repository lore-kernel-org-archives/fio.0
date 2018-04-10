Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] os/os-dragonfly: sync with header file changes in
 upstream
References: <1523374532-8629-1-git-send-email-kusumi.tomohiro@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <9a881af3-1b6b-6337-96eb-e58e8d911b04@kernel.dk>
Date: Tue, 10 Apr 2018 09:17:35 -0600
MIME-Version: 1.0
In-Reply-To: <1523374532-8629-1-git-send-email-kusumi.tomohiro@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 4/10/18 9:35 AM, Tomohiro Kusumi wrote:
> IOCTLTRIM was moved and renamed to a different header file,
> so conditionally include previous or current header depending on
> __DragonFly_version.
> 
> Some details in below commit messages.
> In short, they have had IOCTLTRIM in a wrong header, and they
> decided to fix/change it since fio was the only application using
> IOCTLTRIM within their userspace package collections.
> 
> <sys/ioctl_compat.h>: Add a reminder comment about IOCTLTRIM.
> http://gitweb.dragonflybsd.org/dragonfly.git/commitdiff/7226e3530be4df743a5cfe61f602b0c4bd436ee9
> 
> Move the IOCTLTRIM ioctl to a better header and rename it to DAIOCTRIM.
> http://gitweb.dragonflybsd.org/dragonfly.git/commitdiff/32506cfa691f80faa47486d6f94a98ae12387eeb

Applied, thanks.

-- 
Jens Axboe



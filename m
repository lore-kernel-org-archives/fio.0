Return-Path: <axboe@kernel.dk>
Date: Tue, 18 Feb 2014 11:23:10 -0800
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] librbd ioengine support v2
Message-ID: <20140218192310.GA25515@kernel.dk>
References: <1392644128-25678-1-git-send-email-d.gollub@telekom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392644128-25678-1-git-send-email-d.gollub@telekom.de>
To: Daniel Gollub <d.gollub@telekom.de>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Mon, Feb 17 2014, Daniel Gollub wrote:
> Same as v1 - only diffence:
>  - revert unintended changes in options.c to windowsaio options struct
> 
> Daniel Gollub (1):
>   librbd ioengine support
> 
>  Makefile      |    3 +
>  configure     |   30 ++++
>  engines/rbd.c |  449 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  options.c     |    5 +
>  options.h     |    2 +
>  5 files changed, 489 insertions(+)
>  create mode 100644 engines/rbd.c

Thanks, applied this one and 2-3/3 from the other series.

-- 
Jens Axboe



Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <1610864656-6451-1-git-send-email-glqinhongwei@gmail.com>
In-Reply-To: <1610864656-6451-1-git-send-email-glqinhongwei@gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 17 Jan 2021 11:07:41 +0000
Message-ID: <CALjAwxhf4m17rK5+DspN-WwstK+=eM2QC1M2sFNiB-y1nbxm5A@mail.gmail.com>
Subject: Re: [PATCH] Fix thinktime_blocks
Content-Type: text/plain; charset="UTF-8"
To: HongweiQin <glqinhongwei@gmail.com>
Cc: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On Sun, 17 Jan 2021 at 06:26, HongweiQin <glqinhongwei@gmail.com> wrote:
>
> According to the manual, the thinktime_blocks controls how many blocks to issue (instead of complete) before waiting.
>
> Signed-off-by: HongweiQin <glqinhongwei@gmail.com>
> ---
>  backend.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

At this point wouldn't it be better to update the help to reflect the
code rather than the other way around?

-- 
Sitsofe


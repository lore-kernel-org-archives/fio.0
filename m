Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Fix Windows build by using lib/strcasestr.{c,h}
References: <1444090730-4656-1-git-send-email-bruce.cran@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5616BCA8.2080009@kernel.dk>
Date: Thu, 8 Oct 2015 12:57:44 -0600
MIME-Version: 1.0
In-Reply-To: <1444090730-4656-1-git-send-email-bruce.cran@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce.cran@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/05/2015 06:18 PM, Bruce Cran wrote:
> ---
>   Makefile        | 1 +
>   os/os-windows.h | 1 +
>   2 files changed, 2 insertions(+)

My bad, thanks Bruce!

-- 
Jens Axboe



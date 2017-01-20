Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] Change .category of cpuio to FIO_OPT_C_ENGINE
References: <1484934403-16963-1-git-send-email-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <97509edb-ad4a-2899-dab1-247af901b9d4@kernel.dk>
Date: Fri, 20 Jan 2017 09:50:31 -0800
MIME-Version: 1.0
In-Reply-To: <1484934403-16963-1-git-send-email-tkusumi@tuxera.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 01/20/2017 09:46 AM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> This is supposed to be ENGINE instead of GENERAL.
> 
>  # grep "\.category" engines -rI | grep -v ENGINE
>  engines/cpu.c:          .category = FIO_OPT_C_GENERAL,
>  engines/cpu.c:          .category = FIO_OPT_C_GENERAL,
>  engines/cpu.c:          .category = FIO_OPT_C_GENERAL,

Thanks, applied 1-2.

-- 
Jens Axboe



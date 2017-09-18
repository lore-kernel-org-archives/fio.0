Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/4] minor fixes
References: <20170918175350.38471-1-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <4db453df-e6a5-099e-16e9-1bddfb43a8e2@kernel.dk>
Date: Mon, 18 Sep 2017 12:04:58 -0600
MIME-Version: 1.0
In-Reply-To: <20170918175350.38471-1-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 09/18/2017 11:53 AM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> 
> Tomohiro Kusumi (4):
>   add "invalid IO size" to "first direct IO errored." message
>   add fio_set_directio() error message for platforms without direct I/O
>   lib/memalign: don't malloc size twice
>   fix strncpy(3) copy length

Applied 3-4, commented on the other two.

-- 
Jens Axboe



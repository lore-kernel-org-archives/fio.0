Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] man: add missing \ for fcntl(2) in write_hint option
References: <20170716124020.2585-1-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5012f6cb-61f9-adbc-64c5-7ebafe34ad6c@kernel.dk>
Date: Sun, 16 Jul 2017 08:11:33 -0600
MIME-Version: 1.0
In-Reply-To: <20170716124020.2585-1-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 07/16/2017 06:40 AM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> 8f4b9f24 ('Update documentation for write_hint') was missing \.
> Without this '|' becomes visible.

Oops, my fault. Thanks, applied.

-- 
Jens Axboe



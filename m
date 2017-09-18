Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v3] add fio_set_directio() error message for platforms
 without direct I/O
References: <20170918184250.50403-1-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <90267277-ff85-623c-7ab0-2f5276e224b9@kernel.dk>
Date: Mon, 18 Sep 2017 12:43:41 -0600
MIME-Version: 1.0
In-Reply-To: <20170918184250.50403-1-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 09/18/2017 12:42 PM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> This lets platforms without dio (e.g. OpenBSD) fail with an explicit
> message, otherwise they fail without a clue about dio even with
> --debug=all enabled.

Applied, thanks.

-- 
Jens Axboe



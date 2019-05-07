Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Update CFLAGS and LDFLAGS for FreeBSD builds
References: <20190506221241.9951-1-rebecca@bluestop.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <626e0e78-c13c-6549-0e83-bd74e1d01a86@kernel.dk>
Date: Mon, 6 May 2019 22:19:19 -0600
MIME-Version: 1.0
In-Reply-To: <20190506221241.9951-1-rebecca@bluestop.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bluestop.org>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 5/6/19 4:12 PM, Rebecca Cran wrote:
> FreeBSD installs third-party headers into /usr/local/include
> and libraries into /usr/local/lib.
> Update CFLAGS and LDFLAGS to look there.

Applied, thanks.

-- 
Jens Axboe



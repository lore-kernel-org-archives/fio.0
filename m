Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] configure: fix syntax error with NetBSD
References: <20200817234708.20701-1-dmitry.fomichev@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <628f241e-af58-3bc3-6630-b527655fb9fa@kernel.dk>
Date: Wed, 19 Aug 2020 07:05:48 -0600
MIME-Version: 1.0
In-Reply-To: <20200817234708.20701-1-dmitry.fomichev@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Dmitry Fomichev <dmitry.fomichev@wdc.com>, Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 8/17/20 4:47 PM, Dmitry Fomichev wrote:
> The recent patch to detect for pkg-config presence has introduced some
> bash-specific code to configure script. This lead to syntax errors
> while running configure under some other shells, such as (d)ash.
> 
> Avoid ${!var} indirect substitution syntax and stop using "local"
> keyword which is non-POSIX-standard. Address a few minor shellcheck
> complaints about the code in same function.

Applied, thanks.

> Fixes: 162f8c2a96ae181d7e4099af8e9f39b5eac6886e

Fixed this one up in the process, it should look like this:

Fixes: 162f8c2a96ae ("configure: check if pkg-config is installed")

-- 
Jens Axboe



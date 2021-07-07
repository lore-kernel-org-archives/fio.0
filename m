Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Makefile: use override directive on engine CFLAGS
References: <20210706172700.189584-1-stefanha@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <dc2b5428-3af3-db12-b9a0-529f8bac0b87@kernel.dk>
Date: Wed, 7 Jul 2021 07:06:27 -0600
MIME-Version: 1.0
In-Reply-To: <20210706172700.189584-1-stefanha@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Stefan Hajnoczi <stefanha@redhat.com>, fio@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
List-ID: <fio@vger.kernel.org>

On 7/6/21 11:27 AM, Stefan Hajnoczi wrote:
> The GNU Make documentation says the following about the override
> keyword:
> 
>   Subsequent assignments or appends to this variable which are not
>   marked override will be ignored.
> 
>   https://www.gnu.org/software/make/manual/html_node/Override-Directive.html
> 
> When the override CFLAGS line was moved in commit
> f4bd2c3d80bc35f76892205a7e50426711e3def3 it broke the engine template,
> which does not use the override directive. Since the engine template is
> now evaluated afterwards, the engine CFLAGS are ignored.
> 
> Add the override keyword to the engine template so that engine CFLAGS
> are honored again.
> 
> Note that the CONFIG_DYNAMIC_ENGINES case doesn't need the override
> directive. It seems that GNU Make assigns CFLAGS even without the
> override directive in this case:
> 
>   $$($(1)_OBJS): CFLAGS := -fPIC $$($(1)_CFLAGS) $(CFLAGS)

Applied, thanks.

-- 
Jens Axboe



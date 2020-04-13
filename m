Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd: fix zonemode=zbd with NDEBUG
References: <20200410190621.GA26148@avx2>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <95c0d22e-1dae-0b5b-3e4f-f1e1d1381d03@kernel.dk>
Date: Mon, 13 Apr 2020 08:20:20 -0600
MIME-Version: 1.0
In-Reply-To: <20200410190621.GA26148@avx2>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: damien.lemoal@wdc.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 4/10/20 1:06 PM, Alexey Dobriyan wrote:
> assert() with NDEBUG doesn't evaluate argument.

Thanks, that's exactly why assert/debug calls to statements with
side effects is a really bad idea.

-- 
Jens Axboe



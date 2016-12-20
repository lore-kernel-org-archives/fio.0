Return-Path: <axboe@kernel.dk>
Subject: Re: OSX build error: POSIX_FADV_NORMAL undeclared
References: <92eceba1-55a9-b936-48a1-ddd2dd1c2695@bluestop.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <cceff9e0-e775-833b-fc57-d4d12ad787a7@kernel.dk>
Date: Tue, 20 Dec 2016 15:23:32 -0700
MIME-Version: 1.0
In-Reply-To: <92eceba1-55a9-b936-48a1-ddd2dd1c2695@bluestop.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bluestop.org>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/20/2016 02:34 PM, Rebecca Cran wrote:
> It looks like the commit ecb2083d39558db2664c41b5d78aa73cd51bff58 
> yesterday broke building on OS X (macOS Sierra) because it doesn't have 
> POSIX_FADV_NORMAL:
> 
> 
> ioengines.c:467:12: error: use of undeclared identifier 'POSIX_FADV_NORMAL'
>                          flags = POSIX_FADV_NORMAL;

Gah, my bad, should be fixed now.

-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Fix return value checking of fread() in iolog.c
References: <20180404231842.35916-1-rebecca@bluestop.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <992e2db4-0bba-8363-3706-ea39cb62c698@kernel.dk>
Date: Wed, 4 Apr 2018 19:19:06 -0600
MIME-Version: 1.0
In-Reply-To: <20180404231842.35916-1-rebecca@bluestop.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bluestop.org>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 4/4/18 5:18 PM, Rebecca Cran wrote:
> According to http://pubs.opengroup.org/onlinepubs/7908799/xsh/fread.html
> fread() returns a size_t, not ssize_t, and returns a value of 0 on
> both eof and an error. Therefore, check both feof() and ferror() to
> determine whether the call succeeded.

Thanks Rebecca, applied.

-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] smalloc: Disable if running on Valgrind
References: <20180310004506.5642-1-bart.vanassche@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8593db16-4582-85f0-0007-8c602d4732af@kernel.dk>
Date: Fri, 9 Mar 2018 21:33:00 -0700
MIME-Version: 1.0
In-Reply-To: <20180310004506.5642-1-bart.vanassche@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 3/9/18 5:45 PM, Bart Van Assche wrote:
> The Valgrind memory checker can only detect uninitialized reads and
> out-of-bounds writes if it knows about the dynamic memory allocation
> calls performed by an application. There are two ways to inform
> Valgrind about the sfree(), smalloc() and scalloc() calls:
> * Call the glibc equivalents if running on Valgrind.
> * By using the Valgrind memory pool client requests. See also
>   http://valgrind.org/docs/manual/mc-manual.html#mc-manual.mempools.
> 
> Since the former approach is the easiest to implement, follow that
> approach.

smalloc() is shared memory backed, it's not process private.

-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2] os-windows: fix cpumask operations
References: <20171114010040.72921-1-elliott@hpe.com>
 <20171114022209.73563-1-elliott@hpe.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <298318c6-9efc-6387-b56c-35ae8eb9e4f6@kernel.dk>
Date: Thu, 16 Nov 2017 14:07:01 -0700
MIME-Version: 1.0
In-Reply-To: <20171114022209.73563-1-elliott@hpe.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Robert Elliott <elliott@hpe.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/13/2017 07:22 PM, Robert Elliott wrote:
> Fix cpumask manipulation on (64-bit) Windows systems.
> 
> cpus_allowed=nn values greater than 32 does not work, due to
> * the compiler not promoting expressions like "1 << cpu" to
>   64 bits
> * the clear function clearing the wrong bit (using "cpu - 1"),
> * the clear function using XOR to clear (which only works if the
>   bit was previously set)
> * the check function returning a 64-bit value through a 32-bit
>   return value
> 
> Example problems (from extra debug prints):
> * setting CPU 32 really sets bit 0 (CPU 0)
> 	Set mask of 0000000000000000 to add 0000000000000001 (32)
> 
> * setting CPU 63 really sets bit 31 (CPU 31)
> 	Set mask of 0000000000000000 to add 0000000080000000 (63)
> 
> * clearing CPU 0 really clears bit 63 (CPU 63)
> 	Clear mask of 0000000055555555 to remove 8000000000000000 (0)
> 
> * clearing CPU 2 really clears bit 2 (CPU 2)
> 	Clear mask of 0000000055555555 to remove 0000000000000002 (2)
> 
> * checking claims CPU 32 is not in a mask of CPUs {32,34,36,38}
> 	for 0000005500000000 check if bit 32 is set ==> FALSE

Classic error... Thanks Robert, applied.

-- 
Jens Axboe



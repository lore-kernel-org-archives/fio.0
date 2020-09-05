Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] fio: support io_size=N% (N <= 100)
References: <20200903165402.GA78826@localhost.localdomain>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <12ba61f4-b40b-a1e1-65a7-f9c530ea4e0b@kernel.dk>
Date: Sat, 5 Sep 2020 09:39:19 -0600
MIME-Version: 1.0
In-Reply-To: <20200903165402.GA78826@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 9/3/20 10:54 AM, Alexey Dobriyan wrote:
> Parse "io_size=N%".
> 
> Semantics is "multiply whatever size= calculations result in".
> 
> Example #1:
> 
> 	size=50%
> 	io_size=50%
> 
> will do 25% of a file.
> 
> Example #2:
> 
> 	size=1G
> 	io_size=50%
> 
> will do 512M I/O.
> 
> As side effect, fix a bug with essentially infinite loop if both size=N%
> and io_size=M% are given: io_size is set to 2^64-... in this case (a lot!).
> 
> Note: only values under 100% work currently.
> Going for io_size=150% requires resetting workload generator state
> which is whole separate endeavour.

Applied, thanks.

-- 
Jens Axboe



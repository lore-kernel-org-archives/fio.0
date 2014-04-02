Return-Path: <axboe@kernel.dk>
Message-ID: <533C1CAE.7080702@kernel.dk>
Date: Wed, 02 Apr 2014 08:20:30 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Two fixes reported by clang
References: <533BD811.3050809@enovance.com>
In-Reply-To: <533BD811.3050809@enovance.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Erwan Velu <erwan@enovance.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-04-02 03:27, Erwan Velu wrote:
> Hi Jens,
>
> I've been running Clang 3.3 on fio and after reading many false positive
> errors, I found 1 real mistake and an improvement to make on the code.
>
> Please find my branch here :
> https://github.com/enovance/fio/tree/erwan/clang
>
> Note that my previous emails about init & options.c were coming also
> from this clang pass.

Both of these look good, applied! Thanks.


-- 
Jens Axboe



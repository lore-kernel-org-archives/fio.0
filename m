Return-Path: <axboe@kernel.dk>
Message-ID: <534C27AD.9060107@kernel.dk>
Date: Mon, 14 Apr 2014 12:23:41 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: No output when insufficient parameters given on the commandline
References: <5348653E.2010909@cran.org.uk>
In-Reply-To: <5348653E.2010909@cran.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/11/2014 03:57 PM, Bruce Cran wrote:
> When an incomplete job file is run, fio displays an error - but when
> insufficient parameters are specified on the commandline, fio just exits
> with no messages:
>
>  > fio --iodepth 32
>  >
>
>  > fio --filename test --iodepth 8 --rw randrw --size 4g --thread
> --runtime 120 --time_based
>  > echo $?
> 0

Thanks, I'll get that inconsistency fixed up.

-- 
Jens Axboe



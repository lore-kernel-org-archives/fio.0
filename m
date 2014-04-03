Return-Path: <axboe@kernel.dk>
Message-ID: <533DA6F7.1000303@kernel.dk>
Date: Thu, 03 Apr 2014 12:22:47 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: io_bytes overflow in JSON output on Windows
References: <533DA646.9070807@cran.org.uk>
In-Reply-To: <533DA646.9070807@cran.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/03/2014 12:19 PM, Bruce Cran wrote:
> On Windows, the io_bytes parameter can overflow in the JSON output
> because the JSON_INTEGER type is a 'long' - which is only 32-bit on
> Windows.  The attached patch should fix it by changing the JSON integer
> type to be 'long long'.
>

Thanks, applied.

-- 
Jens Axboe



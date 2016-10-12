Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Implement nice() for Windows
References: <136b33f7-ebb8-ee58-b4aa-b301c6433102@cran.org.uk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b8adc95a-37ba-8652-b760-9d8c136c59b8@kernel.dk>
Date: Wed, 12 Oct 2016 09:00:17 -0600
MIME-Version: 1.0
In-Reply-To: <136b33f7-ebb8-ee58-b4aa-b301c6433102@cran.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/11/2016 08:28 PM, Bruce Cran wrote:
> Setting "nice=-5" (i.e. "Above normal" priority) gives fio sufficient
> scheduling priority to keep the disk queues full. Otherwise, with more
> than 2 disks it can't keep up with SSDs.
>
Applied, thanks.

-- 
Jens Axboe



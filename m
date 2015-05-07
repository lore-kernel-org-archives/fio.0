Return-Path: <axboe@kernel.dk>
Message-ID: <554BD9E3.4040005@kernel.dk>
Date: Thu, 07 May 2015 15:32:19 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Add Windows ctime_r implementation and empty ioctl.h
 header
References: <554ADC87.2070605@cran.org.uk> <554B99DD.2000902@kernel.dk> <554BD378.70209@cran.org.uk> <554BD3CE.6090609@kernel.dk> <554BD8A5.6040104@cran.org.uk>
In-Reply-To: <554BD8A5.6040104@cran.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 05/07/2015 03:27 PM, Bruce Cran wrote:
> On 5/7/2015 3:06 PM, Jens Axboe wrote:
>>
>> Thanks, added
>
> And another patch, since my tree wasn't quite up-to-date: this time to
> add <limits.h> to eta.c and define _POSIX_HOST_NAME_MAX.

Honestly, that should just use PATH_MAX. I'll make that change instead 
of adding this patch.

-- 
Jens Axboe



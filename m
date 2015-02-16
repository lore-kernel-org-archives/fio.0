Return-Path: <axboe@kernel.dk>
Message-ID: <54E26834.2090202@kernel.dk>
Date: Mon, 16 Feb 2015 14:59:16 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] gettime.h: use time_t instead of size_t for copy
 of tv_sec
References: <1423838764-40731-1-git-send-email-castor.fu@egocast.org>
In-Reply-To: <1423838764-40731-1-git-send-email-castor.fu@egocast.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: castor.fu@egocast.org, fio@vger.kernel.org
Cc: Castor Fu <castor@egocast.org>
List-ID: <fio@vger.kernel.org>

On 02/13/2015 07:46 AM, castor.fu@egocast.org wrote:
> From: Castor Fu <castor@egocast.org>
>
> This addresses a small nit that our compiler was complaining about.
> Thanks!

Thanks, applied.


-- 
Jens Axboe



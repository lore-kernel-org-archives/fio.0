Return-Path: <axboe@kernel.dk>
Subject: Re: multiple entries for each second for bw/iop/xlat log files
References: <npf9p3$6e3$1@blaine.gmane.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <caf6faa7-9584-724c-2c5b-a6fb1a2af441@kernel.dk>
Date: Mon, 22 Aug 2016 11:33:13 -0600
MIME-Version: 1.0
In-Reply-To: <npf9p3$6e3$1@blaine.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Saeed <ionictea@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/22/2016 10:37 AM, Saeed wrote:
> Why are there multiple entries for each interval / second in the fio log
> generated?
>
> 1, 585142, 1, 4096
> 1, 4096000, 1, 4096
> 1, 4096000, 1, 4096
> 1, 0, 1, 4096
> 1, 0, 1, 4096
> 1, 4096000, 1, 4096
> 1, 0, 1, 4096
> 1, 0, 1, 4096
> 1, 4096000, 1, 4096
> 1, 0, 1, 4096
> 2, 4096000, 1, 4096
> 2, 4096000, 1, 4096
> 2, 4096000, 1, 4096
> 2, 0, 1, 4096
> 2, 4096000, 1, 4096
> 2, 4096000, 1, 4096
> 2, 4096000, 1, 4096
> 2, 0, 1, 4096
> 2, 0, 1, 4096
> 2, 0, 1, 4096

Ditto for this one, try current -git.

-- 
Jens Axboe


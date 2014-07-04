Return-Path: <axboe@kernel.dk>
Message-ID: <53B71D24.606@kernel.dk>
Date: Fri, 04 Jul 2014 15:31:16 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: lots of closes causing lots of invalidates while running
References: <94D0CD8314A33A4D9D801C0FE68B402958B83482@G9W0745.americas.hpqcorp.net> <53B71A50.603@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958B86823@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B86823@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: "dgilbert@interlog.com" <dgilbert@interlog.com>
List-ID: <fio@vger.kernel.org>

On 2014-07-04 15:26, Elliott, Robert (Server Storage) wrote:
>
>
>> -----Original Message-----
>> From: Jens Axboe [mailto:axboe@kernel.dk]
>> Sent: Friday, 04 July, 2014 4:19 PM
>> To: Elliott, Robert (Server Storage); fio@vger.kernel.org
>> Cc: dgilbert@interlog.com
>> Subject: Re: lots of closes causing lots of invalidates while running
>>
>> How big are the devices? Should only open/close once per reading it, but
>> if it's scsi_debug and they are small, then that might explain it. If
>> that's not the case, it's definitely a but and we'll need to look into it.
>>
>
> My original test was with 128 MiB.
> Same result with 1 GiB.
> Goes away with 2 GiB and 4 GiB.

The behavior should be the same, just a change in frequency.

-- 
Jens Axboe



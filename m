Return-Path: <axboe@kernel.dk>
Message-ID: <537F7E8E.4050200@kernel.dk>
Date: Fri, 23 May 2014 10:59:58 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Allow to reset offset_increment counter
References: <537F439E.9040904@gmail.com>
In-Reply-To: <537F439E.9040904@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jiri Horky <jiri.horky@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-05-23 06:48, Jiri Horky wrote:
> Hi all,
>
> because I got bitten by this multiple times I decided to give this patch
> a try :)
>
> Current implementation of offset calculation when offset_increment is in
> effect uses global thread_number as follows:
>      f->file_offset = td->o.start_offset + (td->thread_number - 1) *
> td->o.offset_increment;
>
> The thread number gets incremented for every job (subjob) so even you
> have multiple jobs with different filenames, the offset calculation is
> shared. I find this very unintuitive, especially in cases the offsets
> gets past the device/file. For example, if one wants to run sequential
> read test in 16 threads of multiple devices (/dev/sd{b,c,d}) in one
> group, which are of  1TB size, and to eliminate caching effect he wants
> each read to start at different offset, the config could look like
> following:

Maybe it would be better to have this offset calculation be on a 
per-thread-per-file basis? You are right in that it only makes sense 
within the same file or device, so maybe it'd be better to make it work 
more like you expect.

-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Subject: Re: Setting number of read threads
References: <CABO+gV_6uBVxzzZ3K4HmDs18w_KzT8C5QxsNgLN3wp1C=x7NwQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <02eb7f85-72ab-f311-22fe-832a140bb2e6@kernel.dk>
Date: Wed, 26 Feb 2020 19:52:13 -0700
MIME-Version: 1.0
In-Reply-To: <CABO+gV_6uBVxzzZ3K4HmDs18w_KzT8C5QxsNgLN3wp1C=x7NwQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Elliott Balsley <elliott@altsystems.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2/26/20 2:32 PM, Elliott Balsley wrote:
> When I do a sequential read test with multiple threads, the initial
> write only uses one thread.  Is there some way to adjust this?  For
> example a command like this:
> 
> fio --name moe --rw read --directory /mnt/nv01/fio/local --size 40G
> --bs 4M --numjobs 4 --group_reporting --direct 1
> 
> It lays out four files one at a time, then it reads them all back at
> once.  I would like to lay out the four files simultaneously to save
> time.  I hope this makes sense; I'm not sure if I'm phrasing this in
> the right way.

create_serialize=false would do that. It defaults to sequentially
since otherwise the fs layout tends to suffer.

-- 
Jens Axboe



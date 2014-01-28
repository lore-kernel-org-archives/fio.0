Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34692 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651AbaA1TYF (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 28 Jan 2014 14:24:05 -0500
Date: Tue, 28 Jan 2014 12:24:03 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: rand_seed declarations not consistent...is that ok?
Message-ID: <20140128192359.GB15212@kernel.dk>
References: <CANEJEGu_qW7rBB75B-Xppy8X-_=+dy951H7DeJ+9phJ4L=LVWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGu_qW7rBB75B-Xppy8X-_=+dy951H7DeJ+9phJ4L=LVWg@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: FIO_list <fio@vger.kernel.org>

On Tue, Jan 28 2014, Grant Grundler wrote:
> cscope tells me:
> C symbol: rand_seed
> 
>   File             Function                  Line
> 0 ioengine.h       <global>                    59 unsigned long rand_seed;
> 1 options.c        <global>                  1660 .off1 =
>                                                   td_var_offset(rand_seed),
> 2 thread_options.h <global>                   103 unsigned int rand_seed;
> 3 thread_options.h <global>                   327 uint32_t rand_seed;
> 4 verify.h         <global>                    34 uint64_t rand_seed;
> 
> Any reason we have 4 different declarations of the same name?
> Thoughts on if/how this should be fixed?
> 
> Even if it's not wrong, it's definitely confusing.

Heh no. But they are not all the same. Could be cleaned up, but the
parser has some expectations and the thread_options.h one has the local
and over-the-net client version (which is why they are different, one
matches the parser and the other is independent). I would suggest we
make 0/3/4 a uint64_t to unify that part. The option could be made
unsigned long long and the type changed.

-- 
Jens Axboe


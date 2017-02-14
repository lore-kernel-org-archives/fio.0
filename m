Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2 6/7] Acquire file ->lock while the lock itself is being
 copied
References: <20170214151948.16460-1-tkusumi@tuxera.com>
 <20170214151948.16460-7-tkusumi@tuxera.com>
 <20170214152348.GA32572@kernel.dk>
 <CAHndrBniGbuEmgZHzn6Ppn-qQqrpDd1rgnHy0Y-+UJsHJONBzw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <03cc02e6-dd53-3b23-ed72-ad8deda8bf6f@kernel.dk>
Date: Tue, 14 Feb 2017 08:33:39 -0700
MIME-Version: 1.0
In-Reply-To: <CAHndrBniGbuEmgZHzn6Ppn-qQqrpDd1rgnHy0Y-+UJsHJONBzw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 02/14/2017 08:27 AM, Tomohiro Kusumi wrote:
> I couldn't see a race too, but assumed there is since you (the author) say so.
> For the other one in dup_files(), I didn't think there's any race as commented.
> 
> But yes, if there's no race, please drop this.

OK good, then I'll just drop it. BTW, for reference, this was the
original code:

if (__f) {
        /*
         * racy, need the __f->lock locked
         */
        f->lock = __f->lock;
        f->lock_owner = __f->lock_owner;
        f->lock_batch = __f->lock_batch;
        f->lock_ddir = __f->lock_ddir;
	[...]

where that comment was from.

-- 
Jens Axboe



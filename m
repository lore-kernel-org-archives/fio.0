Return-Path: <axboe@kernel.dk>
Subject: Re: memalign.c and posix_memalign
References: <8FBD8EC3-8FCE-4071-9A28-032E3E24CA5A@bluestop.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f5e5fd56-e382-f93c-374b-8493bdc257a9@kernel.dk>
Date: Mon, 4 Dec 2017 08:08:45 -0700
MIME-Version: 1.0
In-Reply-To: <8FBD8EC3-8FCE-4071-9A28-032E3E24CA5A@bluestop.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bluestop.org>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12/02/2017 09:12 AM, Rebecca Cran wrote:
> I noticed that fio has code in lib/memalign.c to return an aligned
> pointer. I was wondering if we could call posix_memalign instead? Or
> is it too new to exist on all systems we support?

Don't think it's generally available, unfortunately. I always forget,
and then I get errors on windows and friends.

-- 
Jens Axboe



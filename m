Return-Path: <axboe@kernel.dk>
Subject: Re: Results from clang 7.0 analyzer (scan-build)
References: <2aebbd38-2c87-a88c-0b28-23d4d72c33cb@bluestop.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <6c156847-385b-5303-f015-df5fb2ba283d@kernel.dk>
Date: Sun, 8 Apr 2018 16:00:20 -0600
MIME-Version: 1.0
In-Reply-To: <2aebbd38-2c87-a88c-0b28-23d4d72c33cb@bluestop.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bluestop.org>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 4/7/18 5:58 PM, Rebecca Cran wrote:
> I ran clang 7.0's analyzer scan-build on a checkout of fio from a few 
> days ago (rev 196ce5d5ff76af30cf93fd24240f12d8c4d24381, Tue Apr 3).
> 
> 
> I've uploaded the results to 
> https://bluestop.org/scan-build-2018-04-07-171241-24360-1/ in case 
> anyone wants to take a look to see if it has found any real bugs.

I went through some of them, most of them don't matter. The only one
I found that could matter is:

commit 583e0dfa7479be45b8a5ab7a53c9de88139683e4
Author: Jens Axboe <axboe@kernel.dk>
Date:   Sun Apr 8 15:46:17 2018 -0600

    client: fix bad shadowing of 'ret'

-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Subject: Re: Recent changes (master)
References: <20190815120002.693802C22FD@kernel.dk>
 <0647fb02-f8db-d611-8079-e7f4348c6715@bsdio.com>
 <cab007cd-10f1-c504-4f1e-3fb45a25d337@kernel.dk>
 <bb33d4e0-46d9-486f-62b9-d4cdde61a7b1@bsdio.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <dfa0bc59-c3b9-941d-d47f-80315687cf2d@kernel.dk>
Date: Thu, 15 Aug 2019 09:17:19 -0600
MIME-Version: 1.0
In-Reply-To: <bb33d4e0-46d9-486f-62b9-d4cdde61a7b1@bsdio.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bsdio.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/15/19 9:05 AM, Rebecca Cran wrote:
> On 8/15/2019 8:28 AM, Jens Axboe wrote:
> 
>>
>> I did notice, I just didn't see what was wrong here. Can you remove the
>> assert and check the struct sizes of jobs_eta and jobs_eta_packed?
> 
> 
> jobs_eta is 168 bytes; jobs_eta_packed is 164.
> 
> Adding an extra 32-bit field before run_str fixes the error.

Can you check current -git? I took a look at the struct and cleaned it a
bit.

http://git.kernel.dk/cgit/fio/commit/?id=cd8920a40ef04625d9e76f63fa09fcaac9e9977e

-- 
Jens Axboe



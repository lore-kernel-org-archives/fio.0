Return-Path: <axboe@kernel.dk>
Message-ID: <54734976.2040207@kernel.dk>
Date: Mon, 24 Nov 2014 08:06:30 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Recent changes (master)
References: <20141124130003.2440440408@lyth.info> <5473317D.1060809@cran.org.uk>
In-Reply-To: <5473317D.1060809@cran.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/24/2014 06:24 AM, Bruce Cran wrote:
> On 11/24/2014 6:00 AM, Jens Axboe wrote:
>>        lfsr: don't pass in last value to lfsr_next()
>>
>>   io_u.c     |   14 ++++++++------
>>   lib/lfsr.c |    2 +-
>>   lib/lfsr.h |    2 +-
>>   3 files changed, 10 insertions(+), 8 deletions(-)
>
> t/axmap.c:40 also calls lfsr_next and needs updated.

Gah, sorry about that. I was working on a standalone test app, 
apparently forgot to check the whole thing. Fixed up now.

-- 
Jens Axboe



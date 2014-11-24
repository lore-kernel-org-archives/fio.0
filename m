Return-Path: <bruce@cran.org.uk>
Message-ID: <5473317D.1060809@cran.org.uk>
Date: Mon, 24 Nov 2014 06:24:13 -0700
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: Recent changes (master)
References: <20141124130003.2440440408@lyth.info>
In-Reply-To: <20141124130003.2440440408@lyth.info>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/24/2014 6:00 AM, Jens Axboe wrote:
>        lfsr: don't pass in last value to lfsr_next()
>
>   io_u.c     |   14 ++++++++------
>   lib/lfsr.c |    2 +-
>   lib/lfsr.h |    2 +-
>   3 files changed, 10 insertions(+), 8 deletions(-)

t/axmap.c:40 also calls lfsr_next and needs updated.

-- 
Bruce


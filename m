Return-Path: <axboe@kernel.dk>
Message-ID: <55CE0D4D.6020103@kernel.dk>
Date: Fri, 14 Aug 2015 09:46:21 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Clang static analyzer warnings
References: <55C0DEDA.2090306@cran.org.uk>
In-Reply-To: <55C0DEDA.2090306@cran.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 08/04/2015 09:48 AM, Bruce Cran wrote:
> I don't know how many of these are false positives, but I ran clang's
> static analyzer and it found a few potential issues. e.g.:
>
> client.c:1577:3: warning: Use of memory after it is freed
>                  fio_client_dec_jobs_eta(eta, ops->eta);
>                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> client.c:1579:2: warning: Use of memory after it is freed
>          dprint(FD_NET, "client: requested eta tag %p\n", eta);
>
> I've attached a copy of the build log, which includes the other warnings.

I don't think that's a real issue. I changed the code to make it 
explicit, hopefully that'll help clang as well.


-- 
Jens Axboe



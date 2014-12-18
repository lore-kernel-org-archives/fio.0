Return-Path: <axboe@kernel.dk>
Message-ID: <54935E81.60405@kernel.dk>
Date: Thu, 18 Dec 2014 16:08:49 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: 'fio: no option found at offset'
References: <5492265F.6090100@cran.org.uk>
In-Reply-To: <5492265F.6090100@cran.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12/17/2014 05:57 PM, Bruce Cran wrote:
> I noticed when running examples/tiobench-example.fio on both Windows and
> FreeBSD that several "fio: no option found at offset x" messages were
> displayed.   Are they supposed to be printed?

Nope, that should not happen. I don't seen them when running that
example config here, can you paste the full thing? I'll try freebsd
later today.

-- 
Jens Axboe



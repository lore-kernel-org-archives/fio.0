Return-Path: <axboe@kernel.dk>
Subject: Re: hash.h warning - left shift count
References: <531cbdb4-b115-c103-5eac-f83fa1b3119f@cran.org.uk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5745FAF0.5020606@kernel.dk>
Date: Wed, 25 May 2016 13:20:16 -0600
MIME-Version: 1.0
In-Reply-To: <531cbdb4-b115-c103-5eac-f83fa1b3119f@cran.org.uk>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: Bruce Cran <bruce@cran.org.uk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 05/24/2016 07:38 PM, Bruce Cran wrote:
> I'm seeing a new compiler warning on Windows. Since 'long' is 32 bits:
>
>
> hash.h: In function ‘__hash_long’:
> hash.h:58:2: warning: left shift count >= width of type
>    n <<= 33;
>    ^

Should be fixed by this:

http://git.kernel.dk/cgit/fio/commit/?id=1bd4cb6b62903c7785d6891d8b40a745b52c609f

-- 
Jens Axboe



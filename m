Return-Path: <axboe@kernel.dk>
Subject: Re: "disable_bw" option in HOWTO should be "disable_bw_measurement"
References: <3dcd7620-5355-680d-ae2e-c20f7a50045e@cran.org.uk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <03444854-ebc8-3aaa-0956-1212fcb9812f@kernel.dk>
Date: Wed, 12 Oct 2016 09:00:52 -0600
MIME-Version: 1.0
In-Reply-To: <3dcd7620-5355-680d-ae2e-c20f7a50045e@cran.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/11/2016 07:38 PM, Bruce Cran wrote:
> I'm hoping to have time to put together a patch, but just so it's
> reported: the HOWTO mentions an option "disable_bw", but options.c calls
> it "disable_bw_measurement".
>

I added that as an alias, to keep it inline with the slat/clat
equivalents.

-- 
Jens Axboe



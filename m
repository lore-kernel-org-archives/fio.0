Return-Path: <axboe@kernel.dk>
Subject: Re: FW: default value for random_generator
References: <923FC40148D42D44A828D320CE66E06A01E620@MX204CL01.corp.emc.com>
 <56A9411B.5020707@kernel.dk>
 <923FC40148D42D44A828D320CE66E06A01F15E@MX204CL01.corp.emc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56AD95DD.9060902@kernel.dk>
Date: Sat, 30 Jan 2016 22:04:29 -0700
MIME-Version: 1.0
In-Reply-To: <923FC40148D42D44A828D320CE66E06A01F15E@MX204CL01.corp.emc.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@emc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 01/30/2016 10:21 AM, Ruvinsky, Konstantin wrote:
> Hi Jens,
>
> Thanks for your answer. Sorry for delay - was OOO.
> The patch is very simple: is necessary to add words ", this is the default value" after description of the tausworthe generator:
>
>
>   999 random_generator=str    Fio supports the following engines for generating
> 1000                 IO offsets for random IO:
> 1001
> 1002                 tausworthe      Strong 2^88 cycle random number generator,
> 			        this is the default value.
> 1003                 lfsr            Linear feedback shift register generator
> 1004                 tausworthe64    Strong 64-bit 2^258 cycle random number
> 1005                                 generator
>
> Could you please add it to one of your future commits, since I'm not familiar enough with patching?

Sure, I added a mention of that to the HOWTO and man page.

-- 
Jens Axboe



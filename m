Return-Path: <axboe@kernel.dk>
Subject: Re: fiologparser.py
References: <12634496.Be1YEipj88@merkaba>
 <2097283958.65342663.1464088355308.JavaMail.zimbra@redhat.com>
 <196b983d-e6e1-2c2d-299e-de3b9cc742ff@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <574460FD.5060009@kernel.dk>
Date: Tue, 24 May 2016 08:11:09 -0600
MIME-Version: 1.0
In-Reply-To: <196b983d-e6e1-2c2d-299e-de3b9cc742ff@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Mark Nelson <mark.a.nelson@gmail.com>, Ben England <bengland@redhat.com>, Martin Steigerwald <ms@teamix.de>
Cc: fio@vger.kernel.org, Mark Nelson <mnelson@redhat.com>
List-ID: <fio@vger.kernel.org>

On 05/24/2016 08:04 AM, Mark Nelson wrote:
> I'm totally fine with removing .py from the name unless anyone else has
> objections.  I hadn't really thought about writing a man page, but that
> would be great if you want to give it a go.
>
> Let's see if we can remove the numpy and scipy dependencies.  It looks
> like we are just using it for min/average/median/max/percentile
> calculations.  It would be nice if users didn't need anything other than
> argparse.

I haven't looked at it, but if it's just for min/av/median/etc and 
percentiles, that can be trivially hand rolled.

-- 
Jens Axboe



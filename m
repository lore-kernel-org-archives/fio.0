Return-Path: <axboe@kernel.dk>
Received: from [192.168.1.130] ([216.160.245.98])
        by smtp.gmail.com with ESMTPSA id gv6sm9014353obc.21.2015.12.23.08.47.46
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Dec 2015 08:47:47 -0800 (PST)
Subject: Re: Fio 2.3 released
References: <567ACF12.1050404@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <567AD032.1070807@kernel.dk>
Date: Wed, 23 Dec 2015 09:47:46 -0700
MIME-Version: 1.0
In-Reply-To: <567ACF12.1050404@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/23/2015 09:42 AM, Jens Axboe wrote:
> Hi,
>
> Just in time for Christmas, I've spun a new release. You might have
> noticed that it has a different numbering than expected. The previous
> release was 2.2.13, so this should have been 2.2.14. But I've decided to
> switch to a simpler versioning scheme, so we'll just bump the Y of the
> X.Y numbering going forward.
>
> As usual, report any weirdness in testing this newer release.
>
> Happy Holidays!

Shortlog of the release can be found here:

http://brick.kernel.dk/snaps/fio-2.3.shortlog.txt

Notable new features is a rewrite of the client/server message handling, 
so it should be more stable now. It should also be a bit more fault 
tolerant, it can recover from certain lost messages. It also supports 
transmitting of the logs now, so you don't have to grab those from the 
server side. If you use fio in client/server mode, testing would be great.

There's a rewrite of the hdfs IO engine.

And there's support for a new job primitive, 'wait_for'. This is a bit 
more flexible than 'stonewall' in that you can wait for specific jobs, 
instead of just inserting a barrier in your job file.

-- 
Jens Axboe



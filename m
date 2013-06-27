Return-Path: <james.vanns@framestore.com>
Date: Thu, 27 Jun 2013 15:37:06 +0100 (BST)
From: James Vanns <james.vanns@framestore.com>
Reply-To: james.vanns@framestore.com
Message-ID: <10718372.30278923.1372343825971.JavaMail.root@framestore.com>
In-Reply-To: <20130627141648.GY25599@kernel.dk>
Subject: Re: Simulating bursts at different rates at irregular intervals?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: FIO <fio@vger.kernel.org>, Roger Sibert <roger_sibert@xyratex.com>
List-ID: <fio@vger.kernel.org>

> That's a bit of a bother, though, since you have to collect data and
> output from each individual run. And not only that, shutdown/startup
> will make things less than smooth. It could potentially dirty your
> results.
> 
> We could have something ala:
> 
> rate_sequence={10s:20M},{20s:5M}
> 
> or whatever, which runs 10s at 20M/sec, then 20s at 5M/sec. Repeat.
> Would be fairly easy to do.

Yes, that would be rather useful I think and the parameter format 
is intuitive. Though perhaps another parameter to somehow skew or
randomise the length at which the burst rate runs for? And to also
modify the sequence itself? Perhaps something akin to the following;

; define a list  of rates that occasionally override the default in 'rate'
burst_rates={10s:20M},{20s:5M}
; rate_sequence could default to the order defined above
burst_rate_sequence=random
; intervals (in ms) - defaults to random
burst_rate_interval=2500

Just imagine a spiky chart of write (or read, for that matter) throughput over time ;)

I suppose if interval were to be random then there should be a minimum and maximum.

Regards,

Jim

> --
> Jens Axboe
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Jim Vanns
Senior Software Developer
Framestore



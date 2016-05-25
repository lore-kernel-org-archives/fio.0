Return-Path: <bengland@redhat.com>
Date: Tue, 24 May 2016 22:02:49 -0400 (EDT)
From: Ben England <bengland@redhat.com>
Message-ID: <544894985.65649384.1464141769327.JavaMail.zimbra@redhat.com>
In-Reply-To: <5744F4C6.5060700@kernel.dk>
References: <897324962.65623516.1464126010451.JavaMail.zimbra@redhat.com> <5744F4C6.5060700@kernel.dk>
Subject: Re: assert failing with latency log
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Tim Wilkinson <twilkins@redhat.com>
List-ID: <fio@vger.kernel.org>

thx, that worked.  -ben

----- Original Message -----
> From: "Jens Axboe" <axboe@kernel.dk>
> To: "Ben England" <bengland@redhat.com>, fio@vger.kernel.org
> Cc: "Tim Wilkinson" <twilkins@redhat.com>
> Sent: Tuesday, May 24, 2016 8:41:42 PM
> Subject: Re: assert failing with latency log
> 
> On 05/24/2016 03:40 PM, Ben England wrote:
> > If I run this fio jobfile with absolute latest upstream code:
> >
> > [global]
> > directory=/var/tmp
> >
> > [randreads]
> > direct=1
> > rate_iops=1000
> > size=512m
> > ioengine=sync
> > bs=4k
> > rw=randread
> > filename=ben.dd
> > runtime=30
> > write_lat_log=foo
> >
> > It fails with
> >
> > fio: stat.c:1988: get_cur_log: Assertion `iolog->pending->nr_samples <
> > iolog->pending->max_samples' failed.
> >
> > But if I take out the "write_lat_log=foo" line, it succeeds.  The assertion
> > seems to be in the code path for latency logs, right?  Anyone else seen
> > this?
> 
> Gah, that's my bad, I broke sync IO engines with logging. I pushed a fix:
> 
> http://git.kernel.dk/cgit/fio/commit/?id=cf2c8d5260c9676964854e79382cba3eb498fd2e
> 
> I'll tag a new version as well, this is pretty unfortunate.
> 
> --
> Jens Axboe
> 
> 


Return-Path: <axboe@kernel.dk>
Message-ID: <541209FF.2070503@kernel.dk>
Date: Thu, 11 Sep 2014 14:45:51 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: deadlock in fio.. client/server
References: <CALKLVuJv4KqbKFU5fk0-TXw5fcXYmP55GA_RXdeA2+SXvantcg@mail.gmail.com>
In-Reply-To: <CALKLVuJv4KqbKFU5fk0-TXw5fcXYmP55GA_RXdeA2+SXvantcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Castor Fu <castor@egocast.org>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/30/2014 08:41 AM, Castor Fu wrote:
> I see what looks to me like a deadlock when running with multiple jobs
> in client/server mode.
> However, I'm not too used to debugging multithreaded code, so I
> figured maybe some additional eyes would help.
> 
> This is on a Gen8 HP DL380 (dual socket x86_64) running CentOS EL6.
> 
> I haven't seen this when just running from the command line.
> 
> I start the daemon with:
> 
> fio --daemonize=/tmp/fio.pid.4987 --server=localhost,8098
> 
> and a client with
> fio --client=localhost 8098 --output=test_blk.20140830Z1419 test_bad2.fio
> 
> #
> [global]
> 
> ioengine=libaio
> thread=1
> bs=4k
> filename=/dev/sdb
> size=1M
> do_verify=1
> iodepth=8
> stonewall
> 
> [writes]
> rw=write
> # 3 passes
> # 4 fails
> numjobs=4
> 
> and sometimes (50% or higher with num_jobs=4) it hangs.

Sorry for being late on this, I can reproduce it. Will take a look!

-- 
Jens Axboe



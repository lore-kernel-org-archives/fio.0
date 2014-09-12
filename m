Return-Path: <castor@egocast.org>
MIME-Version: 1.0
In-Reply-To: <54122B2E.4080202@kernel.dk>
References: <CALKLVuJv4KqbKFU5fk0-TXw5fcXYmP55GA_RXdeA2+SXvantcg@mail.gmail.com>
	<541209FF.2070503@kernel.dk>
	<54122B2E.4080202@kernel.dk>
Date: Thu, 11 Sep 2014 23:34:32 -0700
Message-ID: <CALKLVuLEE1xPaJw81ah_TUyPe6vY09Ux6ZbAcNNkZEQTdQT1EA@mail.gmail.com>
Subject: Re: deadlock in fio.. client/server
From: Castor Fu <castor@egocast.org>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thanks Jens!  That seems to work for me.

-castor

On Thu, Sep 11, 2014 at 4:07 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 09/11/2014 02:45 PM, Jens Axboe wrote:
>> On 08/30/2014 08:41 AM, Castor Fu wrote:
>>> I see what looks to me like a deadlock when running with multiple jobs
>>> in client/server mode.
>>> However, I'm not too used to debugging multithreaded code, so I
>>> figured maybe some additional eyes would help.
>>>
>>> This is on a Gen8 HP DL380 (dual socket x86_64) running CentOS EL6.
>>>
>>> I haven't seen this when just running from the command line.
>>>
>>> I start the daemon with:
>>>
>>> fio --daemonize=/tmp/fio.pid.4987 --server=localhost,8098
>>>
>>> and a client with
>>> fio --client=localhost 8098 --output=test_blk.20140830Z1419 test_bad2.fio
>>>
>>> #
>>> [global]
>>>
>>> ioengine=libaio
>>> thread=1
>>> bs=4k
>>> filename=/dev/sdb
>>> size=1M
>>> do_verify=1
>>> iodepth=8
>>> stonewall
>>>
>>> [writes]
>>> rw=write
>>> # 3 passes
>>> # 4 fails
>>> numjobs=4
>>>
>>> and sometimes (50% or higher with num_jobs=4) it hangs.
>>
>> Sorry for being late on this, I can reproduce it. Will take a look!
>
> Committed a fix for this, can you check current -git? This is the fix:
>
> http://git.kernel.dk/?p=fio.git;a=commit;h=44c8268d6e6d3b3f1efb1eb8a1c2d7bba1e8477b
>
>
> --
> Jens Axboe
>


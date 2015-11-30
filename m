Return-Path: <axboe@kernel.dk>
Subject: Re: Bug using ramp_time shows cpu over 100%
References: <ed17d1a2eea2407cb00badb46a05a386@BOWEX36-B.micron.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <565CC382.1010706@kernel.dk>
Date: Mon, 30 Nov 2015 14:45:38 -0700
MIME-Version: 1.0
In-Reply-To: <ed17d1a2eea2407cb00badb46a05a386@BOWEX36-B.micron.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Deyoung Hong (dhong)" <dhong@micron.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 11/25/2015 12:36 PM, Deyoung Hong (dhong) wrote:
> I think this is an fio bug.
>
> Description:   When specifying ramp_time, cpu may show over 100% (when using a polling mode driver).
> If ramp_time is not specified, cpu values appear to be correct.
> You normally don't see this problem because most drivers don't utilize high CPU usage.
> You will have to use some custom driver that does polling, for example (something like http://www.dpdk.org/).
>
> OS:  Any (but tested on Linux CentOS 6.6)

This should fix it:

http://git.kernel.dk/cgit/fio/commit/?id=210dd0fc66b8956065e098bb9314febe8993e849

Try current -git and hopefully it'll behave better.

-- 
Jens Axboe



Return-Path: <axboe@kernel.dk>
Message-ID: <52FCDF56.3060408@kernel.dk>
Date: Thu, 13 Feb 2014 08:05:58 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix g++ warning about void* used in arithmetic
References: <1392229542-14083-1-git-send-email-d.gollub@telekom.de>	<52FC45E9.3090101@kernel.dk> <20140213071357.36e92383@marvin>
In-Reply-To: <20140213071357.36e92383@marvin>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: Daniel Gollub <daniel.gollub@t-online.de>
Cc: fio@vger.kernel.org, Daniel Gollub <d.gollub@telekom.de>
List-ID: <fio@vger.kernel.org>

On 02/12/2014 11:13 PM, Daniel Gollub wrote:
> Hi Jens,
>
> On Wed, 12 Feb 2014 21:11:21 -0700, Jens Axboe wrote:
>> On 2014-02-12 11:25, Daniel Gollub wrote:
>>> ../parse.h: In function ‘void* td_var(thread_options*, fio_option*,
>>> unsigned int)’: ../parse.h:110:10: warning: pointer of type ‘void
>>> *’ used in arithmetic [-Wpointer-arith] ../parse.h:112:9: warning:
>>> pointer of type ‘void *’ used in arithmetic [-Wpointer-arith]
>>
>> I bet there are a lot of these, or other similar code that would
>> prevent compiling with g++. I'm dubious of the value add here. Fio is
>> written in C, after all.
>>
>
> I should have mentioned this in the commit message: this is required to
> compile an external ionengine written in C++. I do not try to compile
> entire fio with g++. If I include fio.h in the external ioengine,
> parse.h gets included by fio.h or so and causes this g++ warning.
>
> This was the last warning (which just got introduced 2 days
> ago) when fio.h gets included by an external engine build with g++.
>
> So the value here is to build external ioengines against libraries/APIs
> which are only available in C++. In my case against an internal library
> of CEPH.

I guessed as much last night, so I did end up applying your patches.

-- 
Jens Axboe



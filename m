Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] pattern.c: Add support for files in buffer_pattern
 argument.
From: Jens Axboe <axboe@kernel.dk>
References: <1496922406-10355-1-git-send-email-sbates@raithlin.com>
 <d261d47d-0f81-10d7-4821-33de313da21f@kernel.dk>
Message-ID: <9f2ae78e-8b84-950d-a459-ddf8def26f63@kernel.dk>
Date: Thu, 8 Jun 2017 09:20:28 -0600
MIME-Version: 1.0
In-Reply-To: <d261d47d-0f81-10d7-4821-33de313da21f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: sbates@raithlin.com, fio@vger.kernel.org
Cc: sagi@grimberg.me, logang@deltatee.com, muli@lightbitslabs.com
List-ID: <fio@vger.kernel.org>

On 06/08/2017 09:19 AM, Jens Axboe wrote:
> On 06/08/2017 05:46 AM, sbates@raithlin.com wrote:
>> From: Stephen Bates <sbates@raithlin.com>
>>
>> It is useful to be able to initialize the buffer contents using an
>> input file (e.g. when testing certain pathological patterns for
>> compression). Add support to the buffer_pattern input argument for
>> reading data from a file via enclosing the filename in ``''``.
> 
> Nifty! Thanks Stephen, I'll add this.

Could I trouble you for an update to the fio.1 man page as well?

-- 
Jens Axboe



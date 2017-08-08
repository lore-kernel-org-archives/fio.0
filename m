Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2] Add ability to keep memory-mapped files
References: <1501885470-2445-1-git-send-email-sbates@raithlin.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <03adc312-dac6-4c59-27de-58d7f618f933@kernel.dk>
Date: Tue, 8 Aug 2017 14:29:01 -0600
MIME-Version: 1.0
In-Reply-To: <1501885470-2445-1-git-send-email-sbates@raithlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: sbates@raithlin.com, fio@vger.kernel.org
Cc: logang@deltatee.com
List-ID: <fio@vger.kernel.org>

On 08/04/2017 04:24 PM, sbates@raithlin.com wrote:
> From: Stephen Bates <sbates@raithlin.com>
> 
> By default file backed memory mappings are unlink()'ed after use. This
> patch keeps the files if they already existed. We don't check for
> errors on access() since we will catch them on the open().
> 
> Discovered this when doing p2pmem testing and fio kept deleting the
> /dev/p2pmem0 files...
> 
> Changes since v1
>   Altered based on feedback from Jens to avoid using an option and
>   test for file existance instead.

This gets closer, but it doesn't make sense to use a new member in
the options structure for this. It's not an option, and as such it's
a bad fit. Additionally, options should always have a counter part
in the _packed version of the structure, and be converted as well,
for the onwire protocol.

I changed this to just use a flag in the thread_data instead:

http://git.kernel.dk/cgit/fio/commit/?id=f9cfc7d44a80638f81810416385136c35ad34658

-- 
Jens Axboe



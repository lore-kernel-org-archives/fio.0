Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Fix iodepth_batch=0
References: <7d9e503153a511700809a945521613b3c03389f5.1464764641.git.osandov@fb.com>
 <575054AD.90306@kernel.dk> <20160602173134.GA9588@vader.dhcp.thefacebook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <57506FA2.9030704@kernel.dk>
Date: Thu, 2 Jun 2016 11:40:50 -0600
MIME-Version: 1.0
In-Reply-To: <20160602173134.GA9588@vader.dhcp.thefacebook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Omar Sandoval <osandov@osandov.com>
Cc: fio@vger.kernel.org, kernel-team@fb.com, Omar Sandoval <osandov@fb.com>
List-ID: <fio@vger.kernel.org>

On 06/02/2016 11:31 AM, Omar Sandoval wrote:
> On Thu, Jun 02, 2016 at 09:45:49AM -0600, Jens Axboe wrote:
>> On 06/01/2016 01:04 AM, Omar Sandoval wrote:
>>> From: Omar Sandoval <osandov@fb.com>
>>>
>>> The man page claims that iodepth_batch=0 falls back to whatever was
>>> specified for iodepth, but the enforced minimum of 1 means that 0 is not
>>> actually valid.
>>>
>>> Fixes: a2e6f8ac56a9 ("Make iodepth_batch=1 by default")
>>> Signed-off-by: Omar Sandoval <osandov@fb.com>
>>
>> Probably a better idea to just adjust the check-and-set instead, ala the
>> below:
>>
>> diff --git a/init.c b/init.c
>> index 7166ea766d8a..e82446ba6f2a 100644
>> --- a/init.c
>> +++ b/init.c
>> @@ -695,7 +695,8 @@ static int fixup_options(struct thread_data *td)
>>   	/*
>>   	 * If batch number isn't set, default to the same as iodepth
>>   	 */
>> -	if (o->iodepth_batch > o->iodepth || !o->iodepth_batch)
>> +	if (o->iodepth_batch > o->iodepth ||
>> +	    !fio_option_is_set(o, iodepth_batch))
>>   		o->iodepth_batch = o->iodepth;
>>
>>   	/*
>
> I wasn't trying to change the default (which is currently 1), just trying to
> fix the discrepancy between the man page:
>
> iodepth_batch=int, iodepth_batch_submit=int
> 	This defines how many pieces of IO to submit at once. It defaults to 1
> 	which means that we submit each IO as soon as it is available, but can
> 	be raised to submit bigger batches of IO at the time. If it is set to 0
> 	the iodepth value will be used.
>
> and the actual behavior:
>
> # ./fio --name=test --filename=/dev/nullb0 --direct=1 --ioengine=libaio --iodepth=8 --iodepth_batch=0 --runtime=1 --time_based
> min value out of range: 0 (1 min)
> fio: failed parsing iodepth_batch=0

Ah gotcha, I think your patch will do nicely for that, and re-instate 
the documented behavior. Added, thanks.


-- 
Jens Axboe



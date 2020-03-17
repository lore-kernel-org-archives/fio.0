Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH RFC] gauss.c: correct the stddev initializtion
References: <20200317125331.6799-1-feng.tang@intel.com>
 <dab7e008-2fff-62d8-28f6-cc08a5388738@kernel.dk>
 <20200317145240.GA18256@shbuild999.sh.intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c7573ca4-e31d-583c-d5d1-c122ba54efe8@kernel.dk>
Date: Tue, 17 Mar 2020 08:56:19 -0600
MIME-Version: 1.0
In-Reply-To: <20200317145240.GA18256@shbuild999.sh.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Feng Tang <feng.tang@intel.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 3/17/20 8:52 AM, Feng Tang wrote:
> Hi,
> 
> On Tue, Mar 17, 2020 at 08:34:48AM -0600, Jens Axboe wrote:
>> On 3/17/20 6:53 AM, Feng Tang wrote:
>>> Signed-off-by: Feng Tang <feng.tang@intel.com>
>>> ---
>>>  lib/gauss.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/lib/gauss.c b/lib/gauss.c
>>> index 1d24e187..3f84dbc6 100644
>>> --- a/lib/gauss.c
>>> +++ b/lib/gauss.c
>>> @@ -51,7 +51,7 @@ void gauss_init(struct gauss_state *gs, unsigned long nranges, double dev,
>>>  	gs->nranges = nranges;
>>>  
>>>  	if (dev != 0.0) {
>>> -		gs->stddev = ceil((double) (nranges * 100.0) / dev);
>>> +		gs->stddev = ceil((double)(nranges * dev) / 100.0);
>>>  		if (gs->stddev > nranges / 2)
>>>  			gs->stddev = nranges / 2;
>>>  	}
>>
>> Looks like I very helpfully did not include a reference to to where
>> this is from... Can you expand on the need for the patch?
> 
> Thanks for your prompt response! 
> 
> I tried to run fio with "random_distribution=normal:20" as one
> parameter, and didn't notice it has difference with "normal:50",
> so I went to read the source code, as the man page says the
> deviation ranges from 0 to 100, so this gs->stddev will
> always be "nranges/2". Or I misunderstood the man page?

Nope I think you are right, I looked up the original change
that made it a parameter:

https://git.kernel.dk/cgit/fio/commit/?id=3cdb8cf38198d5cea73074d427ae310320e1d65f

and that clearly indicates that your patch is correct. I'll
apply it, thanks!

-- 
Jens Axboe



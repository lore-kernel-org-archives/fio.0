Return-Path: <axboe@kernel.dk>
Subject: Re: [three fio patches 3/3] smalloc: allocate pool-> members from
 shared memory
References: <20190828174842.25423-1-vincentfu@gmail.com>
 <20190828174842.25423-4-vincentfu@gmail.com>
 <bb5acdc6-d2f6-99e6-2e9e-01fef4650b74@kernel.dk>
 <BL0PR04MB4898E1614B5213924541271B95A30@BL0PR04MB4898.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d511fd90-d267-8a77-0d48-57b912447c23@kernel.dk>
Date: Wed, 28 Aug 2019 13:47:23 -0600
MIME-Version: 1.0
In-Reply-To: <BL0PR04MB4898E1614B5213924541271B95A30@BL0PR04MB4898.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Vincent Fu <Vincent.Fu@wdc.com>, "vincentfu@gmail.com" <vincentfu@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 8/28/19 1:44 PM, Vincent Fu wrote:
> On 8/28/19 3:13 PM, Jens Axboe wrote:
>> On 8/28/19 11:48 AM, vincentfu@gmail.com wrote:
>>> From: Vincent Fu <vincent.fu@wdc.com>
>>>
>>> If one process is making smalloc calls and another process is making
>>> sfree calls, pool->free_blocks and pool->next_non_full will not be
>>> synchronized because the two processes each have independent, local
>>> copies of the variables.
>>>
>>> This patch allocates space for the two variables from shared storage so
>>> that separate processes will be modifying quantities stored at the same
>>> locations.
>>>
>>> This issue was discovered on the server side running a client/server job
>>> with --status-interval=1. Such a job encountered an OOM error when only
>>> ~50 objects were allocated from the smalloc pool.
>>>
>>> Also change the calculation of free_blocks in add_pool() to use
>>> SMALLOC_BPI instead of SMALLOC_BPB. These two constants are
>>> coincidentally the same on Linux and Windows but SMALLOC_BPI is the
>>> correct one to use. free_blocks is the number of available blocks of
>>> size SMALLOC_BPB. It is the product of the number of unsigned integers
>>> in the bitmap (bitmap_blocks) and the number of bits per unsigned
>>> integer (SMALLOC_BPI).
>>
>> Would it make more sense to just have the pool[] come out of shared
>> memory?
>>
>>
> 
> Yeah, that would avoid the ugly *(pool->free_blocks) expressions and
> make things easier if anything else that needs to be shared is ever
> added to struct pool.
> 
> Would something like this in sinit() work?
> 
> if (nr_pools == 0)
> 
>       mp = mmap(NULL, MAX_POOLS * sizeof(struct pool), ...)

It should only be called once, so you should not need that nr_pools
check. But yeah, something like that.

> I'm on vacation through Labor Day and will work on this next week.

Sounds good. I have applied 1-2 for now, thanks Vincent.

-- 
Jens Axboe



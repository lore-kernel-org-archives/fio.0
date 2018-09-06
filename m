Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v3] zbd: Fix test scripts
References: <20180905080237.21887-1-damien.lemoal@wdc.com>
 <6f8e2641-8324-d767-4136-ed43984d5bd8@kernel.dk>
 <700656050e6f204b39dddcea467d52c92efb11ac.camel@wdc.com>
 <61d92ae03a6485aca95905d18e6ab0af7280dc2a.camel@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0f43ffdb-be83-ffb3-ac54-3f553622db39@kernel.dk>
Date: Wed, 5 Sep 2018 19:26:02 -0600
MIME-Version: 1.0
In-Reply-To: <61d92ae03a6485aca95905d18e6ab0af7280dc2a.camel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: "bvanassche@acm.org" <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

On 9/5/18 7:12 PM, Damien Le Moal wrote:
> On Thu, 2018-09-06 at 01:08 +0000, Damien Le Moal wrote:
>> Jens,
>>
>> On Wed, 2018-09-05 at 08:36 -0600, Jens Axboe wrote:
>>> On 9/5/18 2:02 AM, Damien Le Moal wrote:
>>>> Fix handling of the path to the test-zbd-support script to avoid an
>>>> error when the tests are run directly when in fio/t/zbd using the
>>>> command "./run-against...".
>>>
>>> Thanks, applied.
>>>
>>> Where are we on the other zbd fixes? I want to cut a new version
>>> fairly soon, but I don't want to do that with fixes still pending.
>>
>> The v3 of the 3 patch series I sent was heavily tested and reviewed by Bart.
>> So I think the changes are OK to go.
>>
>> I updated my pull request in github with the latest version of all patches:
>> * The 3 patches of the v3 "ZBD support improvements and cleanup":
>> 	[PATCH v3 1/3] zbd: Improve read randomness
>> 	[PATCH v3 2/3] zbd: Remove inexistent functions declaration
>> 	[PATCH v3 3/3] zbd: Fix zbd_zone_idx()
>> * This test script fix patch
>> * A patch that cleans up the code using the fio regular byte unit for zone
>> information:
>> 	[PATCH] zbd: Use bytes unit
> 
> Correction: I rebased the pull request. Since the test script patch was
> applied, only 4 patches in the pull request now.

Great thanks, I'll pull them in.

-- 
Jens Axboe



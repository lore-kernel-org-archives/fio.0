Return-Path: <axboe@kernel.dk>
Subject: Re: Potential Bug: Block size dropped in log files when running with
 log_avg_msec
References: <BN3PR1001MB1137DE7C7340FA5B1DD9E6709D730@BN3PR1001MB1137.namprd10.prod.outlook.com>
 <5739F9FC.4020205@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5739FB6E.7010201@kernel.dk>
Date: Mon, 16 May 2016 10:55:10 -0600
MIME-Version: 1.0
In-Reply-To: <5739F9FC.4020205@kernel.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Todd Lawall <tlawall@pivot3.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 05/16/2016 10:49 AM, Jens Axboe wrote:
> On 05/12/2016 04:54 PM, Todd Lawall wrote:
>> Hello,
>>
>> I've been doing some test runs with fio using the write_bw_log,
>> write_lat_log and write_iops_log options, and I've needed to use the
>> log_avg_msec option to set my sample interval.   I've noticed when
>> running with log_avg_msec, the block size is dropped from the logs.
>> See examples of the BW log:
>>
>> Without log_avg_msec:
>>
>> 13, 14833, 0, 32768
>> 13, 14780, 1, 32768
>> 13, 14780, 1, 32768
>> 13, 15003, 0, 32768
>> 13, 17702, 1, 32768
>> 13, 17655, 1, 32768
>>
>> With log_avg_msec:
>>
>> 500, 312320, 0, 0
>> 1090, 343972, 0, 0
>> 1090, 310784, 1, 0
>> 2083, 329861, 0, 0
>> 2083, 324756, 1, 0
>> 3073, 285252, 0, 0
>> 3073, 306290, 1, 0
>> 4040, 320644, 0, 0
>
> That is correct, fio will do that. I can add the block size, if it's
> consistent. The problem is if you are doing averaging for a multiple
> block size workload, then fio can't add it, as there would be no right
> answer. For a fixed size, it could though. I'll ensure that it does for
> that case.

http://git.kernel.dk/cgit/fio/commit/?id=66b98c9fe942e8fd417525ace39d0e0b93bcb9e9

This should fix it for you.

-- 
Jens Axboe



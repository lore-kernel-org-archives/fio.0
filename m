Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd: fix sequential verify with max_open_zones=1
References: <20200408221652.GA2592@avx2>
 <BY5PR04MB6900B4F8DFDDBB498EDA8768E7C10@BY5PR04MB6900.namprd04.prod.outlook.com>
 <20200409171401.GA3220@avx2>
 <BY5PR04MB6900D077D39EEAF4AE35809FE7C10@BY5PR04MB6900.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b6b09ff8-1149-c662-9838-35e61a7ce295@kernel.dk>
Date: Sat, 11 Apr 2020 14:18:56 -0600
MIME-Version: 1.0
In-Reply-To: <BY5PR04MB6900D077D39EEAF4AE35809FE7C10@BY5PR04MB6900.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <Damien.LeMoal@wdc.com>, Alexey Dobriyan <adobriyan@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 4/9/20 4:41 PM, Damien Le Moal wrote:
> On 2020/04/10 2:14, Alexey Dobriyan wrote:
>> On Thu, Apr 09, 2020 at 01:58:13AM +0000, Damien Le Moal wrote:
>>> On 2020/04/09 7:16, Alexey Dobriyan wrote:
>>>> Sequential write with max_open_zones=1 has interesting (read: buggy)
>>>> interaction with verify=.
>>
>>>> +				if (f->zbd_info->open_zones[i] == nz) {
>>>> +					zbd_close_zone(td, f, i);
>>>> +				}
>>>
>>> nit: you do not need the {} brackets for the if here.
>>
>> I started to use {} everywhere, it is less thinking that way.
> 
> Sure, but that is not the coding style normally used in fio and many other open
> source C projects. I will let Jens decide here.

I prefer no braces for single lines. The exception is if/else, where if one
has braces, the rest should too. Fio isn't really consistent in the latter
I think, but definitely the former.

-- 
Jens Axboe



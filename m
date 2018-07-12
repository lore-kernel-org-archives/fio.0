Return-Path: <axboe@kernel.dk>
Subject: Re: fio max blocksize
References: <MWHPR04MB032082F03EB254879C04F26B8F470@MWHPR04MB0320.namprd04.prod.outlook.com>
 <15f67a56-7f53-cfca-f4e6-289e1d6c2b14@kernel.dk>
 <MWHPR04MB0320E4A6307D8C818D3666418F590@MWHPR04MB0320.namprd04.prod.outlook.com>
 <4c57a31e-7955-d0b2-ed27-9d494f090651@kernel.dk>
 <MWHPR04MB032079BDBD1D6341D9B1D77A8F590@MWHPR04MB0320.namprd04.prod.outlook.com>
 <e0d997fd-0ee3-2157-1dac-4f0c4c0dfcda@kernel.dk>
 <MWHPR04MB0320A295A6828D92707C552D8F590@MWHPR04MB0320.namprd04.prod.outlook.com>
 <c36b2cb1-5af7-5171-3f84-6279b216b1d6@kernel.dk>
 <MWHPR04MB03209A6E1D7B2CB3319CFE028F590@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8c29ce9b-372d-d9f8-c836-b2e467d97a97@kernel.dk>
Date: Thu, 12 Jul 2018 16:49:01 -0600
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB03209A6E1D7B2CB3319CFE028F590@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 7/12/18 4:47 PM, Jeff Furlong wrote:
>> The above will overwrite nearby members.
> Was thinking the member was allocated as 64 bits but may only use 32
> bits, but agreed that's not true for other options that use
> FIO_OPT_INT (e.g. nr_files).  How about just breaking the ULL if/else
> out separately:

That is much better, that'll work fine.

BTW, not on when you do a more final version, be wary of tabs and
spaces. You seem to mix and match a bit. It's always tabs.

-- 
Jens Axboe



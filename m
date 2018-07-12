Return-Path: <axboe@kernel.dk>
Subject: Re: fio max blocksize
References: <MWHPR04MB032082F03EB254879C04F26B8F470@MWHPR04MB0320.namprd04.prod.outlook.com>
 <15f67a56-7f53-cfca-f4e6-289e1d6c2b14@kernel.dk>
 <MWHPR04MB0320E4A6307D8C818D3666418F590@MWHPR04MB0320.namprd04.prod.outlook.com>
 <4c57a31e-7955-d0b2-ed27-9d494f090651@kernel.dk>
 <MWHPR04MB032079BDBD1D6341D9B1D77A8F590@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e0d997fd-0ee3-2157-1dac-4f0c4c0dfcda@kernel.dk>
Date: Thu, 12 Jul 2018 13:38:04 -0600
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB032079BDBD1D6341D9B1D77A8F590@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 7/12/18 1:11 PM, Jeff Furlong wrote:
>> Basically the unsigned int version should just be a subset of the
>> ull, with the min/max settings things would just work out nicely.
>
> So the idea is to share the same case statement for both, not
> introduce unique case statements for UL and ULL, right?

Right, it's just converting (if needed) the general case to be ull
based. See how FIO_OPT_INT is basically the same as FIO_OPT_STR_VAL.
You might need to add an implicit knowledge that the uint based options
have an implied maxval of UINT_MAX, if maxval isn't set, to avoid cases
where we can parse much larger values than a particular option may be
able to store.

-- 
Jens Axboe



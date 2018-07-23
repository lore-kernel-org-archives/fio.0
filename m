Return-Path: <axboe@kernel.dk>
Subject: Re: fio max blocksize
References: <MWHPR04MB032082F03EB254879C04F26B8F470@MWHPR04MB0320.namprd04.prod.outlook.com>
 <15f67a56-7f53-cfca-f4e6-289e1d6c2b14@kernel.dk>
 <MWHPR04MB0320E4A6307D8C818D3666418F590@MWHPR04MB0320.namprd04.prod.outlook.com>
 <4c57a31e-7955-d0b2-ed27-9d494f090651@kernel.dk>
 <MWHPR04MB032079BDBD1D6341D9B1D77A8F590@MWHPR04MB0320.namprd04.prod.outlook.com>
 <e0d997fd-0ee3-2157-1dac-4f0c4c0dfcda@kernel.dk>
 <MWHPR04MB0320A295A6828D92707C552D8F590@MWHPR04MB0320.namprd04.prod.outlook.com>
 <AT5PR8401MB11693CAB8B003A65F407BDF1AB580@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <MWHPR04MB0320F06DBEA0F11A75EEF1BE8F580@MWHPR04MB0320.namprd04.prod.outlook.com>
 <MWHPR04MB0320FC699861B6963D67D54F8F580@MWHPR04MB0320.namprd04.prod.outlook.com>
 <a1f8111f-5b0f-1f6f-cab8-c02a35e35d3a@kernel.dk>
 <MWHPR04MB03200193A7DE2F49107615288F5C0@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <6fae3201-41af-e59e-1f4b-72e17a39f6c2@kernel.dk>
Date: Mon, 23 Jul 2018 09:17:52 -0600
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB03200193A7DE2F49107615288F5C0@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 7/17/18 3:38 PM, Jeff Furlong wrote:
>> I'd just convert those helpers to deal with unsigned long long always, that should work fine for the uint case.
> Done.  I tested with:
> 
> # fio --name=test --ioengine=libaio --direct=1 --rw=trim --iodepth=1 --bssplit=4g/100 --filename=/dev/nvme1n1 --number_ios=2
> 
> Here's the final patch unless someone finds an issue.  I also updated
> it so it applies nicely to the latest on git.  Tested with bs, ba,
> bsrange, bssplit options that have a >32 bit value.

Looks pretty good to me, I applied it with various little fixups in
terms of style. Please test current -git and ensure that it works
properly for you. Ran some basic testing here, and it still seems good.

-- 
Jens Axboe



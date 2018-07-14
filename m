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
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a1f8111f-5b0f-1f6f-cab8-c02a35e35d3a@kernel.dk>
Date: Fri, 13 Jul 2018 21:05:33 -0600
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB0320FC699861B6963D67D54F8F580@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 7/13/18 5:59 PM, Jeff Furlong wrote:
> I fixed the buflen issue (just keep peeling the onion back and
> updating all associated vars), fixed bsrange, fixed "auto" tabs, and
> did some simple tests:
> # fio --name=test --ioengine=libaio --direct=1 --rw=trim --iodepth=1 --bs=4g --filename=/dev/nvme1n1 --number_ios=1
> # fio --name=test --ioengine=libaio --direct=1 --rw=trim --iodepth=1 --bs=1t --filename=/dev/nvme1n1 --number_ios=1
> # fio --name=test --ioengine=libaio --direct=1 --rw=trim --iodepth=1 --bsrange=4g-8g --filename=/dev/nvme1n1 --number_ios=2
> 
> The open issue I have is parsing bssplit.  I plumbed out bssplit.bs as
> a 64 bit value, but using the existing value_pair helpers (32 bit)
> seem to conflict.  Don’t really want to duplicate chunks of code, so
> open to ideas there.

I'd just convert those helpers to deal with unsigned long long always,
that should work fine for the uint case.

Just a note that I'll be out all of next week, so you'll have plenty of
time to make this perfect before I get back :-)

-- 
Jens Axboe



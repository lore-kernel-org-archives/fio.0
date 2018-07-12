Return-Path: <axboe@kernel.dk>
Subject: Re: fio max blocksize
References: <MWHPR04MB032082F03EB254879C04F26B8F470@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <15f67a56-7f53-cfca-f4e6-289e1d6c2b14@kernel.dk>
Date: Thu, 12 Jul 2018 11:15:54 -0600
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB032082F03EB254879C04F26B8F470@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 7/6/18 3:15 PM, Jeff Furlong wrote:
> Hi All,
> Currently it looks like fio has a max blocksize of uint32_t.  So commands such as 
> 
> # fio --name=test --ioengine=libaio --direct=1 --rw=trim --iodepth=1 --bs=4g --filename=/dev/nvme1n1 --number_ios=1 max value out of range: 4294967296 (4294967295 max)
> fio: failed parsing bs=4g
> 
> will fail.  While I wouldn't normally do 4GB reads/writes, I would like to issue 4GB trims.  Otherwise I need to invoke a tool such as blkdiscard, but then summarizing all job IO is very difficult.  I went through the process of unsuccessfully changing the blocksize variables to uint64_t (failed getting buflen), but not sure if I missed a minor detail or a major roadblock that would prevent it.  How could >4GB blocksizes be supported?  Thanks.

You'd just need to change the type of the bs related options, and all
of the structs that hold it. Not impossible at all, an pretty
straight forward. So I'd say that what you did would likely work,
though it's hard to ensure that you didn't miss a conversion
somewhere. Post the patch and we can take a look at it.

-- 
Jens Axboe



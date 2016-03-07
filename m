Return-Path: <axboe@kernel.dk>
Subject: Re: Specify range and distribution of accesses
References: <BN3PR0401MB145783CB3B39ADEEAED39523F7A70@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CANvN+e=rTzEnCybj3jFkxt0WCGbSP4R1YbTBKpF+QBv3H2swkA@mail.gmail.com>
 <20160303161828.GC22164@kernel.dk> <20160303200446.GA2234@kernel.dk>
 <BN3PR0401MB1457E708CC129BD01FE8B94EF7B10@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <94D0CD8314A33A4D9D801C0FE68B40295C352DA9@G9W0745.americas.hpqcorp.net>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56DDF687.2070405@kernel.dk>
Date: Mon, 7 Mar 2016 14:45:43 -0700
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295C352DA9@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Jeff Furlong <jeff.furlong@hgst.com>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/07/2016 02:19 PM, Elliott, Robert (Persistent Memory) wrote:
>
>
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>> Behalf Of Jeff Furlong
>> Sent: Monday, March 07, 2016 2:47 PM
>> To: Jens Axboe <axboe@kernel.dk>; Andrey Kuzmin
>> <andrey.v.kuzmin@gmail.com>
>> Cc: fio@vger.kernel.org
>> Subject: RE: Specify range and distribution of accesses
>>
>> Thanks for the suggestions and patches.  Using the latest fio
>> version, the JESD219 workload is possible:
>>
>> # fio -version
>> fio-2.6-27-gd283
>>
>> # fio --name=JESD219 --ioengine=libaio --direct=1 --rw=randrw --
>> norandommap --randrepeat=0 --rwmixread=40 --rwmixwrite=60 --
>> iodepth=256 --size=100% --numjobs=4 --
>> bssplit=512/4:1024/1:1536/1:2048/1:2560/1:3072/1:3584/1:4k/67:8k/10:1
>> 6k/7:32k/3:64k/3 --random_distribution=zoned:50/5:30/15:20/80 --
>> overwrite=1 --filename=/dev/nvme0n1 --group_reporting --runtime=5m --
>> time_based --output=JESD219
>>
>
> That would fit well in the examples/ directory.

Agree, I have added it. I removed the 'overwrite=1' as that only applies 
to files, not devices. And norandommap is redundant with a non uniform 
random distribution, but it serves as documentation, so I left it. 
size=100% was also removed, as that is the default.

-- 
Jens Axboe



Return-Path: <mishagreen@gmail.com>
Return-Path: <mishagreen@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH 0/4] Generalize zonemode=zbd
From: Michael Green <mishagreen@gmail.com>
In-Reply-To: <7b5d0ce0-3204-20ba-2b44-17d734511d78@kernel.dk>
Date: Tue, 7 Apr 2020 16:50:04 -0400
Content-Transfer-Encoding: 7bit
Message-Id: <16A1A532-0269-4BF7-8E9E-848DC01FEDA8@gmail.com>
References: <20200407015900.1335019-1-damien.lemoal@wdc.com>
 <7b5d0ce0-3204-20ba-2b44-17d734511d78@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, fio <fio@vger.kernel.org>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>



> On Apr 7, 2020, at 4:48 PM, Jens Axboe <axboe@kernel.dk> wrote:
> 
> On 4/6/20 6:58 PM, Damien Le Moal wrote:
>> This series extend support for zonemode=zbd beyond Linux only and as is
>> allows the use of this zonemode on any platform with regular block
>> devices. The same also applies to Linux systems that do not have zoned
>> block device support (e.g. enterprise distributions with kernels version
>> lower than 4.10). For zoned block device support, Linux implementation
>> is preserved. Other OS specific code can be added with automatic
>> configuration with the configure script to add zoned block device
>> support.
>> 
>> Additionally, ioengine operations are updated to allow an IO engine to
>> provide implementations for the zone operations needed to support zoned
>> block devices. This is convenient for cases where the system OS/kernel
>> does not have any support implementation available.
>> 
>> Finally, the libzbc IO engine is introduced to support zoned block
>> devices on Linux distributions without native kernel level support (E.g.
>> RedHat/CentOS). SImilarly to the sg ioengine, this new IO engine usesi
>> passthrough commands implemeted by libzbc API to directly access SMR
>> drives.
> 
> Looks ok to me, I've applied it. But please send a job file that uses
> it as well to put in examples/, thanks.
> 
> -- 
> Jens Axboe
> 



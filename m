Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
Subject: Re: [PATCH 0/4] Generalize zonemode=zbd
References: <20200407015900.1335019-1-damien.lemoal@wdc.com>
 <7b5d0ce0-3204-20ba-2b44-17d734511d78@kernel.dk>
From: Vincent Fu <vincentfu@gmail.com>
Message-ID: <61e87991-3fdb-bed3-95b9-b730d7bfb222@gmail.com>
Date: Tue, 7 Apr 2020 20:07:03 -0400
MIME-Version: 1.0
In-Reply-To: <7b5d0ce0-3204-20ba-2b44-17d734511d78@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org
Cc: Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On 4/7/20 4:48 PM, Jens Axboe wrote:
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

The AppVeyor Windows builds fail due to the zbd changes:

https://ci.appveyor.com/project/axboe/fio/builds/32024485

configure reports:

Zoned block device support    no
libzbc engine                 no

but nevertheless an attempt is made to build the zbd code.


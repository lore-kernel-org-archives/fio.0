Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34243 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab2DJOCr (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 10 Apr 2012 10:02:47 -0400
Message-ID: <4F843D84.1070206@kernel.dk>
Date: Tue, 10 Apr 2012 16:02:44 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Re-2: Running FIO on Windows on given partition or raw device
References: <DIIE.000007F3000307A7@192.168.0.5>
In-Reply-To: <DIIE.000007F3000307A7@192.168.0.5>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: shu@wwwgroup.de
Cc: neependra.khare@gmail.com, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2012-04-10 15:33, shu@wwwgroup.de wrote:
>> On 04/10/2012 11:04 AM, Neependra Khare wrote:
>>> Hi,
>>>
>>> I want to run FIO on a given partition on Windows.  To do this I use
>>> the "mountvol" command and get the volume names and their mount
>>> points and then use them for "filename" option with FIO
>>>
>>> For example for "E:\" get following from "mountvol" command.
>>>
>>>     \\?\Volume{1277e70d-79a7-11e1-9fed-f04da2ef6fc9}\ E:\
>>>
>>> Then I run following commands:-
>>>
>>> $ fio.exe   --name=baseline --rw=randwrite --direct=1 --size=1g
>>> --iodepth=32 --blocksize=4096 --ioengine=windowsaio
>>> --filename=\\.\Volume{1277e70d-79a7-11e1-9fed-f04da2ef6fc9}
>>> --name=hddBaseline --stonewall
>>>
>>> $ fio.exe   --name=baseline --rw=randwrite --direct=1 --size=1g
>>> --iodepth=32 --blocksize=4096 --ioengine=windowsaio  --filename=E:\
>>> --name=hddBaseline --stonewall
>>>
>>> $ fio.exe   --name=baseline --rw=randwrite --direct=1 --size=1g
>>> --iodepth=32 --blocksize=4096 --ioengine=windowsaio
>>> --filename=E:\filename --name=hddBaseline --stonewall
>>>
>>> In all these cases I do not see any IO happening on "E" drive using
>>> "perfmon". All the IO happens on the root drive("C").
>>>
>>> On Linux I can use "/dev/sda" , "/dev/sda1" etc.
>>>
>>> I was expecting same on Windows.  Any help or pointers would be
>>> great.
>>
>> CC'ing in Bruce, he's the Windows guru...
>
> please try the "\\.\PhysicalDrive1" notation.  I use the "full
> physical drive" for stress testing RAID-Arrays under Windows and it
> works great.

Taking the liberty of CC'ing the original asker and the list back. Hope
this works for you, too.


-- 
Jens Axboe


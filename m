Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59480 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2DJMlv (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 10 Apr 2012 08:41:51 -0400
Message-ID: <4F842A2F.709@kernel.dk>
Date: Tue, 10 Apr 2012 14:40:15 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Running FIO on Windows on given partition or raw device
References: <CAMZBPnepbgTSTfW5JA2UYZ=NxXi_==tSVeWKXF_KCYD=FTs2sQ@mail.gmail.com>
In-Reply-To: <CAMZBPnepbgTSTfW5JA2UYZ=NxXi_==tSVeWKXF_KCYD=FTs2sQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Neependra Khare <neependra.khare@gmail.com>
Cc: fio@vger.kernel.org, Bruce Cran <bruce@cran.org.uk>

On 04/10/2012 11:04 AM, Neependra Khare wrote:
> Hi,
> 
> I want to run FIO on a given partition on Windows.  To do this I use
> the "mountvol" command and get the volume names and
> their mount points and then use them for "filename" option with FIO
> 
> For example for "E:\" get following from "mountvol" command.
> 
>     \\?\Volume{1277e70d-79a7-11e1-9fed-f04da2ef6fc9}\
>         E:\
> 
> Then I run following commands:-
> 
> $ fio.exe   --name=baseline --rw=randwrite --direct=1 --size=1g
> --iodepth=32 --blocksize=4096 --ioengine=windowsaio
> --filename=\\.\Volume{1277e70d-79a7-11e1-9fed-f04da2ef6fc9}
> --name=hddBaseline --stonewall
> 
> $ fio.exe   --name=baseline --rw=randwrite --direct=1 --size=1g
> --iodepth=32 --blocksize=4096 --ioengine=windowsaio  --filename=E:\
> --name=hddBaseline --stonewall
> 
> $ fio.exe   --name=baseline --rw=randwrite --direct=1 --size=1g
> --iodepth=32 --blocksize=4096 --ioengine=windowsaio
> --filename=E:\filename --name=hddBaseline --stonewall
> 
> In all these cases I do not see any IO happening on "E" drive using
> "perfmon". All the IO happens on the root drive("C").
> 
> On Linux I can use "/dev/sda" , "/dev/sda1" etc.
> 
> I was expecting same on Windows.
> Any help or pointers would be great.

CC'ing in Bruce, he's the Windows guru...

-- 
Jens Axboe


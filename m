Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60951 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab2DKEwT convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 11 Apr 2012 00:52:19 -0400
Received: by vcqp1 with SMTP id p1so366501vcq.19
        for <fio@vger.kernel.org>; Tue, 10 Apr 2012 21:52:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7694153F-BA83-41AF-BCB4-C857D0E1B9BB@cran.org.uk>
References: <CAMZBPnepbgTSTfW5JA2UYZ=NxXi_==tSVeWKXF_KCYD=FTs2sQ@mail.gmail.com>
	<7694153F-BA83-41AF-BCB4-C857D0E1B9BB@cran.org.uk>
Date: Wed, 11 Apr 2012 10:22:18 +0530
Message-ID: <CAMZBPneSb=yOSr62O5Od_G111kuSNQ0jcx0N3GVYjVidGJYuAQ@mail.gmail.com>
Subject: Re: Running FIO on Windows on given partition or raw device
From: Neependra Khare <neependra.khare@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Wed, Apr 11, 2012 at 5:44 AM, Bruce Cran <bruce@cran.org.uk> wrote:
> On 10 Apr 2012, at 10:04, Neependra Khare <neependra.khare@gmail.com> wrote:
>> $ fio.exe   --name=baseline --rw=randwrite --direct=1 --size=1g
>> --iodepth=32 --blocksize=4096 --ioengine=windowsaio
>> --filename=E:\filename --name=hddBaseline --stonewall
>>
>> In all these cases I do not see any IO happening on "E" drive using
>> "perfmon". All the IO happens on the root drive("C").
>
> ':' is a file name separator in fio (so e:\filename is writing to \filename on the current disk) so you should try escaping it, e.g. --filename=E\:\filename .

Thanks a lot Bruce.
By using  --filename=E\\:\filename I was able to run FIO on a partition.

Regards,
Neependra

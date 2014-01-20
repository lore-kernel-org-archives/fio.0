Return-Path: <fio-owner@vger.kernel.org>
Received: from smtprelay0087.hostedemail.com ([216.40.44.87]:51622 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750743AbaATV3w (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 20 Jan 2014 16:29:52 -0500
Message-ID: <52DD954E.7020706@nellans.org>
Date: Mon, 20 Jan 2014 15:29:50 -0600
From: David Nellans <david@nellans.org>
MIME-Version: 1.0
Subject: Re: Strange aggregate BW
References: <748581DD-9A26-41D7-A537-58F6D6741B33@gmail.com>
In-Reply-To: <748581DD-9A26-41D7-A537-58F6D6741B33@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: grant <626542@gmail.com>, fio@vger.kernel.org

On 01/20/2014 03:23 PM, grant wrote:
> Hello,
>
> I=EF=BF=BDve got a HWRAID with 10 NL-SAS HDDs.
> All of them used in logical volume RAID6.
> I=EF=BF=BDve tried to benchmark created volume with FIO v2.1.4:
>
> # cat seqwrite.fio
> [write]
> blocksize=3D512k
> filename=3D/dev/sda
> rw=3Dwrite
> direct=3D1
> buffered=3D0
> ioengine=3Dlibaio
> iodepth=3D1
> runtime=3D10m
> numjobs=3D16
>
> #./fio seqwrite.fio
>
> FIO returns:
> ...
> Run status group 0 (all jobs):
>    WRITE: io=3D127958MB, aggrb=3D2132.5MB/s, minb=3D56530KB/s, maxb=3D229=
141KB/s..


Between some hardware raid buffering, large block transfers, and 100%=20
sequential write you'll certainly be near optimal for sequential write=20
I/O seen at each disk.  200MB/s/disk is higher than most folks would=20
probably ballpark, but its not off by an order of magnitude or anything.=20
I assume ~150MB/s sequential performance for most "good" consumer=20
7200RPM drives.  Higher RPM alone could push you to ~200MB/s.
Try turning it into random I/O and if it goes to shit, then the results
are probably as-expected ;)

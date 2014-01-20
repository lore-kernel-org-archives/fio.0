Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yh0-f41.google.com ([209.85.213.41]:47855 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaATV2F (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 20 Jan 2014 16:28:05 -0500
Received: by mail-yh0-f41.google.com with SMTP id i7so1781820yha.28
        for <fio@vger.kernel.org>; Mon, 20 Jan 2014 13:28:03 -0800 (PST)
Received: from cloudberry-sbg.aeoncomputing.com ([12.226.163.194])
        by mx.google.com with ESMTPSA id a67sm5996591yhj.10.2014.01.20.13.28.02
        for <fio@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 20 Jan 2014 13:28:02 -0800 (PST)
Message-ID: <52DD94E1.2060607@aeoncomputing.com>
Date: Mon, 20 Jan 2014 13:28:01 -0800
From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
MIME-Version: 1.0
Subject: Re: Strange aggregate BW
References: <748581DD-9A26-41D7-A537-58F6D6741B33@gmail.com>
In-Reply-To: <748581DD-9A26-41D7-A537-58F6D6741B33@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

What make/model of NL-SAS disk drive? The 4TB/7200RPM drives are pushing=20
sequential media rates of >150MB/sec.

On 1/20/14, 1:23 PM, grant wrote:
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
>
> 2132 / 10 ~ 200 MB/s per HDD, is that possible???

--=20
------------------------------
Jeff Johnson
Co-Founder
Aeon Computing

jeff.johnson "at" aeoncomputing dot com
www.aeoncomputing.com
t: 858-412-3810 x1001   f: 858-412-3845

4170 Morena Boulevard, Suite D - San Diego, CA 92117

High-performance Computing / Lustre Filesystems / Scale-out Storage


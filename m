Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38154 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab2LAOv2 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 1 Dec 2012 09:51:28 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so571982vcd.19
        for <fio@vger.kernel.org>; Sat, 01 Dec 2012 06:51:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1582502590.159531.1354372015482.JavaMail.root@thomas-krenn.com>
References: <CAPDOW77bBKw7dm1e+jHdN+PXMnAddEzQOxnL6nPY25nZU2FCfQ@mail.gmail.com>
	<1582502590.159531.1354372015482.JavaMail.root@thomas-krenn.com>
Date: Sat, 1 Dec 2012 23:51:27 +0900
Message-ID: <CAPDOW77s0v6mrEr_DMUm1O4dBrFmD6aMbuDwj-Wsq6TiHU2Ysw@mail.gmail.com>
Subject: Re: I/O is issued twice at scsi level
From: Hiroyuki Yamada <mogwaing@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?ISO-8859-1?Q?Georg_Sch=F6nberger?= <gschoenberger@thomas-krenn.com>
Cc: fio@vger.kernel.org

Hi Georg,

I am using CentOS 5.7 and 5.8.
Using ext3 FS on LVM.
This issue happens without LVM, so LVM is not the cause, I think.

I changed the I/O size at the application level to 16KB then,
16KB I/O and 4KB I/O are issued at scsi level as following.
(SYSPREAD is application level I/O and SCSI is scsi i/o dispatching
from systemtap.)

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
SYSPREAD random(8472) 3, 0x16fc5200, 16384, 128137183232
SCSI random(8472) 0 1 0 0 start-sector: 226321183 size: 4096 bufflen
4096 FROM_DEVICE 1354354008068009
SCSI random(8472) 0 1 0 0 start-sector: 226323431 size: 16384 bufflen
16384 FROM_DEVICE 1354354008075927
SYSPREAD random(8472) 3, 0x16fc5200, 16384, 21807710208
SCSI random(8472) 0 1 0 0 start-sector: 1889888935 size: 4096 bufflen
4096 FROM_DEVICE 1354354008085128
SCSI random(8472) 0 1 0 0 start-sector: 1889891823 size: 16384 bufflen
16384 FROM_DEVICE 1354354008097161
SYSPREAD random(8472) 3, 0x16fc5200, 16384, 139365318656
SCSI random(8472) 0 1 0 0 start-sector: 254092663 size: 4096 bufflen
4096 FROM_DEVICE 1354354008100633
SCSI random(8472) 0 1 0 0 start-sector: 254094879 size: 16384 bufflen
16384 FROM_DEVICE 1354354008111723
SYSPREAD random(8472) 3, 0x16fc5200, 16384, 60304424960
SCSI random(8472) 0 1 0 0 start-sector: 58119807 size: 4096 bufflen
4096 FROM_DEVICE 1354354008120469
SCSI random(8472) 0 1 0 0 start-sector: 58125415 size: 16384 bufflen
16384 FROM_DEVICE 1354354008126343
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Do you have any idea what's going on ?



On Sat, Dec 1, 2012 at 11:26 PM, Georg Sch=EF=BF=BDnberger
<gschoenberger@thomas-krenn.com> wrote:
> ----- Original Message -----
>> From: "Hiroyuki Yamada" <mogwaing@gmail.com>
>> To: fio@vger.kernel.org
>> Sent: Saturday, 1 December, 2012 9:31:42 AM
>> Subject: I/O is issued twice at scsi level
>>
>> Hi,
>>
>> I am using fio for benchmarking random read IOPS of files.
>> (Test configuration is listed at the bottom.)
>>
>> I have traced I/Os from fio by systemtap and
>> noticed that the number of I/Os at scsi level is twice as many as the
>> number of I/Os at vfs level.
>> But, I/O size at both scsi level and vfs level shown as 4KB, so
>> simply
>> measured 1/2 performance.
>> I also tried by benchmarking tools and the same issue happend.
>> so, it's not fio specific issue.
>> But, I am wondering if any of you knows the reason for that or some
>> hints.
>>
>>
>> Test configuration.
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ioengine=3Dpsync
>> rw=3Drandread
>> numjobs=3D1
>> blocksize=3D4096
>> filename=3Dfile_morethan_100G
>> thread
>> runtime=3D60
>> randrepeat=3D0
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> (I clean up page caches every time before mesurement.)
>>
>>
>> Thanks,
>> Hiroyuki
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> This is very interesting as I am currently investigating a 50% performanc=
e gap between two performance systems.
> I am inspecting a 50% difference concerning 4k random read IOPS for the s=
ame device on different systems (a SCSI SSD), one Ubuntu 12.04 and one Cent=
OS.
>
> Can you provide some more information about your platform?
>
> Thanks, Georg

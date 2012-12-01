Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.thomas-krenn.com ([217.7.54.186]:51494 "EHLO
	mail.thomas-krenn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab2LAO06 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 1 Dec 2012 09:26:58 -0500
Date: Sat, 1 Dec 2012 15:26:55 +0100 (CET)
From: Georg =?utf-8?Q?Sch=C3=B6nberger?= 
	<gschoenberger@thomas-krenn.com>
Message-ID: <1582502590.159531.1354372015482.JavaMail.root@thomas-krenn.com>
In-Reply-To: <CAPDOW77bBKw7dm1e+jHdN+PXMnAddEzQOxnL6nPY25nZU2FCfQ@mail.gmail.com>
Subject: Re: I/O is issued twice at scsi level
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Hiroyuki Yamada <mogwaing@gmail.com>
Cc: fio@vger.kernel.org

----- Original Message -----
> From: "Hiroyuki Yamada" <mogwaing@gmail.com>
> To: fio@vger.kernel.org
> Sent: Saturday, 1 December, 2012 9:31:42 AM
> Subject: I/O is issued twice at scsi level
> 
> Hi,
> 
> I am using fio for benchmarking random read IOPS of files.
> (Test configuration is listed at the bottom.)
> 
> I have traced I/Os from fio by systemtap and
> noticed that the number of I/Os at scsi level is twice as many as the
> number of I/Os at vfs level.
> But, I/O size at both scsi level and vfs level shown as 4KB, so
> simply
> measured 1/2 performance.
> I also tried by benchmarking tools and the same issue happend.
> so, it's not fio specific issue.
> But, I am wondering if any of you knows the reason for that or some
> hints.
> 
> 
> Test configuration.
> =================
> ioengine=psync
> rw=randread
> numjobs=1
> blocksize=4096
> filename=file_morethan_100G
> thread
> runtime=60
> randrepeat=0
> =================
> (I clean up page caches every time before mesurement.)
> 
> 
> Thanks,
> Hiroyuki
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
This is very interesting as I am currently investigating a 50% performance gap between two performance systems.
I am inspecting a 50% difference concerning 4k random read IOPS for the same device on different systems (a SCSI SSD), one Ubuntu 12.04 and one CentOS.

Can you provide some more information about your platform?

Thanks, Georg

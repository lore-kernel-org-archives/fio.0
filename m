Return-Path: <fio-owner@vger.kernel.org>
Received: from rcsinet13.oracle.com ([148.87.113.125]:50376 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbZDXEmm (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 24 Apr 2009 00:42:42 -0400
Message-ID: <49F142A8.4030000@oracle.com>
Date: Fri, 24 Apr 2009 10:10:08 +0530
From: Gurudas Pai <gurudas.pai@oracle.com>
MIME-Version: 1.0
Subject: Re: Recent changes
References: <869776.96350.qm@web63807.mail.re1.yahoo.com>
In-Reply-To: <869776.96350.qm@web63807.mail.re1.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: girish.satihal@yahoo.com
Cc: fio@vger.kernel.org

Do as follow:

DO NOT mount partition on /mnt
run fio.

OR

mount partition on /mnt
use /mnt in fio jobfile. do not use partition.

Thanks,
-guru


Girish Satihal wrote:
> Hi Guru,
> I first mount the paritition with ext3 files system on /mnt and run the 
> fio test on the device.
> When you run mount command you can see the device is mounted on /mnt 
> with ext3 file system. Let me know if you have anything to say on this. 
> Did you ever try such testing earlier?
>  
> Thanks,
>  Girish
> 
> --- On *Wed, 4/22/09, Gurudas Pai /<gurudas.pai@oracle.com>/* wrote:
> 
>     From: Gurudas Pai <gurudas.pai@oracle.com>
>     Subject: Re: Recent changes
>     To: "Girish Satihal" <girish.satihal@yahoo.com>
>     Cc: fio@vger.kernel.org
>     Date: Wednesday, April 22, 2009, 11:23 AM
> 
>     Girish,
> 
>     > The reason for saying ext3, is I run fdisk on /dev/cciss/c1d0 and created
>     a primary partition.
>     > Then I created a ext3 filesystem on this partition by running mkefs and
>     mounted this partition 
>     > on /mnt folder. Then I run fio on this partition.
>     you run it on disk directly(/dev/cciss/c1d0) without mounting it on /mnt.
> 
> 
>     Thanks,
>     -Guru
>     --
>     To unsubscribe from this list: send the line "unsubscribe fio" in
>     the body of a message to majordomo@vger.kernel.org
>     More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Return-Path: <fio-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35502 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab0KRWMN (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 18 Nov 2010 17:12:13 -0500
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id oAILu1gI009095
	for <fio@vger.kernel.org>; Thu, 18 Nov 2010 16:56:01 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id oAIMCB3D2273416
	for <fio@vger.kernel.org>; Thu, 18 Nov 2010 17:12:11 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id oAIMCB7P027212
	for <fio@vger.kernel.org>; Thu, 18 Nov 2010 17:12:11 -0500
Message-ID: <4CE5A4BA.7030409@austin.ibm.com>
Date: Thu, 18 Nov 2010 16:12:10 -0600
From: Steven Pratt <slpratt@austin.ibm.com>
MIME-Version: 1.0
Subject: Re: How to flush the writing cache before a test with read
References: <AANLkTimn=cJXQN-=wC4v8AeMEYGXUUfrM5nvVMzLkwEY@mail.gmail.com> <AANLkTiknYzSOx8Othcvb4UA=Vvyb4WTPd8jy9t-2CV+b@mail.gmail.com>
In-Reply-To: <AANLkTiknYzSOx8Othcvb4UA=Vvyb4WTPd8jy9t-2CV+b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dan Le <wb.danle@gmail.com>
Cc: fio@vger.kernel.org

Dan Le wrote:
> Greetings,
>
> FIO needs to write data files in order to read them. Without disabling
> the write-cache of the disk, I was wondering if there's a way to flush
> these data cache to disk right before FIO starts to read these files.
>   
Fio does an fsync and an FADVISE_DONT_NEED call after file creation 
phase which causes the cache to be dropped. I have never had a problem 
with files still being in cache when a read test starts.  The only one 
to watch out for is if you repeat the test, the files may be in cache 
from a previous read, as the default behavior is to not delete on 
completion and to not re-create if they already exist.

Steve

> I don't want to run every second "sync && echo 3 >
> /proc/sys/vm/drop_caches" at the same time with FIO because of its
> incurred overhead. Please help.
>
> Thank you,
>
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   


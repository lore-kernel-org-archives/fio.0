Return-Path: <fio-owner@vger.kernel.org>
Received: from mail4.conversis.de ([213.203.219.181]:57767 "EHLO
	mail4.conversis.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab3HGKgV (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 7 Aug 2013 06:36:21 -0400
Message-ID: <52022323.2030208@conversis.de>
Date: Wed, 07 Aug 2013 12:36:19 +0200
From: Dennis Jacobfeuerborn <dennisml@conversis.de>
MIME-Version: 1.0
Subject: Re: no slat log
References: <520173F7.6000104@conversis.de> <52020EFA.6060208@enovance.com>
In-Reply-To: <52020EFA.6060208@enovance.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 07.08.2013 11:10, Erwan Velu wrote:
> On 07/08/2013 00:08, Dennis Jacobfeuerborn wrote:
>> Hi,
>> when I try to create logs with fio I get bw, iops, lat, clat and slat
>> logs but the slat log always has a size of 0 bytes. Is this a bug or
>> is data for this log only generated with specific options for fio?
>>
> Dennis,
>
> I've been trying this on my 2.1.2 with the following job :
>
> [read-sda-4k-para]
> bs=4k
> filename=/dev/sda
> rw=read
> write_lat_log=lat.log
>
> On my side, the slat file is perfectly filled.
>
> Can you provide a testing procedure & the version you use ?

I just tested the job above and these are the files produced:

[dennis@nexus fio]$ ls -l
total 11272
-rw-r--r--. 1 root   root   5767080  7. Aug 12:31 lat.log_clat.log
-rw-r--r--. 1 root   root   5767087  7. Aug 12:31 lat.log_lat.log
-rw-r--r--. 1 root   root         0  7. Aug 12:31 lat.log_slat.log
-rw-rw-r--. 1 dennis dennis      84  7. Aug 12:31 logtest.fio

There are not errors or warnings during the fio run so it's not clear 
why the file ends up being empty.

Regards,
   Dennis


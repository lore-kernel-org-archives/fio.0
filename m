Return-Path: <fio-owner@vger.kernel.org>
Received: from postman.teamix.net ([194.150.191.120]:35757 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932108Ab2EIO1G convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 9 May 2012 10:27:06 -0400
Received: from zimbra.of.teamix.net (unknown [172.21.242.23])
	by rproxy.teamix.net (Postfix) with ESMTP id B34357A0A4
	for <fio@vger.kernel.org>; Wed,  9 May 2012 16:27:05 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.of.teamix.net (Postfix) with ESMTP id A2137123764
	for <fio@vger.kernel.org>; Wed,  9 May 2012 16:27:05 +0200 (CEST)
Received: from zimbra.of.teamix.net ([127.0.0.1])
	by localhost (zimbra.of.teamix.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d9oagC5SAG+Q for <fio@vger.kernel.org>;
	Wed,  9 May 2012 16:27:05 +0200 (CEST)
Received: from mango.localnet (kaesefondue.of.teamix.net [172.21.123.2])
	by zimbra.of.teamix.net (Postfix) with ESMTPSA id 47A15123762
	for <fio@vger.kernel.org>; Wed,  9 May 2012 16:27:05 +0200 (CEST)
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: difference between "lat" and "clat"
Date: Wed, 9 May 2012 16:27:04 +0200
References: <201205091423.03699.ms@teamix.de>
In-Reply-To: <201205091423.03699.ms@teamix.de>
MIME-Version: 1.0
Content-Type: Text/Plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201205091627.04740.ms@teamix.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Am Mittwoch, 9. Mai 2012 schrieb Martin Steigerwald:
> Hi Jens, hi everyone,
> 
> Well mails from my mail client seem to appear here.
> 
> 
> I have some questions regarding fio latencies.
> 
> There are three kind of latencies described in README, from which fio 2.0.7
> only displays clat and lat:
> 
> slat = submission latency
> 
> clat = completion latency
> 
> lat = I/O completion latency
> 
> 
> Now I try to understand the README but I am not sure whether I really got
> the difference.
> 
> I understand:
> 
> slat: The time to submit the I/O. This is the time after which a syscall
> returns to userspace. On sync I/O this will include the completion of the
> request as sync I/O will wait for the request to land in pagecache. On
> asynchronous I/O this will be really fast.
> 
> clat: This is the time to complete handling the I/O request. Then it is at
> least in the pagecache on buffered I/O.
> 
> lat: The time it takes till the request has been processed. The HOWTO says:
> "This is the time from when IO leaves fio and when it gets completed."
> 
> So how is that completion different from the other completion in clat?
[…]
> Reads:
>     clat (usec): min=189 , max=954818 , avg=5423.72, stdev=21529.85
>      lat (usec): min=190 , max=954818 , avg=5423.90, stdev=21529.85
> 
> 
> Writes:
>     clat (usec): min=3 , max=2391.5K, avg=180.47, stdev=8936.82
>      lat (usec): min=4 , max=2391.5K, avg=180.59, stdev=8936.82
> 
> 
> So whats the difference here? Is
> 
> lat = slat + clat?

Could be (from another job with iodepth 64)

write:
slat (usec): min=5 , max=753280 , avg=190.49, stdev=8787.41
clat (usec): min=677 , max=2178.2K, avg=317831.81, stdev=282569.45
lat (usec): min=715 , max=2178.2K, avg=318023.20, stdev=282631.85

read:
slat (usec): min=5 , max=139 , avg=22.73, stdev= 5.52
clat (msec): min=8 , max=1756 , avg=203.10, stdev=174.58
lat (msec): min=8 , max=1756 , avg=203.13, stdev=174.58

Hmmm, on read averages don't add up.

> Why did you drop slat from output?

Forget this one. It obviously is there.

Ciao,
-- 
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

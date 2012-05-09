Return-Path: <fio-owner@vger.kernel.org>
Received: from postman.teamix.net ([194.150.191.120]:60017 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754527Ab2EIMXG convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 9 May 2012 08:23:06 -0400
Received: from zimbra.of.teamix.net (unknown [172.21.242.23])
	by rproxy.teamix.net (Postfix) with ESMTP id C0EFC7A0A4
	for <fio@vger.kernel.org>; Wed,  9 May 2012 14:23:04 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.of.teamix.net (Postfix) with ESMTP id B90A0146C1F
	for <fio@vger.kernel.org>; Wed,  9 May 2012 14:23:04 +0200 (CEST)
Received: from zimbra.of.teamix.net ([127.0.0.1])
	by localhost (zimbra.of.teamix.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nXPr1qAwuBUx for <fio@vger.kernel.org>;
	Wed,  9 May 2012 14:23:04 +0200 (CEST)
Received: from mango.localnet (kaesefondue.of.teamix.net [172.21.123.2])
	by zimbra.of.teamix.net (Postfix) with ESMTPSA id 42AA6146C19
	for <fio@vger.kernel.org>; Wed,  9 May 2012 14:23:04 +0200 (CEST)
From: Martin Steigerwald <ms@teamix.de>
Subject: difference between "lat" and "clat"
Date: Wed, 9 May 2012 14:23:03 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201205091423.03699.ms@teamix.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens, hi everyone,

Well mails from my mail client seem to appear here.


I have some questions regarding fio latencies.

There are three kind of latencies described in README, from which fio 2.0.7 
only displays clat and lat:

slat = submission latency

clat = completion latency

lat = I/O completion latency


Now I try to understand the README but I am not sure whether I really got the 
difference.

I understand:

slat: The time to submit the I/O. This is the time after which a syscall 
returns to userspace. On sync I/O this will include the completion of the 
request as sync I/O will wait for the request to land in pagecache. On 
asynchronous I/O this will be really fast.

clat: This is the time to complete handling the I/O request. Then it is at 
least in the pagecache on buffered I/O.

lat: The time it takes till the request has been processed. The HOWTO says: 
"This is the time from when IO leaves fio and when it gets completed."

So how is that completion different from the other completion in clat? 

In fact values seem to be roughly the same:

Reads:
    clat (usec): min=773 , max=104267 , avg=6333.91, stdev=4327.57
     lat (usec): min=773 , max=104267 , avg=6334.10, stdev=4327.57


Writes:
    clat (usec): min=773 , max=104267 , avg=6333.91, stdev=4327.57
     lat (usec): min=773 , max=104267 , avg=6334.10, stdev=4327.57

For:

root@frisbie:~#  cat randreadwrite.job
[global]
size=2g
runtime=60
direct=1
[zufälliglesen]
rw=randread
[zufälligschreiben]
rw=randwrite

But even on buffered I/O this seems to be similar (same job without direct=1):

Reads:
    clat (usec): min=189 , max=954818 , avg=5423.72, stdev=21529.85
     lat (usec): min=190 , max=954818 , avg=5423.90, stdev=21529.85


Writes:
    clat (usec): min=3 , max=2391.5K, avg=180.47, stdev=8936.82
     lat (usec): min=4 , max=2391.5K, avg=180.59, stdev=8936.82


So whats the difference here? Is

lat = slat + clat?




Why did you drop slat from output?

I tried to enable it.

But I get:

root@frisbie:~# fio randreadwrite-buffered.job
fio: failed parsing disable_slat=false
fio: job global dropped
root@frisbie:~#

Is this another deprecated manpage option?



And then I try to understand the clat new output:

    clat percentiles (usec):
     |  1.00th=[    4],  5.00th=[    5], 10.00th=[    5], 20.00th=[    5],
     | 30.00th=[    5], 40.00th=[    5], 50.00th=[    5], 60.00th=[    6],
     | 70.00th=[    6], 80.00th=[    6], 90.00th=[    6], 95.00th=[    7],
     | 99.00th=[   12], 99.50th=[13120], 99.90th=[31360], 99.95th=[38656],
     | 99.99th=[58112]

What does the th mean?

After reading documentation on "percentile_list" read this as follows:

- 1% of the requests have taken 4 usec
- 5% of the requests have taken 5 usec (does that include the 1% number? Seems 
so)
- 10% of the requests have taken 5 usec (some issue with accuracy here? 
5.something usec?)
[…]
- 70% of the requests have taken 6 usec
- 99,99% of the requests have taken less than 58112 usec





Up to know I have looked at the most was "lat" - seems that seemed to be the 
most realistic value to me. Is there any point in giving much attention to 
clat from an admin point of view? I am inclined to omit it from output via 
"disable_clat" unless I see a case where I need this.

Thanks,
-- 
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

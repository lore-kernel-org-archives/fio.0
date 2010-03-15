Return-Path: <fio-owner@vger.kernel.org>
Received: from ge0.mail1.hoer.dk.ip.fullrate.dk ([90.185.1.42]:50651 "EHLO
	smtp.fullrate.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937130Ab0COXTP (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 15 Mar 2010 19:19:15 -0400
Received: from arvinserver1.home.troels.arvin.dk (1608ds2-ksa.0.fullrate.dk [90.184.70.86])
	by smtp.fullrate.dk (Postfix) with ESMTP id 1B3D39CD1D
	for <fio@vger.kernel.org>; Tue, 16 Mar 2010 00:19:13 +0100 (CET)
Received: from localhost (arvinserver1.home.troels.arvin.dk [127.0.0.1])
	by arvinserver1.home.troels.arvin.dk (Postfix) with ESMTP id A336C108124
	for <fio@vger.kernel.org>; Tue, 16 Mar 2010 00:19:10 +0100 (CET)
Received: from arvinserver1.home.troels.arvin.dk ([127.0.0.1])
	by localhost (arvinserver1.home.troels.arvin.dk [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id BF+QJbGz78GQ for <fio@vger.kernel.org>;
	Tue, 16 Mar 2010 00:19:08 +0100 (CET)
Received: from kurt-III.home.troels.arvin.dk (kurt-III.home.troels.arvin.dk [192.168.1.9])
	by arvinserver1.home.troels.arvin.dk (Postfix) with ESMTP id 0CDBC1080F1
	for <fio@vger.kernel.org>; Tue, 16 Mar 2010 00:19:08 +0100 (CET)
Message-ID: <4B9EC06E.2000101@arvin.dk>
Date: Tue, 16 Mar 2010 00:19:10 +0100
From: Troels Arvin <troels@arvin.dk>
MIME-Version: 1.0
Subject: Re: Does fio write only 0x00s?
References: <4B9E9D92.80701@arvin.dk> <20100315212219.GQ5768@kernel.dk>
In-Reply-To: <20100315212219.GQ5768@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

On Mar 15, Jens Axboe wrote:
> By default, fio will at init time randomly fill the buffer of the
> allocated IO units. If you are using the sync io engine, then only one
> buffer will be allocated and that will be repeatedly written. So yes,
> that'll compress very nicely.

I'm using libaio. So the data from that shouldn't compress all that much?


> You can enable refill_buffers=1 and
> that'll cause fio to randomly fill it everytime it's submitted instead.
> That should effectively disable compression at the storage end.

Turning refill_buffers on or off doesn't seem to make much of a 
difference when compressing fil's work-file with "gzip -2" (201MB vs 
198MB). But perhaps, "gzip -2" still compreses more than one can expect 
from a storage system?

I'm probably missing something. Here's the job description file I'm 
using (in this case only testing a small amount of I/O; when I was 
testing the storage systems, I used size=10g and six numjobs=6):
===========================================================
[global]
description=Emulation of Intel IOmeter File Server Access Pattern

[iometer]
bssplit=512/10:1k/5:2k/5:4k/60:8k/2:16k/4:32k/4:64k/10
rw=randrw
rwmixread=70
direct=1
size=1g
ioengine=libaio
iodepth=256
refill_buffers=0
===========================================================

-- 
Regards,
Troels Arvin <troels@arvin.dk>
http://troels.arvin.dk/

Received: from dsmtpq4-prd-nl1-vfz.edge.unified.services (dsmtpq4-prd-nl1-vfz.edge.unified.services [84.116.6.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADA31B7F4
	for <fio@vger.kernel.org>; Thu,  4 Apr 2024 18:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.116.6.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712257088; cv=none; b=XHvct3f8aAZh8fDcAFeDn2/iEDyHxBvudTTqpdCE1tlXqJBu+LA37VkqEnF0yvFhoRs4QyLkDLRRkwUZd5cTXg98gfZoBY2/BRLI7KR5LAQjrKU1swtMlryhwfcvBWP+DUFb96uCERD5laXrc65j91i66zvjFuNj48a1MBC4omQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712257088; c=relaxed/simple;
	bh=CynJegiiXhceJhw65yLA+mn46+zDhRvUHHqPWBiyMeI=;
	h=MIME-Version:Content-Type:Date:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=dpAHd5SLj7KGMu3jXNqENsaomUBcJdV3XeZ32CiJMopSJDEpholKP28oM2ii8oMek0VslTEOTbawDYOPnYaNI8pnBByupoh76BzTF6cwbfzoziQFH14ucO3f9khzO05mDzKTNWS8k7oXhgatwO6/lC9/Puh9aYseNijZS+JRcps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kngnt.org; spf=pass smtp.mailfrom=kngnt.org; dkim=pass (2048-bit key) header.d=kngnt.org header.i=@kngnt.org header.b=lY4V+1+s; arc=none smtp.client-ip=84.116.6.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kngnt.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kngnt.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kngnt.org header.i=@kngnt.org header.b="lY4V+1+s"
Received: from csmtpq2-prd-nl1-vfz.edge.unified.services ([84.116.50.17])
	by dsmtpq4-prd-nl1-vfz.edge.unified.services with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <felix@kngnt.org>)
	id 1rsRqe-007Fxh-R8
	for fio@vger.kernel.org; Thu, 04 Apr 2024 20:30:04 +0200
Received: from csmtp6-prd-nl1-vfz.nl1.unified.services ([100.107.80.134] helo=csmtp6-prd-nl1-vfz.edge.unified.services)
	by csmtpq2-prd-nl1-vfz.edge.unified.services with esmtp (Exim 4.93)
	(envelope-from <felix@kngnt.org>)
	id 1rsRqX-00FrW0-BV
	for fio@vger.kernel.org; Thu, 04 Apr 2024 20:29:57 +0200
Received: from mail.kngnt.org ([80.115.15.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 256/256 bits)
	(Client did not present a certificate)
	by csmtp6-prd-nl1-vfz.edge.unified.services with ESMTPSA
	id sRqWrbyAVVcfQsRqXrUNGo; Thu, 04 Apr 2024 20:29:57 +0200
X-Env-Mailfrom: felix@kngnt.org
X-Env-Rcptto: fio@vger.kernel.org
X-SourceIP: 80.115.15.152
X-CNFS-Analysis: v=2.4 cv=A6lqPbWG c=1 sm=1 tr=0 ts=660ef1a5 cx=a_exe
 a=YXwiZ4wAml67grcSS0vdmg==:117 a=YXwiZ4wAml67grcSS0vdmg==:17
 a=IkcTkHD0fZMA:10 a=nkeF1AVaAAAA:8 a=n4fEmJXIZf_LsKOaTh8A:9 a=QEXdDO2ut3YA:10
 a=UYIxEE25oWhQQR-GPtP5:22
X-Authenticated-Sender: f.rubiodalmau@ziggo.nl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kngnt.org; s=mail;
	t=1712255396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2snFKMBnpS7mLWkQLxBHDM3+NZgQmvAxxNHHU6THwB8=;
	b=lY4V+1+sh3P1KzqJOJh7WBoIxCq4Tky2WEFuoKLVzglgo5juhOvXrGSms6i8vMEB3/JF6r
	txAa1YijMg92guczwj1ZbxGtYihQceyAFIL5rrdcSHuf86agwOjUoG0AXf70M8Yi6ynYoB
	TzSq+sY46ApPgmCAf7mQ3idvfUyjlEzkBcqAj/GFVRH8H40y9d+5P7h/bEFUURfLRxALHE
	9nsTpxcAsLCJHXZq3FJMSu4RAR7TZ5UvMY5pL0gXPY2ztCHgN91EUKWdK4ml8j6CbAmnQZ
	4YZ5dyzPN+IkK6aJbZw4sFKwMR11t9kbGsBYBA7tZYl3qqI9xE6fDcyApdwUqQ==
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Apr 2024 20:29:56 +0200
From: Felix Rubio <felix@kngnt.org>
To: fio@vger.kernel.org
Subject: Re: help understanding the output of fio
In-Reply-To: <e9efa7bb-f2b3-47f0-aa03-5191f85562e8@kernel.org>
References: <90e42eaab7569a03239ad05dfd1ebb1d@kngnt.org>
 <2494cb75-e0ff-41fe-ad4c-73f383a0c704@cs.utexas.edu>
 <a3415a4de55f178b06c3451fdbe43e08@kngnt.org>
 <cfbf631e-5783-40a1-b577-9716c3cdc955@kernel.org>
 <4d12ea060363d934d84201f834b21a38@kngnt.org>
 <e9efa7bb-f2b3-47f0-aa03-5191f85562e8@kernel.org>
Message-ID: <ab53bad3b175f18fa2e170078325d99e@kngnt.org>
X-Sender: felix@kngnt.org
X-CMAE-Envelope: MS4xfESBz5toSlZCPtpAqOfWPy25wYtnr6KcGGVRhdqWUnzgdlhpoPx/uTAAsXC3l5E9B2MO+0OrSsQ8JIXMl192HFA59iE7HNkGsd4hUeFQRRj7Pt0nNKCd
 kI7ddDX+xe8+ItjniOt2LUAc/BGZxzFHzxa7pr0UF98lx/gBEU0mZs2YF1zAMZNOHr88YODGOtCEaw==

Hi Damien,

First of all, thank you for your time responding to this email. I do not 
know what info was supposed to provide, so I am completing it as info is 
requested. In this case, I am using a kernel 6.1.0, coming down from 
debian stable. The ZFS version that I am using is 2.1.11, and 
unfortunately I cannot test it against the raw drive because I would be 
destroying my pools (as also Patrick points out).

I have a feeling that the drives are not the ones to blame because a) 
they get reported 
(https://ssd.userbenchmark.com/SpeedTest/1471/SanDisk-SDSSDP064G) as 
performing at at 190+ MBps, way better than I am obtaining, and b) I 
bought 2 of these drives on one hand, and the third separately one year 
later (so the changes of getting a bad batch are pretty low. If I run 
the tests on the pool that has the two drives, in strip mode, I get 
double the performance... so the SSD behave consistently in that aspect.

Before coming here I passed by the openzfs libera chat, where some 
colleagues tried to help pointing out that could be related to the SATA 
controller. With respect to that, I have observed that the other drive 
(HDD ST3500412AS) connected to that same SATA controller offers the 
following results:

BS     bandwidth (MBps)   IOPS
4K          93           23700
8K         101           12300
16k         96            5871
32k         97            2970
64k        103            1568
128k       100             788
256k        99             392

which are consistent with the results observed in 
https://hdd.userbenchmark.com/SpeedTest/5332/ST3500412AS.

So... everything points to either an evil combination of the SATA 
controller and the SSD, or a misconfiguration somewhere in my linux that 
I can not pinpoint. The reason because of I landed here is... to try to 
gain some knowledge, because professionally I am quite far from storage 
system benchmarking, so... I can get numbers, but interpreting those is 
definitely another discussion :-/

Thank you for any further insights, if any!

Regards,

---
Felix Rubio
"Don't believe what you're told. Double check."

Received: from dsmtpq3-prd-nl1-vfz.edge.unified.services (dsmtpq3-prd-nl1-vfz.edge.unified.services [84.116.6.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0DB132807
	for <fio@vger.kernel.org>; Thu,  4 Apr 2024 19:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.116.6.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712257215; cv=none; b=ewT1XsyLB42tca7H07AxV6oRVmP+AqimHg1tjULl3cofu4kFrTUr8zJyJUicN+i1T5JXT4AmtWYLJTzRUArFJh24ctvU63INsgwfr7zy3YpDIEOVO3O5AFKnV4RqLYoWiNZMqKGwc39mXK/xmDNJYD3ilyBioNPsy1QYOrsriA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712257215; c=relaxed/simple;
	bh=ToscF7E5ch80CP4xS/9YCXHziDXYwmMD54ikauKF9xs=;
	h=MIME-Version:Content-Type:Date:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=oouPJLMqr1PRaLMAmErQV01iXPr0RdwD6AvE471tJ0k5ElJlZiHOV9cJTRJOCtygDE5edkPp9y0uv6CrWDNkF8FMYcUzTGO+kMLh33A87vasz9zBLZktI6xP3da45SWDVfh/JY+OCKIf5K7QK0ywTIApjQoXA7Y85PZDdKvsFjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kngnt.org; spf=pass smtp.mailfrom=kngnt.org; dkim=pass (2048-bit key) header.d=kngnt.org header.i=@kngnt.org header.b=mpTD1j1W; arc=none smtp.client-ip=84.116.6.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kngnt.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kngnt.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kngnt.org header.i=@kngnt.org header.b="mpTD1j1W"
Received: from csmtpq4-prd-nl1-vfz.edge.unified.services ([84.116.50.10])
	by dsmtpq3-prd-nl1-vfz.edge.unified.services with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <felix@kngnt.org>)
	id 1rsSJe-00CAO4-Lu
	for fio@vger.kernel.org; Thu, 04 Apr 2024 21:00:02 +0200
Received: from csmtp4-prd-nl1-vfz.nl1.unified.services ([100.107.80.18] helo=csmtp4-prd-nl1-vfz.edge.unified.services)
	by csmtpq4-prd-nl1-vfz.edge.unified.services with esmtp (Exim 4.93)
	(envelope-from <felix@kngnt.org>)
	id 1rsSJX-00EA41-EF
	for fio@vger.kernel.org; Thu, 04 Apr 2024 20:59:55 +0200
Received: from mail.kngnt.org ([80.115.15.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 256/256 bits)
	(Client did not present a certificate)
	by csmtp4-prd-nl1-vfz.edge.unified.services with ESMTPSA
	id sSJXrBBYU1i6dsSJXrTiyx; Thu, 04 Apr 2024 20:59:55 +0200
X-Env-Mailfrom: felix@kngnt.org
X-Env-Rcptto: fio@vger.kernel.org
X-SourceIP: 80.115.15.152
X-CNFS-Analysis: v=2.4 cv=MKBmmtZl c=1 sm=1 tr=0 ts=660ef8ab cx=a_exe
 a=YXwiZ4wAml67grcSS0vdmg==:117 a=YXwiZ4wAml67grcSS0vdmg==:17
 a=IkcTkHD0fZMA:10 a=u-4_mny8rZ0eyI1ysugA:9 a=QEXdDO2ut3YA:10
X-Authenticated-Sender: f.rubiodalmau@ziggo.nl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kngnt.org; s=mail;
	t=1712257194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9eS3vmALZfwL8A+qr1SCy2DdCniYhrxqta6W3ESPU8Y=;
	b=mpTD1j1W/aE+SzKn4SR7aiqF/rRIqUssJd7scquhkND7OtH/IBOONEkCYuuR9l/bEY04LK
	PATc+mjXonZ9U2D52COeAXqoBuhHuT17HOGCIEf9vyusSvwBRmcsOy7lltVUc4XH1nZsR7
	pcWsajAA+ZiLqNpVpWrS7EFEUWxascUUXPeFlpEjNWXei5C88tmzQ0Pdgox6+59nqtlfP8
	lZaUK9+DLQfMhD92GqTyXO7qwD4LBDCzg5/mTiRcA/rqMJcfHMM5rS05TDYWjgaCd62xYA
	RayunJLzJuXw38E4JIEFIdgRKFUkUeCzGGyYDJiRu/n3K+n3P6OKfIR/+tSQYw==
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Apr 2024 20:59:54 +0200
From: Felix Rubio <felix@kngnt.org>
To: fio@vger.kernel.org
Subject: Re: help understanding the output of fio
In-Reply-To: <CAFCYAscWYUASXzLYk1d1M1d2zcZDtPaz3PdwV_hZmxPw_tRxPA@mail.gmail.com>
References: <90e42eaab7569a03239ad05dfd1ebb1d@kngnt.org>
 <2494cb75-e0ff-41fe-ad4c-73f383a0c704@cs.utexas.edu>
 <a3415a4de55f178b06c3451fdbe43e08@kngnt.org>
 <cfbf631e-5783-40a1-b577-9716c3cdc955@kernel.org>
 <CAFCYAscWYUASXzLYk1d1M1d2zcZDtPaz3PdwV_hZmxPw_tRxPA@mail.gmail.com>
Message-ID: <7c7cb7c19e6f3587864f37888122b58d@kngnt.org>
X-Sender: felix@kngnt.org
X-CMAE-Envelope: MS4xfBmr3E/teqh1pTw5tZSmXPtn+zm1JXCIvHgAL+Gi3FcFWFQvrvFrflfsgByptZZceNT1d7hN42/GtHj7XGTP5PnhWXzlz2gcUzQLJW6IiydiGfWBiXI+
 0yehoaJvoh69L7loa+ZFVKPrUGfsGDUZsvwTcb9d5st4xGiFpMAZdv3VzI/A+AdMasP+MMmFg3UDtA==

hey Jeff,

Good catch! I have run the following command:

fio --name=seqread --numjobs=1 --time_based --runtime=60s --ramp_time=2s 
--iodepth=8 --ioengine=libaio --direct=1 --verify=0 --group_reporting=1 
--bs=1M --rw=read --size=1G --filename=/dev/sda

(/sda and /sdd are the drives I have on one of the pools), and this is 
what I get:

seqread: (g=0): rw=read, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, 
(T) 1024KiB-1024KiB, ioengine=libaio, iodepth=8
fio-3.33
Starting 1 process
Jobs: 1 (f=1): [R(1)][100.0%][r=388MiB/s][r=388 IOPS][eta 00m:00s]
seqread: (groupid=0, jobs=1): err= 0: pid=2368687: Thu Apr  4 20:56:06 
2024
   read: IOPS=382, BW=383MiB/s (401MB/s)(22.4GiB/60020msec)
     slat (usec): min=17, max=3098, avg=68.94, stdev=46.04
     clat (msec): min=14, max=367, avg=20.84, stdev= 6.61
      lat (msec): min=15, max=367, avg=20.91, stdev= 6.61
     clat percentiles (msec):
      |  1.00th=[   21],  5.00th=[   21], 10.00th=[   21], 20.00th=[   
21],
      | 30.00th=[   21], 40.00th=[   21], 50.00th=[   21], 60.00th=[   
21],
      | 70.00th=[   21], 80.00th=[   21], 90.00th=[   21], 95.00th=[   
21],
      | 99.00th=[   25], 99.50th=[   31], 99.90th=[   48], 99.95th=[   
50],
      | 99.99th=[  368]
    bw (  KiB/s): min=215040, max=399360, per=100.00%, avg=392047.06, 
stdev=19902.89, samples=120
    iops        : min=  210, max=  390, avg=382.55, stdev=19.43, 
samples=120
   lat (msec)   : 20=0.19%, 50=99.80%, 100=0.01%, 500=0.03%
   cpu          : usr=0.39%, sys=1.93%, ctx=45947, majf=0, minf=37
   IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=100.0%, 16=0.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued rwts: total=22954,0,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=8

Run status group 0 (all jobs):
    READ: bw=383MiB/s (401MB/s), 383MiB/s-383MiB/s (401MB/s-401MB/s), 
io=22.4GiB (24.1GB), run=60020-60020msec

Disk stats (read/write):
   sda: ios=23817/315, merge=0/0, ticks=549704/132687, in_queue=683613, 
util=99.93%

400 MBps!!! This is a number I have never experienced. I understand this 
means I need to go back to the openzfs chat/forum?

---
Felix Rubio
"Don't believe what you're told. Double check."

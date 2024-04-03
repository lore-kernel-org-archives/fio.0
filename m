Received: from csmtpq1-prd-nl1-vfz.edge.unified.services (csmtpq1-prd-nl1-vfz.edge.unified.services [84.116.50.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F15246425
	for <fio@vger.kernel.org>; Wed,  3 Apr 2024 05:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.116.50.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712122560; cv=none; b=OEoUHyBlgjtV4l2PO6mU4a91EMgO+IXYhDxvSqpQ4B+aiVSDKqiPdHyY9puGPpddNd6CFWt7lUg0fyKPVpyN5RveH0mbzPvixkOJf48jxYddUNWMRAU9Ewlj/X4sSpo69smKRWQB5dINsQyLZuNu63+ge8bnRNAgE74tHfUa8Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712122560; c=relaxed/simple;
	bh=4NHS6L+XELRnknThyzJaFeZkHBIF+Aa4x4rAAq6f/UQ=;
	h=MIME-Version:Content-Type:Date:From:To:Subject:Message-ID; b=OQaYVO5+YjeEdUBms1ZtUxYA341UtnCW4DqMs0MzATh52xYpaYmQ7Qs23v4bc/jifJx7KOif5bEocTzp9S491kMMNmRNeauZpABEPh/jeVZEXVGoqp5EnbbE4wCKratRILVGuuyGz9DoP4cgGpg3BCHbJtdhcW+v6iBU/ERG9gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kngnt.org; spf=pass smtp.mailfrom=kngnt.org; dkim=pass (2048-bit key) header.d=kngnt.org header.i=@kngnt.org header.b=m7o7knwl; arc=none smtp.client-ip=84.116.50.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kngnt.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kngnt.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kngnt.org header.i=@kngnt.org header.b="m7o7knwl"
Received: from csmtp2-prd-nl1-vfz.nl1.unified.services ([100.107.80.135] helo=csmtp2-prd-nl1-vfz.edge.unified.services)
	by csmtpq1-prd-nl1-vfz.edge.unified.services with esmtp (Exim 4.93)
	(envelope-from <felix@kngnt.org>)
	id 1rrtHt-005Mne-RF
	for fio@vger.kernel.org; Wed, 03 Apr 2024 07:35:53 +0200
Received: from mail.kngnt.org ([80.115.15.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 256/256 bits)
	(Client did not present a certificate)
	by csmtp2-prd-nl1-vfz.edge.unified.services with ESMTPSA
	id rtHtr0kHz72fvrtHtrR2ba; Wed, 03 Apr 2024 07:35:53 +0200
X-Env-Mailfrom: felix@kngnt.org
X-Env-Rcptto: fio@vger.kernel.org
X-SourceIP: 80.115.15.152
X-CNFS-Analysis: v=2.4 cv=IKoECBvG c=1 sm=1 tr=0 ts=660ceab9 cx=a_exe
 a=YXwiZ4wAml67grcSS0vdmg==:117 a=YXwiZ4wAml67grcSS0vdmg==:17
 a=IkcTkHD0fZMA:10 a=ybeoN50CqIB83waTwkIA:9 a=QEXdDO2ut3YA:10
X-Authenticated-Sender: f.rubiodalmau@ziggo.nl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kngnt.org; s=mail;
	t=1712122553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NCmYAHFJkTsG2isbKEdkidpJpgVmx5LGUH8ArPqc5PE=;
	b=m7o7knwlWrs/YF9j4cRuYbJhsI879/D5UwpyDOtAE4dt2fvuka5DPy1Q3QjuM1vGofZsdK
	kyTOXC0r270/Y8jlsRae0Fwh+S5e/6hUziATHM3TkZKZw8IcqOuFElSGKM+YCOPfU7uVn4
	sFk/VT+y3HnxtIQnnYWct3MkPdtwMFu7m0zks9/iFBcB17i+suhWqFagjMJOmcoGy6BXhp
	5soF+DgoMGK5Ggm+rAlh0hyR/R4XO7XKMcBnzh0KiT933k9foQI811rhogwMUWPe0b9nAC
	cmW68DBR5iacEkmrPgvk8a+pUZKp/x3VpmmKpGWqtiwEXl65yfPRgKRpFc/QSA==
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 03 Apr 2024 07:35:52 +0200
From: Felix Rubio <felix@kngnt.org>
To: fio@vger.kernel.org
Subject: help understanding the output of fio
Message-ID: <90e42eaab7569a03239ad05dfd1ebb1d@kngnt.org>
X-Sender: felix@kngnt.org
X-CMAE-Envelope: MS4xfKZtFPiBL8sKMs45EYhwGlZt4xyx2EManawOL+VYHQ6qd1Y351ZTVQV3gRSNOBhs/6i1a0/MD9qfL/FEYfVPAX5TWhc/VIUk4Qhd6i8zh4A3Kxj0seqh
 9PUdIbQmrwVEPYe5cxEAMqCz1qKQMMrhqnUBMI2+3cOHWGrm9ycbSqQoFxcvbQGQ3Q3r7XvNbJT/NA==

Hi everybody,

I have started recently to use fio, and I am getting the following 
output for sequential writes:

write_throughput_i: (groupid=0, jobs=16): err= 0: pid=2301660: Tue Apr  
2 21:03:41 2024
   write: IOPS=2, BW=5613KiB/s (5748kB/s)(2048MiB/373607msec); 0 zone 
resets
     slat (msec): min=41549, max=373605, avg=260175.71, stdev=76630.63
     clat (nsec): min=17445, max=31004, avg=20350.31, stdev=3744.64
      lat (msec): min=235566, max=373605, avg=318209.63, stdev=32743.17
     clat percentiles (nsec):
      |  1.00th=[17536],  5.00th=[17536], 10.00th=[17792], 
20.00th=[17792],
      | 30.00th=[18048], 40.00th=[18304], 50.00th=[18304], 
60.00th=[18816],
      | 70.00th=[21632], 80.00th=[22144], 90.00th=[27008], 
95.00th=[31104],
      | 99.00th=[31104], 99.50th=[31104], 99.90th=[31104], 
99.95th=[31104],
      | 99.99th=[31104]
    bw (  MiB/s): min= 2051, max= 2051, per=100.00%, avg=2051.84, stdev= 
0.00, samples=16
    iops        : min= 2048, max= 2048, avg=2048.00, stdev= 0.00, 
samples=16
   lat (usec)   : 20=68.75%, 50=31.25%
   cpu          : usr=0.00%, sys=0.02%, ctx=8350, majf=13, minf=633
   IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
 >=64=100.0%
      submit    : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=100.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=100.0%, 
 >=64=0.0%
      issued rwts: total=0,1024,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   WRITE: bw=5613KiB/s (5748kB/s), 5613KiB/s-5613KiB/s 
(5748kB/s-5748kB/s), io=2048MiB (2147MB), run=373607-373607msec

Should I understand this correctly, the submission latency (slat) is at 
minimum 41.5 seconds? I am experiencing problems with my SSD disk (the 
performance is pretty low, which this seems to confirm), but now I am 
wondering if this could be a problem with my OS and not my disk, being 
the slat the submission latency?

Thank you
-- 
Felix Rubio
"Don't believe what you're told. Double check."
Felix Rubio

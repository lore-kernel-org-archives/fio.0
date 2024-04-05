Received: from csmtpq3-prd-nl1-vfz.edge.unified.services (csmtpq3-prd-nl1-vfz.edge.unified.services [84.116.50.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390D41803D
	for <fio@vger.kernel.org>; Fri,  5 Apr 2024 05:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.116.50.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712295690; cv=none; b=CV1mIbuAyuHdOe3D4B2cBV+j1rt3fQyEJOERbuQO4zuzJvDZQ2HO1uTRp6Jdo18Gh9c0sT7UIS7gLJDna+O97gqjU5HNgfMv/j9V3VxxyvesO6ajjHL+oEdpJlZGcASYhTQGSVeJYuV5l5ZFsFUDqacOEJUvn9z+DTWAXets4QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712295690; c=relaxed/simple;
	bh=x9VIXWyFe7ESLHHFVEz318uiwW4v9sGMWIYGtNKjxno=;
	h=MIME-Version:Content-Type:Date:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=IidGOpkV/Mef9A3a1IElawjg1qJcAff16K3gH9MjBEjM2MAGB+Cj8kCJPV0X9PinJJb4EGGGXf/gJN5eQI5OySsWJMQAIEpSYVBY9pRhugOpgK6iBNESPPPcnGMoDEois4MuSyQ4JiVjkszASvUvnF7UL+Q6O/J8M/Lr4/pS2nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kngnt.org; spf=pass smtp.mailfrom=kngnt.org; dkim=pass (2048-bit key) header.d=kngnt.org header.i=@kngnt.org header.b=tsAYugF7; arc=none smtp.client-ip=84.116.50.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kngnt.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kngnt.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kngnt.org header.i=@kngnt.org header.b="tsAYugF7"
Received: from csmtp3-prd-nl1-vfz.nl1.unified.services ([100.107.80.136] helo=csmtp3-prd-nl1-vfz.edge.unified.services)
	by csmtpq3-prd-nl1-vfz.edge.unified.services with esmtp (Exim 4.93)
	(envelope-from <felix@kngnt.org>)
	id 1rscKC-001nU9-6i
	for fio@vger.kernel.org; Fri, 05 Apr 2024 07:41:16 +0200
Received: from mail.kngnt.org ([80.115.15.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 256/256 bits)
	(Client did not present a certificate)
	by csmtp3-prd-nl1-vfz.edge.unified.services with ESMTPSA
	id scKBrI9KlEmN7scKCrC9nZ; Fri, 05 Apr 2024 07:41:16 +0200
X-Env-Mailfrom: felix@kngnt.org
X-Env-Rcptto: fio@vger.kernel.org
X-SourceIP: 80.115.15.152
X-CNFS-Analysis: v=2.4 cv=esHZzJpX c=1 sm=1 tr=0 ts=660f8efc cx=a_exe
 a=YXwiZ4wAml67grcSS0vdmg==:117 a=YXwiZ4wAml67grcSS0vdmg==:17
 a=IkcTkHD0fZMA:10 a=ILRSbEqXAAAA:8 a=SvNGRqXrAAAA:8 a=qHKAhtD8teU4qfcy5xsA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=fTbmtd9Fbw_Of8ZeN6dE:22
 a=ef3PzV3K9T5IpRhN8Zv0:22 a=KOgXzodFjZbWs0y4kEX1:22
X-Authenticated-Sender: f.rubiodalmau@ziggo.nl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kngnt.org; s=mail;
	t=1712295675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zd0/A2sutfm6qyiiyL2pcCuDT6IiFlVolzqnT00Ypbw=;
	b=tsAYugF7otZTJ8ZI5KK4NAg3fEBisT+oKSty2LcQSoE8bpfvrzf4gQXCMGdxC4Ukv3nTeo
	ppktZTxhGMptt520msW5l5GXDyC4UGON4smzamxZ1HgZttrsg1MBl56Di6qf8LyGpEd8hF
	8RPWr9N3dj1iheYiF/QD/5OBlSWeAohcEzQ2K1GQm1Z/+fFl2qgYnR2ePAN/7bOntBQrue
	i0VzWw2vptAZ0lcOQKTWUHpdQUQLwNwV4kZXs3J8Vp8HxQtvCIs0P7qIuCQ8zpZJmSl/I2
	t+LpRGgisQQTIhMkcilpz9DZ6687i/1MizRKlZ17M7+XtA5uWvmX6XIc3/BEDQ==
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Fri, 05 Apr 2024 07:41:15 +0200
From: Felix Rubio <felix@kngnt.org>
To: fio@vger.kernel.org
Subject: Re: help understanding the output of fio
In-Reply-To: <CAFCYAsfBmYA9hr3MyL91DiPb4+fpavUU_GXERGcjt7ytQQ5WJg@mail.gmail.com>
References: <90e42eaab7569a03239ad05dfd1ebb1d@kngnt.org>
 <2494cb75-e0ff-41fe-ad4c-73f383a0c704@cs.utexas.edu>
 <a3415a4de55f178b06c3451fdbe43e08@kngnt.org>
 <cfbf631e-5783-40a1-b577-9716c3cdc955@kernel.org>
 <CAFCYAscWYUASXzLYk1d1M1d2zcZDtPaz3PdwV_hZmxPw_tRxPA@mail.gmail.com>
 <7c7cb7c19e6f3587864f37888122b58d@kngnt.org>
 <CAFCYAsfBmYA9hr3MyL91DiPb4+fpavUU_GXERGcjt7ytQQ5WJg@mail.gmail.com>
Message-ID: <65e4f78e3652754dcfe6ecb356a8226f@kngnt.org>
X-Sender: felix@kngnt.org
X-CMAE-Envelope: MS4xfD7nBkiAeEGmTp2UfIZCq4qhZrR8NFFDIPBNZH3SlW7QgVOP6Ot7gz1eWkSaMYENmCEwiQcsw+wmrYlA9wln6paR2qJ+wnNJdiUvnen3Ajpmlg8LjWun
 cL1d23hbdzcpviugtpKqkvhCrrAXyp0hZ68kRult4n1ksbuCcC8c1y/+CUya/2Dixnqk7HfYko8HIA==

Hi Jeff,

I have done the test you suggested, and this is what came up:

read_throughput_rpool: (g=0): rw=read, bs=(R) 1024KiB-1024KiB, (W) 
1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=psync, iodepth=1
fio-3.33
Starting 1 process
read_throughput_rpool: Laying out IO file (1 file / 1024MiB)
Jobs: 1 (f=1): [R(1)][100.0%][r=904MiB/s][r=903 IOPS][eta 00m:00s]
read_throughput_rpool: (groupid=0, jobs=1): err= 0: pid=3284411: Fri Apr 
  5 07:31:18 2024
   read: IOPS=1092, BW=1092MiB/s (1145MB/s)(64.0GiB/60001msec)
     clat (usec): min=733, max=6031, avg=903.71, stdev=166.68
      lat (usec): min=734, max=6032, avg=904.88, stdev=166.84
     clat percentiles (usec):
      |  1.00th=[  742],  5.00th=[  750], 10.00th=[  750], 20.00th=[  
758],
      | 30.00th=[  766], 40.00th=[  791], 50.00th=[  824], 60.00th=[  
873],
      | 70.00th=[ 1037], 80.00th=[ 1106], 90.00th=[ 1139], 95.00th=[ 
1188],
      | 99.00th=[ 1254], 99.50th=[ 1287], 99.90th=[ 1401], 99.95th=[ 
1500],
      | 99.99th=[ 2474]
    bw (  MiB/s): min=  871, max= 1270, per=100.00%, avg=1092.97, 
stdev=166.88, samples=120
    iops        : min=  871, max= 1270, avg=1092.78, stdev=166.95, 
samples=120
   lat (usec)   : 750=6.17%, 1000=60.30%
   lat (msec)   : 2=33.51%, 4=0.02%, 10=0.01%
   cpu          : usr=2.04%, sys=97.52%, ctx=2457, majf=0, minf=37
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued rwts: total=65543,0,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
    READ: bw=1092MiB/s (1145MB/s), 1092MiB/s-1092MiB/s 
(1145MB/s-1145MB/s), io=64.0GiB (68.7GB), run=60001-60001msec

I take that the file was being cached (because the 1145 MBps on a single 
SSD disk is hard to believe)? For the write test, these are the results:

write_throughput_rpool: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 
1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=psync, iodepth=1
fio-3.33
Starting 1 process
write_throughput_rpool: Laying out IO file (1 file / 1024MiB)
Jobs: 1 (f=1): [W(1)][100.0%][w=4100KiB/s][w=4 IOPS][eta 00m:00s]
write_throughput_rpool: (groupid=0, jobs=1): err= 0: pid=3292023: Fri 
Apr  5 07:36:11 2024
   write: IOPS=5, BW=5394KiB/s (5524kB/s)(317MiB/60174msec); 0 zone 
resets
     clat (msec): min=16, max=1063, avg=189.59, stdev=137.19
      lat (msec): min=16, max=1063, avg=189.81, stdev=137.19
     clat percentiles (msec):
      |  1.00th=[   18],  5.00th=[   22], 10.00th=[   41], 20.00th=[   
62],
      | 30.00th=[  129], 40.00th=[  144], 50.00th=[  163], 60.00th=[  
190],
      | 70.00th=[  228], 80.00th=[  268], 90.00th=[  363], 95.00th=[  
489],
      | 99.00th=[  567], 99.50th=[  592], 99.90th=[ 1062], 99.95th=[ 
1062],
      | 99.99th=[ 1062]
    bw (  KiB/s): min= 2048, max=41042, per=100.00%, avg=5534.14, 
stdev=5269.61, samples=117
    iops        : min=    2, max=   40, avg= 5.40, stdev= 5.14, 
samples=117
   lat (msec)   : 20=3.47%, 50=11.99%, 100=8.83%, 250=51.42%, 500=20.19%
   lat (msec)   : 750=3.79%, 2000=0.32%
   cpu          : usr=0.11%, sys=0.52%, ctx=2673, majf=0, minf=38
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued rwts: total=0,317,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   WRITE: bw=5394KiB/s (5524kB/s), 5394KiB/s-5394KiB/s 
(5524kB/s-5524kB/s), io=317MiB (332MB), run=60174-60174msec

Still at 6 MBps. Should move this discussion to the openzfs team, or is 
there anything else still worth testing?

Thank you very much!

---
Felix Rubio
"Don't believe what you're told. Double check."

On 2024-04-04 21:07, Jeff Johnson wrote:
> Felix,
> 
> Based on your previous emails about the drive it would appear that the
> hardware (ssd, cables, port) are fine and the drive performs.
> 
> Go back and run your original ZFS test on your mounted ZFS volume
> directory and remove the "--direct=1" from your command as ZFS does
> not yet support direct_io and disabling buffered io to the zfs
> directory will have very negative impacts. This is a ZFS thing, not
> your kernel or hardware.
> 
> --Jeff
> 
> On Thu, Apr 4, 2024 at 12:00 PM Felix Rubio <felix@kngnt.org> wrote:
>> 
>> hey Jeff,
>> 
>> Good catch! I have run the following command:
>> 
>> fio --name=seqread --numjobs=1 --time_based --runtime=60s 
>> --ramp_time=2s
>> --iodepth=8 --ioengine=libaio --direct=1 --verify=0 
>> --group_reporting=1
>> --bs=1M --rw=read --size=1G --filename=/dev/sda
>> 
>> (/sda and /sdd are the drives I have on one of the pools), and this is
>> what I get:
>> 
>> seqread: (g=0): rw=read, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB,
>> (T) 1024KiB-1024KiB, ioengine=libaio, iodepth=8
>> fio-3.33
>> Starting 1 process
>> Jobs: 1 (f=1): [R(1)][100.0%][r=388MiB/s][r=388 IOPS][eta 00m:00s]
>> seqread: (groupid=0, jobs=1): err= 0: pid=2368687: Thu Apr  4 20:56:06
>> 2024
>>    read: IOPS=382, BW=383MiB/s (401MB/s)(22.4GiB/60020msec)
>>      slat (usec): min=17, max=3098, avg=68.94, stdev=46.04
>>      clat (msec): min=14, max=367, avg=20.84, stdev= 6.61
>>       lat (msec): min=15, max=367, avg=20.91, stdev= 6.61
>>      clat percentiles (msec):
>>       |  1.00th=[   21],  5.00th=[   21], 10.00th=[   21], 20.00th=[
>> 21],
>>       | 30.00th=[   21], 40.00th=[   21], 50.00th=[   21], 60.00th=[
>> 21],
>>       | 70.00th=[   21], 80.00th=[   21], 90.00th=[   21], 95.00th=[
>> 21],
>>       | 99.00th=[   25], 99.50th=[   31], 99.90th=[   48], 99.95th=[
>> 50],
>>       | 99.99th=[  368]
>>     bw (  KiB/s): min=215040, max=399360, per=100.00%, avg=392047.06,
>> stdev=19902.89, samples=120
>>     iops        : min=  210, max=  390, avg=382.55, stdev=19.43,
>> samples=120
>>    lat (msec)   : 20=0.19%, 50=99.80%, 100=0.01%, 500=0.03%
>>    cpu          : usr=0.39%, sys=1.93%, ctx=45947, majf=0, minf=37
>>    IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=100.0%, 16=0.0%, 32=0.0%,
>>  >=64=0.0%
>>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>  >=64=0.0%
>>       complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%,
>>  >=64=0.0%
>>       issued rwts: total=22954,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>>       latency   : target=0, window=0, percentile=100.00%, depth=8
>> 
>> Run status group 0 (all jobs):
>>     READ: bw=383MiB/s (401MB/s), 383MiB/s-383MiB/s (401MB/s-401MB/s),
>> io=22.4GiB (24.1GB), run=60020-60020msec
>> 
>> Disk stats (read/write):
>>    sda: ios=23817/315, merge=0/0, ticks=549704/132687, 
>> in_queue=683613,
>> util=99.93%
>> 
>> 400 MBps!!! This is a number I have never experienced. I understand 
>> this
>> means I need to go back to the openzfs chat/forum?
>> 
>> ---
>> Felix Rubio
>> "Don't believe what you're told. Double check."
>> 
> 
> 
> --
> ------------------------------
> Jeff Johnson
> Co-Founder
> Aeon Computing
> 
> jeff.johnson@aeoncomputing.com
> www.aeoncomputing.com
> t: 858-412-3810 x1001   f: 858-412-3845
> m: 619-204-9061
> 
> 4170 Morena Boulevard, Suite C - San Diego, CA 92117
> 
> High-Performance Computing / Lustre Filesystems / Scale-out Storage

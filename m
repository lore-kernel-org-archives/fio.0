Received: from csmtpq3-prd-nl1-vfz.edge.unified.services (csmtpq3-prd-nl1-vfz.edge.unified.services [84.116.50.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8A7155394
	for <fio@vger.kernel.org>; Wed,  3 Apr 2024 19:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.116.50.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712172109; cv=none; b=FrMpv3pq34lSElAaxywRZkD5CBT65JBsBYzYDlZ2ME8zgp+NJcuYlqpXVJ9F5eHdEBJRly2ujJe7r1Tm1f17EBhw9a6z4PKuw03yIzQ693mqk7Mvp769DVBNqNqdjm81fL2jcM5/oARi557RkDayzMwmH3Bi/wq0aBE2J/ueqVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712172109; c=relaxed/simple;
	bh=bNxj1hQyJ5P6Rc2M8zhzxVrh2gyo2u42LDg5EO4bQkM=;
	h=MIME-Version:Content-Type:Date:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=dnuk6nz6b7k6SogyR+QQK1C4WwM3PtEsR5behbnqhrzO+a4AbaFsZZ1V8ETR0uan3Y6yKYtH9zcE2xrw2qp6Zmy9LWItJn4MnFnlejl2VnrQ7hngoqwWjtIgL02KEw3tlI2iwTieTUGilRplTht81PsdMyWW0liRSd1q/nu8ngM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kngnt.org; spf=pass smtp.mailfrom=kngnt.org; dkim=pass (2048-bit key) header.d=kngnt.org header.i=@kngnt.org header.b=rsV5SMDV; arc=none smtp.client-ip=84.116.50.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kngnt.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kngnt.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kngnt.org header.i=@kngnt.org header.b="rsV5SMDV"
Received: from csmtp4-prd-nl1-vfz.nl1.unified.services ([100.107.80.18] helo=csmtp4-prd-nl1-vfz.edge.unified.services)
	by csmtpq3-prd-nl1-vfz.edge.unified.services with esmtp (Exim 4.93)
	(envelope-from <felix@kngnt.org>)
	id 1rs6Ay-008Tqz-7X
	for fio@vger.kernel.org; Wed, 03 Apr 2024 21:21:36 +0200
Received: from mail.kngnt.org ([80.115.15.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 256/256 bits)
	(Client did not present a certificate)
	by csmtp4-prd-nl1-vfz.edge.unified.services with ESMTPSA
	id s6Axr4c3x1i6ds6AyrMEUs; Wed, 03 Apr 2024 21:21:36 +0200
X-Env-Mailfrom: felix@kngnt.org
X-Env-Rcptto: fio@vger.kernel.org
X-SourceIP: 80.115.15.152
X-CNFS-Analysis: v=2.4 cv=MKBmmtZl c=1 sm=1 tr=0 ts=660dac40 cx=a_exe
 a=YXwiZ4wAml67grcSS0vdmg==:117 a=YXwiZ4wAml67grcSS0vdmg==:17
 a=IkcTkHD0fZMA:10 a=hopKal9mQNJs8kurUFgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Authenticated-Sender: f.rubiodalmau@ziggo.nl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kngnt.org; s=mail;
	t=1712172095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z+fy/s7M8MkoD8SXEM3eFR487DaD4MjRUn09CNe0TtU=;
	b=rsV5SMDVrltNAwzOThmzcyOMRkepYQ2EJNFWLO6TqpxQ9oUvQnhSiZIpc9qsYMvROBb6Lb
	tmfhwtjE7e8lBwdNY73Tah4OSZlpi/xL6TuxShe65KLNEkJSZTquHKlBeqUfqV9DzPBy6V
	F7EJBtQmN6feEWjIs1VFsO0XhkOX/KwLdo8+KoaYYUI9OletjXHAsbebX5MktgMnJKzXaD
	1Iq3PHBTbk7foWHcHBBhEofsJBvS28DrAng7y7Xd7Ujpo2qkA4wvhgDvLXwiToqDc5dduC
	72rsTdMCMs/GjppZn6RB3wQLJYgJYZ3Eh+1YRPVHOur6BN4vlW/ifcJo9Z3zVg==
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Wed, 03 Apr 2024 21:21:35 +0200
From: Felix Rubio <felix@kngnt.org>
To: fio@vger.kernel.org
Subject: Re: help understanding the output of fio
In-Reply-To: <2494cb75-e0ff-41fe-ad4c-73f383a0c704@cs.utexas.edu>
References: <90e42eaab7569a03239ad05dfd1ebb1d@kngnt.org>
 <2494cb75-e0ff-41fe-ad4c-73f383a0c704@cs.utexas.edu>
Message-ID: <a3415a4de55f178b06c3451fdbe43e08@kngnt.org>
X-Sender: felix@kngnt.org
X-CMAE-Envelope: MS4xfB1g1euxc4BI7Gn3uNkL3XAbZmeiapr/7wFQ2oM5K/EIDZ1WYe4XI36NyPNiJgYeWEVEwbVoJU7t2fqckblUtOZC1tXBd5j+Deshv0vbignYcSCkODA8
 besShwQ8KY/NdUzYOYjmT0aaLTMDOGN7zmg5Qwm0hmZX2YU2Gjasd9LVuGDyHKWH/PB+Xom2BBZaqg==

Hi Patrick,

Thank you for your answer. I am quite lost with the results shown by 
fio: I do not get to understand them. I have a system with 3 ZFS pools: 
in 1 I have a single SSD, in another I have 2 stripped SSD, and in the 
third I have a single HDD. On the first pool I am running this command:

fio --numjobs=1 --size=1024M --time_based --runtime=60s --ramp_time=2s 
--ioengine=libaio --direct=1 --verify=0 --group_reporting=1 --bs=1M 
--rw=write

And I am getting this result:

write_throughput_i: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 
1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=libaio, iodepth=1
fio-3.33
Starting 1 process
write_throughput_i: Laying out IO file (1 file / 1024MiB)
Jobs: 1 (f=1): [W(1)][21.1%][eta 03m:56s]
write_throughput_i: (groupid=0, jobs=1): err= 0: pid=235368: Wed Apr  3 
21:01:16 2024
   write: IOPS=3, BW=3562KiB/s (3647kB/s)(211MiB/60664msec); 0 zone 
resets
     slat (msec): min=16, max=1777, avg=287.56, stdev=282.15
     clat (nsec): min=10930, max=31449, avg=12804.00, stdev=3289.32
      lat (msec): min=16, max=1777, avg=288.86, stdev=282.20
     clat percentiles (nsec):
      |  1.00th=[11072],  5.00th=[11328], 10.00th=[11456], 
20.00th=[11584],
      | 30.00th=[11840], 40.00th=[11840], 50.00th=[12096], 
60.00th=[12224],
      | 70.00th=[12352], 80.00th=[12736], 90.00th=[13248], 
95.00th=[13760],
      | 99.00th=[29568], 99.50th=[30848], 99.90th=[31360], 
99.95th=[31360],
      | 99.99th=[31360]
    bw (  KiB/s): min= 2048, max=51302, per=100.00%, avg=4347.05, 
stdev=6195.46, samples=99
    iops        : min=    2, max=   50, avg= 4.24, stdev= 6.04, 
samples=99
   lat (usec)   : 20=96.19%, 50=3.81%
   cpu          : usr=0.10%, sys=0.32%, ctx=1748, majf=0, minf=37
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued rwts: total=0,210,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   WRITE: bw=3562KiB/s (3647kB/s), 3562KiB/s-3562KiB/s 
(3647kB/s-3647kB/s), io=211MiB (221MB), run=60664-60664msec

For a read test, running the same parameters (changing rw=write by 
rw=read), I get:

read_throughput_i: (g=0): rw=read, bs=(R) 1024KiB-1024KiB, (W) 
1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=libaio, iodepth=1
fio-3.33
Starting 1 process
read_throughput_i: Laying out IO file (1 file / 1024MiB)
Jobs: 1 (f=1): [R(1)][100.0%][r=1229MiB/s][r=1229 IOPS][eta 00m:00s]
read_throughput_i: (groupid=0, jobs=1): err= 0: pid=245501: Wed Apr  3 
21:14:27 2024
   read: IOPS=1283, BW=1284MiB/s (1346MB/s)(75.2GiB/60001msec)
     slat (usec): min=371, max=27065, avg=757.71, stdev=185.43
     clat (usec): min=9, max=358, avg=12.44, stdev= 3.93
      lat (usec): min=383, max=27078, avg=770.15, stdev=185.66
     clat percentiles (usec):
      |  1.00th=[   11],  5.00th=[   12], 10.00th=[   12], 20.00th=[   
12],
      | 30.00th=[   12], 40.00th=[   12], 50.00th=[   13], 60.00th=[   
13],
      | 70.00th=[   13], 80.00th=[   13], 90.00th=[   13], 95.00th=[   
14],
      | 99.00th=[   24], 99.50th=[   29], 99.90th=[   81], 99.95th=[   
93],
      | 99.99th=[  105]
    bw (  MiB/s): min= 1148, max= 1444, per=100.00%, avg=1285.12, 
stdev=86.12, samples=119
    iops        : min= 1148, max= 1444, avg=1284.97, stdev=86.05, 
samples=119
   lat (usec)   : 10=0.09%, 20=98.90%, 50=0.73%, 100=0.26%, 250=0.02%
   lat (usec)   : 500=0.01%
   cpu          : usr=3.14%, sys=95.75%, ctx=6274, majf=0, minf=37
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued rwts: total=77036,0,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
    READ: bw=1284MiB/s (1346MB/s), 1284MiB/s-1284MiB/s 
(1346MB/s-1346MB/s), io=75.2GiB (80.8GB), run=60001-60001msec


If I understand properly these results, I am getting ~4 MBps of write 
bandwidth to disk,caused by a submission latency problem , but when 
reading sequentially I am getting 1.3 GBps (also very weird) (previously 
I shared another test with different parameters, multiple jobs, etc., 
but with the same result). I am trying to find out if this analysis is 
correct and whether is a software or a hardware error.
---
Felix Rubio
"Don't believe what you're told. Double check."

On 2024-04-03 17:45, Patrick Goetz wrote:
> Hi Felix -
> 
> It might be helpful to share your job file or fio command line. Not
> sure, I'm a neophyte as well with many questions such as what happens
> when the number of jobs is less than the iodepth.
> 
> On 4/3/24 00:35, Felix Rubio wrote:
>> Hi everybody,
>> 
>> I have started recently to use fio, and I am getting the following 
>> output for sequential writes:
>> 
>> write_throughput_i: (groupid=0, jobs=16): err= 0: pid=2301660: Tue Apr 
>> 2 21:03:41 2024
>>    write: IOPS=2, BW=5613KiB/s (5748kB/s)(2048MiB/373607msec); 0 zone 
>> resets
>>      slat (msec): min=41549, max=373605, avg=260175.71, stdev=76630.63
>>      clat (nsec): min=17445, max=31004, avg=20350.31, stdev=3744.64
>>       lat (msec): min=235566, max=373605, avg=318209.63, 
>> stdev=32743.17
>>      clat percentiles (nsec):
>>       |  1.00th=[17536],  5.00th=[17536], 10.00th=[17792], 
>> 20.00th=[17792],
>>       | 30.00th=[18048], 40.00th=[18304], 50.00th=[18304], 
>> 60.00th=[18816],
>>       | 70.00th=[21632], 80.00th=[22144], 90.00th=[27008], 
>> 95.00th=[31104],
>>       | 99.00th=[31104], 99.50th=[31104], 99.90th=[31104], 
>> 99.95th=[31104],
>>       | 99.99th=[31104]
>>     bw (  MiB/s): min= 2051, max= 2051, per=100.00%, avg=2051.84, 
>> stdev= 0.00, samples=16
>>     iops        : min= 2048, max= 2048, avg=2048.00, stdev= 0.00, 
>> samples=16
>>    lat (usec)   : 20=68.75%, 50=31.25%
>>    cpu          : usr=0.00%, sys=0.02%, ctx=8350, majf=13, minf=633
>>    IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,  
>> >=64=100.0%
>>       submit    : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=100.0%, 
>>  >=64=0.0%
>>       complete  : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=100.0%, 
>>  >=64=0.0%
>>       issued rwts: total=0,1024,0,0 short=0,0,0,0 dropped=0,0,0,0
>>       latency   : target=0, window=0, percentile=100.00%, depth=64
>> 
>> Run status group 0 (all jobs):
>>    WRITE: bw=5613KiB/s (5748kB/s), 5613KiB/s-5613KiB/s 
>> (5748kB/s-5748kB/s), io=2048MiB (2147MB), run=373607-373607msec
>> 
>> Should I understand this correctly, the submission latency (slat) is 
>> at minimum 41.5 seconds? I am experiencing problems with my SSD disk 
>> (the performance is pretty low, which this seems to confirm), but now 
>> I am wondering if this could be a problem with my OS and not my disk, 
>> being the slat the submission latency?
>> 
>> Thank you

Received: from csmtpq3-prd-nl1-vfz.edge.unified.services (csmtpq3-prd-nl1-vfz.edge.unified.services [84.116.50.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47101772F
	for <fio@vger.kernel.org>; Sat,  6 Apr 2024 07:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.116.50.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712387033; cv=none; b=KpXTJwt1QxDAHmdg62J0hiqrz1A2aXc00+HFMaAXF8wENkSlgiJOrFBQGAZ1x39h0UI6Xlz9gTzA07RptN1PWpqag+9CzDrFHtn3Zma/YI5e7eLyaAV51juo2wRAauxDBXtX2jaPBaiRROKQ4BZYbt0KdGAB01bWR41EybiC5BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712387033; c=relaxed/simple;
	bh=NqN98H6w+0KScxMpjEuW6dJgayPq2Pbw7uE22YXi/X0=;
	h=MIME-Version:Content-Type:Date:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=Q8pwCCf19xGon/h3tRzkSgz5+YR0c/q5HJkTdrlNhqU4FhnmxLNSv+/8AbHbMsyjH4rqepX0Wz3DDvXRkR9tjgyOWFQlFl5EGyZQ0yW+OymoickNu4gU2ibJATzIrqtBnQXxYuMofAfPaIUiuQjAZprpeksS6OoC0w8Zu60YK9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kngnt.org; spf=pass smtp.mailfrom=kngnt.org; dkim=pass (2048-bit key) header.d=kngnt.org header.i=@kngnt.org header.b=qIvXe0bU; arc=none smtp.client-ip=84.116.50.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kngnt.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kngnt.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kngnt.org header.i=@kngnt.org header.b="qIvXe0bU"
Received: from csmtp3-prd-nl1-vfz.nl1.unified.services ([100.107.80.136] helo=csmtp3-prd-nl1-vfz.edge.unified.services)
	by csmtpq3-prd-nl1-vfz.edge.unified.services with esmtp (Exim 4.93)
	(envelope-from <felix@kngnt.org>)
	id 1rt05U-008z3f-BC
	for fio@vger.kernel.org; Sat, 06 Apr 2024 09:03:40 +0200
Received: from mail.kngnt.org ([80.115.15.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 256/256 bits)
	(Client did not present a certificate)
	by csmtp3-prd-nl1-vfz.edge.unified.services with ESMTPSA
	id t05UrPeScEmN7t05UrEb4k; Sat, 06 Apr 2024 09:03:40 +0200
X-Env-Mailfrom: felix@kngnt.org
X-Env-Rcptto: fio@vger.kernel.org
X-SourceIP: 80.115.15.152
X-CNFS-Analysis: v=2.4 cv=esHZzJpX c=1 sm=1 tr=0 ts=6610f3cc cx=a_exe
 a=YXwiZ4wAml67grcSS0vdmg==:117 a=YXwiZ4wAml67grcSS0vdmg==:17
 a=IkcTkHD0fZMA:10 a=ILRSbEqXAAAA:8 a=SvNGRqXrAAAA:8 a=spRmRm2oRrkrZtDBbQgA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=fTbmtd9Fbw_Of8ZeN6dE:22
 a=ef3PzV3K9T5IpRhN8Zv0:22
X-Authenticated-Sender: f.rubiodalmau@ziggo.nl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kngnt.org; s=mail;
	t=1712387019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dk+/H9dCQQkufHS/4mfCELeMbwm6HZrUFeITrqfXnVI=;
	b=qIvXe0bUIMwhYulaJhcSm5gH4cnq0Poc2ycQoc7QnTxU0mEh2jQZB7H3zzEtKtPQNcltkr
	44In2PtWHAKqQz7vUR6yB4pux8m5ckOi1ngQXLKrTd6+JSjxvLb3uLvJou267RXK7kZFwU
	imPfCmWskRnIU4FI9hhcEj3hS0PrUdau/JFeG55/iV/hF14rF+VOgC+qwoQgJFFWYRkbug
	H9tRHGbmKdbd4eb5Z90ijJTweYBBhcEuUBKMymgQiUSgRdCSGaPvlnB9s40ipvIh+f+9G5
	ehpada48ZJrMQAcYixWDUFcoTZIHDCckQGs1VynK+5eDd9vowAoZ2vVpQs1/Nw==
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Sat, 06 Apr 2024 09:03:38 +0200
From: Felix Rubio <felix@kngnt.org>
To: fio@vger.kernel.org
Subject: Re: help understanding the output of fio
In-Reply-To: <CAFCYAsdXh08yEP5wM1BBQ8dLLVyKSksFFG3eBngbBdWNk=nRhQ@mail.gmail.com>
References: <90e42eaab7569a03239ad05dfd1ebb1d@kngnt.org>
 <2494cb75-e0ff-41fe-ad4c-73f383a0c704@cs.utexas.edu>
 <a3415a4de55f178b06c3451fdbe43e08@kngnt.org>
 <cfbf631e-5783-40a1-b577-9716c3cdc955@kernel.org>
 <CAFCYAscWYUASXzLYk1d1M1d2zcZDtPaz3PdwV_hZmxPw_tRxPA@mail.gmail.com>
 <7c7cb7c19e6f3587864f37888122b58d@kngnt.org>
 <CAFCYAsfBmYA9hr3MyL91DiPb4+fpavUU_GXERGcjt7ytQQ5WJg@mail.gmail.com>
 <65e4f78e3652754dcfe6ecb356a8226f@kngnt.org>
 <CAFCYAsdXh08yEP5wM1BBQ8dLLVyKSksFFG3eBngbBdWNk=nRhQ@mail.gmail.com>
Message-ID: <1bdba632a389d002a443eeb233b19573@kngnt.org>
X-Sender: felix@kngnt.org
X-CMAE-Envelope: MS4xfMk7O7aldrVIH0YcbJbcoxYHreqN09kmYaWQb/S1zA0lyaSd96DhN+QMo7Nh61iEOee0Zt80GNALxlw8O46IQFLTOnpHQxH7DEJ8UpEWoCRujgaL6V6i
 DBePQvUGoO/AHjF+niUzV7venRxKaQM8BNingw2wkC2QJkyuYqvFqc+9JIO3Zk0kkdD6qqj4q2O81w==

Hi Jeff,

I have run the write test using libaio, and with the primary and 
secondary caches set to "none"
fio --name=write_throughput_rpool --numjobs=1 --time_based --runtime=60s 
--ramp_time=2s --iodepth=8 --ioengine=libaio --verify=0 
--group_reporting=1 --bs=16k --rw=write --size=1G 
--filename=/var/cache/test

These are the results:
fio-3.33
Starting 1 process
write_throughput_rpool: Laying out IO file (1 file / 1024MiB)
Jobs: 1 (f=1): [W(1)][51.6%][w=256KiB/s][w=16 IOPS][eta 00m:59s]
write_throughput_rpool: (groupid=0, jobs=1): err= 0: pid=1330097: Sat 
Apr  6 08:56:27 2024
   write: IOPS=550, BW=8808KiB/s (9019kB/s)(519MiB/60315msec); 0 zone 
resets
     slat (usec): min=185, max=2865.8k, avg=1810.21, stdev=32343.38
     clat (usec): min=19, max=2869.5k, avg=12720.49, stdev=85213.20
      lat (msec): min=2, max=2870, avg=14.53, stdev=91.03
     clat percentiles (msec):
      |  1.00th=[    3],  5.00th=[    3], 10.00th=[    4], 20.00th=[    
5],
      | 30.00th=[    6], 40.00th=[    6], 50.00th=[    7], 60.00th=[    
8],
      | 70.00th=[    9], 80.00th=[   10], 90.00th=[   13], 95.00th=[   
16],
      | 99.00th=[   34], 99.50th=[  313], 99.90th=[ 1217], 99.95th=[ 
1687],
      | 99.99th=[ 2869]
    bw (  KiB/s): min=  256, max=42068, per=100.00%, avg=11304.49, 
stdev=9239.48, samples=94
    iops        : min=   16, max= 2629, avg=706.47, stdev=577.45, 
samples=94
   lat (usec)   : 20=0.01%
   lat (msec)   : 2=0.07%, 4=14.03%, 10=68.18%, 20=15.56%, 50=1.40%
   lat (msec)   : 100=0.23%, 250=0.04%, 500=0.06%, 750=0.13%, 1000=0.06%
   lat (msec)   : 2000=0.21%, >=2000=0.04%
   cpu          : usr=0.46%, sys=2.57%, ctx=33743, majf=0, minf=38
   IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=100.0%, 16=0.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued rwts: total=0,33194,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=8

Run status group 0 (all jobs):
   WRITE: bw=8808KiB/s (9019kB/s), 8808KiB/s-8808KiB/s 
(9019kB/s-9019kB/s), io=519MiB (544MB), run=60315-60315msec

Should I use multiple jobs, running
fio --name=write_throughput_rpool --numjobs=8 --time_based --runtime=60s 
--ramp_time=2s --iodepth=8 --ioengine=libaio --verify=0 
--group_reporting=1 --bs=16k --rw=write --size=128M 
--filename=/var/cache/test

I get the following results:
write_throughput_rpool: (g=0): rw=write, bs=(R) 16.0KiB-16.0KiB, (W) 
16.0KiB-16.0KiB, (T) 16.0KiB-16.0KiB, ioengine=libaio, iodepth=8
...
fio-3.33
Starting 8 processes
write_throughput_rpool: Laying out IO file (1 file / 128MiB)
write_throughput_rpool: Laying out IO file (1 file / 128MiB)
write_throughput_rpool: Laying out IO file (1 file / 128MiB)
write_throughput_rpool: Laying out IO file (1 file / 128MiB)
write_throughput_rpool: Laying out IO file (1 file / 128MiB)
write_throughput_rpool: Laying out IO file (1 file / 128MiB)
write_throughput_rpool: Laying out IO file (1 file / 128MiB)
write_throughput_rpool: Laying out IO file (1 file / 128MiB)
Jobs: 8 (f=2): [f(4),W(1),f(2),W(1)][35.6%][w=2818KiB/s][w=176 IOPS][eta 
01m:54s]
write_throughput_rpool: (groupid=0, jobs=8): err= 0: pid=1338427: Sat 
Apr  6 09:02:00 2024
   write: IOPS=543, BW=8712KiB/s (8921kB/s)(511MiB/60023msec); 0 zone 
resets
     slat (usec): min=733, max=2260.7k, avg=14703.28, stdev=63546.14
     clat (usec): min=4, max=2385.0k, avg=102868.92, stdev=164897.88
      lat (usec): min=774, max=2405.7k, avg=117555.81, stdev=175738.91
     clat percentiles (msec):
      |  1.00th=[   19],  5.00th=[   29], 10.00th=[   36], 20.00th=[   
44],
      | 30.00th=[   50], 40.00th=[   55], 50.00th=[   62], 60.00th=[   
70],
      | 70.00th=[   81], 80.00th=[  103], 90.00th=[  133], 95.00th=[  
359],
      | 99.00th=[ 1045], 99.50th=[ 1167], 99.90th=[ 1385], 99.95th=[ 
1754],
      | 99.99th=[ 2366]
    bw (  KiB/s): min=  384, max=33551, per=100.00%, avg=9727.65, 
stdev=850.37, samples=853
    iops        : min=   24, max= 2095, avg=607.90, stdev=53.14, 
samples=853
   lat (usec)   : 10=0.01%, 20=0.02%, 1000=0.01%
   lat (msec)   : 2=0.01%, 4=0.02%, 10=0.10%, 20=1.01%, 50=30.81%
   lat (msec)   : 100=47.01%, 250=15.29%, 500=2.31%, 750=2.00%, 
1000=0.53%
   lat (msec)   : 2000=1.04%, >=2000=0.02%
   cpu          : usr=0.11%, sys=0.45%, ctx=33751, majf=0, minf=295
   IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=100.0%, 16=0.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued rwts: total=0,32620,0,0 short=0,0,0,0 dropped=0,0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=8

Run status group 0 (all jobs):
   WRITE: bw=8712KiB/s (8921kB/s), 8712KiB/s-8712KiB/s 
(8921kB/s-8921kB/s), io=511MiB (535MB), run=60023-60023msec

So... I am getting more or less the same bandwidths in both cases.

---
Felix Rubio
"Don't believe what you're told. Double check."

On 2024-04-05 20:39, Jeff Johnson wrote:
> Felix,
> 
> You're using the psync ioengine with a queue depth of 1. This will
> slow zfs down a lot. Use libaio and a queue depth of 8-16.
> 
> To temporarily disable ZFS arc caching on your volume, say your
> benchmark volume is mypool/myvol mounted at /myvol you can do:
> zfs get all mypool/myvol > ~/myvol-settings-save.txt
> zfs set primarycache=off mypool/myvol
> zfs set secondarycache=off mypool/myvol
> 
> then run your fio tests. After you are done benchmarking your ZFS
> refer to the settings saved in ~/myvol-settings-save.txt to set
> primarycache and secondarycache back to original.
> 
> --Jeff
> 
> 
> On Thu, Apr 4, 2024 at 10:41 PM Felix Rubio <felix@kngnt.org> wrote:
>> 
>> Hi Jeff,
>> 
>> I have done the test you suggested, and this is what came up:
>> 
>> read_throughput_rpool: (g=0): rw=read, bs=(R) 1024KiB-1024KiB, (W)
>> 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=psync, iodepth=1
>> fio-3.33
>> Starting 1 process
>> read_throughput_rpool: Laying out IO file (1 file / 1024MiB)
>> Jobs: 1 (f=1): [R(1)][100.0%][r=904MiB/s][r=903 IOPS][eta 00m:00s]
>> read_throughput_rpool: (groupid=0, jobs=1): err= 0: pid=3284411: Fri 
>> Apr
>>   5 07:31:18 2024
>>    read: IOPS=1092, BW=1092MiB/s (1145MB/s)(64.0GiB/60001msec)
>>      clat (usec): min=733, max=6031, avg=903.71, stdev=166.68
>>       lat (usec): min=734, max=6032, avg=904.88, stdev=166.84
>>      clat percentiles (usec):
>>       |  1.00th=[  742],  5.00th=[  750], 10.00th=[  750], 20.00th=[
>> 758],
>>       | 30.00th=[  766], 40.00th=[  791], 50.00th=[  824], 60.00th=[
>> 873],
>>       | 70.00th=[ 1037], 80.00th=[ 1106], 90.00th=[ 1139], 95.00th=[
>> 1188],
>>       | 99.00th=[ 1254], 99.50th=[ 1287], 99.90th=[ 1401], 99.95th=[
>> 1500],
>>       | 99.99th=[ 2474]
>>     bw (  MiB/s): min=  871, max= 1270, per=100.00%, avg=1092.97,
>> stdev=166.88, samples=120
>>     iops        : min=  871, max= 1270, avg=1092.78, stdev=166.95,
>> samples=120
>>    lat (usec)   : 750=6.17%, 1000=60.30%
>>    lat (msec)   : 2=33.51%, 4=0.02%, 10=0.01%
>>    cpu          : usr=2.04%, sys=97.52%, ctx=2457, majf=0, minf=37
>>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>>  >=64=0.0%
>>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>  >=64=0.0%
>>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>  >=64=0.0%
>>       issued rwts: total=65543,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>>       latency   : target=0, window=0, percentile=100.00%, depth=1
>> 
>> Run status group 0 (all jobs):
>>     READ: bw=1092MiB/s (1145MB/s), 1092MiB/s-1092MiB/s
>> (1145MB/s-1145MB/s), io=64.0GiB (68.7GB), run=60001-60001msec
>> 
>> I take that the file was being cached (because the 1145 MBps on a 
>> single
>> SSD disk is hard to believe)? For the write test, these are the 
>> results:
>> 
>> write_throughput_rpool: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W)
>> 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=psync, iodepth=1
>> fio-3.33
>> Starting 1 process
>> write_throughput_rpool: Laying out IO file (1 file / 1024MiB)
>> Jobs: 1 (f=1): [W(1)][100.0%][w=4100KiB/s][w=4 IOPS][eta 00m:00s]
>> write_throughput_rpool: (groupid=0, jobs=1): err= 0: pid=3292023: Fri
>> Apr  5 07:36:11 2024
>>    write: IOPS=5, BW=5394KiB/s (5524kB/s)(317MiB/60174msec); 0 zone
>> resets
>>      clat (msec): min=16, max=1063, avg=189.59, stdev=137.19
>>       lat (msec): min=16, max=1063, avg=189.81, stdev=137.19
>>      clat percentiles (msec):
>>       |  1.00th=[   18],  5.00th=[   22], 10.00th=[   41], 20.00th=[
>> 62],
>>       | 30.00th=[  129], 40.00th=[  144], 50.00th=[  163], 60.00th=[
>> 190],
>>       | 70.00th=[  228], 80.00th=[  268], 90.00th=[  363], 95.00th=[
>> 489],
>>       | 99.00th=[  567], 99.50th=[  592], 99.90th=[ 1062], 99.95th=[
>> 1062],
>>       | 99.99th=[ 1062]
>>     bw (  KiB/s): min= 2048, max=41042, per=100.00%, avg=5534.14,
>> stdev=5269.61, samples=117
>>     iops        : min=    2, max=   40, avg= 5.40, stdev= 5.14,
>> samples=117
>>    lat (msec)   : 20=3.47%, 50=11.99%, 100=8.83%, 250=51.42%, 
>> 500=20.19%
>>    lat (msec)   : 750=3.79%, 2000=0.32%
>>    cpu          : usr=0.11%, sys=0.52%, ctx=2673, majf=0, minf=38
>>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>>  >=64=0.0%
>>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>  >=64=0.0%
>>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>  >=64=0.0%
>>       issued rwts: total=0,317,0,0 short=0,0,0,0 dropped=0,0,0,0
>>       latency   : target=0, window=0, percentile=100.00%, depth=1
>> 
>> Run status group 0 (all jobs):
>>    WRITE: bw=5394KiB/s (5524kB/s), 5394KiB/s-5394KiB/s
>> (5524kB/s-5524kB/s), io=317MiB (332MB), run=60174-60174msec
>> 
>> Still at 6 MBps. Should move this discussion to the openzfs team, or 
>> is
>> there anything else still worth testing?
>> 
>> Thank you very much!
>> 
>> ---
>> Felix Rubio
>> "Don't believe what you're told. Double check."
>> 
>> On 2024-04-04 21:07, Jeff Johnson wrote:
>> > Felix,
>> >
>> > Based on your previous emails about the drive it would appear that the
>> > hardware (ssd, cables, port) are fine and the drive performs.
>> >
>> > Go back and run your original ZFS test on your mounted ZFS volume
>> > directory and remove the "--direct=1" from your command as ZFS does
>> > not yet support direct_io and disabling buffered io to the zfs
>> > directory will have very negative impacts. This is a ZFS thing, not
>> > your kernel or hardware.
>> >
>> > --Jeff
>> >
>> > On Thu, Apr 4, 2024 at 12:00 PM Felix Rubio <felix@kngnt.org> wrote:
>> >>
>> >> hey Jeff,
>> >>
>> >> Good catch! I have run the following command:
>> >>
>> >> fio --name=seqread --numjobs=1 --time_based --runtime=60s
>> >> --ramp_time=2s
>> >> --iodepth=8 --ioengine=libaio --direct=1 --verify=0
>> >> --group_reporting=1
>> >> --bs=1M --rw=read --size=1G --filename=/dev/sda
>> >>
>> >> (/sda and /sdd are the drives I have on one of the pools), and this is
>> >> what I get:
>> >>
>> >> seqread: (g=0): rw=read, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB,
>> >> (T) 1024KiB-1024KiB, ioengine=libaio, iodepth=8
>> >> fio-3.33
>> >> Starting 1 process
>> >> Jobs: 1 (f=1): [R(1)][100.0%][r=388MiB/s][r=388 IOPS][eta 00m:00s]
>> >> seqread: (groupid=0, jobs=1): err= 0: pid=2368687: Thu Apr  4 20:56:06
>> >> 2024
>> >>    read: IOPS=382, BW=383MiB/s (401MB/s)(22.4GiB/60020msec)
>> >>      slat (usec): min=17, max=3098, avg=68.94, stdev=46.04
>> >>      clat (msec): min=14, max=367, avg=20.84, stdev= 6.61
>> >>       lat (msec): min=15, max=367, avg=20.91, stdev= 6.61
>> >>      clat percentiles (msec):
>> >>       |  1.00th=[   21],  5.00th=[   21], 10.00th=[   21], 20.00th=[
>> >> 21],
>> >>       | 30.00th=[   21], 40.00th=[   21], 50.00th=[   21], 60.00th=[
>> >> 21],
>> >>       | 70.00th=[   21], 80.00th=[   21], 90.00th=[   21], 95.00th=[
>> >> 21],
>> >>       | 99.00th=[   25], 99.50th=[   31], 99.90th=[   48], 99.95th=[
>> >> 50],
>> >>       | 99.99th=[  368]
>> >>     bw (  KiB/s): min=215040, max=399360, per=100.00%, avg=392047.06,
>> >> stdev=19902.89, samples=120
>> >>     iops        : min=  210, max=  390, avg=382.55, stdev=19.43,
>> >> samples=120
>> >>    lat (msec)   : 20=0.19%, 50=99.80%, 100=0.01%, 500=0.03%
>> >>    cpu          : usr=0.39%, sys=1.93%, ctx=45947, majf=0, minf=37
>> >>    IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=100.0%, 16=0.0%, 32=0.0%,
>> >>  >=64=0.0%
>> >>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>  >=64=0.0%
>> >>       complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >>  >=64=0.0%
>> >>       issued rwts: total=22954,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>> >>       latency   : target=0, window=0, percentile=100.00%, depth=8
>> >>
>> >> Run status group 0 (all jobs):
>> >>     READ: bw=383MiB/s (401MB/s), 383MiB/s-383MiB/s (401MB/s-401MB/s),
>> >> io=22.4GiB (24.1GB), run=60020-60020msec
>> >>
>> >> Disk stats (read/write):
>> >>    sda: ios=23817/315, merge=0/0, ticks=549704/132687,
>> >> in_queue=683613,
>> >> util=99.93%
>> >>
>> >> 400 MBps!!! This is a number I have never experienced. I understand
>> >> this
>> >> means I need to go back to the openzfs chat/forum?
>> >>
>> >> ---
>> >> Felix Rubio
>> >> "Don't believe what you're told. Double check."
>> >>
>> >
>> >
>> > --
>> > ------------------------------
>> > Jeff Johnson
>> > Co-Founder
>> > Aeon Computing
>> >
>> > jeff.johnson@aeoncomputing.com
>> > www.aeoncomputing.com
>> > t: 858-412-3810 x1001   f: 858-412-3845
>> > m: 619-204-9061
>> >
>> > 4170 Morena Boulevard, Suite C - San Diego, CA 92117
>> >
>> > High-Performance Computing / Lustre Filesystems / Scale-out Storage
>> 

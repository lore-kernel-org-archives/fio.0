Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894A2367
	for <fio@vger.kernel.org>; Thu,  4 Apr 2024 04:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712204919; cv=none; b=Rf26eDHTihLWY/Bg2XQUUP/fTJw07xMozuNItfDCcKMhUzlxfbZf4uifxMR9fHh0tyyZJS8jGNt51Si+j4zsNH+KvF61gU9PDm8gAO9SfS+3KHC3ISGb5MnWuAYO5zS8GB15BxFV3PJxLJV9+scFkxlRtOr/paZB5wlULqbu5fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712204919; c=relaxed/simple;
	bh=m75ZpNsLGzLh/fZ86oYWgtXME0Isb/WemBpTmEy9dO0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gCl3Rkk2GT7B+q6pLqQnEnCUng8BpmyacCxFaa3dsooouGXEDZPgULt3PX3o/PpreXyxWWUy9pDdUclTy4R2G/I0OGY01XfPCgEN+xhOQGXgeTFpW7k+3I7MXkJwEfRgaBvNcVbcqR/Veoj5Vu0wzVsBDI/7T5lBXpLuigKTcMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VknlpeLQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VknlpeLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15C9C433C7;
	Thu,  4 Apr 2024 04:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712204919;
	bh=m75ZpNsLGzLh/fZ86oYWgtXME0Isb/WemBpTmEy9dO0=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=VknlpeLQySWF+Llt/bvrA8KgHrFxf6bslnM5CJt2MU0Da4BJ+AkwYon+MkC4Jh5Ki
	 xSduTTtNSBcfFUarGjexnlkc4CQ8HpLt0TbJeaRTO2g7/HHRrKu0zeYAPwx1M+KpJT
	 xDALFFvAjoLIIolFYh8n1tB2XZBWST+NGeOrs+t/tOh8H19FicnoenO/4FZD+Dcm9K
	 tvunqMZcCgkWOZ/69ZpOLOEv4YjxupzZ8fyp7+TwtzvjRQ8Y3lSZ7CUmvRfOZ90Xvw
	 aKguC7HH+c60yCr4vFHRv+WWUGIAKjcIde+J1ZnytZwxJcDqJ9owphGtWcu0uK78be
	 +waQ3PcyiFh8w==
Message-ID: <cfbf631e-5783-40a1-b577-9716c3cdc955@kernel.org>
Date: Thu, 4 Apr 2024 13:28:37 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: help understanding the output of fio
To: Felix Rubio <felix@kngnt.org>, fio@vger.kernel.org
References: <90e42eaab7569a03239ad05dfd1ebb1d@kngnt.org>
 <2494cb75-e0ff-41fe-ad4c-73f383a0c704@cs.utexas.edu>
 <a3415a4de55f178b06c3451fdbe43e08@kngnt.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <a3415a4de55f178b06c3451fdbe43e08@kngnt.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/4/24 04:21, Felix Rubio wrote:
> Hi Patrick,
> 
> Thank you for your answer. I am quite lost with the results shown by 
> fio: I do not get to understand them. I have a system with 3 ZFS pools: 
> in 1 I have a single SSD, in another I have 2 stripped SSD, and in the 
> third I have a single HDD. On the first pool I am running this command:
> 
> fio --numjobs=1 --size=1024M --time_based --runtime=60s --ramp_time=2s 
> --ioengine=libaio --direct=1 --verify=0 --group_reporting=1 --bs=1M 
> --rw=write

You did not specify --iodepth. If you want to run at QD=1, the use
--ioengine=psync. For QD > 1, use --ioengine=libaio --iodepth=X (X > 1). You can
use --ioengine=io_uring as well.

Also, there is no filename= option here. Are you running this workload on the
ZFS file system writing to a file ? Or ar you running this against the SSD block
device file ?

> 
> And I am getting this result:
> 
> write_throughput_i: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 
> 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=libaio, iodepth=1
> fio-3.33
> Starting 1 process
> write_throughput_i: Laying out IO file (1 file / 1024MiB)
> Jobs: 1 (f=1): [W(1)][21.1%][eta 03m:56s]
> write_throughput_i: (groupid=0, jobs=1): err= 0: pid=235368: Wed Apr  3 
> 21:01:16 2024
>    write: IOPS=3, BW=3562KiB/s (3647kB/s)(211MiB/60664msec); 0 zone 
> resets

Your drive does 3 I/Os per second... That is very slow... Did you have a look at
dmesg to see if there is anything going on with the driver ?

You may want to start with testing 4K writes and increasing the block size from
there (8k, 16k, 32k, ...) and see if there is a value that triggers the slow
behavior.

But this all look like a HW issue or FS/driver issue. What type of SSD is this ?
NVMe ? ATA ?

>      slat (msec): min=16, max=1777, avg=287.56, stdev=282.15
>      clat (nsec): min=10930, max=31449, avg=12804.00, stdev=3289.32
>       lat (msec): min=16, max=1777, avg=288.86, stdev=282.20
>      clat percentiles (nsec):
>       |  1.00th=[11072],  5.00th=[11328], 10.00th=[11456], 
> 20.00th=[11584],
>       | 30.00th=[11840], 40.00th=[11840], 50.00th=[12096], 
> 60.00th=[12224],
>       | 70.00th=[12352], 80.00th=[12736], 90.00th=[13248], 
> 95.00th=[13760],
>       | 99.00th=[29568], 99.50th=[30848], 99.90th=[31360], 
> 99.95th=[31360],
>       | 99.99th=[31360]
>     bw (  KiB/s): min= 2048, max=51302, per=100.00%, avg=4347.05, 
> stdev=6195.46, samples=99
>     iops        : min=    2, max=   50, avg= 4.24, stdev= 6.04, 
> samples=99
>    lat (usec)   : 20=96.19%, 50=3.81%
>    cpu          : usr=0.10%, sys=0.32%, ctx=1748, majf=0, minf=37
>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>  >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>  >=64=0.0%
>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>  >=64=0.0%
>       issued rwts: total=0,210,0,0 short=0,0,0,0 dropped=0,0,0,0
>       latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>    WRITE: bw=3562KiB/s (3647kB/s), 3562KiB/s-3562KiB/s 
> (3647kB/s-3647kB/s), io=211MiB (221MB), run=60664-60664msec
> 
> For a read test, running the same parameters (changing rw=write by 
> rw=read), I get:
> 
> read_throughput_i: (g=0): rw=read, bs=(R) 1024KiB-1024KiB, (W) 
> 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=libaio, iodepth=1
> fio-3.33
> Starting 1 process
> read_throughput_i: Laying out IO file (1 file / 1024MiB)
> Jobs: 1 (f=1): [R(1)][100.0%][r=1229MiB/s][r=1229 IOPS][eta 00m:00s]
> read_throughput_i: (groupid=0, jobs=1): err= 0: pid=245501: Wed Apr  3 
> 21:14:27 2024
>    read: IOPS=1283, BW=1284MiB/s (1346MB/s)(75.2GiB/60001msec)
>      slat (usec): min=371, max=27065, avg=757.71, stdev=185.43
>      clat (usec): min=9, max=358, avg=12.44, stdev= 3.93
>       lat (usec): min=383, max=27078, avg=770.15, stdev=185.66
>      clat percentiles (usec):
>       |  1.00th=[   11],  5.00th=[   12], 10.00th=[   12], 20.00th=[   
> 12],
>       | 30.00th=[   12], 40.00th=[   12], 50.00th=[   13], 60.00th=[   
> 13],
>       | 70.00th=[   13], 80.00th=[   13], 90.00th=[   13], 95.00th=[   
> 14],
>       | 99.00th=[   24], 99.50th=[   29], 99.90th=[   81], 99.95th=[   
> 93],
>       | 99.99th=[  105]
>     bw (  MiB/s): min= 1148, max= 1444, per=100.00%, avg=1285.12, 
> stdev=86.12, samples=119
>     iops        : min= 1148, max= 1444, avg=1284.97, stdev=86.05, 
> samples=119
>    lat (usec)   : 10=0.09%, 20=98.90%, 50=0.73%, 100=0.26%, 250=0.02%
>    lat (usec)   : 500=0.01%
>    cpu          : usr=3.14%, sys=95.75%, ctx=6274, majf=0, minf=37
>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>  >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>  >=64=0.0%
>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>  >=64=0.0%
>       issued rwts: total=77036,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>       latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>     READ: bw=1284MiB/s (1346MB/s), 1284MiB/s-1284MiB/s 
> (1346MB/s-1346MB/s), io=75.2GiB (80.8GB), run=60001-60001msec
> 
> 
> If I understand properly these results, I am getting ~4 MBps of write 
> bandwidth to disk,caused by a submission latency problem , but when 
> reading sequentially I am getting 1.3 GBps (also very weird) (previously 
> I shared another test with different parameters, multiple jobs, etc., 
> but with the same result). I am trying to find out if this analysis is 
> correct and whether is a software or a hardware error.
> ---
> Felix Rubio
> "Don't believe what you're told. Double check."
> 
> On 2024-04-03 17:45, Patrick Goetz wrote:
>> Hi Felix -
>>
>> It might be helpful to share your job file or fio command line. Not
>> sure, I'm a neophyte as well with many questions such as what happens
>> when the number of jobs is less than the iodepth.
>>
>> On 4/3/24 00:35, Felix Rubio wrote:
>>> Hi everybody,
>>>
>>> I have started recently to use fio, and I am getting the following 
>>> output for sequential writes:
>>>
>>> write_throughput_i: (groupid=0, jobs=16): err= 0: pid=2301660: Tue Apr 
>>> 2 21:03:41 2024
>>>    write: IOPS=2, BW=5613KiB/s (5748kB/s)(2048MiB/373607msec); 0 zone 
>>> resets
>>>      slat (msec): min=41549, max=373605, avg=260175.71, stdev=76630.63
>>>      clat (nsec): min=17445, max=31004, avg=20350.31, stdev=3744.64
>>>       lat (msec): min=235566, max=373605, avg=318209.63, 
>>> stdev=32743.17
>>>      clat percentiles (nsec):
>>>       |  1.00th=[17536],  5.00th=[17536], 10.00th=[17792], 
>>> 20.00th=[17792],
>>>       | 30.00th=[18048], 40.00th=[18304], 50.00th=[18304], 
>>> 60.00th=[18816],
>>>       | 70.00th=[21632], 80.00th=[22144], 90.00th=[27008], 
>>> 95.00th=[31104],
>>>       | 99.00th=[31104], 99.50th=[31104], 99.90th=[31104], 
>>> 99.95th=[31104],
>>>       | 99.99th=[31104]
>>>     bw (  MiB/s): min= 2051, max= 2051, per=100.00%, avg=2051.84, 
>>> stdev= 0.00, samples=16
>>>     iops        : min= 2048, max= 2048, avg=2048.00, stdev= 0.00, 
>>> samples=16
>>>    lat (usec)   : 20=68.75%, 50=31.25%
>>>    cpu          : usr=0.00%, sys=0.02%, ctx=8350, majf=13, minf=633
>>>    IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,  
>>>> =64=100.0%
>>>       submit    : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=100.0%, 
>>>  >=64=0.0%
>>>       complete  : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=100.0%, 
>>>  >=64=0.0%
>>>       issued rwts: total=0,1024,0,0 short=0,0,0,0 dropped=0,0,0,0
>>>       latency   : target=0, window=0, percentile=100.00%, depth=64
>>>
>>> Run status group 0 (all jobs):
>>>    WRITE: bw=5613KiB/s (5748kB/s), 5613KiB/s-5613KiB/s 
>>> (5748kB/s-5748kB/s), io=2048MiB (2147MB), run=373607-373607msec
>>>
>>> Should I understand this correctly, the submission latency (slat) is 
>>> at minimum 41.5 seconds? I am experiencing problems with my SSD disk 
>>> (the performance is pretty low, which this seems to confirm), but now 
>>> I am wondering if this could be a problem with my OS and not my disk, 
>>> being the slat the submission latency?
>>>
>>> Thank you
> 

-- 
Damien Le Moal
Western Digital Research


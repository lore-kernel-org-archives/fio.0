Received: from newman.cs.utexas.edu (newman.cs.utexas.edu [128.83.139.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B7E149DE1
	for <fio@vger.kernel.org>; Wed,  3 Apr 2024 15:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.83.139.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712159546; cv=none; b=dc2NotIBHEQmM08V478bgf94xhUVG+Nob7anGQ5PL29Cm8DzYEdx0A3muj5V3msie36ON4B2eU6r7YM8vOTgjD0bP/3lR88EItctW8cdaENkUY1suQPutLJcwelDMMiJYr3/nXYej9sD9I7quRGgC5O6Dft3IqOxvEfhvUtK1d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712159546; c=relaxed/simple;
	bh=bqLvH2wPFjtKQtP9v/xhWeZrxxIihZrYYTtNFrmAwBU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=J6ARnzWIntOZWET8wxcQljX88XjrevrZ3tXHIzz2eTCMkjSkclGe+RoiFp377RYBHp3CdayFIt5kdkomd86oRLmcwlEEdrB5FznyWvl+0bdK0NnYjOG1tLUx8jIhiIdbFlxHMq2TC1pLrh3zQeEssK4lPD9/9uxSGNrejW4Cn6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.utexas.edu; spf=pass smtp.mailfrom=cs.utexas.edu; dkim=pass (1024-bit key) header.d=cs.utexas.edu header.i=@cs.utexas.edu header.b=HdvsV06U; arc=none smtp.client-ip=128.83.139.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.utexas.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.utexas.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.utexas.edu header.i=@cs.utexas.edu header.b="HdvsV06U"
X-AuthUser: pgoetz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.utexas.edu;
	s=default; t=1712159152;
	bh=bqLvH2wPFjtKQtP9v/xhWeZrxxIihZrYYTtNFrmAwBU=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=HdvsV06UvIa7Nw2kkR0wRoKkdZ9kPn7krNrUngu6kcunLuxGC9pTmMHpgW3/oUX1E
	 XJByVCLNpRMO/jJKWz2rWrYJwfNkOCbJ9E/Q7B0YdLn6hY5qQRRogUFXzSEsjSAvBC
	 h5vXZhVvjHl4CuClv60LEhaiwCxZ/bn6XviADA0Y=
Received: from [128.83.120.185] (texas-tea.cs.utexas.edu [128.83.120.185])
	(authenticated bits=0)
	by newman.cs.utexas.edu (8.14.4/8.14.4/Debian-4.1ubuntu1.1) with ESMTP id 433Fjp5j008144
	(version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 3 Apr 2024 10:45:52 -0500
Message-ID: <2494cb75-e0ff-41fe-ad4c-73f383a0c704@cs.utexas.edu>
Date: Wed, 3 Apr 2024 10:45:51 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: help understanding the output of fio
Content-Language: en-US
To: Felix Rubio <felix@kngnt.org>, fio@vger.kernel.org
References: <90e42eaab7569a03239ad05dfd1ebb1d@kngnt.org>
From: Patrick Goetz <pgoetz@cs.utexas.edu>
In-Reply-To: <90e42eaab7569a03239ad05dfd1ebb1d@kngnt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (newman.cs.utexas.edu [128.83.139.110]); Wed, 03 Apr 2024 10:45:52 -0500 (CDT)
X-Virus-Scanned: clamav-milter 0.103.8 at newman
X-Virus-Status: Clean

Hi Felix -

It might be helpful to share your job file or fio command line. Not 
sure, I'm a neophyte as well with many questions such as what happens 
when the number of jobs is less than the iodepth.

On 4/3/24 00:35, Felix Rubio wrote:
> Hi everybody,
> 
> I have started recently to use fio, and I am getting the following 
> output for sequential writes:
> 
> write_throughput_i: (groupid=0, jobs=16): err= 0: pid=2301660: Tue Apr 2 
> 21:03:41 2024
>    write: IOPS=2, BW=5613KiB/s (5748kB/s)(2048MiB/373607msec); 0 zone 
> resets
>      slat (msec): min=41549, max=373605, avg=260175.71, stdev=76630.63
>      clat (nsec): min=17445, max=31004, avg=20350.31, stdev=3744.64
>       lat (msec): min=235566, max=373605, avg=318209.63, stdev=32743.17
>      clat percentiles (nsec):
>       |  1.00th=[17536],  5.00th=[17536], 10.00th=[17792], 20.00th=[17792],
>       | 30.00th=[18048], 40.00th=[18304], 50.00th=[18304], 60.00th=[18816],
>       | 70.00th=[21632], 80.00th=[22144], 90.00th=[27008], 95.00th=[31104],
>       | 99.00th=[31104], 99.50th=[31104], 99.90th=[31104], 99.95th=[31104],
>       | 99.99th=[31104]
>     bw (  MiB/s): min= 2051, max= 2051, per=100.00%, avg=2051.84, stdev= 
> 0.00, samples=16
>     iops        : min= 2048, max= 2048, avg=2048.00, stdev= 0.00, 
> samples=16
>    lat (usec)   : 20=68.75%, 50=31.25%
>    cpu          : usr=0.00%, sys=0.02%, ctx=8350, majf=13, minf=633
>    IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>  >=64=100.0%
>       submit    : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=100.0%, 
>  >=64=0.0%
>       complete  : 0=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=100.0%, 
>  >=64=0.0%
>       issued rwts: total=0,1024,0,0 short=0,0,0,0 dropped=0,0,0,0
>       latency   : target=0, window=0, percentile=100.00%, depth=64
> 
> Run status group 0 (all jobs):
>    WRITE: bw=5613KiB/s (5748kB/s), 5613KiB/s-5613KiB/s 
> (5748kB/s-5748kB/s), io=2048MiB (2147MB), run=373607-373607msec
> 
> Should I understand this correctly, the submission latency (slat) is at 
> minimum 41.5 seconds? I am experiencing problems with my SSD disk (the 
> performance is pretty low, which this seems to confirm), but now I am 
> wondering if this could be a problem with my OS and not my disk, being 
> the slat the submission latency?
> 
> Thank you

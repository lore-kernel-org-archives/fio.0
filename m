Received: from newman.cs.utexas.edu (newman.cs.utexas.edu [128.83.139.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D806815B0E2
	for <fio@vger.kernel.org>; Wed, 24 Apr 2024 14:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.83.139.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713967949; cv=none; b=KJl3PNKDqrDnChObrRG2Xmd6s8LCxukrOW4RZOgoJIdcru0zl54H/s0d5ZkrQ8d18euiXNTLdXqNXETyAGJnQojlLSFvr//8Gav79dNfYef/oucDtJBb05oGYf8Guos9+yHQ8OXqFHTNOYz1WRl/7h1rZnH2Q4ZFkjjxxOegO5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713967949; c=relaxed/simple;
	bh=40x8E+ytPxp9Ekd4JmE+MvVMyEo6N8acz9blH+fM4No=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DswNHsvLSH+FQWGd/lPNLyxjO6dLaTgmadofda6lambzeEp3kgCNfHpIGpdNB+bdju6AgHuETxN6epJy7nP07oEYOp2YTHO41/tUopI7DP/wpXeVWXX/iGOyTh9OssLf1XKgr/Hr8jkyB+k0Od4OWd2+FpD1sk9jZdI4y5CcjjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.utexas.edu; spf=pass smtp.mailfrom=cs.utexas.edu; dkim=pass (1024-bit key) header.d=cs.utexas.edu header.i=@cs.utexas.edu header.b=iaHZxWjf; arc=none smtp.client-ip=128.83.139.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.utexas.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.utexas.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.utexas.edu header.i=@cs.utexas.edu header.b="iaHZxWjf"
X-AuthUser: pgoetz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.utexas.edu;
	s=default; t=1713967910;
	bh=40x8E+ytPxp9Ekd4JmE+MvVMyEo6N8acz9blH+fM4No=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=iaHZxWjfUfVjrwDhSLVmVIQQj82KlU6MMyL7MzjcVMRnM9bA3Hk8E+p4+WSLLpRsn
	 4hr1kehQdCUnIBsKZGCzaMRSAhfKIGm8qsf4kju0+U0NUvDaCSU7d3eryKq7KnHQuC
	 eNb+SyxCkh8tnLc4gkHGQrbbRd06VWHxdF2NKFf8=
Received: from [128.83.120.185] (texas-tea.cs.utexas.edu [128.83.120.185])
	(authenticated bits=0)
	by newman.cs.utexas.edu (8.14.4/8.14.4/Debian-4.1ubuntu1.1) with ESMTP id 43OEBnrd012244
	(version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 24 Apr 2024 09:11:49 -0500
Message-ID: <91565e31-e6fa-4e79-b2f0-8f28b9fd82f9@cs.utexas.edu>
Date: Wed, 24 Apr 2024 09:11:48 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Trying ot better understand when requested iodepth is not
 achieved
Content-Language: en-US
To: Nick Neumann <nick@pcpartpicker.com>, fio@vger.kernel.org
References: <CADqNVTq4POWDi_aX9-gx4DkzGXaWfPd64tMmj2_Ehseq1YzSeg@mail.gmail.com>
From: Patrick Goetz <pgoetz@cs.utexas.edu>
In-Reply-To: <CADqNVTq4POWDi_aX9-gx4DkzGXaWfPd64tMmj2_Ehseq1YzSeg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (newman.cs.utexas.edu [128.83.139.110]); Wed, 24 Apr 2024 09:11:49 -0500 (CDT)
X-Virus-Scanned: clamav-milter 0.103.8 at newman
X-Virus-Status: Clean

SSD drives are loaded down with trickery designed to enhance 
performance, including using faster SLC cells or DRAM for cache. Usually 
the high performance numbers you see for consumer grade SSDs are because 
the tests are just hitting the drive cache and not the QLC cells. 
Someone feel free to correct me if I'm mistaken about this.



On 4/23/24 18:39, Nick Neumann wrote:
> I recently started doing some higher iodepth (32/64) testing with some
> high-end consumer SSDs. Of the 6 I tried, one consistently led to fio
> runs achieving a lower percentage of IO at the requested iodepth.
> (Every other SSD had >99% of IO at requested depth, This particular
> drive would get as low as 97%.)
> 
> I was trying to understand how specific hardware could affect this. It
> would seem like the only thing an SSD could do to cause lower
> iodepth_level would be to process data faster than fio could supply
> it. So I would expect times of unusually low latency.
> 
> Instead, looking at the runs when this happens, the drive is actually
> performing unusually poorly. There are some big latency dips from high
> latencies to much better latencies, but the latencies seen are never
> anything lower than another better-performing drive.
> 
> Any thoughts? Happy to share graphs if helpful.
> 
> Thanks,
> Nick

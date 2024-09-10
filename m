Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC331AC8A2
	for <fio@vger.kernel.org>; Tue, 10 Sep 2024 23:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726012184; cv=none; b=tPjTOennKYrAzItJuSgAe1zwxjJOgHTZQNE0n3FQtjfrh1QGCnTRKaM+G5QJD2tTm0vCOyPwuHv9iDNDt97ythtmEjeHCsY3iH6TNS5OqHtB894WEGHS7ziAuODT1r3l6FHcqd8GQhG68+7ME9/QjwY5qXIM7U329Ji29n2zFhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726012184; c=relaxed/simple;
	bh=YMU6gsf4C9f+g2Tntl647MDHB59jvjZ1VVQjhNy0E9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=moZqDVVBQb/5ob8SJsWS41tK97H06+amhhHHExojkhNMbOIhNvEsMA0M3yLt8b5+Q96CjdwD+19Aq5q3OTr5D+8uckht0ZhAcbSuI+f3YU6iB+TBRz9gSJvjQmdRArgmcKXhdnSmVpuevl53TR7/x/Vy1AK2NRquhPdwMDQM/hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KvBJyGDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KvBJyGDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69253C4CEC3;
	Tue, 10 Sep 2024 23:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726012183;
	bh=YMU6gsf4C9f+g2Tntl647MDHB59jvjZ1VVQjhNy0E9U=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=KvBJyGDFpEPw1WjZTzdDxIJqAQNd4KdyYmBzbDqxkvHIukIemBqV7U3nXHtnWFSBw
	 pS6OHiJ+qCZeAqd9Ok2nciDnnEtePBnKkw5zimc9D/CdWBVTSk0fe+MDTCNksP+Nrn
	 Thn65nQ511rxGAXEM8fKATLwEpTnuDbRRyv63aVd3kyYEx27ceM16aDr6nZzOv1Qb4
	 2Zb5WFYXowuC8XpMkeRSWbFk20EpBFA9o7X+cVrUNTTwah0aDIDqRrp2SYMLq5gkYj
	 6VlRwYv7Fqn3Tt7anPKe40mUZ4GZi0atsVxMc8fTXiN/i57aGZsb/UI9ZvWUNFz7Qp
	 TWgTwg8xw5+6g==
Message-ID: <44241ecf-7130-469f-8a10-873be7e464d8@kernel.org>
Date: Wed, 11 Sep 2024 08:49:42 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: how to fully load RAM while stressing SSD using fio
To: Anatoly Belanovsky <abelanovsky@gmail.com>, fio@vger.kernel.org
References: <CALeYq=AP_h293ZrkixjFLxXzYpB3nm1YgAyZxYCMHW=ByvxBWg@mail.gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <CALeYq=AP_h293ZrkixjFLxXzYpB3nm1YgAyZxYCMHW=ByvxBWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/11/24 03:01, Anatoly Belanovsky wrote:
> Hello,
> 
> I would like to stress my SSD and RAM with fio and I use command
> 
> fio --direct=1 --rw=randrw --rwmixread=90 --rwmixwrite=10 --bs=4k
> --ioengine=libaio --iodepth=256 --numjobs=2 --time_based
> --group_reporting --eta-newline=1 --runtime 12h --name=job1
> --new_group --filename=/dev/nvme0n1
> 
> I noticed that while I am stressing it with fio the power consumption
> of RAM is much less than if I use other stress utilities like intel
> ptat or y-cruncher.
> 
> How I can run fio to use full power capacity of RAM? I tried to
> increase numjobs but it didn't help.

Remove direct=1. That will add lots of memory copies. But then you may not see
the real speed of your drive due to this added overhead.

-- 
Damien Le Moal
Western Digital Research


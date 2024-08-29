Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7786BA92D
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 00:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724893179; cv=none; b=Js25RSLCxzXVLAl9z3eTiUhYiSPDnPbdWvqnKwzXTs4xdHp1YHBdMV5WYRY9ZXiYIAbkp9bYfuHwdpE1Hl37dJrlstykL2HYCMi1ZPPRd7QBaRumzjI7htzisim6YGqGqcU0qzseItSPUCVLUwQ2Nf4ky0tIv9/Yj2PsVobppYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724893179; c=relaxed/simple;
	bh=lG1TS6xu37cZrPkHU229kCxGZsgY/h8wjKYKURamgN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eWpfMU/wEcGIWHiNKRbGQz9GTS+ww4pMLpGgzmNvDtdFMJ0hc4Bme+zoo3wShr1aEt+qi7QhQfBeEbB+p/SsE8xUDPX3KvBto2hJLv+7uxqgVs9RFn5Fx8yXCwz45f4PxLAHE1kSYkpBv1zrWOcoGC6g77kOYG+7u5T4ahx8QKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KiO9nak8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KiO9nak8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B69C4CEC0;
	Thu, 29 Aug 2024 00:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724893178;
	bh=lG1TS6xu37cZrPkHU229kCxGZsgY/h8wjKYKURamgN8=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=KiO9nak8wMsA+xc/FkczgBdbDzxfoVDxbnK1EmCSFI/ZEWbWWyWE585yCdegggzva
	 uVkbeNPK/rEG2Pt6zPbbGjVcbPgoyKDFtseZDAhULkvPPw+Pw1gaGONAYt37dXzJpH
	 FJTfI7y+jusePkDRuZTAq93NlVp4khZ8ZbKvMo1ZcUNcgz5Dwjv0s37wqhtLExBZK1
	 gnHlXVCNC/j4NgeY5n0sNDOZqVLX3CPSovf2MvXv3vAXCVWNhJJixJQosWz0qBthqi
	 bTH2LebdLGZ7MfrSbN3dRA5/X39+oJyzd2jOkTOFzvVPGtXwAC53boXt/9pg4ZsFDS
	 Ihp4NspD06J3Q==
Message-ID: <696d408a-b36d-4648-8eb4-93384cf2d65f@kernel.org>
Date: Thu, 29 Aug 2024 09:59:37 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/9] introduce the log_issue_time option
To: Jens Axboe <axboe@kernel.dk>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Vincent Fu <vincentfu@gmail.com>
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
 <d056a445-52c3-4407-b792-fdd2b6be204e@kernel.dk>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <d056a445-52c3-4407-b792-fdd2b6be204e@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/29/24 02:06, Jens Axboe wrote:
> On 8/27/24 1:08 AM, Shin'ichiro Kawasaki wrote:
>> When write_lat_log option is set, fio outputs the 'clat' completion
>> latency log file. This clat log can be used to analyze IO latency. This
>> file can also be considered as an IO trace file as each IO entry can
>> fully describe an IO when the --log_offset and --log_prio options are
>> also used. However, using the clat log file as an IO trace is inaccurate
>> because the time field of each entry uses millisecond units, which is
>> too coarse for fast IOs (e.g. when using SSDs). This series proposes the
>> new option 'log_issue_time' to address the inaccuracy problem. When this
>> option is set, fio adds another field to the log file entries to log an
>> IO issuing time in nanoseconds.
>>
>> The first four patches in the series clean up the current code as
>> preparation. The 5th patch introduces the 'log_issue_time' option. The
>> following two patches document the new option. The last two patches add
>> two test cases to check the log file format.
> 
> In general this looks fine, and I think it's a useful feature. However,
> should we have an option to make the generic time in the log entry be
> in nsec as well?

I am not sure if it is that useful given that the entry time field does not
directly correspond to any I/O time. But to be consistent with the other time
fields, I may be good to add this option. That is easy to do.

-- 
Damien Le Moal
Western Digital Research


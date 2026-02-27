Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6495F3290B5
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 04:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772168381; cv=none; b=lpueLRdZGXcoDQc0tIcSOi1eRiuPNmKhSvHk7Dtncp8SLGJTw3fguYtxxBot2VRH6hmOQKZc+2nWisv5gyLyhtQPfInciesr496BAByhS/uOciZUtO+5nPWUqOigfIeUJ2v7Vrt9bEGa62ZSk+Vf5nVDo95hGlppQEbY1rQqNs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772168381; c=relaxed/simple;
	bh=sLhKy7Esut2ue/s7EVLUrrGwalIr8kakZQTxDlpuPdA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VFVE2Z8zjnC2/ajos4wJP85EIA7e76s5tjcY9LmWWclwpKB5lv2MAcwCx2JFFzbz7A2PHHDoQ4fNaE6tsBV52wmdmQbIRslSbLEOYNvOUedA72FTFtYmITB9J5zWhtkpbbYiJdrREsH2bHp5FmvvdIh6Zyc5biAA4LOoMJtlHFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mK/hmVkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mK/hmVkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B05C116C6;
	Fri, 27 Feb 2026 04:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772168381;
	bh=sLhKy7Esut2ue/s7EVLUrrGwalIr8kakZQTxDlpuPdA=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=mK/hmVkJpfwWrAJzCwrNK6T/FsMSNqFCoHB4ZaZg7Yn+kfc9IwwzTZ3CyuO3VsMgU
	 LsR+HnbtJOyLGcHa5oC40ZQj4s/iz7zILdmUn9Gx2TKwoJgI/chv7RsYzrCq7sidKG
	 MLOwzsn/TN+L6stZ/2hIQFiv1MGwpMsdVOXJnk3xNuDVEd+oz5LIcT6vUxAlvPDpjn
	 LI81Fuo3vAGS9qj5An+yIej6nazjnhIqfYV8qlDQkzgbQTUcoasHTdbkV+llqKNlCo
	 Ru8+ymrso/kdpKaxGNY2JLxr15m+LCAPqTPhCxQ7eP6aGgjNvipOrrycnOJ6l5+mNI
	 LqsJR4mc646Dw==
Message-ID: <f3df9bb5-d6bc-4d60-97f3-e8d3805387ef@kernel.org>
Date: Fri, 27 Feb 2026 13:59:39 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/8] zbd: introduce write_zone_remainder option
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
References: <20260216075936.3318729-1-shinichiro.kawasaki@wdc.com>
 <20260216075936.3318729-4-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260216075936.3318729-4-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/16/26 16:59, Shin'ichiro Kawasaki wrote:
> When the specified block size is not aligned with the zone size or the
> write pointer positions at workload start, write workloads create
> unwritten remainder areas at the ends of zones. These remainder areas
> leave zones in the open condition. This disrupts the intended write
> target zone selection.
> 
> Previous commits e1a1b59b0b9b ("zbd: finish zones with remainder smaller
> than minimum write block size") and e2e29bf6f830 ("zbd: finish zone when
> all random write target zones have small remainder") attempted to solve
> this problem by issuing zone finish operation for zones with small
> remainders. However, this approach caused performance degradation due to
> two reasons. First, the zone finish operation requires substantial
> execution time. Second, zone finish operation requires to wait for in-
> flight writes from other jobs to complete, which is done by calling
> io_u_quiesce() before the zone finish operation.
> 
> To avoid the performance degradation, introduce the new option named
> "write_zone_remainder". When the option is specified, issue writes to
> the remainder areas instead of issuing zone finish operation. The write
> operation makes the zones in the full condition in the same manner as
> the zone finish operation, freeing up the zone resource of the device
> and enabling writing to other zones. Also when the option is set, skip
> the io_u_quiesce() which was required before the zone finish operation.
> The performance benefit by eliminating the waits on in-flight writes are
> particularly significant in asynchronous I/O workloads, where the write
> operations to the remainder areas are managed as part of queued I/Os.
> 
> The drawback of this approach is that writing these remainders requires
> write sizes smaller than the minimum block size. As a result, when using
> the write_zone_remainder option, the random map feature must be disabled
> using the norandommap=1 option, which is automatically done when the
> option is specified.

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

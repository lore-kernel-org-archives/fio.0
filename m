Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0150213C816
	for <fio@vger.kernel.org>; Thu,  4 Apr 2024 23:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712273873; cv=none; b=no1xW3qvnjMtKoAv657tNDvrpdWYMVu8aSncw0ZXQjlYT6AYnYCIDTMI/p14Q0Sq7Jt2Qh5RWJmCr6b0fsS7Jr4nCFnGHQx4iH0LpKNz1TFzCAsBVtKd1jFBC/crBUqbKL8etOpBWV71LoP2N0IbTCpKwCgwShs8iPUmV5wDL7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712273873; c=relaxed/simple;
	bh=uSZrxafjps28IgkwfvXLCnOKAGsLfeoSI15MmLD7Jeg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ga+wMkoeEUs6hRw8jwtcnP2fXg1nrl4EFqD9S0CV6CfXJpulNeLSEMb4UCXrpbuS5u10mrh8KflAF5qpNzCcH5KwwW35O+AOwIrpNWNk5d+k5nlIv5GwUTCONcRD+qPZCO1/5V7rhc6gRjbzMdA9sfAISarWWmt2/fzHsKjRXx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AqQ+bYhq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AqQ+bYhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14662C43399;
	Thu,  4 Apr 2024 23:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712273872;
	bh=uSZrxafjps28IgkwfvXLCnOKAGsLfeoSI15MmLD7Jeg=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=AqQ+bYhqOAobAcUXvUHdTaQzgavzpVSqN66qrPnizqcRLWTV+NqkSuwL8eVnzIVf8
	 z5RzXI0hPS37yp6T1avI6m+xPlDIlcYCspnT/plyrqSjECiqUx/d2hPdQgehtNkoKU
	 QrvIMPSOZSDBGK2IMcm1533UTjYGhOBMNsPPV3S+e7pO79IP0b3fohQlH3x68v6lRS
	 yPz6AnvX0ocLzMrGKqh8XFUJ8N6qBUqD+BdVbXTuOR+Q1C8QQD387qK6b+bOv6u0oZ
	 kcY3u+sgIGtws/OfJHKHAtOEVt3IylRq+vhw3bM812yXsQR54oBlpU7+SeYSEc5xWl
	 F3Hi4JEh/eILQ==
Message-ID: <d7a1c622-0d91-485d-88c3-e595ece06f51@kernel.org>
Date: Fri, 5 Apr 2024 08:37:50 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: help understanding the output of fio
To: Patrick Goetz <pgoetz@cs.utexas.edu>, Felix Rubio <felix@kngnt.org>,
 fio@vger.kernel.org
References: <90e42eaab7569a03239ad05dfd1ebb1d@kngnt.org>
 <2494cb75-e0ff-41fe-ad4c-73f383a0c704@cs.utexas.edu>
 <a3415a4de55f178b06c3451fdbe43e08@kngnt.org>
 <cfbf631e-5783-40a1-b577-9716c3cdc955@kernel.org>
 <213da342-d37c-49be-93f8-a36c9bbef06e@cs.utexas.edu>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <213da342-d37c-49be-93f8-a36c9bbef06e@cs.utexas.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/5/24 01:18, Patrick Goetz wrote:
> On 4/3/24 23:28, Damien Le Moal wrote:
>>
>> Also, there is no filename= option here. Are you running this workload on the
>> ZFS file system writing to a file ? Or ar you running this against the SSD block
>> device file ?
>>
> 
> If he ran this fio test against the SSD block device, wouldn't that blow 
> up his zpool?
> 
> I read through the entirety of 
> https://fio.readthedocs.io/en/latest/fio_doc.html and still feel 
> completely clueless about many details. It kind of feels like you need a 
> good grasp of how all this is implemented in the kernel to make sense of 
> it. Does anyone have any tips for what to read in order to be able to 
> master the fio documentation?

Look at the examples in fio/examples/.

-- 
Damien Le Moal
Western Digital Research


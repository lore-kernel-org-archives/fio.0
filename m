Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607BD430BA2
	for <fio@vger.kernel.org>; Mon,  2 Mar 2026 02:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772418266; cv=none; b=FwEbPpZZv+dMm9E2T9+MNxc2NcYmTpz9tWbKgjjnKh5xG1/Vk+TsxGuO/qa0D3EEOOznAnpzeFxaCCUxOE60iEPlwsXi+8u+gGhYguVxRkcYtsk3r9rUJtFBrCjrqcu4bKrJCDmy3MyjBSu7Pqa5U/RYrEAT2hhhwkI+qsZ4IL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772418266; c=relaxed/simple;
	bh=RKkukgPs/v/Usm0rN9IPXbhIN4VKqsj5cuAkuVZ7Pxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FFcS/2sc3fdWniFmVO1bvCJME0mjInUiv479wNeeHcF4q7aBCnfbtWLsYxTfZdYSd70QP3rISSWdOcT0UTq8aPzv0KeEGCrQZarzRjklY6dqI5W/BxIzne9cDE+T/pX2cjrDSZGjCe5iBq+d8mm4Szsn+zESBG9irHN4ai5Yn3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p65v3idk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p65v3idk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798AFC116C6;
	Mon,  2 Mar 2026 02:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772418266;
	bh=RKkukgPs/v/Usm0rN9IPXbhIN4VKqsj5cuAkuVZ7Pxg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p65v3idkDKp4cHduUXRl6IcGaTpj7AouQunzHPc/eDoU36yXawqqKwWrqa9KXwi8d
	 OkDndsK0tMeyeBy2nTbgm2utm/xUlHGIb4oW6y0SLYjnXD3aTIUlPoQl1o3tZDrHKj
	 B0r6ZGWhYikOh0QJndLRS7qonUs0sH0GsBnoIhFqM+o0Wdop7cu+iR7Z08/tADLCjk
	 ySMH5C5YeNefJdt73EbBea9oi2SkR9eOiiT5CbDT94TcGch9Pq/cZOIqbMFMtHY5uw
	 3Lpc4ZT8AItKe46e5FY7PEzJutlLco5OspNWGcxn4Cp0b5Sq3w9Cj67V1gYVhkuaSJ
	 u9sZTMfpu/nKg==
Message-ID: <38e88c6a-7081-4f68-bb57-ffeb2ce5e577@kernel.org>
Date: Mon, 2 Mar 2026 11:18:59 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/8] Introduce the end_syncfs option
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Vincent Fu <vincentfu@gmail.com>
References: <20260227080712.2422380-1-dlemoal@kernel.org>
 <CALjAwxj1zbewniV8SNUt9d-qkDGrNAaGPkzp0BtRAdoL71pmUg@mail.gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <CALjAwxj1zbewniV8SNUt9d-qkDGrNAaGPkzp0BtRAdoL71pmUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/1/26 7:47 PM, Sitsofe Wheeler wrote:
> On Fri, 27 Feb 2026 at 08:13, Damien Le Moal <dlemoal@kernel.org> wrote:
>>
>> This patch series introduces the end_syncfs option and adds support for
>> it to the main IO engines that can handle regular files.
>> This new option improves the precision of file system benchmarks when a
>> large number of files are being handled.
> 
> This looks excellent to me and I especially like that it now groups
> the syncing by the filesystem each file uses. I went through the
> ioengine flags and wondered whether absence of FIO_DISKLESSIO was
> enough to know that an ioengine would support syncfs but there are
> engines (like mmap and sg) that lack FIO_DISKLESSIO but would be
> inappropriate so a new flag makes sense.
> 
> Out of idle curiosity, what happens if you use the syncfs option when
> the file being operated on is a device? Regardless:

In add_file_fs(), I have:

	if (f->filetype != FIO_TYPE_FILE)
		return 0;

So for any file that is not a regular file, we do not try to add a mount
point/FS to the job list and end_syncfs will have no effect for these
non-regular files.


-- 
Damien Le Moal
Western Digital Research

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45F42E0902
	for <fio@vger.kernel.org>; Fri, 19 Dec 2025 08:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766131924; cv=none; b=ARnYQq3oZZMLWO/r9/S2keVm2aWy8c7yK87e4MUeSRRPaLTmA6RZYg91ALkNADUg6Vp+zj588I/X+mWwxCPvJ2htCTHVMC/gviHCMlU27qba1nbu3ijy9H6T+XZTis6wqeBGAXlvz8k9wMzgT3bAMNgJgv6xAOgTKY/zm66PyT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766131924; c=relaxed/simple;
	bh=502l28cQ6PKiWr0MoF78TKTkZYJt7eAxFTu3kQVL/Rc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KIe2nrjkTZtJ1xe2IcD9a7351VxmMAc2fTs65/yeXNwpFQT3HQZmuz6UTxsarp6qaz9c8fDdJxD3eCnltenggLWbgULFiOjL6B3Fm1htANkj6hV2O1XoKk1gPxQMC2vnsO3YdUEA89WQjszA379n/W5MkWWJJyJ5MnCKdaEWiic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DCn8xcbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DCn8xcbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFBAC4CEF1;
	Fri, 19 Dec 2025 08:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766131924;
	bh=502l28cQ6PKiWr0MoF78TKTkZYJt7eAxFTu3kQVL/Rc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DCn8xcbIGoL+U3RGQ8GwlCOI/APxGFTX4C7N+qqfQTrTwCIx4SanRpH3mshO9OH9c
	 GK08WfY4hXL87n5crqvy/kuociPhdf+UAHtc7xlu0XcjqbVilNrWdZXuNt2PjBiTYg
	 6yZkgdq1x4hkFHxehTpMIqMUGPd3kEGqSndUXCLJyZONw3Xt8E4nnoPw43GsNOAz5/
	 LboE3aBUgaV4OnN6SYQ29/Hhr197WDrqmlqXvpNrCVgF7zoFL1jNRDUCWrHxnnyNdM
	 O2Dapj8puWf5IXQXdiT4TXKWzXG+GevazqyFD8/AV5q/hS9ZMIgjzU0Ha7zZHoA4Vk
	 qTGwT6gaB05zg==
Message-ID: <d68515f5-4335-40fd-b9ee-c3017908d3d9@kernel.org>
Date: Fri, 19 Dec 2025 17:12:02 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] Add option to specify ramp period by amount of IO
To: Jan Kara <jack@suse.cz>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Vincent Fu <vincentfu@gmail.com>
References: <20251217160217.15533-1-jack@suse.cz>
 <20251217161722.6357-5-jack@suse.cz>
 <7dab8aa5-3ff1-4031-8c9f-30c2bc8cc050@kernel.org>
 <he6xudnbje7lqwdd7wikgaqvfyhofl57oranzslhckhhjqihag@cbk3rfp6slwa>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <he6xudnbje7lqwdd7wikgaqvfyhofl57oranzslhckhhjqihag@cbk3rfp6slwa>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/19/25 01:31, Jan Kara wrote:
>>> +.. option:: ramp_size=size
>>> +
>>> +	If set, fio will wait until the workload does given amount of IO before
>>> +	logging any performance numbers. Similar considerations apply as for
>>> +	``ramp_time`` option. When the unit is omitted, the value is given in
>>> +	megabytes.
>>
>> Hmm... It may be less confusing/easier to use the regular fio "int" parameter
>> type here, which takes all the kilo, mega etc suffixes. This means that the
>> default without any suffix would be bytes, not megabytes.
> 
> Well, this argument also takes all the kilo, mega, etc. suffixes. Just
> without any suffix it will default to MB. I've copied this behavior from
> 'size' and 'filesize' options which behave like this striving for some
> consistency. That being said I don't really care deeply about the behavior
> without units because I think sane people write the units explicitly.

Sam here: I do not really mind one way or the other. I raised this comment so
that the options stay consistent in behavior, same as you aim for.

Checking with some quick runs, if I run something like:

fio --name=write --ioengine=psync --bs=512 --rw=write --directory=/mnt \
	--filename_format='test.$jobnum.$filenum' --nrfiles=16 --openfiles=1 \
	--create_fsync=0 --filesize=1024 --create_on_open=1 \
	--allow_file_create=1 --end_fsync=1

I get files of 1024B, not 1GiB. Same with even smaller values like:
	--bs=8 --filesize=8
I get files of 8 Bytes.

So I doubt that the default is MiB when there is no unit specified.

Checking the code, the .interval field of filesize option (and all other options
in fact) seems to be unused, except by the goptions.c file, which I think is for
the fio GUI.

So the default it seems is Bytes when no unit suffix is specified. Your code is
good then, except the man page and HOWTO files where you should remove the text
"When the unit is omitted, the value is given in megabytes."

With that,

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

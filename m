Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70A63398A
	for <fio@vger.kernel.org>; Tue, 27 Jan 2026 02:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769480330; cv=none; b=QsvdlVR2f1xp9jL/oE/mdELIExu16Tqnn3SZ0VImM3Q2KvIIUtMTMBdE+UgkT//UjynXsp2Sp/6PNtrpyqgsAPBYuW2kRPU9la7gZ3WPyGZc4cJ2fGBQiNX5LehVyNgntirsr+kPJAWNfoLClA6i3BhrdtAsr3BHdKIXumn4Vlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769480330; c=relaxed/simple;
	bh=o1rBHldd0CL1u9bjce0wuC3ezLMvqZHA+Dq/UAfqvOM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nb601tCXbdXx/p3axxHpY/k/arrzj3Djle6tCiGvUXHaMkw0xtG1ZDghIqkzmHYyagSiA5CkcwTI+V7Q/9QHUwFM4C1jlvb3mewwPdZi7v/E+pcE4tOQxfeVtzzPT52oY6BhJGVmhLhJ4b110O4tfqit2o/AXOfXqDsl1fUmTUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tsKuYyQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tsKuYyQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1CFC116C6;
	Tue, 27 Jan 2026 02:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769480330;
	bh=o1rBHldd0CL1u9bjce0wuC3ezLMvqZHA+Dq/UAfqvOM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tsKuYyQJE4nYz02dwB2dDbsCZDQLvmN67TcPIwxwwhykL+0knu+DQELZaxM2Iito5
	 FY+nx2CeUCXgDlnxwBm98sXtcg2B9wmQkTH7We/jVD/S/7IiSlTq1OrI/3WE7uEqsx
	 4zQJX/e9CY2NDrLE7Pc7rY8F9MVBYrqOPSOD1aDRXIud0qbGqOPRL9BDT2HF8nnZG+
	 WqxY9srMj66XDmXAP4CB/RfFaAlbNlxmq7KC9Z1TydpA1New6C1Sp39W4wIwhL5gVI
	 ssznx/LWLfJQu1xywPjhAE98rapSpD9mN++X/uR36UqBZc9u8t6FW93YuXdjmKR499
	 pxyiK/fPnCN5g==
Message-ID: <7ae36bea-e5c4-4626-bad0-a301ba69777c@kernel.org>
Date: Tue, 27 Jan 2026 11:18:48 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] Introduce the end_syncfs option
To: Vincent Fu <vincentfu@gmail.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <20260126061721.270448-1-dlemoal@kernel.org>
 <CAOp=CX=dWPmgjKhZFK8BDKA57qyYJKCJkYBKYOLynU1n6bi=ug@mail.gmail.com>
 <83b16ae2-4a7f-4165-8c8f-adbde7e581d5@kernel.org>
 <CAOp=CXnJ3Sr2ZGDjiAHdPhi4eKfUo-RtJ0h1oF072ew+Xfcy7Q@mail.gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <CAOp=CXnJ3Sr2ZGDjiAHdPhi4eKfUo-RtJ0h1oF072ew+Xfcy7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/27/26 11:15, Vincent Fu wrote:
> On Mon, Jan 26, 2026 at 9:05 PM Damien Le Moal <dlemoal@kernel.org> wrote:
>>
>> On 1/27/26 10:01, Vincent Fu wrote:
>>> On Mon, Jan 26, 2026 at 1:22 AM Damien Le Moal <dlemoal@kernel.org> wrote:
>>>>
>>> <snip>
>>>>                 }
>>>> +
>>>> +               if (td->o.end_syncfs) {
>>>> +                       td_set_runstate(td, TD_FSYNCING);
>>>> +
>>>> +                       for_each_file(td, f, i) {
>>>> +                               if (fio_file_syncfs(td, f))
>>>> +                                       log_err("fio: end_syncfs failed\n");
>>>> +                               break;
>>>
>>> This seems like it will break out of the loop after syncfs-ing the first file.
>>> Is this intentional or should fio break only if there is an error?
>>
>> It is intentional and it is the entire point of this patch: doing syncfs for the
>> first file will sync the entire FS, so all the other files will be sync-ed as
>> well. We thus avoid the entire loop on all files which is extremely slow when
>> running with a large number of files. We only need to do syncfs() once for the
>> first file. Ideally, we should do it for the directory specified for the files,
>> but that is a little more involved as a change.
> 
> Ok thank you for clarifying.
> Please emphasize in the documentation that this feature assumes that
> all files will reside on the same file system.

OK. Will do in v3.

> 
> Vincent


-- 
Damien Le Moal
Western Digital Research

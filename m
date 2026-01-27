Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AC81E9B3D
	for <fio@vger.kernel.org>; Tue, 27 Jan 2026 06:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769493837; cv=none; b=NGPWqGojhWGVhdE8HoNaGah2KBkpg75PcSfwDWkWiq4it7/leqEHTXsYK4oqxm7AFoqct0Ue7cEm/3jijvLyCk3x/Ax0V60gXNeXESc0GhHhPKEl3LmXJfSd96jIK9BoosCYlMZvG3Z0T7SwujfwD2oitlyQno2Wf9TxZvDPlTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769493837; c=relaxed/simple;
	bh=qj8mxhq49uty+t2Js3XS8PJZlWK3Mkn709wcRebit0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LbNqVvOMOcfA9/WaPXcsiaxZbdco4iQFS/KWsrFxJtFaCWlf5jKgf9nNSTaOiZs6j4SWgV2WYCbKv2K7fObJ2htbpbRUpjPx0N9NASTMgmaA3HX1qr9JWmmyzFL0Iwx8JwT8krJrQ2jL/LJwTfz/kkFb2q4bpOzTY0dRWjkJCrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UelFuShQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UelFuShQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10720C116C6;
	Tue, 27 Jan 2026 06:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769493836;
	bh=qj8mxhq49uty+t2Js3XS8PJZlWK3Mkn709wcRebit0w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UelFuShQr4i+eZvmNQ4JIKMo7ywQAZVzivYaKk5CMxexVNVh6syyGIyDROYC5LThH
	 Cab7wklsYwkQ/NQtUAPJFy6Jl+IqccNyXykSx6ypwgETkGt6G+2Q5Aujd9pJfOJvte
	 cMXY0pB1GUZ/k2SLxLXJ7JtyBpgQqNFL6CjvhYE44s4q1XoMKZ4y580rRrU2XxX6tT
	 5L+BQHP6beDS+T7f4l9Z0DPSCmhzoBWhWPPVSlZ6vBuBhCjymEOfSu6DJpfwLOYTCu
	 6QUvkI39lWc+AtpoXItBkwjkwULzuQ3+O/8DXVVDkpoWlhr4cAEiCjMf1TRIpJeHly
	 m7mK/3rt/VRyw==
Message-ID: <84e0fcd3-7d54-4c40-97d3-86cc94293d8e@kernel.org>
Date: Tue, 27 Jan 2026 15:03:54 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] Introduce the end_syncfs option
To: Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
Cc: fio@vger.kernel.org
References: <20260126061721.270448-1-dlemoal@kernel.org>
 <CAOp=CX=dWPmgjKhZFK8BDKA57qyYJKCJkYBKYOLynU1n6bi=ug@mail.gmail.com>
 <83b16ae2-4a7f-4165-8c8f-adbde7e581d5@kernel.org>
 <CAOp=CXnJ3Sr2ZGDjiAHdPhi4eKfUo-RtJ0h1oF072ew+Xfcy7Q@mail.gmail.com>
 <7ae36bea-e5c4-4626-bad0-a301ba69777c@kernel.org>
 <9468ef0d-a027-4aba-85f8-5b9ed3b2aee8@kernel.dk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <9468ef0d-a027-4aba-85f8-5b9ed3b2aee8@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/27/26 12:59, Jens Axboe wrote:
> On 1/26/26 7:18 PM, Damien Le Moal wrote:
>> On 1/27/26 11:15, Vincent Fu wrote:
>>> On Mon, Jan 26, 2026 at 9:05?PM Damien Le Moal <dlemoal@kernel.org> wrote:
>>>>
>>>> On 1/27/26 10:01, Vincent Fu wrote:
>>>>> On Mon, Jan 26, 2026 at 1:22?AM Damien Le Moal <dlemoal@kernel.org> wrote:
>>>>>>
>>>>> <snip>
>>>>>>                 }
>>>>>> +
>>>>>> +               if (td->o.end_syncfs) {
>>>>>> +                       td_set_runstate(td, TD_FSYNCING);
>>>>>> +
>>>>>> +                       for_each_file(td, f, i) {
>>>>>> +                               if (fio_file_syncfs(td, f))
>>>>>> +                                       log_err("fio: end_syncfs failed\n");
>>>>>> +                               break;
>>>>>
>>>>> This seems like it will break out of the loop after syncfs-ing the first file.
>>>>> Is this intentional or should fio break only if there is an error?
>>>>
>>>> It is intentional and it is the entire point of this patch: doing syncfs for the
>>>> first file will sync the entire FS, so all the other files will be sync-ed as
>>>> well. We thus avoid the entire loop on all files which is extremely slow when
>>>> running with a large number of files. We only need to do syncfs() once for the
>>>> first file. Ideally, we should do it for the directory specified for the files,
>>>> but that is a little more involved as a change.
>>>
>>> Ok thank you for clarifying.
>>> Please emphasize in the documentation that this feature assumes that
>>> all files will reside on the same file system.
>>
>> OK. Will do in v3.
> 
> That seems like a very odd limitation that people will never know about,
> and hence it won't do what they think it does. We stat these files for
> getting the size, right? Then do a sync for each fs. Only doing the
> first is a cop-out imho, and somewhat of a lazy way of doing it.

OK.

> We either sync any fs that has a file that was written, or let's not add
> this feature. That can be done in any number of ways. It's a terrible
> option otherwise.
> 


-- 
Damien Le Moal
Western Digital Research

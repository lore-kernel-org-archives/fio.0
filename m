Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEA42D6E4B
	for <fio@vger.kernel.org>; Tue, 27 Jan 2026 02:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769479541; cv=none; b=L4Rukiqn0Nelg3Dk4vCXlSHilIoczeXV48RKfUHphGjKBoOAGWjIwNvwDT5rgX8TLUYs2GXHldINLJXgQSDQyNErx9XA62mUjxHatx6BGdmEQtmOMegfqkd1DATR1dqW6uaJ7l/7ML81z30ICLRttvwhe6MvmwqJ6+LTOTfNAZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769479541; c=relaxed/simple;
	bh=IzBMc3FTfRf1shwo2W3tYVgVIsyaUBayCgj3NYa29Mc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q11HSWjC/ce/04C54xu1C0y7fSx6pjeY8LY3N02Vp3PjCUokEqK+4m5LJB5mYe8vOKw+5QMc068Yj0W4DAhzVAEKI4esJvB0PMd/DDJK4r4Cs7QwSnKqFogezTn7p7ymo2Ixxoa9skRtoNAJpSW8dwi8Ns0+MWjOWOnlOBex7Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OqPRrkSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OqPRrkSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27BEC19421;
	Tue, 27 Jan 2026 02:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769479541;
	bh=IzBMc3FTfRf1shwo2W3tYVgVIsyaUBayCgj3NYa29Mc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OqPRrkSx6pfDGCVKBL8q8WSuKk7gRwZWwS64orvYDx96n/copbXY2IcCVd3bl2C4c
	 t0SxUSlU5R8YpWcLa9jcTweVu8t3zKYy7G+/NfSRYiSLHaNK0gF6DTk2cAlHDt1HOU
	 T/1iKsZGOt3A6bcL5BrDWQJ22PHG3n5lXL3L5t8Z7OqDI4v1uqD/+bVBhH+2Q1Nk7Y
	 S3yLrP4IhZjjdlv/CfQfP04PMWjKF/4vRIQXgMSf1bY42TL5cgNP7HCTZMmomjpQtA
	 MNYpjVvwT23uX2/AxnQHvbYe+SmhNWC8SQBvGkq9SQpFifNnbhf/U/zyiDQ9L8VqPY
	 8r1/NYdhloZsw==
Message-ID: <83b16ae2-4a7f-4165-8c8f-adbde7e581d5@kernel.org>
Date: Tue, 27 Jan 2026 11:05:34 +0900
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
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <CAOp=CX=dWPmgjKhZFK8BDKA57qyYJKCJkYBKYOLynU1n6bi=ug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/27/26 10:01, Vincent Fu wrote:
> On Mon, Jan 26, 2026 at 1:22 AM Damien Le Moal <dlemoal@kernel.org> wrote:
>>
> <snip>
>>                 }
>> +
>> +               if (td->o.end_syncfs) {
>> +                       td_set_runstate(td, TD_FSYNCING);
>> +
>> +                       for_each_file(td, f, i) {
>> +                               if (fio_file_syncfs(td, f))
>> +                                       log_err("fio: end_syncfs failed\n");
>> +                               break;
> 
> This seems like it will break out of the loop after syncfs-ing the first file.
> Is this intentional or should fio break only if there is an error?

It is intentional and it is the entire point of this patch: doing syncfs for the
first file will sync the entire FS, so all the other files will be sync-ed as
well. We thus avoid the entire loop on all files which is extremely slow when
running with a large number of files. We only need to do syncfs() once for the
first file. Ideally, we should do it for the directory specified for the files,
but that is a little more involved as a change.


-- 
Damien Le Moal
Western Digital Research

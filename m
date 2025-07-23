Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355F02192F4
	for <fio@vger.kernel.org>; Wed, 23 Jul 2025 19:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753298614; cv=none; b=O5rPT7bx1BLe7RjOYGsQSsgJMNbGYG2hoZ6TGWZIPbSsCbTJPEiQkWGZnkEyOY4akG1sXCiaHZg3EjZGvC9v4Aj76EQS78kPJJuMnd00YQidR2rS7JJbcyre3A06iF6WxAN0uFPOvVkSFCOy91v5KhR8eczigl3PXpJV/N3K1E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753298614; c=relaxed/simple;
	bh=sAzrYp6WV93wi0lZEG9UVv2cqHuXVkX0fd0dHBMdGo8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b5EwwV2rqnUt+yQwPQ4ZKyrlxeQzkO/3ofXQQdQTOuPNBBTB8CP5OnkXJnJrho+vxELCNdW0Y8SOyyD/YGlVpBUA3eOWRxK7l28YD7H4N5eCOSwnowFc6SPfBcRp0zngoZKW8C8CI5PvdGkqqhHTK2bONDrcVLhN84F0KPHa5/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=U8PMASSY; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="U8PMASSY"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-8733548c627so7463339f.3
        for <fio@vger.kernel.org>; Wed, 23 Jul 2025 12:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1753298610; x=1753903410; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jYOuVee0gHCi+OBY2NwySqqBfKfi16msT1jiJwyU8+E=;
        b=U8PMASSYdi3YlZaq+jIiIP0HitwY9mXMqLNUT3OU8JI863yzONr+0MNx/uX63w+oRU
         dKp7InRg8rY9H5FWVJowVX9r9MXwKyPWWpcBYSyzah3pE18f/Ia8BkofQwxxIf1ROhd/
         8NZ68HhVf86TJPulmNQPw5yF+fF+qjrRJ0IBo1yp1nIMi/GaPTEoRAzXF6iOk/R4OScr
         gOwb62htDdr+NfZO2WiuXZJW3y5i2yRbBcsCym04TpwcnBSCmaq5i+Y8/T+aTMCPYTTe
         CCfEwh3NFo5b8ZMckrcrQPhcxU4vB+/HHSxuIUujY7yc1cq5dPgM7BqUyHIRQ6HxV1L1
         Lpbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753298610; x=1753903410;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jYOuVee0gHCi+OBY2NwySqqBfKfi16msT1jiJwyU8+E=;
        b=SunN07gVchGRZJqIGER74chywkhv0+XldxHE5zWUn3v4MoK8sWE7CIIkYQj4WtOWz6
         f01b5uI5va+HQVSU5aNY4NIvZG6iWWs5frLWmT1svo32VOOKzFxB8IWXBSgsyIIhUTNO
         MniIALVQgOI31jFVhQRohr5VftsvLKUEoWXIozhvwlsTSPQyZC7XLgheaB7mMaUhn1VG
         d76BsdY2dPA/6wI/IPlyOetyIxoeVwDFN0MAI2Go+XgyDFTKNBTy2yeCjKKjbQuJa0ge
         RqcwKlrrcpXU3b8URVo5pEmpHiRL75I2QIcOUCKPW6Jo7w0nJxkizBcQ2t3HI+sEfOrD
         rRAA==
X-Forwarded-Encrypted: i=1; AJvYcCUFtk+aWxpO3qAvgxq9Dt/CJs3DV+ByCWPSW4IPu6UWI8Xf9+lFSc8gyUVtTHlm6s5QTZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZp0jwK1O9V1Xj62y3prGOr/oukX7qfJ8atLp2uDlhzrtgi0jo
	YtRCeBq2gJqGvoyGdu5cj7svtQpf/EGI7oijJSFFinW/bJEAewATUjtQ0HjiRGAhmmg=
X-Gm-Gg: ASbGncvEttm0ZxMZceG62DkuPbSsqMXeQbx8uWZnWGkZkHAnyVVizllKOxon+8ivSnI
	9xbMFJG1ISY7mPGu+qdD9X8XIbvi5bEFYt4mCcrmdsx3Z5sSFYiSJoqePQyX8oF+t8ET9tuqGni
	jn3gybckMSrsMWBVkCUjkuF73R4RZY5PIa5gh+W+2+4oNsgYZCqWDetdNYlINIQSbn5uFXf2YUy
	a6jiZH6WJcyXu1dXpVuv7FxL2WYVFi0XxTDI5B2iIerw7gnWtHm0B65xKBQ0waGfl/qTGf5ovf/
	wqzNyy+u2QQTvRO9ocwin50dQQE4KFCDONNDc+HWj/QpEDOJ+2VjwpZyAjJ7I4Yxa/UTAcySXd9
	mJsisyme5Q5Y7Asz45g==
X-Google-Smtp-Source: AGHT+IFsefKBotm0KGO67oodnQE9bZ9LrJ1oJbkb+3ZEpj9FOyzqISUctDD8sV4IX3Ed5NhqfK9Jig==
X-Received: by 2002:a05:6e02:2302:b0:3e2:c07d:e984 with SMTP id e9e14a558f8ab-3e32fcc3405mr62364855ab.10.1753298610171;
        Wed, 23 Jul 2025 12:23:30 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5084c7c4facsm3301084173.50.2025.07.23.12.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 12:23:29 -0700 (PDT)
Message-ID: <3493cb8e-5978-4c6b-b9f5-cc565f3dfa3c@kernel.dk>
Date: Wed, 23 Jul 2025 13:23:28 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] engines/io_uring: support r/w with metadata
To: Vincent Fu <vincentfu@gmail.com>, anuj1072538@gmail.com,
 hch@infradead.org, joshi.k@samsung.com, anuj20.g@samsung.com,
 fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
References: <cover.1753282479.git.vincent.fu@samsung.com>
 <67829b031f25595387d7dce10fa0355d85fbebae.1753282479.git.vincent.fu@samsung.com>
 <15cb4581-7067-40fa-9a1b-8883c9993d2c@kernel.dk>
 <e548d5f8-9ebe-46cf-9f43-79be601d2057@kernel.dk>
 <0f56a2e4-81a9-4e4c-9120-b88e9cd1c0c6@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0f56a2e4-81a9-4e4c-9120-b88e9cd1c0c6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/23/25 12:28 PM, Vincent Fu wrote:
> On 7/23/25 1:37 PM, Jens Axboe wrote:
>>>> +    if (!strcmp(td->io_ops->name, "io_uring") && o->md_per_io_size) {
>>>> +        struct nvme_data *data = FILE_ENG_DATA(io_u->file);
>>>> +        struct nvme_cmd_ext_io_opts ext_opts = {0};
>>>> +
>>>> +        if (data->pi_type) {
>>>> +            if (o->pi_act)
>>>> +                ext_opts.io_flags |= NVME_IO_PRINFO_PRACT;
>>>> +
>>>> +            ext_opts.io_flags |= o->prchk;
>>>> +            ext_opts.apptag = o->apptag;
>>>> +            ext_opts.apptag_mask = o->apptag_mask;
>>>> +        }
>>>> +        fio_nvme_generate_guard(io_u, &ext_opts);
>>>> +    }
>>>
>>> Ehh a strcmp() in the hot path?! First of all, that's a big no-no.
>>> Secondly, if this really was required, you'd add something to put that
>>> strcmp() in the slow path and flag it. Lastly, thankfully this should be
>>> much better as:
>>>
>>>     if (td->io_ops == &ioengine_uring ...)
>>>
>>> instead.
>>
>> Eh I guess dynamically loaded engines would need special treatment. I'll
>> take a look. In any case, strcmp() is just too ugly to live, actually
>> quite a few in there and the io_uring engine is the only one that thinks
>> this is necessary.
>>
> 
> Thanks for the feedback. How about doing a strcmp at ioengine init
> time and setting a flag that we can check in the hot path?

You can do that if you want, that'd be fine too. I did io_ops->prep
compare, which is a bit annoying in that it's a double deref to get
there. But at least it's not a strcmp! If you check the repo now, some
cleanups done too, last couple of feature additions to the io_uring
engine have not really been up to snuff imho.

-- 
Jens Axboe

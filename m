Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421B1244673
	for <fio@vger.kernel.org>; Wed, 23 Jul 2025 17:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753292233; cv=none; b=ikHdCRnQjdkElhnTrMK4hfzT601HVVtWW8m75QFwONgiXLhSgvSlubM8cdkmQXUCKbBtLvYmYM/sqA2FBpLqr4Wo8WryojRezKkX4LlAPav2d3fiMeoP9wKX1KzkUdMfhGKp6EpeZiEYFlzF28KmmceTrZkGePiuIiXmaOYGGqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753292233; c=relaxed/simple;
	bh=Zaulz08RaapZ05nywo7XzX8a3qhNIM2UPkTnoniZ6iE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=kr7k1Nvxgf6DF3jJAtT+9xYePg0HvhRmLgb3DORi+XoKxxqzCLdFfBsD97JWQ3Q9NFBKdzMYUqHKD5LMXqLYJVSXwscW9/B37bRrKQdugQ5un088QhNd3b847iyBmWb4f7VYYsG15Br/7Yy1R8LrMLzaXMGo+dfjg9cCT+T6sy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LTcah5gz; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LTcah5gz"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3dc9e7d10bdso414265ab.2
        for <fio@vger.kernel.org>; Wed, 23 Jul 2025 10:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1753292229; x=1753897029; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cFW75KPcZHyA1OK+wTZgydGm3N4jV1LwYoEA32ZOoMk=;
        b=LTcah5gzaN8bq33eCeOUTUgq8EIBhbT3cOxYOHKAISH6q5p68ct9cLBqfS4TE2WJ8I
         pZckrENwfgoM+19qI6pgIAvot4eXlWY5VH43tjjPpZcJ2iOqDjZXDmETgf+il0kKSyYQ
         yMU7lGXIW/YQjl99Z4sGZ7D5WnHYkBsoUmbwjq7bbubxxSg3gDmM/qTkCfXRDthWZNOb
         0MmrnQiSD844nsQ1idpsBB7HtN9fY7ZtwNt4VHNRf+wLPWXKeuW7jeZEg3I+WteCr9/8
         d8IsZkW2x4cPHzr6dFPjpeju0dS1oOtxspQu7bO9XMxOi3eA2cVyLnWK77zXFqQwALZa
         7HLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753292229; x=1753897029;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cFW75KPcZHyA1OK+wTZgydGm3N4jV1LwYoEA32ZOoMk=;
        b=uxI07Z5zpi64TMVNGk3M1ChuxzOuwvKQDH63WGdzlOAu5ve2NfVtHvMQHRT2k/x+C9
         VWHzTnMH4bDIoCLcNfLRnqVu1Baen2AZzHcpWr/w5HRtZ2tK/AtYlxbfE3G2CkEfYIQI
         JctorRCL38FI9h5VD511gkVtH37MeG30ffxsdV+IPQfhnW1jmIBiVjaqr/EJkG4ERKVi
         n40lpE3i9ROQBGyho2bay3bZQE2EJL4dfxSGdo7ALlnpWsc30f7S3wPwxFIgrE2hTZ5a
         Bibs6dQedBPrEWOJHLLC/gvkocqosx1laG0jx1XLKA9at6OR7fphxRtFsLA85+Mzbg1z
         G4CQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeuDBkFnpeoMxRXtXeOcndbAXwouriHxJr7hClZ6HIPPbM2LRmgiE+NQS77JEGlFNbwl4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9PwIci8DV0vmc2rNs4QnqY9SE5wmrmevsxeqLKQ1cum9lj8KT
	U0eHsbO/WDPRhvSMueofcNv1pVFpqguJZ2OYdLxBMHgavRzJFxZyf1PmzBboMP/6hSg=
X-Gm-Gg: ASbGncvsD9CvbtNzgJJ0JYd8Z15+6EG345UepJROrK5v+gmVkO2uN2N/zMMuzSpQ9T0
	ILahLmQbL//PbG7rDAiQzhgOvZNmTbxD0rgzfl0585nlZa5yJeyMW2SDc+WSLMjokU7R5gSZDsB
	lWFv59BetRf00ssOmciU8KUEVbbyoRWAZ9jfMgy5W3ad72T0s4uWb042hGGhWj0DEKfztiMXUJ9
	gTt2Fzr2vKjmnrxxU5kK/XBHJhjl3sI1CxfwoXk45EAgyjWpbkhcj6yB1klckyiIRYqfJJ9em8a
	IzhHba3zBuhjIylbGfj0xkt8MoRdL42F2OXkefoSzrnm+Pq7FuOnC5uRai2GlngnHiFzIqytZg8
	eUp8OQ05FlDBJLk5yIA==
X-Google-Smtp-Source: AGHT+IGMqQ648y8CBYSuKGX3KwTWVhUQxy/HeLVLxAg0PUKr8i9QP6gPyRJ51im9RR+pj3lTLD7frA==
X-Received: by 2002:a05:6e02:12c9:b0:3dc:804b:2e74 with SMTP id e9e14a558f8ab-3e3355c9439mr63784655ab.19.1753292227162;
        Wed, 23 Jul 2025 10:37:07 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5084c8042f4sm3245821173.57.2025.07.23.10.37.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 10:37:06 -0700 (PDT)
Message-ID: <e548d5f8-9ebe-46cf-9f43-79be601d2057@kernel.dk>
Date: Wed, 23 Jul 2025 11:37:05 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] engines/io_uring: support r/w with metadata
From: Jens Axboe <axboe@kernel.dk>
To: Vincent Fu <vincentfu@gmail.com>, anuj1072538@gmail.com,
 hch@infradead.org, joshi.k@samsung.com, anuj20.g@samsung.com,
 fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
References: <cover.1753282479.git.vincent.fu@samsung.com>
 <67829b031f25595387d7dce10fa0355d85fbebae.1753282479.git.vincent.fu@samsung.com>
 <15cb4581-7067-40fa-9a1b-8883c9993d2c@kernel.dk>
Content-Language: en-US
In-Reply-To: <15cb4581-7067-40fa-9a1b-8883c9993d2c@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

>> +	if (!strcmp(td->io_ops->name, "io_uring") && o->md_per_io_size) {
>> +		struct nvme_data *data = FILE_ENG_DATA(io_u->file);
>> +		struct nvme_cmd_ext_io_opts ext_opts = {0};
>> +
>> +		if (data->pi_type) {
>> +			if (o->pi_act)
>> +				ext_opts.io_flags |= NVME_IO_PRINFO_PRACT;
>> +
>> +			ext_opts.io_flags |= o->prchk;
>> +			ext_opts.apptag = o->apptag;
>> +			ext_opts.apptag_mask = o->apptag_mask;
>> +		}
>> +		fio_nvme_generate_guard(io_u, &ext_opts);
>> +	}
> 
> Ehh a strcmp() in the hot path?! First of all, that's a big no-no.
> Secondly, if this really was required, you'd add something to put that
> strcmp() in the slow path and flag it. Lastly, thankfully this should be
> much better as:
> 
> 	if (td->io_ops == &ioengine_uring ...)
> 
> instead.

Eh I guess dynamically loaded engines would need special treatment. I'll
take a look. In any case, strcmp() is just too ugly to live, actually
quite a few in there and the io_uring engine is the only one that thinks
this is necessary.

-- 
Jens Axboe

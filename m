Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24211E7C38
	for <fio@vger.kernel.org>; Wed, 23 Jul 2025 18:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753295337; cv=none; b=vB55MlG47AhT8cs/Ajs3Hd9ZumKjGGTbH5CtWmqsB5ZWZqcqpPRKe5NqD41rsuZMXpPjDZn7TuCta5lXjOAfBvNijQUxG+d36TepVtKX70zYrmcVlQkUikgYaVCZjmpi7qZpvkwFhyR+BZQqxAUEBwdP/ru+IxXZnrogHYW+9o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753295337; c=relaxed/simple;
	bh=iQ58LDDXG/dYToXuG381RspuNkdZRc2ZHp8vBEQkV5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KdQse9p/mF9Rc2tXd3R5GEquWt0Q6oMmyDsdmDFkO2yORX0/tIr0eCg4ty3PuAgi7HXwAu/E9BUUAHLybxI5Q34NR1IKch4gAO5Lkfr1aRT/HYDuOv3p+cjbiu6MK1A+sYg+7+tfPe/Mej/EhAWnrKkvo8lPiWnrGccdex+rSN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LamB1qy7; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LamB1qy7"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6fafdd322d3so1565746d6.3
        for <fio@vger.kernel.org>; Wed, 23 Jul 2025 11:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753295335; x=1753900135; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BW0oKeML6vO0nkLBe3DNI2/taW/aRj/LyyXDKqfwzIg=;
        b=LamB1qy7y8dDWn1S8H79f8drXfP2QqaU50ho6vnMSE1ygE4BA6NIeui4I8s9IrTOTT
         +b2+7SEDAkKZXoJvysoZwg8dgzz1fv6kZimlfkQomTIchu7J4FXaEdwZTGAtGj7sEjLY
         LvAbIqCJhc2AXYWcZ6dykbMdv1eI+J9P4CZV0bSPTIkfMvGJ5CdNhHrUij88Rk0DwUsi
         5ymAtrHpHSntzM8JgGS6aRc0HCZR2jXSoCzOiy3FZHRv1Rf0EGLycS1/oTyOgr+1L/st
         vrIGNph5GEdXThaMEpM3hxP7gidKM/p2XO5a+mSrtdxq40NdFi/zBVbqPA/3CXNbNJVE
         M/Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753295335; x=1753900135;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BW0oKeML6vO0nkLBe3DNI2/taW/aRj/LyyXDKqfwzIg=;
        b=qKCN09P5n0ma9NxeZzxkua3ukOsvaar4vBNMQ5rxHhtwkkAm6Hl+hjwvIcFtbSTKD8
         MN4ofGWxxoK9yojROjZwCl08su82OclwY7T2OnczpsAsGoUg/+Mw6Mg247eoDl9rxgSX
         m4SHVtdi4QYbQrCyYQVDrAZlK0i1uj9HlIPAt1U7BuIpww2A1fVrtrW7kTJTnn3+CkpL
         TySbmVNLiZ2kqNTtFtkhbByC6hEaEtwBFFWbjI1tFZAM+y2AQLPAkksOOhpHNc9/aOFf
         HQ9jsoWLKi0j2hJb2yRc3RmqDBlHIHpqurLlBFUsLX/Qgq989ErHXkNfBTqJz3fkwx/Y
         ELFA==
X-Forwarded-Encrypted: i=1; AJvYcCWC5DrKkrT1HvO/9Chkh9eJRxHl8DAj3GZr3crQSR/QkbRlLog6AO1Ul3y0rQ0F+vfDipY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGo1wkWgAj4f3ZPweCNYZrN0phECtWtsSB1am71Clqz85CTUcg
	lyuHflXei7hf/Fi0PTl5EvayoUJ1NseJJdw9IttznYas5Rqu7VOz/prT
X-Gm-Gg: ASbGnctlxx8cJEUiOjQ5U3QBO0P9cB5vVuD0F6laHJaaqDRf2Yg/MJT5pn8en1Ig5G2
	+ii84qTqdRWJoImfHjc/KZf1igQWWbh8hN1l6cWtvwIyWcIjIJLlTEr4siV5CnHU63PN3DIn5+8
	Ea4SWBH7Ge1GnEvz/fe/RnGEoBpD296fS2oLn521LJlEalX1BZGZrbUAPLtWLex10QUmIjdYL1Y
	zzBfPdmpx3CoaKespzPB07BOYAVsC6P9TeXslx4mo5EyIhgo/Xu1CCzKhZ1s8b9y5514mM6Rw5B
	GcfVP9Fwk4USikaDna4wcWhyZ4x94d4zED9y4FYV82JuUKqocKPx6hb6omlyvvZ9vx4FMiN4+Lf
	OysRbg0AXqNCmyWS4yoO9yc5lx82pxLYOj30liU47/2MvYsTKPNf3jvPVcuCLOOKVX309NT8=
X-Google-Smtp-Source: AGHT+IGWwWO3l6BLcZ5dNihiCr8tgeoyEbUFCV/CFux8eLCpt+cdxxayQ7KuWPprPb2Bw3VXbrhiFw==
X-Received: by 2002:a05:6214:2aa7:b0:705:2799:caa6 with SMTP id 6a1803df08f44-70700588ff3mr47793536d6.15.1753295334545;
        Wed, 23 Jul 2025 11:28:54 -0700 (PDT)
Received: from [192.168.1.211] (pool-72-66-106-13.washdc.fios.verizon.net. [72.66.106.13])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7051b8e3ea0sm67131786d6.31.2025.07.23.11.28.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 11:28:53 -0700 (PDT)
Message-ID: <0f56a2e4-81a9-4e4c-9120-b88e9cd1c0c6@gmail.com>
Date: Wed, 23 Jul 2025 14:28:53 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] engines/io_uring: support r/w with metadata
To: Jens Axboe <axboe@kernel.dk>, anuj1072538@gmail.com, hch@infradead.org,
 joshi.k@samsung.com, anuj20.g@samsung.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
References: <cover.1753282479.git.vincent.fu@samsung.com>
 <67829b031f25595387d7dce10fa0355d85fbebae.1753282479.git.vincent.fu@samsung.com>
 <15cb4581-7067-40fa-9a1b-8883c9993d2c@kernel.dk>
 <e548d5f8-9ebe-46cf-9f43-79be601d2057@kernel.dk>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <e548d5f8-9ebe-46cf-9f43-79be601d2057@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/25 1:37 PM, Jens Axboe wrote:
>>> +	if (!strcmp(td->io_ops->name, "io_uring") && o->md_per_io_size) {
>>> +		struct nvme_data *data = FILE_ENG_DATA(io_u->file);
>>> +		struct nvme_cmd_ext_io_opts ext_opts = {0};
>>> +
>>> +		if (data->pi_type) {
>>> +			if (o->pi_act)
>>> +				ext_opts.io_flags |= NVME_IO_PRINFO_PRACT;
>>> +
>>> +			ext_opts.io_flags |= o->prchk;
>>> +			ext_opts.apptag = o->apptag;
>>> +			ext_opts.apptag_mask = o->apptag_mask;
>>> +		}
>>> +		fio_nvme_generate_guard(io_u, &ext_opts);
>>> +	}
>>
>> Ehh a strcmp() in the hot path?! First of all, that's a big no-no.
>> Secondly, if this really was required, you'd add something to put that
>> strcmp() in the slow path and flag it. Lastly, thankfully this should be
>> much better as:
>>
>> 	if (td->io_ops == &ioengine_uring ...)
>>
>> instead.
> 
> Eh I guess dynamically loaded engines would need special treatment. I'll
> take a look. In any case, strcmp() is just too ugly to live, actually
> quite a few in there and the io_uring engine is the only one that thinks
> this is necessary.
> 

Thanks for the feedback. How about doing a strcmp at ioengine init time 
and setting a flag that we can check in the hot path?

Vincent

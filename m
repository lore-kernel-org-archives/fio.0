Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1E91FAC29
	for <fio@vger.kernel.org>; Fri,  4 Oct 2024 19:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728068846; cv=none; b=eRipSl9OTJLO699tRLH6ki2Jm8TliW4q87symWezE8QY7Prq3C89FAPHxI+s963wL8F8umBBjICl2+thWJ/jxdIqkh40MJp0CtKxJ2eelpMJlEc0CmDnMP0fRf6nzICcj1tO9S9ePucG6g1gd4UGNSyPIRXMBjpapaoQwxflCbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728068846; c=relaxed/simple;
	bh=Pqk96e6MIPeZmzCafRGxMopNkjgqYEkTGi27nqudt4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DTf56a+XBe/5R/75zgvz6uDgiCGPdj4MfPTN61zjB52yMuzMxHETmQSyiOa97zPV0FNRc+OlTenJD9btAVoQpXbDV1mNTfYxoZyDgBmnF+Yr2UXWGPhQccf6FC/IhYK1Fl0zZb0LFE+gT5NS0Z4ab9KBaNmp3lmFL+LdlQ8OXPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GMqe0SM2; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GMqe0SM2"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-45826431d4bso17132811cf.0
        for <fio@vger.kernel.org>; Fri, 04 Oct 2024 12:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728068842; x=1728673642; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fQoG49He7qhIiGEONnDGEqtDR/qRk/AQ/ff9jyU1UJE=;
        b=GMqe0SM289r3i8GtwuVjgFfVYndtdJJUabBLoWp8+llnF5zBcw4Qarw4JX3Yct8fPQ
         ACf0xOWXlOB94LZ8TcYq7EsWosm6mVP901Hiyko35d//CppM+2XfJyULbuFBIYwcEjBd
         VvROJ+7C+q332PzPL2kXmPysMYkF4apBaMpY55qxyIPeVpHuCoYVX8jigleZS0MKQs2s
         GwLaIn5LlCgxeLy8XRq8KR61CktavHg7H9RVYVwNC45NQTXpaPCtdbZ12knERWVYOL85
         bvhjjQXKq5QmuzRGkqyUEGQiT8iPkPY65XPLUqaUw21V/485p5cyGwHqb88nVTganGXD
         L8dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728068842; x=1728673642;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fQoG49He7qhIiGEONnDGEqtDR/qRk/AQ/ff9jyU1UJE=;
        b=TqljGl+GzNmnuQ6GMcLqPHM5xuTziPf6HDCCJ4+FqXSM5jIlE8Ob3JqC8n7yitWV9n
         htl/qRjpNpVvsX5gedEgsYDgQ5jHc/7b1qUK5VWBxLHrX5cW13YKRblaioV+br4T19kD
         kFEnkPf2L63hRP2gh9TFZN02ri2XojrqXa+y3vwn8O2wFAETYl+MC1HSE11kWy6X++QL
         LhqPkb+b3CNQTHKGvX54/pTq5tCTV1bDnixRQ7PyaA3r6LTIaKySUKtA8U0/h9LRJP0v
         y6EGK51XO4gM4WaHIRpVuqY1LQpjiSA39X0dy/jEvdi1FRrdbz+IGyDnL2aYXkvirpYi
         3gJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcJEFxaYD3BhotHx5MebEuPvdfqnHMJu2lr6SZFay/iOk7inrcq6ITEDkqgI0e3FVBQUk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3L3ydIS4HZbjqjNrzDzR5jGfNV23c04oHEpZQsVFQf59zLj23
	cA37hIFUSY1A6TCWyDhVGKmKHAHAloOmv+xxA4eauP/IUgnWTcwa
X-Google-Smtp-Source: AGHT+IHTQQ+QfIl1QF9rT33mnTb3hMMZcLsS09bHc+B6TtpbUWCsViYQV4ZXvqE4IgwBIxn+Rw2LUA==
X-Received: by 2002:a05:622a:4cc8:b0:45c:aa3c:33ef with SMTP id d75a77b69052e-45d9ba4e612mr63892561cf.23.1728068842509;
        Fri, 04 Oct 2024 12:07:22 -0700 (PDT)
Received: from [192.168.1.220] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45da75561d5sm1717171cf.50.2024.10.04.12.07.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2024 12:07:21 -0700 (PDT)
Message-ID: <a76b6241-7ac0-4933-8556-b0f36498bfd5@gmail.com>
Date: Fri, 4 Oct 2024 15:07:20 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Question about an fio profile which leads to a CPU lockup
To: Haris Iqbal <haris.iqbal@ionos.com>, fio@vger.kernel.org
References: <CAJpMwygnT=KmzZHxJGUWgg1AJe-UbAP_bP5mN7iCLdtFoYwNdQ@mail.gmail.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <CAJpMwygnT=KmzZHxJGUWgg1AJe-UbAP_bP5mN7iCLdtFoYwNdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/4/24 11:09, Haris Iqbal wrote:
> Hello,
> 
> I am running the following fio profile on an RDMA storage stack with a
> raid5 in the back end, and I see a CPU lockup. (I can provide more
> details about the setup if needed).
> 
> ""
> [global]
> description=Emulation of Storage Server Access Pattern
> bssplit=512/20:1k/16:2k/9:4k/12:8k/19:16k/10:32k/8:64k/4
> fadvise_hint=0
> rw=randrw
> direct=1
> random_distribution=zipf:1.2
> time_based=1
> runtime=60
> ramp_time=1
> ioengine=libaio
> iodepth=128
> iodepth_batch_submit=128
> iodepth_batch_complete_min=1
> iodepth_batch_complete_max=128
> numjobs=1
> group_reporting
> 
> [job1]
> filename=/dev/rnbd0
> ""
> 
> First question I have is, is there wrong with the above profile?
> Next, if I simply change the iodepth_batch_complete_min=0 in the above
> profile, I see no hangup.
> 
> My next step is to reach out to the kernel raid group, but before that
> I wanted to confirm that the fio profile leading to the hangup isn't
> incorrect/illegal or something.
> 
> Regards
> -Haris
> 

There is nothing obviously wrong with your job options. Try running it 
with --debug=io to see what is going on. There will be a lot of output 
since there will be multiple debug messages for each I/O.

Note that, from the documentation, if iodepth_batch_complete_min=0 then 
fio will always check for completed events before queuing more I/O.

Vincent


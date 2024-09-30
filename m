Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645C62AE8E
	for <fio@vger.kernel.org>; Mon, 30 Sep 2024 13:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727702673; cv=none; b=LABSp0FmoIGstcTMN02+Mz6xo7l2HB89O2Kd+g21Rg1QA24Xk5Gs13X2GKeEG84BLOs+PouCUqbLBFtGXCffICR1Vnwn4paW2tdsdY3cp43DtryYg7I3rqQtmoWI9zFYH/2NbnR8dmXSjGSVHR7YT09YCuXgXNrH4K1DcVbxn+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727702673; c=relaxed/simple;
	bh=PRCxB+toTX6rSc3snyR/KV4aWFbpbQSJoRNqQz7bATE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ndPG8ZtwxyEzwKtjJjgmm/VEqLKtEoh8f/YgTUu1NgB/ecrLm5CqdbFJO3PChHBzf1Df5EVvpYi2R1ElS/a0qh094UjfNXkcLLwgBIHmj+0HcPxfatrsBHBey9q7O5t2m85nMsy32pxXbHPpkx1jRqqjsTIrjQYDWPGs76IcgdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eokuvdwr; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eokuvdwr"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7a99eee4a5bso391696085a.0
        for <fio@vger.kernel.org>; Mon, 30 Sep 2024 06:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727702671; x=1728307471; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4g6CvIcATAMJsilyRi434Fvd/oJtARz+WRmcXnDjo8A=;
        b=EokuvdwrRSIHkduU1DjrGwij0MOT/5MxN7gHicU6A82YbwuvP5BVeP6hNI/Gv3Ltje
         B0YI20z3pId42EKFLibroOzq5uuKbUlO2qlcG0uAC3ZpRkCrmjAlHlk0w/eHoGBBuaw5
         ropUTGXkmzfgh0UKry9oEtb1B4M2Pf4YWeZBKUSKgPqqcjtONjX32yPFPAoNsliZk/pu
         pJFm5869Un2YPnHyXAs3ZCseMd+onbKSzSA5gC7Z8czr7VRkzCbix2xCtbZH94k1AXwG
         rKJLD9JOP17zjx9LkXDRrXUpRvJmFCbnuxSLYwzv/TftH3F1B9l6dbk3IuSQm7fScF4M
         BdJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727702671; x=1728307471;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4g6CvIcATAMJsilyRi434Fvd/oJtARz+WRmcXnDjo8A=;
        b=l/avrV3rxLPztrh1U7hnewC9g03nAXsMItA4aeOzzYEZ/V7wSk1WgzckYxPE5EvEU7
         pV6zlX9tuD+GYUM2F+TTTfwR0qvvoE7vMeQL/dd0g/0xAOeTxaCs+W7KQWz0amdBKeSy
         qDHmhohvobn3bnxNMNePIPiryMwRu2yw4rZYxD+9RYlK4D78BHGo1gZUPQScgujK5Ica
         1OR09vgmsWfD6A6O5L0ma8FdmNsMzAZtJxLyg9jQu1LEnp6ZHxR/Q3cTidJbVwVt2vn6
         PYCsvH1euZsUnIUFCE3euwCc9LzDWshZe53rzv7yM7HVmlhhYnK9CzHwUqLCNeX2QrER
         xjtg==
X-Forwarded-Encrypted: i=1; AJvYcCVijQbdzVefw5ugFEjz9VgctkiQK1FYhr25uav7WB1lHAyoNqEcgp8LAcMWirbJkQMdX5A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLtkPszTraUU/AQ6zo2AY0bzlYJU69mFtUIpJONX01GlUfwj/e
	aWzumkVi/Pobk5rscc99r3irQECPO9/KV23lyBZFDnYydTn65VCT
X-Google-Smtp-Source: AGHT+IFxOA4qXo4SwEM0B/vD954oenuzH+1IJ5HiX+VFcauR/Q9JuZGmYH1fGVYut/zpvx58iXeKUQ==
X-Received: by 2002:a05:620a:469f:b0:79f:15ca:b786 with SMTP id af79cd13be357-7ae37838ce3mr1810428385a.16.1727702671133;
        Mon, 30 Sep 2024 06:24:31 -0700 (PDT)
Received: from [192.168.1.220] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae3783d4b5sm412382485a.100.2024.09.30.06.24.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2024 06:24:29 -0700 (PDT)
Message-ID: <35346198-6484-4f6a-85a7-1009e57eb45c@gmail.com>
Date: Mon, 30 Sep 2024 09:24:28 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [General question] on iodepth Combined with numjobs
To: Jigao Luo <jigao.luo@outlook.com>, fio@vger.kernel.org
References: <GV1P195MB205577C20DA7B1A65782397AEE762@GV1P195MB2055.EURP195.PROD.OUTLOOK.COM>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <GV1P195MB205577C20DA7B1A65782397AEE762@GV1P195MB2055.EURP195.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/24 04:05, Jigao Luo wrote:
> Hi everyone,
> 
> I have a quick question to confirm the behavior of *iodepth* when 
> combined with *numjobs* in FIO. Based on the FIO script below, is the 
> iodepth set to 256 for the device /dev/nvme0n1?
>  From my understanding, iodepth value is set to 128 for each numjobs, 
> and since there are 2 numjobs for this device, the total depth would be 
> 128 * 2 = 256 for /dev/nvme0n1. Is this interpretation correct?
> 
> Thanks
> 
> 
> [global]
> ioengine=io_uring
> thread=1
> direct=1
> percentile_list=50:90:99:99.5:99.9:99.99:99.999
> group_reporting=1
> norandommap=1
> rw=randread
> bs=4k
> time_based=1
> runtime=20
> 
> [filename0]
> filename=Nvme0n1
> iodepth=128
> numjobs=2
> cpus_allowed=18,19
> numa_mem_policy=prefer:1
> 
> 

Yes, that's right. numjobs creates the specified number of jobs each 
with the same set of options. So you will have two jobs each with an 
iodepth of 128.

Vincent

Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E1213E02A
	for <fio@vger.kernel.org>; Thu, 24 Apr 2025 14:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745503289; cv=none; b=iu+Jhgkgb5jjRO4lsohc1DF5rZQ93koOGO+Fs6J4ak4TaUW48aZLuhPgLypQywy4AFn37WfDm1l7o5On7D0yyBKtu+1xPtLE6s0mWYiWiiqykuv99IH7ofRHlHpm9qooqOXZoQNAIQi4A8JkOWJaGo8hnCtkdvj7ASySG5Sh1bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745503289; c=relaxed/simple;
	bh=hLtipk3GquP6WkdGAQDeYVji5tUNLJDqZ4UtIEZWsQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GyOrP0nRdHQeEUgjLM4u8O8F8nLz/WtPo8cZSQWwoOZEudrqy4mIQ4oW6Zf1gVS8TkwTnD+F48n0pNmNhgqmLrqfPY4AozxYOaCcB+UODb7HeLMOD3ZbBe0Q4e36oHwNtLQb3PZWjqG7yjn4a+nOqPsZjnpkryOePXXmPgiW22s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OGI6MEqt; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OGI6MEqt"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6e8ff1b051dso1849926d6.1
        for <fio@vger.kernel.org>; Thu, 24 Apr 2025 07:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745503286; x=1746108086; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RGAUb5Wjph+cDHFjYucndb+YJnTEUeAlmmroId3bFDY=;
        b=OGI6MEqtvcMvdXuVLpXse1EA/M0ZTqLGRt+gt9OGRah4Z0EESZWi7Ag61P5vb4L6y0
         4rkKcR5hwr7o0aFPVEodyk6SFSW16oY3c4wIIZk9kT/QOM08Fv4gU1b9Oq669q34JGj4
         VJRYf92W12pjvJCfQ9TNBhqlDGkv7/13hgUlO6WmEqkzCl4kl/tPsh7o45SRZOEIIZum
         cMafA3RPQ4qPsIRG16FNTCfhxxo2W6CRPLIVJEs7MjGIAZp+4yoWBdoVuFuqE+CHYUgu
         lhBxJONvIyLY1nRS/0j1Ob5Rq0bcM735R7i5ZNuYh6yfdg7SRk1wqDvojN1nOM4Zu9rn
         bP0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745503286; x=1746108086;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RGAUb5Wjph+cDHFjYucndb+YJnTEUeAlmmroId3bFDY=;
        b=uWPKWn1sU9/kJb8smkONi/5oJEXxfrYt7zhOIgVR2aVPzbtdjyhuf6zARIZnRN5GyF
         7IFoKUNFepyf7sT7THyRCZMa9K3F6bn4Qmx7rXgjaUUFu7aD9bdF/Sjv+FBCwsuVt51k
         umpAeBf6VeJ5i0iVQM2pYQvik0JAGR46DNmDL9uW1UsOAPwtW/7/HwePTHx7XmdlNhIg
         gdSmqfEEsk4W5vdWzb/YKA7ytUFNRc9NdiROaOusZSGNE/ZOtgkbbK0KbueH5ql5teXU
         On5aoa1M3cvnPZw0DBZFmUqUiTnc+HlpMbDbSWXCFeVP5sbiGRp4lXYtne8Y81QFg85d
         MGnA==
X-Forwarded-Encrypted: i=1; AJvYcCXNAH7AssMTt+jxdNkU8SnewLKdiRQ2RHv5YJ17Y4e0suwl439L/Oj4hdWsbvlB5sZukBY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcHWdvIOUnL7583npqu4sab3IjtP3iVYewrk01jz4yrwyVAJmb
	AghhmTWAe1aBKVHzx7TfSnPjfkSb2hliy99PxyB/Q8pVomGLj0dk
X-Gm-Gg: ASbGncs6+EAyz2cMqcxyHYVFpCrzVxvKwhvJQOlTTX0zvrr31RiKsr55uKEKy+q/Bha
	d85HFULofmHzfrc3vci+8Aad/lvZvt9hmqSy95ZxVfdrnrIdk89o9rqA5ptWPVRWORzBT1JQ6s5
	gCwTj+Y2Mp9pyE4Zol9AG9LuPF3QqclSkzPB6rF8KWidRcq36UZZmDNfBj14Lfa0jPsy5qE9hDa
	YLOjlP6sKs+60LTda/j5uEribdQ4anoHajLPOvYDb/hSkz0lWqlPH83Xv+esu3zPjqUu4SRgLRv
	mFmWBOg1WpqqosiJYyVEig3gFYrNQttBtoGVeuJNx1IoQcso7+IVlDrmJaoTu06vy5KqZ1C0Yfk
	mXgzvUDwV/AUkCEp3
X-Google-Smtp-Source: AGHT+IF0YOgMHfoKQPNEj6SnS7qlYFPEteSZV05WU4Iv71BPVCzTA+qlNT0CFM8v7B6O47XAVlBlfA==
X-Received: by 2002:ad4:4ea1:0:b0:6f0:e2d4:226e with SMTP id 6a1803df08f44-6f4bffd8122mr14947756d6.8.1745503286140;
        Thu, 24 Apr 2025 07:01:26 -0700 (PDT)
Received: from [192.168.1.201] (pool-108-48-176-137.washdc.fios.verizon.net. [108.48.176.137])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f4c0968ed0sm9734966d6.67.2025.04.24.07.01.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 07:01:25 -0700 (PDT)
Message-ID: <ce3a5fb5-ed48-b751-4de7-cf72aae5df49@gmail.com>
Date: Thu, 24 Apr 2025 10:01:24 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [BUG] active zones exceeded error with max_open_zones
Content-Language: en-US
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org"
 <fio@vger.kernel.org>, Damien Le Moal <dlemoal@kernel.org>
References: <2b55d2f4-a093-d944-3d36-6efb5fb271ef@gmail.com>
 <ptncklg56axp5463pdaadt5a3xxepeu4vnnl3qqtg3k2elpsmj@lcl7boaxswn5>
From: Sean Anderson <seanga2@gmail.com>
In-Reply-To: <ptncklg56axp5463pdaadt5a3xxepeu4vnnl3qqtg3k2elpsmj@lcl7boaxswn5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/25 02:13, Shinichiro Kawasaki wrote:
> On Apr 23, 2025 / 13:11, Sean Anderson wrote:
>> Hi,
>>
>> I'm getting an "active zones exceeded" error when running fio with
>> --rw=randwrite mode:
>>
>> # fio --bs=4k --rw=randwrite --norandommap --fsync=1 --number_ios=16384 --name=flushes --direct=1 --zonemode=zbd --max_open_zones=1978 --filename=/dev/my_zone_dev
>> flushes: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
> 
> Hi,
> 
> The block size is 4k. And according to the blkzone report, it looks like the gap
> between the zone size and zone capacity is 512b. So, I guess the fio can not
> fill the gap by 4k writes. It looks likely this unalignment between the gap and
> the block size left unwritten small remainders in many zones, then many zones
> are kept open and the device exceeded the max active zone limit. Based on this
> guess, I suggest to try with 512 byte block size to align it with the gap.

Same issue. And fio seems to be capable of working with the gap in --rw=write mode.

>> fio-3.39
> 
> Recently, I contributed a fix which handles the case many small remainders are
> left by random write workload to zoned block devices [1]. The fix was upstreamed
> after the fio version 3.39. I also suggest to try out the latest fio code with
> 4k blocksize.
> 
> [1] https://github.com/axboe/fio/commit/e2e29bf6f8300186d267fa46a7b266d14d174575

Yeah, I saw that, but it didn't appear to be related to this issue. I will try it
out tonight.

--Sean

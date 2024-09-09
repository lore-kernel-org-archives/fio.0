Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5163F18C31
	for <fio@vger.kernel.org>; Mon,  9 Sep 2024 19:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725911309; cv=none; b=EAxfPbF31/SQS/Qm8JqPXQg+dxUpg/636o8Q3ZNe8sTzKITsFwD6I6aTJdwYb2yrXhT700LZqjaJDuhjaUHaTBLy6r4SbezFUqy9Jamx9FUpNV3+KY/apEZ9bkrTOCEHoLXh7oyLHPb99crQsdAefOp19Bxzq0NPuIqpC35rRVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725911309; c=relaxed/simple;
	bh=2XXUnHtmV+hE9ouLZX04BGtHk/Lx5BejJ5NbSUROrUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NmX6x2KqkdlM5+0I8Xzobud374HgmhMPADC2lLBDzrYwThyaDXWycV+cHR90XdAcP3iAWNkaT8bRar4qcLYbvaP5ta1i7cUfZK4CXNoblPp5S5obeVXrC/dXl1xzuDaMpcp9I7vMNkm0qSXMZbS4qirC8/FiZbsl/7Sdxyy/ytM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=j43UQOdF; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="j43UQOdF"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-6e7b121be30so3036954a12.1
        for <fio@vger.kernel.org>; Mon, 09 Sep 2024 12:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725911305; x=1726516105; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CLbnCCclseSAQr9yZZ8roThrDj7pYlrqmy+Zc6zZF7E=;
        b=j43UQOdF94DhzQ19K4T9RWy6nshihAThAO6fsx5LrddqQYJsLtDZkPZaJikuLxncn9
         FBmxYYA3CGVkiXjdXRtDtktDs2aZiCUn0DRj26tvBPrrwx6i2VTCCrr2zIY9FcfHo7dH
         GGaxGuDpcbP39woMMIIu9O+2k+9b3iuIJuXJFIMhU/6zby44Vn6zLYKfSD9S1tq2AErB
         ewhR+jRVuk/ysIFxvpR4mF6hOh3r7+8gpOscBWBSK4wgGr1MHyrgl+Dxw8gKd/4S1GlQ
         59Gb/0tm/NF5LZD+S/0CtjL+F2QIgZROBTYpGe1jU0aPgVUE+Yv7E0hszZGGO8Jca0gM
         y5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725911305; x=1726516105;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CLbnCCclseSAQr9yZZ8roThrDj7pYlrqmy+Zc6zZF7E=;
        b=JkF0ZaxpD0TNq/zQr7qR77/Pbgt5tRoYOHdbr9ZjhixEfoov7Xoizoc197jrLuSeyo
         JxF87uT8AqbXb5Yrg1TkuXFRNC068VZtbh9dKEb0Tfqwyt1Dd9V2Uzg1mZmyJjndUxNg
         WJJICgEZ3BLk7oZpLuaY34JPDWpDx0ZeS9T2W77aDspt58RxlRH3t/La7D/7BlA4cVLK
         oiMSG5XU93U5e+zsp5Vb1BtYVMiWeKI6R0SM/6WrKzcbPF84cQRn/w+J30TcJXyceZZV
         JrwiSOQdpVfR2KgH5OvOOr+5RldAN7g7WGwcTiM4Z7K+erAhCLJI4GvGTVqmyfTZYc1l
         w83A==
X-Gm-Message-State: AOJu0YyPfqcutABW2fAAinxs9mYnk+iAFY77tyNRFdRgoxpZZVyiaU1U
	38TZvaAbQGu8lTb1bOQMlQDTmTPVk2BSzKL9y3Sdr7olaiCYzjLZ5rozV57dfl9fEQh1CBPLgLd
	N
X-Google-Smtp-Source: AGHT+IHMW2cYMfhsNzm8l5R25MeqccTL/TRT2qKtesD6mKxudRfg4P3Uw/OQD51zouTqHJYvBpeb8Q==
X-Received: by 2002:a05:6a20:b40a:b0:1cf:506a:cdd8 with SMTP id adf61e73a8af0-1cf506ad337mr702750637.12.1725911305216;
        Mon, 09 Sep 2024 12:48:25 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d823736c8esm3709751a12.8.2024.09.09.12.48.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 12:48:24 -0700 (PDT)
Message-ID: <8e15be46-75af-4d3e-ac75-8c38ec179b0c@kernel.dk>
Date: Mon, 9 Sep 2024 13:48:23 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] fio: atomic write support
To: John Garry <john.g.garry@oracle.com>, Luis Chamberlain
 <mcgrof@kernel.org>, Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org, martin.petersen@oracle.com, djwong@kernel.org,
 Pankaj Raghav <p.raghav@samsung.com>, Daniel Gomez <da.gomez@samsung.com>,
 Dan Helmick <dan.helmick@samsung.com>
References: <20240829123107.520005-1-john.g.garry@oracle.com>
 <Ztl72OINsWHeq4pz@bombadil.infradead.org>
 <316ec2a1-52f8-49e5-9645-f93f3e7c5383@oracle.com>
 <ZtuQVTC4MwdzRDsy@bombadil.infradead.org>
 <76e0cf08-e0ac-4443-b107-86e7d2e4c23d@oracle.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <76e0cf08-e0ac-4443-b107-86e7d2e4c23d@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/9/24 2:12 AM, John Garry wrote:
> On 07/09/2024 00:29, Luis Chamberlain wrote:
>> On Fri, Sep 06, 2024 at 04:22:24PM +0100, John Garry wrote:
>>> However, if we have multiple jobs, they may overwrite blocks from other jobs
>>> - fio warns us about that. As such, in verify mode, the read sequence number
>>> may not match was we were expecting with multiple jobs running.
>> Is that a generic bug in fio?
> 
> I wouldn't say so. That is just how the verify mode works.

It is, and it's quite possible to craft a job that won't verify (even
though fio warns you about it, as you said). If you have separate IO
threads stomping on each others writes, it won't verify. That's mostly a
"doctor it hurts when I..." situation.

FWIW, Luis, your email gets marked as spam. I think you need to check
settings. I only see John's replies.

-- 
Jens Axboe

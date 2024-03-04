Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F33C1756D
	for <fio@vger.kernel.org>; Mon,  4 Mar 2024 16:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709570446; cv=none; b=RNGKl/yzAFbv2dosyEpkVwX04gp/0Aoode0Nd8Ls4UFKkzeL5Y1++CIrNLjWwppWkN6F6Sv5UzoiR2veqYQU7D5CfQr9Eiuleuvbp5TIgxsU9MiDl/CQBY6T0FucTqKSu9LfvR3AtrcRXAUN4QNGvOGW0RjevAdgOpcxqBIB8Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709570446; c=relaxed/simple;
	bh=sdeOGus54inqL/MZRgQnMSeM6IF/3ldw4/oX15M5X5E=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=H2p0FlpZ2+4TEgupMC+SLPSnTunSBQvuJINIAmluqBQosgHkZvztkBmKW/hH7kRgvQWWl/pimxAmiMFSAzZw3G0KH1Qo0CD1q87C198urEXxYVEf2yz+6stgHPxIksw5Sze6Hwqn223yOI1o+llHMl8lrwHpyv2WYKvDJ2E6qBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QXRt2eRa; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QXRt2eRa"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7872614af89so435770685a.0
        for <fio@vger.kernel.org>; Mon, 04 Mar 2024 08:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709570444; x=1710175244; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HJAAD9OsSt8JATJ5y0kBHOG2r+3fMyQds8PfZClFy00=;
        b=QXRt2eRa40LXAOrs4M3h0jsSQww9gkCxy929W/4fnl4c2TOR0KoOfYXj6kkCuOLD+S
         k/y5nFFzrytdgul0lMjZKfp6ZPWiCq2KPyeRdy2CzeMIDV0BEF4uV8JNZcq0xC+ylIaj
         oyjGWNYIGWIr+wJ57BlZHq5L9JMJdU9R0hGDgDv4VMXEsc/rnaspFcaMVF7l00wIWEdU
         lYz9baJS7ni7e0RPSe4ZUyC0J83bdp0WrIwQz2/PkK0XBpsd2kPDxFYE1Yw1jdiAzXh0
         fMMgBxGDfq7XdHkK8P5ndgzfayImVPLmn4QX6j/1sYSNYQMHL6cZN+NQXAJfFUaBCcNz
         LtXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709570444; x=1710175244;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HJAAD9OsSt8JATJ5y0kBHOG2r+3fMyQds8PfZClFy00=;
        b=ZbYvJFiqUVbL7hZYFd0UJhf4EFGINaDMzKWawKRhk/mjYqhsXAdpcIBJ6L1uv7WA/6
         D3srDCt17MqK+DG+vmI/AjIFFGBNpU2ZCNWHMeeTLdadQCfx+/0hUYt1OMgiil9DzvNz
         +nhxM30rfcvaqX5mbAfO0FNlm8nc6Su2e5N1iP+71Um+f0KE0NS4shNtG/xo+FcoBAyB
         +GBnhumE4KMapQWtd/xk0JZ5c6RYFfHxcSS3Q8TJkhg11U8icqx5byT6nMaMHFrjGU2L
         gHJdN3V0Xf56Qb0ou2X8mZ+Qqwzp81I9YTpN782j9ry7Y6yvewqU87LX1WzVUYa8nKzP
         f77Q==
X-Gm-Message-State: AOJu0YyXpZ2Pp3Z7N/5XVHTB2ojnajd+rp6P9bbBt8eR4hi2+cKTp7rd
	XLpNqW/GGgwnV4h19us47KNE1knYRyMuUtMP14OSMDqlBv4LYB+/x72dbFNP
X-Google-Smtp-Source: AGHT+IEUcd59050I2PkShk5sne7MFd+JuvMc5tyHM19dVpKzHiqcBPoSKtab0mqvjLxsvwGOAht3vw==
X-Received: by 2002:a05:620a:2191:b0:788:3182:729e with SMTP id g17-20020a05620a219100b007883182729emr28098qka.1.1709570443685;
        Mon, 04 Mar 2024 08:40:43 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id cx25-20020a05620a51d900b00787ace473c0sm4524357qkb.16.2024.03.04.08.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 08:40:43 -0800 (PST)
Message-ID: <37977212-6208-43df-899d-a9b854c6e262@gmail.com>
Date: Mon, 4 Mar 2024 11:40:42 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vincent Fu <vincentfu@gmail.com>
Subject: Blog post: Testing on a big endian system
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: gost.dev@samsung.com, gmascellani@codeweavers.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I'm pleased to share a blog post about how I was able to test a fio bug 
fix on an exotic (to me) computer architecture. Giovanni Mascellani's 
Debian Quick Image Baker helped me test the fix on a big endian system.

Take a look:

https://github.com/vincentkfu/fio-blog/wiki/Testing-on-a-big-endian-platform

Comments, corrections, etc are welcome!

Vincent

Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5551B1C5CC6
	for <fio@vger.kernel.org>; Mon,  9 Dec 2024 15:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733759102; cv=none; b=FLg3mEoJsmYylJUcOaW0mvcCM7y8igoL8BgkghGTv3wA4h5RZ1WMrszrnis1wKsaGv/elUX0cKIE3XuDhk7le7wrN5n1AaLqDL3mFU2FvcTikjftor07nyZZ4A82e2fFoAYp23EAHZRHVnzhBW+H+8ruEKzn5Im/AhlebeOiFHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733759102; c=relaxed/simple;
	bh=PzPr7O16rNwKWQ1J9qfBC2Y4+wYJ/uGwQUMMmRlecvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=m+6vrLoWGoui/CGAktNqwnZh1pcTQ1lnjR6YrkUtz1bt4KuTLP9/v17kDkA6h6ngdeD7fwmgTcxvogIstmj2S0rGGdvolN0mA6FBhodAXUXXzNvRAlhUtWzkvUyUhT5WtsjZyeJoLCnnGArqtOCjHva3UB8h8yF2uMBWolANcnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DCFdz68c; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DCFdz68c"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6d8a3e99e32so35906466d6.2
        for <fio@vger.kernel.org>; Mon, 09 Dec 2024 07:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733759100; x=1734363900; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LGfPkqNZzVo4c+zWLCi5nSrZWsvZ0iSs7Au59hhvWMI=;
        b=DCFdz68cuE7f/plcoPHw8Ce39PkgTcOsEFCHt5KFeE1vpSacrNq4RmZetfVNqGIwJ6
         HfB0Lisi3+BiKdHwjklbp5fDXzlOWjtwYPTab/3t15P2VMp/EMyGLOpU0TnbpsQuwiDL
         pCGOg0UfmuRRq2NSq4FKq7BjMCrQa4L2woamTd9pR0hcoAJe9EQ4vnGg59PN44MNu1/2
         PgU+1AQ8zzbq7nWpzfiozfhSOZtNY0A+7CAnugRAKwGYz4zRufAD2wnE+t1JJGWm7+7n
         +p/T8+RwcKBq3SP3P94/ADTQor52P2DVso+k5rOvfGWnoza6gNVhicCRpF1/01o5pa9p
         xIFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733759100; x=1734363900;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LGfPkqNZzVo4c+zWLCi5nSrZWsvZ0iSs7Au59hhvWMI=;
        b=AcwrckWufCtMv4Lf94VMBM0+WGmQqz3BRMJg+Md6R+LvPqHgOBi48Ey/OQTcvzd1pj
         vWW7sZgZkcsBISh24lDFPVbGwvgFSILMXdE4PVxBjkVgbaaZtipLlneieiPbv5bdYFM+
         41E9MUQdsvHaGwr6wHxCBbxq6X0Se7GtMFFMf/RLj4IqZPCxagJogZbQbMOf9Hlc0msr
         FXs2bnwM158xWIObDVeLti+bpyIKvqE+nXlXwL3Emx8F+zO2sYs++x1biLfofvm81+U2
         Qa3l+IFfcDtpGyhBZkCplVAagp+7TYSwnrHcwCoC2KTb3jEKgG8gL27hnw8kjE6GcaqQ
         FN4g==
X-Forwarded-Encrypted: i=1; AJvYcCVrh4c4Mp18150PxmyMMKpwL/HZG+48QFLTN6dIXkvijDPY/VAPvNoAjNyALZ7BcNd+oMA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx0iB1FQRG9AaX64osKGJTpJ6Bkpztl1yuu7NlkS0AlacZEiVc
	hlVWyRZ3XLw99GmsuAn8ECEr0FjHpwXia9dTPBv6WUnCTgUkHL8g
X-Gm-Gg: ASbGncubvgbe+HUxz1zzZvnUk9scFzTJJFdYvUlbVEeFNA28rXNEV5J1CpU/9q0L0F/
	2F6XRSaTvWycSIZfkydTgMTivAF4eV6ROthA249EN9i8u/W4lVcxIfFxLKldjtdYz9vFCfAICZA
	zYeGPpFsRfNG+lkoetxsdIY9VzYS13rSLpTorZGZis88CcHsI2U/5wduRxHmvycXyfl/1MXLFCZ
	Y+yItwjBG96c3BaNnK9Ah/BDhKlyk81TFH5faiCGLmxFnqYAH6ezdVs/Ib2apKpBJEPAPFb55aN
	so0Uhom2XsEzcw7NIXIu5yBCUw==
X-Google-Smtp-Source: AGHT+IF9UcRNNfdhEbc+fdmyuGsW/7q0zGADmTaIrt5NJTQqwlMD3g5msBKgxgmxYIFTXyh52wxDeA==
X-Received: by 2002:a05:6214:301e:b0:6d8:9c92:654a with SMTP id 6a1803df08f44-6d91e341b7emr18521576d6.10.1733759100059;
        Mon, 09 Dec 2024 07:45:00 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d8fa317ed0sm26624396d6.46.2024.12.09.07.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2024 07:44:59 -0800 (PST)
Message-ID: <bc7d9d9f-7b47-46ae-a06b-ad298125a0e3@gmail.com>
Date: Mon, 9 Dec 2024 10:44:58 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nfs: add support for new libnfs API
To: Ronnie Sahlberg <ronniesahlberg@gmail.com>, fio@vger.kernel.org
References: <20241209054758.3269700-1-ronniesahlberg@gmail.com>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20241209054758.3269700-1-ronniesahlberg@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/9/24 00:47, Ronnie Sahlberg wrote:
> New update of libnfs will have a new API that changes some signatures,
> primarily in order to make nfs_[p]read[_async] calls
> zero-copy in the sense that (almost) no data copy is done in the library
> and READ3/READ4 payloads are read straigth from the socket into the
> application buffer.
> 
> In-library zero-copy only works for !krb5 and !tls sessions but can provide
> significant boost for read-intensive workloads when can be used.
> 
> Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> ---

Applied. Thanks.

Vincent


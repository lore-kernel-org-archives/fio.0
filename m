Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DF73C8C5E
	for <fio@vger.kernel.org>; Thu, 17 Sep 2026 20:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789676981; cv=none; b=eydPEgxOM2PEwNgQjQyaZFPO8iBMHN0WCuqkejtzOBu3+BGDVUICInvMJTBikP2D94jt+PDxr40JGDTSAf6lihoitTOwZS5B10Ax+BvxbLr0JywE8YhBZ0KbvMEEVbqXf4ruc2d0OPJalu6Gy3oxCS3emF9Dgz6NFj+G3DkwEK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789676981; c=relaxed/simple;
	bh=bHkarcTCjSLWh5UZzax3zfdk1G6agbZSXm8L5O3Zb8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Vi4Vc/eJtSZE4YK+xZbDr3dWz1zeP0QhERcw1huAJG9N3zhGEFC9gvQvNflh0tQMFMncEthiox4Mjuv7NrWxCyFCIg/pPcfVc9RIwmq8Y0pDakwYjlQS4R6v/52DON1o+OspAkxHPDcHp9lvaj0tAGY4Ea9cQIAJcCqqCHHP0gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LIladiss; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ry+5+Oc2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LIladiss";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ry+5+Oc2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789676978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OnFmQViMmju8cIDyu/sH9LtpWUp0JNOUztHTGTsxU1g=;
	b=LIladissXg+trV95Laz5hKQ8tnh9T0iHmrZcyTH0bxXntedK7s07vXeJ4VUvuMKqlII+m5
	+4CxnR21pvrqbkOcBcVShhSoUuF7Nn9cH1VXcE6v57u8253JDNwQYvGC/nNLJf+HYgw6RE
	ELH9MTmzuVskV2VxpfxiEkf1djtAipA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-3MmlRw25NG-44JIp0bDjbQ-1; Thu, 17 Sep 2026 16:29:37 -0400
X-MC-Unique: 3MmlRw25NG-44JIp0bDjbQ-1
X-Mimecast-MFC-AGG-ID: 3MmlRw25NG-44JIp0bDjbQ_1789676977
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-530f968ccb3so18218631cf.2
        for <fio@vger.kernel.org>; Thu, 17 Sep 2026 13:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789676977; x=1790281777; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OnFmQViMmju8cIDyu/sH9LtpWUp0JNOUztHTGTsxU1g=;
        b=Ry+5+Oc2B48Up71uVKgcekKIJqM0VowKox6Ulwi6OF9O+2cHeoBl6PJBBRTxvETqQk
         yJtFfr9U70p5BPtvFkrpk0rKc2KzSqevDN52ypRwPbZ3l6UVmiAIcifKopQ5k2amN13V
         9U5DnYTiQQg879g4of2zeYJoP2397UukTvelrpHQlIZXdAdE89bX5/S9KVFuJhLxYb4e
         bhUSqGFDOiW50VKsQiWISvk4cXelOumYYAdAdbYh3JuUBoxWeuRYc2rgea9d4LAdTP8r
         TtgDbGd1uLyPp7Drk+ySAfX/0zaxC0bReOJeQQ7pf7PBVs82c7LRThp8H4E7f+AHBN/V
         HpaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789676977; x=1790281777;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OnFmQViMmju8cIDyu/sH9LtpWUp0JNOUztHTGTsxU1g=;
        b=Cok2UrfHb4nyVnrNePRWkCBl353IkkpEC8rARFnItqtJRlNkbMbCkPprVXm344z6aY
         nbw+yBStD4uOgKf7rcFgwzkd57pLlXNQQG/N5IYtSi02ezAVtVauTIaJqTiUSS7+A9QF
         NZ6pbBfshtWafK0LlwjpfkGcibcJwBEyA4qBNj1rpSSCcvT3a8OXBdPgpOSQcL3oExE1
         OJkpJqBJDdVW6SEoRi/jYrTeliZKgsAWr48x3ejYSKsKENcRYQzf1IbbgGUxfaap7hyx
         QO8QvqDGmPGMmWxnluySUx11isGQ+7K//50bsILvYnHwttdbi95UffWrHeFchLFelOcv
         ICOg==
X-Forwarded-Encrypted: i=1; AKwUvByhT4m34DoMuHOh33O9lRpXa/+o3Jns/XD2ovHBwl2CsWm4Nct6TlwxxO4D6ZPktrTGj34=@vger.kernel.org
X-Gm-Message-State: AFuF++k8+OeoWhzq8wm7DBOn3HemG+WKqvEOB6Lq4qWSQYPjuxac+6Lq
	2vNz8qq4sEWGqkGSJfAsOAmWWPa/RCa6gmQtAr+BQCuc22O/1xztknpPRTvf131MyblC/sxfwnx
	zA2/1+KBor/yyXe/AxqRPrf/memYxXkZg10nJaSSGcgwrgf3z5yD7MQ==
X-Gm-Gg: AYBFou2NPIiUGw2/QAf6LzLcxuAs0PiGVbrnC+/o1PXhNamY58aH7TfXEWDYm5g0RGz
	8at40ABSel5QVjD0zlFiHwgf9VBFZeAXqGuwXNr4O72E2bDxxIER63hU1IFzaX8QiUvs0w9Y5dO
	RlJmOZWUD9L11lXIaqwtCuJkHAM+pFKc957hDSybCuubfAFMQOLVVeTTYkfewkF4U98A0QwbvSs
	h3f23OUX5q7oP/S2KzNn2s0NmHU1NbeRD/rerTyRao6v2kJco7/UPEiF7gZwZQ9aETzfEYsjvO9
	guLbb8CH+Tey8gC2nRd0+AZFmVQhhPl7gdU5PaW0bY1UEoKT0fCuPxuLDCjdHb2pNBb3AfWkzIl
	CmSGG6CXfjDyxF8J/sxcXwIAVAydyL1EaOOK799RvDxJJxA==
X-Received: by 2002:a05:622a:4d93:b0:531:2154:bebc with SMTP id d75a77b69052e-5329e2aaf96mr6151351cf.25.1789676976940;
        Thu, 17 Sep 2026 13:29:36 -0700 (PDT)
X-Received: by 2002:a05:622a:4d93:b0:531:2154:bebc with SMTP id d75a77b69052e-5329e2aaf96mr6150891cf.25.1789676976179;
        Thu, 17 Sep 2026 13:29:36 -0700 (PDT)
Received: from [10.0.0.209] (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53259af6959sm57321631cf.1.2026.09.17.13.29.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 13:29:35 -0700 (PDT)
Message-ID: <53458ab5-5e82-4af0-93ef-d99002c259c2@redhat.com>
Date: Thu, 17 Sep 2026 15:29:35 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] fio: server: Warn when listening on network
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
References: <20260917194706.2264798-1-sandeen@redhat.com>
 <20260917194706.2264798-4-sandeen@redhat.com>
 <ca12a7ee-7a5c-469f-89ea-5d3a3cc43489@kernel.dk>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <ca12a7ee-7a5c-469f-89ea-5d3a3cc43489@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/17/26 3:01 PM, Jens Axboe wrote:
> On 9/17/26 1:41 PM, Eric Sandeen wrote:
>> Make it crystal clear to users at run time that the client/server
>> protocol should only be used in trusted environments.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>  server.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/server.c b/server.c
>> index 34f3f5c0..887ed7ed 100644
>> --- a/server.c
>> +++ b/server.c
>> @@ -2596,6 +2596,13 @@ static int fio_init_server_connection(void)
>>  	} else
>>  		snprintf(bind_str, sizeof(bind_str), "%s", bind_sock);
>>  
>> +	if (!bind_sock) {
>> +		log_info("fio: WARNING: The fio network protocol is neither "
>> +			 "authenticated nor encrypted.\n");
>> +		log_info("fio: WARNING: Use this mode only in trusted "
>> +			 "environments.\n");
>> +	}
>> +
>>  	log_info("fio: server listening on %s\n", bind_str);
>>  
>>  	if (listen(sk, 4) < 0) {
> 
> Let's not pollute the log with that - just document it in the...
> documentation!

Which is implicitly already there in the man page, so it's probably
covered. Could make it more explicit I suppose, tho that's still
assuming users will read it, heh.

> Like I said in a private email, anyone that runs a fio backend
> outside of a trusted local/test environment needs to get their
> head examined. By definition, since it's generally used to open
> block devices and read/write to them it's run as root. And since
> the environment should be trusted, so should the clients. Anyone
> thinking otherwise needs to get their head examined.

I don't disagree. Just floating the idea of making it crystal clear
at runtime, and like I said, if you don't like the change, I'm
happy to drop it.

Thanks,
-Eric



Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4575E3A7F6F
	for <fio@vger.kernel.org>; Thu, 17 Sep 2026 20:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789678021; cv=none; b=Io6sgnlBCuIp9R2tLxbL/eG5XFygQ84ldadFVuHHKUO2Rjn/prNP5VUXiyOpvkyNwi03kaAjm4QIomyVAx+4jOMn/E/4dZwKT/r/xy5GLHsjjTmPWXufYeH83uqkol5leQKcKPcvHo8SRAxJthr0yyrc8tiSB1sAQcAlw5dmtIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789678021; c=relaxed/simple;
	bh=aly2pYyZgrTJzg8CXTCEGAX7Qkuex67NkWpcpjDqiIY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DM/cIjve3vlS4qFK9zeN/30AiNvnp158vlMp2wNPTp4align5dSEc6y8oFADHIHBoTSRkctcT+AtIYh/iWtTGSreLInmeYE4jRDnSkZqYEGWZqgVgKGIMR3uMhnJo/E7kBvonaZKm3XYEWLT+3GUThSS4bVD5mKAWtAAj3JgCEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kirj6uXj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gHpakesF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kirj6uXj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gHpakesF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789678018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HS4tk+8tzO1HcUe9GmYx8aIkd6IcrqCiP78CS9KvWOE=;
	b=Kirj6uXjDEFujNmPudUcXXnE7uOs51V192a0erbiNoJHvnibvsNz/NYLjqiHv9R+DKDPhR
	cvN0BwZAIeSJOu9MDhcBCfcmQSPIJdK+wcpF3i60zeitSl9y+kydZxEMYtk3/gTuBFw+gB
	w9nw06W2Q5MQIPj2YDLUcWoT+ejsHow=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-E-hWlUX9Ny-ltJEHE6bWWg-1; Thu, 17 Sep 2026 16:46:56 -0400
X-MC-Unique: E-hWlUX9Ny-ltJEHE6bWWg-1
X-Mimecast-MFC-AGG-ID: E-hWlUX9Ny-ltJEHE6bWWg_1789678016
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52fb8f67601so16598191cf.3
        for <fio@vger.kernel.org>; Thu, 17 Sep 2026 13:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789678016; x=1790282816; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HS4tk+8tzO1HcUe9GmYx8aIkd6IcrqCiP78CS9KvWOE=;
        b=gHpakesFcQydoCzMnwGT0ExaRTUScSwcKo7EJlKI1cEukJtCvWcpgh9SxdosJjIzXs
         w2klYFjkmQLxEQ1jmiIaHckRcVetcmOS7Uo2WfpesOr1P+212y86AaFwa90R1eG7rRgL
         4VRUoBSQDEptC0+TT7I0871m6CUGne/KaiBSDD6/U+KXyrIgJdZk588Iai1r7TVseVKX
         ZXbfVskIEieiS5fmSZeTqGSqnMgCbOyf5uYJype3r9IYH1XfK/u4PF55DPi06/ez9DBf
         voP94sc6Re7PmTdh0AZYu0roUy/eATyGCLGxO5NgOUp571BnVMIUFNj9aWUMzD5M+/Bm
         8/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789678016; x=1790282816;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HS4tk+8tzO1HcUe9GmYx8aIkd6IcrqCiP78CS9KvWOE=;
        b=fV44MnjhuBsJnUxnlfZ7fLaBHIHcspG4+sEE5xx/6xioyqjvSNVnnN+D5z4TA9z76N
         SzbovmmZMMkARn1L3mZwyEYIk/nbS/TsMnzvHa7QLV0JIxkKLT+3xHyaDXTLvKoAnEho
         7RJMRRjtbAlYnd8RkuHBUDYTQtyjmK3e6br/c9gw1VbQXeURXGnnOU1pxwLoCHyp7v0g
         Bjn2dvx/GutjsQvhtCQvSDgknu0xXLCu43rKR8YsU3dthr7IJUQJSi8mVnzzv5BtsiK0
         te+rrJrZFpEsjPNMlOKuKd7YzWRy1UViuu8UwpiuqqgXuUaB1YSe2jv/wfdUk9jIXoE6
         Lt6Q==
X-Forwarded-Encrypted: i=1; AKwUvBwkiy5UTYFQ4fy2/aghegRCGD60eqzSXBvUOxmAsRjMyXkprjiasvKVH8wWTR6tppsHJqU=@vger.kernel.org
X-Gm-Message-State: AFuF++komoeluu8jvZgf64d5uz6MSyS1CbU05ybbr84NBxwaTiJugT+h
	UO2ErV5L9Yjj6g4V+uuNrdz0UecJcF2XvKp5sLeTtSsDC0b9Zxdcrg/cGUExtegj/quAygAQ08d
	pSesAym+UsVAY3zzTjNE3zMIMYIu5qbbjhL8S+kSxG2VBKnsOvfgNNtW1FsTDLio1
X-Gm-Gg: AYBFou1ik/nsyEpPNEkdHd9E96md0Zv5IctbXvumYdX82TrixxaEA8n0QrwqYKnFvz7
	5vWq22jBcD1s6dgTUHqIc1zwazqwAct5FbEI/6N7ecI4v0FfCSQU2hVMGRrMzUHezGXirDmoO0A
	zgD+Y7lfPMUC7BVWS8BnyxKdLzacWwHCTlrCfmHgeL9SwvgPx8V/E/qkSmi3v+OS4Y8NyQSAldc
	jVWgl7U29Jvar6FECU4Ry8IWezFET2NaIXjIWoP681k5MqbqwjToNHXM7IuB27Gca3IY9dlnsSa
	HjlOyR2cao75D4qpbyXs3MT5JhESZgD7/KFAcX72p2YmaslLHtLBsQwdcJXqgpNUiaRGftLpaJA
	Ympig30EdFur/m9CEpRuqFSqoH8YGLcCZUoaS298FZR0RkQ==
X-Received: by 2002:a05:622a:1456:b0:531:192c:84ff with SMTP id d75a77b69052e-5329e34c2f2mr8477921cf.14.1789678016130;
        Thu, 17 Sep 2026 13:46:56 -0700 (PDT)
X-Received: by 2002:a05:622a:1456:b0:531:192c:84ff with SMTP id d75a77b69052e-5329e34c2f2mr8477571cf.14.1789678015623;
        Thu, 17 Sep 2026 13:46:55 -0700 (PDT)
Received: from [10.0.0.209] (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532620b0c44sm59345261cf.26.2026.09.17.13.46.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 13:46:55 -0700 (PDT)
Message-ID: <62500f3e-1211-41ee-997c-fd5aac3a56fc@redhat.com>
Date: Thu, 17 Sep 2026 15:46:54 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] client: sanitize FIO_NET_CMD_SENDFILE requests
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
References: <20260917194706.2264798-1-sandeen@redhat.com>
 <20260917194706.2264798-2-sandeen@redhat.com>
 <fe69c3bc-95e3-442b-ac61-9d84c85f2e93@kernel.dk>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <fe69c3bc-95e3-442b-ac61-9d84c85f2e93@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/17/26 3:00 PM, Jens Axboe wrote:
> On 9/17/26 1:41 PM, Eric Sandeen wrote:
>> A legitimate fio server should only be requesting files from the
>> client's cwd; reject absolute paths or any paths above the cwd.
>>
>> Since this adds yet another failure mode, move fail: to the end of
>> the function as is a bit more typical for a goto fail;
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>  client.c | 23 ++++++++++++++++++-----
>>  1 file changed, 18 insertions(+), 5 deletions(-)
>>
>> diff --git a/client.c b/client.c
>> index 374a744a..b32c2852 100644
>> --- a/client.c
>> +++ b/client.c
>> @@ -1809,12 +1809,18 @@ static int fio_send_file(struct fio_client *client, struct cmd_sendfile *pdu,
>>  	size = sizeof(*rep);
>>  	rep = malloc(size);
>>  
>> +	/* Sanitize requested path to reject files not under cwd */
>> +	if (pdu->path[0] == '/' ||
>> +	    strstr((const char *)pdu->path, "..") != NULL) {
>> +		log_err("fio: rejecting sendfile request for unsafe path: %s\n",
>> +			(const char *)pdu->path);
>> +		rep->error = EPERM;
>> +		goto fail;
>> +	}
> 
> Won't this potentially break existing use cases?
TBH I did this a while ago and never sent it, so let me re-check. I thought
I had considered that at the time...

OK yeah, I guess it is too broad, I suppose if a job name has ".." in it,
this would  cause improper rejections. I don't think anything legitimately
tries to grab files on relative paths, though.

I'm guessing you think this isn't worth it either, and if so again I'm
happy to just drop it. Or I could tighten it up to only catch things that
really try to grab arbitrary paths outside of cwd.

I'm also leaning towards not worth it. :)

-Eric


Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704693AD51F
	for <fio@vger.kernel.org>; Thu, 17 Sep 2026 20:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789678070; cv=none; b=ZeBuIKpiHtHVtvcVj0yVt8rxOXIMsvAa3jmGvd3q6cg07+Wt23kCybM0ZYKJ3wQxL7JcA6NGDN7Vbxv69bB+m4QovaTPcUyQzZ4U4rsJHWOCrJpXLn95n42twBPDQib5gw7D59V2IUy8MIQoqvo5G/tWj2+kQJrUINwjb/akFqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789678070; c=relaxed/simple;
	bh=tKhyjXe3nhC+1uUdOYoTjtVgSGMl66VRdH3947KCwtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RE/2izirjRUMzcG+Z9JILVvbD906SQ7mky6vbvzb3YpZWRMZ2oSh45SapewQi7TzHZHJA79BKmJ11sGki3OXYLcZk9c2sLyHX1eauEgGSAqKVrfI3/ULfD2mgVJRoZWweMTJDp14zc0YgSmJdOE5dvonn/H1yJQskVVJIwXsUb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=gzYelizj; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="gzYelizj"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912df756so428795e9.3
        for <fio@vger.kernel.org>; Thu, 17 Sep 2026 13:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789678064; x=1790282864; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DzvviLRD17dSkOHErFiRRJeXx7+vkdacb55Hq1MZ0kI=;
        b=gzYelizjno5pe81Ce65d0O481OR6ZKcpgMncd0Zo0FlHe0Db1iuaWjIrii9t1hjR4v
         6Pyh4Fodqj+gMToojap44eOtdriBwmkHIUIMA9bv9IKVH4o1o1ZT0CFnuTaaiP6CdW6n
         g9lofPy3TXOdt0K9WIjZfCcg7scG+UMoN0Txf2sLSnPpj0/QfdRMINsp8Z9C1jr8U3tq
         ESdDDkBoWv609L4l94xzl/uHaGelL0HZf3z4JCmEDePM9uQGjaEFUcRDzvYc60160iPu
         0rrzLH2PoK7iN5qvPpkOm6k8djVDENu5isF/MQs+xK+aERtKDbwEngCSDlDE5637Bih4
         prQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789678064; x=1790282864;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DzvviLRD17dSkOHErFiRRJeXx7+vkdacb55Hq1MZ0kI=;
        b=hqBG99PSF8PYMI/8w5GGSN7BGTbI+aywzb7aOWOQvglO/nSc8Pef6yKafmMnpniygD
         XHGrI/U332MIh7Qi6nJRDvhDEjoQuaIZaNN7CRTHMKVdcqaT2hoL0gAd6XAv6nSnK83U
         GRAMxmLDV6bTf9ZyTIU/ZQMj7/UGtsvZ+OieMfXMlnRvUHMK2eK2S38dW0dEwqlgwzx1
         Vkp0oALAZ3DfsMXUjyxb7f9NXKSVog0roUtBpWNrg+Z8ogi3OrZDsPWgmkQXsvW6/RBy
         Oxe85HtqntBJw3CwtdePAXfGssu+BueYtZTEjlHak3dfX5zK88J1UQCPjBkWuOM6b0va
         Zrqg==
X-Forwarded-Encrypted: i=1; AKwUvBzDeFd3u2Td3BTXZF6vOEb8ZLYV3wRJ/+uIAwMAYO8+0R54ZyBeOy/BE3gVF+w3kRTAJ+8=@vger.kernel.org
X-Gm-Message-State: AFuF++mnR3dB4wUTw8VRY/CpE2JMakvSdvyiNe9SrAwEvRNpmv2R3jSn
	KtNv8T54cbebx/7QnD2TbOmzbDGP8lkZieNC7BRtwo53rgsu8H2UEDnyj5KIp/UM8Qk=
X-Gm-Gg: AYBFou30/rKl+XjFMEOhI0qJhV2ykMY0tXLBq0VQeKsbvpYTLyX46m58l5H/NB7+wpx
	95NyxSWhUtTw68AzB15ISpYbO9CqlLnSxY5fHIM2C8BXCg9NMg3u4EkPbH0mrpxkatqLfJ3374m
	45TVJ2MCdEsmWhIkttVxhrKfB971qRKgJMi/VcMKrMAYwKGVuYJbrFuvUOUWD0rQG76ipgLKMPw
	8JLGK14lZDZuvJoFRWZEv2LxKDax/VvILhTa9CiBXDlwG2NTQ7eBHaFS4y6UU+pGw5j2+PWy4BE
	2xd0DyzhEjINCnvTqPwBlSoX7KKW6ZhRwkXQDjhfqEsdSoTDQwhEADn6I10hUm8D3viu0kwYqR9
	03UPo6SmsTHaLMqFT3/G64c5m8aj7O1YTmZWsbFea+c4M9NP9rhN9ScvLxIlIiM5SJILKhGRg7t
	8GnwXCNbCO0dcYPpQ5MzRpEOxTehgwlM69BENxbU4FQssZ5rXLKd6UHbWyl61GE2wa/Q/rthq9W
	VWS4h4sQNfMCgKac4sntk1utF7zfcOdua3qpOL1rutF/QOIYDzy8wV7Hg==
X-Received: by 2002:a05:600c:1d0d:b0:49c:e27c:6b10 with SMTP id 5b1f17b1804b1-49fc5681652mr1267385e9.3.1789678064402;
        Thu, 17 Sep 2026 13:47:44 -0700 (PDT)
Received: from [192.168.1.112] ([217.65.139.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbf515cfdsm94093605e9.11.2026.09.17.13.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 13:47:43 -0700 (PDT)
Message-ID: <ff4f6468-e7f1-4346-9192-a59fa863a2a7@kernel.dk>
Date: Thu, 17 Sep 2026 14:47:41 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] client: sanitize FIO_NET_CMD_SENDFILE requests
To: Eric Sandeen <sandeen@redhat.com>, fio@vger.kernel.org
References: <20260917194706.2264798-1-sandeen@redhat.com>
 <20260917194706.2264798-2-sandeen@redhat.com>
 <fe69c3bc-95e3-442b-ac61-9d84c85f2e93@kernel.dk>
 <62500f3e-1211-41ee-997c-fd5aac3a56fc@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <62500f3e-1211-41ee-997c-fd5aac3a56fc@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/17/26 2:46 PM, Eric Sandeen wrote:
> On 9/17/26 3:00 PM, Jens Axboe wrote:
>> On 9/17/26 1:41 PM, Eric Sandeen wrote:
>>> A legitimate fio server should only be requesting files from the
>>> client's cwd; reject absolute paths or any paths above the cwd.
>>>
>>> Since this adds yet another failure mode, move fail: to the end of
>>> the function as is a bit more typical for a goto fail;
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>>>  client.c | 23 ++++++++++++++++++-----
>>>  1 file changed, 18 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/client.c b/client.c
>>> index 374a744a..b32c2852 100644
>>> --- a/client.c
>>> +++ b/client.c
>>> @@ -1809,12 +1809,18 @@ static int fio_send_file(struct fio_client *client, struct cmd_sendfile *pdu,
>>>  	size = sizeof(*rep);
>>>  	rep = malloc(size);
>>>  
>>> +	/* Sanitize requested path to reject files not under cwd */
>>> +	if (pdu->path[0] == '/' ||
>>> +	    strstr((const char *)pdu->path, "..") != NULL) {
>>> +		log_err("fio: rejecting sendfile request for unsafe path: %s\n",
>>> +			(const char *)pdu->path);
>>> +		rep->error = EPERM;
>>> +		goto fail;
>>> +	}
>>
>> Won't this potentially break existing use cases?
> TBH I did this a while ago and never sent it, so let me re-check. I thought
> I had considered that at the time...
> 
> OK yeah, I guess it is too broad, I suppose if a job name has ".." in it,
> this would  cause improper rejections. I don't think anything legitimately
> tries to grab files on relative paths, though.
> 
> I'm guessing you think this isn't worth it either, and if so again I'm
> happy to just drop it. Or I could tighten it up to only catch things that
> really try to grab arbitrary paths outside of cwd.
> 
> I'm also leaning towards not worth it. :)

Not worth it.

-- 
Jens Axboe


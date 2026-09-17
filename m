Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F6831327D
	for <fio@vger.kernel.org>; Thu, 17 Sep 2026 20:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789678014; cv=none; b=oXYZGWtADVSrXrbEyFlHnPpWdh8AVq5q4q1BokdjDkoPqZtkPJnmu/593Z8a6poRC85G4DH5hXtatUIjlrWSnwQDxZBGztXOXyRYPnzPSpOf8dGZdwvrEfHR8k2TQkyXomdN7MRWKUdUUu9H30FNgb8VXoKbVmcOhpbQCGZs9ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789678014; c=relaxed/simple;
	bh=O8fZCYtEu2TdenKEtKj5MehpMWTEIdzPqJNDftmberc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=bv5LwcTRYzv7DnqymN4ZVndwMaaSwL31kJ+941OEfLQwX3lqtGXcWRV2fOR1dA7tf9pj8JProv1Tu3RS4cHZ88yfX0nw2bzO7F3eef1edXwetaKIeNMmCG2S6zwWlNuLHCPdW9/8rpsAFFEUbUHfvz3EaczjzAf55ScjdlP16cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=gPQqr7ak; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="gPQqr7ak"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ce364488dso204695e9.0
        for <fio@vger.kernel.org>; Thu, 17 Sep 2026 13:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789678010; x=1790282810; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=h6xW4mS6f29m10foiQkXpm/QTn9Cmru3vq9A42lk5cE=;
        b=gPQqr7akpLFD3/KDtWI7QZx5/n5JBNmZkjxLAnp+s8EN3obslzJVHXN7mYz4ms1CUc
         HqO65hj7Ut4HVwIDpRt1BRAxlMh3NpGtIsWqS3pRBJDp54iiAkwSAewdGgtq/7I3rqrS
         XgC11Aw3QHBv7Zlg59NJsETM788EdNuDpP2+uaFNrFpBAdAnnJOGOnbptebAGvgrLuid
         SbZ1NuHKoJGSW3rjnf4pPOvlFcxHLsw/SJNPnfuDfgGxCOuXHutHHZ9kLTZDrM1JIVGh
         7Cko1C9PVRfI+/9oOoDsWigwWOXeOtfp0zjkd+fE6/ZsIVcFPwVb/4sqdQyYaSuk4RuC
         q/GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789678010; x=1790282810;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=h6xW4mS6f29m10foiQkXpm/QTn9Cmru3vq9A42lk5cE=;
        b=lpBC8zNDutYfaeDN8q7BXRT3CsofCizMamosfu2a0gOqelSzkJBgsUrcldXDGfVsYA
         6gJrLt46kwhrqAFdDhESARjLpg5B08GwWGGDGPxcJuyIbdz+2VuuPU//fBAmrcaRC4TP
         x/jpPizcwjoW0WhSOhNA1v1thjLGkW1pj3l0pqt0A20AYZ6XjwbEbSyTRU4LTn5lAlxn
         VoPb2Td7MdD/J/G9N/Yh/XmwuhYL8i8fgD1MCPKEd+6p5tBDXYsbODbXECp3+LaI6gxw
         WzZtX1xLljNInyUiKLenxi/0ujKHE6eM2p1kng9YrNokgleW9Ez0CBmUVBL4fgSncL2M
         OpZw==
X-Forwarded-Encrypted: i=1; AKwUvByMZJbkYezY9khiXuDFPPmikftRXZUwF2vg8odMfVX/N6YbY9ZTPDYA3VPaaRiCOdq/kGE=@vger.kernel.org
X-Gm-Message-State: AFuF++m8DYJk3Lho8puKZv/Xfr0Pm6h81agrVwhxI9jQVSmPingtH/jt
	TxkR+TZlLIkbBUuKM4sx9CKVhgI9XhzBVCBGkO4RMR+GMXLFHiiaoFyll4nh/CWsNws=
X-Gm-Gg: AYBFou1t+sY8w61QMyB/A0tt8FXj9tAdwWSmuo4lBpgo2CWYdzRo/krIpXjj78tYLvo
	8PM3nMKI85yNdyWJ5NRqtln4VDp7LZZwHOYn4UTsJIpi8XrNuZtTRmZ7kxkmYAiiF3P+/uQ++7b
	M10ejBUL8KdV62pRLEQDxyQpBSQNtbnvIMWiKdyQWTFaHVX0BH0mIH2RowoyjsecVFjrcD3vnZ4
	9DYAivTNMX0Rx0qi1/TsdMrVSQrj4vxYMq60saZxZpzFdqne3koGC+S1a0N+00EYB8vA+8GSL74
	eKsquMJzJWc1STfxVFccOC93iR5H+1cuQj5Vp7jSfAH4zP5ZGkkgrFYyfw/d9CGVkL7s+vunLVL
	0X7ynX9QDc6IJ0spc0enCEGW8ms9hNoJujClYbARZXCYueeAwwHy9beuY4nxIANFRXu0k+4+gby
	6uaur+LgwPSeE+jn/I8rVywWIwQ1oB5xgI7q7yM4CDKRyTU70Y6l+a9Z3FR1AEdxOc1Fb2psmTc
	HA3WMNq2irUUT9wrQi+im7rGKoijV6NMXp6HIHjTnupjpI/LUMVmxRptA==
X-Received: by 2002:a05:600c:310d:b0:49e:65f2:db64 with SMTP id 5b1f17b1804b1-49fc4f85891mr4825435e9.5.1789678010469;
        Thu, 17 Sep 2026 13:46:50 -0700 (PDT)
Received: from [192.168.1.112] ([217.65.139.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc58ce1ddsm1263725e9.3.2026.09.17.13.46.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 13:46:49 -0700 (PDT)
Message-ID: <51ea00eb-b91c-439e-8c16-38ac3729c408@kernel.dk>
Date: Thu, 17 Sep 2026 14:46:48 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] fio: server: Warn when listening on network
From: Jens Axboe <axboe@kernel.dk>
To: Eric Sandeen <sandeen@redhat.com>, fio@vger.kernel.org
References: <20260917194706.2264798-1-sandeen@redhat.com>
 <20260917194706.2264798-4-sandeen@redhat.com>
 <ca12a7ee-7a5c-469f-89ea-5d3a3cc43489@kernel.dk>
 <53458ab5-5e82-4af0-93ef-d99002c259c2@redhat.com>
 <cc91f33f-5153-466a-80db-b2102cbed1c4@kernel.dk>
Content-Language: en-US
In-Reply-To: <cc91f33f-5153-466a-80db-b2102cbed1c4@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/17/26 2:45 PM, Jens Axboe wrote:
>> I don't disagree. Just floating the idea of making it crystal clear
>> at runtime, and like I said, if you don't like the change, I'm
>> happy to drop it.
> 
> I will just pick up patch 2/3, I think that one is obviously fine.

I guess that depends on patch 1 - so please do resend patch 2, and I
will get it applied.

-- 
Jens Axboe

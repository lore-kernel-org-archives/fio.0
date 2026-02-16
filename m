Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A4528A3FA
	for <fio@vger.kernel.org>; Mon, 16 Feb 2026 09:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771233058; cv=none; b=MSfNxxMfStf7OGZxq91XsCQlnOMDd4et/lpVmG3w9I9TO03sI4CLX8eHNdyAqcRed9v+ppyb+bSaQrzD32Cx/b3ci3FLjcf55FgTfPVtwwC7yrIn/ZESriBX3MxnaVVCZxBUhBIKvQpjRAR89TVHl4+4laGQ05lSr55PE38JCLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771233058; c=relaxed/simple;
	bh=VkNgxPlRbibvch99GsB9rSD3untoFfhCGqDXE4rUzoM=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=mcqlDlmCbcZTp/YjnHBwwRpPXmv8Z5Ip50eVy1Dg0cC6f8H7nZF8eO/AJjFknUjWUWM24tlwfNQ8Pi+9UpAsVzcbP3uu1q3AK51iZBYQXnP7FGDdMg+znrHjuiyScQFeANK3hMpxTxad59ExR5CHA0arIM8R3lhZq7dbvwW3TaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZgCXzeDK; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZgCXzeDK"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8ca01dc7d40so311850385a.1
        for <fio@vger.kernel.org>; Mon, 16 Feb 2026 01:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771233056; x=1771837856; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VkNgxPlRbibvch99GsB9rSD3untoFfhCGqDXE4rUzoM=;
        b=ZgCXzeDK42803IBtfY78VTNjII1WJwzkf4VQuuwKPjYTs/YrndYNA1Lobga3ZQzGEu
         iwC7ltPEhHwVNxZsuSlqXljx0bIx2bN5DD6986z9TyhZVQchvYlyn1VHuQQfWpt6lKFP
         1hvf05aFSvz5Utap7NkMvsa8WNx0EUkXOQwYntWjIpunInvwzBxjNpPHTsYfy3L1zxoN
         zkgbhLEz5qkJLuUsE9lvqlNhZM9ZlWpg6nVnxsE/Os/h5Z9EXPJyxKnRvDyJ2H9VG4px
         fZYAeiwbf0OBSaDKNxJU1BVZ0Niqt4HYaZ4/KIGL2Zo6PjI88W9ub2fiViijw5QyZGFH
         eVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771233056; x=1771837856;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VkNgxPlRbibvch99GsB9rSD3untoFfhCGqDXE4rUzoM=;
        b=U5Qcn3F3gmCHPpGZQZhgaV8kJjazhA2LINS9D1bQcjajPtG287bbsLs0N0kD2akD3r
         LC7Q6BE6yIbIf68SBpOkBiquE/E/nGm7scewJ4uhuTvDq2or+lhfbQ3jTm751G5+JkGt
         g+D9kKD+od6uxhsppeUFiB7AxOh49uW45TG4JgLMt3DfNugzc8lo0hDBY4PJpOSBi8tF
         PW0/xx1rw/ltRzO9Tz5Hmu9dhhe6sLio5BOdobuNPp28p0jO3WaBxauqYFgdlVA56wmG
         73KxAWvIH8fCUcrGL9lSsNxebJTTwNwvU6fVmkCneK4FVVIKbVusBH7kHu6cP7eCfJYt
         LSWQ==
X-Gm-Message-State: AOJu0YwkViaKlaGk19TMKZJrvwZReHcc0dnTljXTjlcbu9TasSKwTghb
	k5hAPBYl6ClIOag5QfSCb779Tr3ZmFt3qJJAxhfx36CC3/kYkvfwkTosumV4
X-Gm-Gg: AZuq6aLbB7PU63Mwct/Mi9zu2A800iux9Lj+HOCm/htnF14JZzY3V8MN7hQPaHuUM4Y
	M7V8wmGIyxNsrbhH90higdjt+IajZ0qrcxrdxDBU5HT1S4t4dOp3L/si5eQVgrVLdnQBr7X5RF9
	0EcX26nUqT15rVLwdSeFP07HFmYkn2RRRH343uK+PQuhYxun3OmRxNTFFrEcQeMyVkvcfI0SVJq
	1tTFxBLkkDu6tQ4pX5T2gGSICXbczITJyUpxRst5iVTFTVHxeBuCyoxUbLI1/2Wf2Rmb8AmAMg/
	cCvlkMZjQpSycl2YpZLPhHwAuqJoV4KiNYErMry1nZQNh4NHPxq4z1jfsyUWVj5654IrGRWmgdf
	aLi7AlFoVRVi3mnIqw/U4tZNwRfr1HIDU0ZXafMVPI+tYvdVB5ME4cOSDDwtMrd2R77AlghvB32
	wBF+YQpIR2eq3oGcFUOa9nyOABEebTx9KieGPrLr1BhAqURUn6/5zXrgHMmq/HLhzI9mMrNANT9
	Qvd9A5mW73feTSavkJHrA==
X-Received: by 2002:a05:620a:3705:b0:8b9:d540:5365 with SMTP id af79cd13be357-8cb422a6e1amr1232719085a.39.1771233056227;
        Mon, 16 Feb 2026 01:10:56 -0800 (PST)
Received: from runnervmjduv7.s1jfbgqwn2qebkyxgm3fhys44b.ex.internal.cloudapp.net ([64.236.142.145])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb2b0ce73fsm1304474185a.11.2026.02.16.01.10.55
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 01:10:55 -0800 (PST)
Date: Mon, 16 Feb 2026 01:10:55 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============3512818216119157735=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_v2_0/8=5D_zbd=3A_fix_problems_of_random_write_with_unaligned_block_size?=
In-Reply-To: <20260216075936.3318729-1-shinichiro.kawasaki@wdc.com>
References: <20260216075936.3318729-1-shinichiro.kawasaki@wdc.com>
Message-ID: <177123305533.2890.13284170254560857360@runnervmjduv7.s1jfbgqwn2qebkyxgm3fhys44b.ex.internal.cloudapp.net>

--===============3512818216119157735==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/22055321799

--===============3512818216119157735==--

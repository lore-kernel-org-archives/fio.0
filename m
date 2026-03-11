Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576D83112C1
	for <fio@vger.kernel.org>; Wed, 11 Mar 2026 11:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773229039; cv=none; b=m11SL2eaWXTZP+miU8rqe5BBI7RUElwZCh1YMHjDIfmM2nlq7eWGRoeH45I7zJqfEQHMOf4SjeeCZ6zmlQ3xfkB2h56y4wxv5AzgRlvgH04pv6i007Q0orGBkgbULJLTN0+rnGz5sV9rgrLynA+oVKlQbhiDrpjyUIm5qrpT/gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773229039; c=relaxed/simple;
	bh=aeIB3RNAsZrUMzQvDhKSOWIuzm92qtGJtLALE9Kf1pc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=A/nmCq9eoAX2VrevTl3Ou5aUQ+loPcRcjHg74R4jtjR/QmiuI2NF9ze1bYLoOn7BR+Tn/hdbG8f6nJs4tQp9oA47kABbgHVzl/jR8vjSi+CqvQTBcnIJXWlnbXPT7xR0oJlKheniEOe3edU08zicQizImcqs1qqOb39QWU9iG7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hLy8mBeE; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hLy8mBeE"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d754c7c150so1484904a34.0
        for <fio@vger.kernel.org>; Wed, 11 Mar 2026 04:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773229036; x=1773833836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aJK+APj1VuTXyc4QX0POcXyzpGsvX54++bsG+j8EeRI=;
        b=hLy8mBeE3I8+qcS4Z4rOLgbxI5XG45kPhWKJ8PbVbe0Ry6cxE/v5RtLgAHN+eokMYz
         fkT78XxuDTwMfuvz2NRnEbVXeXbkdybrFuzFmRQ+0zcqDiSytmfkqNdUp5hfwfoSeoN/
         /tH0RatjVQspHd537oc7VzGC7aZRi25bH8LVlxUzYy8pFkByskHtZ+K3CZkO0Jkbcmzd
         QKMSrpZfkeNahQbjVA992cXk8IJEHAljHlWUlgKFNt0Gg4UJ2pNxb95CJCDPW08j/EcL
         oCz9uFR2wTCFjRLJSS6mrAyAMBNnbPbuuCnugNXbo2vlqtH6WrdXFuhto+gq0QopgczT
         SV5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773229036; x=1773833836;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aJK+APj1VuTXyc4QX0POcXyzpGsvX54++bsG+j8EeRI=;
        b=oy7qDIOIb6S9w2BztFFPE4y8q0Ral/4raYLhtA8J96UNeQrrGV5tH6UlU+9HNAsSWs
         fK0OVL3DVMkds6cnRv+FjtIOIjNism+6dPK7CbcBA5vbaOeacF90zfhPySUFlXD3RqMy
         znFFg/IIZH+0f0BD8kB/FcUwYSahy8o+v2YtT8BlyzqXGLVjDRv07hiT5r/mRbKdgOE9
         P/wexrmvP9ZBNwsOaKqayYwX9rpL1Qv4vwMWVPKY2K2ZLLx5l57P7vM3ASZRh+HdVv/p
         puE23sLjPkgpOX1bO5WXbfgca6TWWl+tsCXthz4Juj/LebYhsL5Vp7PxJ8+6ikeh9/v8
         0vMA==
X-Forwarded-Encrypted: i=1; AJvYcCVGWNGFKA2LqcISNDus4/GbWpUQmi07zfWtQ0zxD9PgtDZZlZqy6pVUe4DSVyGdalzUrzw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3/ACZ9v+h5bVS+l2H24VoJnb+xqLTXbswh6+pSOdr+IzYqUn9
	/WUwosDXir3dci0iU/1fToeKsJeObdxPwRX5oZpoSAffG4zCvNAoLEOcHUtCsyg55iYEdHOIqXN
	XUZJzdOA=
X-Gm-Gg: ATEYQzyz90cHiSj/GDBynqwFEJGpTS11p76AvCFCMV0dLwt/52SMkCMC3aH+oo80SDW
	LQ0aMVSebF3qm99k55wMN89DsLstS8eiEDE7+tyc6JU6YcYyQd9tC/JAMJ4z6ZosEeNEDtf+CiB
	GIOq6PBSTjZbZ4OCAO5qJpGRtQqEWWMTxk7dblE+xy9BTRg8qR7dAeNFr6Gs/4DCMg6+Kclc+vo
	isNMZJJ/omDyKq1lVBcsHhO8EXxkx/gKCOWlsflKGw5C/oLuaBgaQx6kryhi8muP65qQXuG9AIJ
	CPqBoOtE+ME3q6uT+Y4fIQAuX8gd+DjE/uX7eI1+V7oJZ6041d3nO0M+yBiR0WQcM8ZHt5OQFlz
	t9tXo6XCcl3i3Us3xPNxfwriays/w5oMicK4+YPPhZ5wRpwsxY++L3AEhuMDt3Y0+vRLnCSxueo
	7KP70/jCg8/3TZruoPMKriF6JvA2LGhFvrtM9WkDyTJOaZ7ByE7pvvaXL5RToZJWUU8ZnrlS2UO
	kth
X-Received: by 2002:a05:6830:4409:b0:7cf:d119:9953 with SMTP id 46e09a7af769-7d76a6b5e77mr1518169a34.16.1773229035944;
        Wed, 11 Mar 2026 04:37:15 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76ae39b39sm1858889a34.15.2026.03.11.04.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 04:37:14 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Vincent Fu <vincentfu@gmail.com>, fio@vger.kernel.org, 
 Dmitry Fomichev <dmitry.fomichev@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, 
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
In-Reply-To: <20260310205804.477935-1-dmitry.fomichev@wdc.com>
References: <20260310205804.477935-1-dmitry.fomichev@wdc.com>
Subject: Re: [PATCH] backend: correctly handle rate_iops combined with
 bssplit
Message-Id: <177322903461.157850.18026029798012251132.b4-ty@kernel.dk>
Date: Wed, 11 Mar 2026 05:37:14 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 11 Mar 2026 05:58:04 +0900, Dmitry Fomichev wrote:
> Currently, rate_iops does not produce the expected I/O rate with
> workloads that use 'bssplit' option. Consider the following example
> configuration -
> 
> [global]
> direct=1
> time_based
> runtime=30s
> ioengine=io_uring
> thread=1
> 
> [...]

Applied, thanks!

[1/1] backend: correctly handle rate_iops combined with bssplit
      commit: 3a0e8ddf28ad32785ea3130ce0ee42524d835d60

Best regards,
-- 
Jens Axboe




Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966F033BBA4
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 07:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772176282; cv=none; b=GShDCRjYGw1SpXZ3yHIP+CbYK2Pyz9z7pgXC4SNtNpmYWbeD0J+/oJ32ZwPTCuzM8SEawxWcYf1Z/uUdTmaFbBF33dPKsTRZJXFisCpP8Vjn7qSc3oUray1HiCF1dzL/HZ4Hvx5yUK7AkfWqegHvIxUWJWM6uOXItfzjC+LkCqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772176282; c=relaxed/simple;
	bh=LZWrXsGt92i2jNWCzZf5c1NqNbhN4VjR6hbKjqqSDc8=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=K7d48q0a1k6sX2pfdmBjciA33jTmWe65H+z/SWYUaoIiMHuGGrwq2xleW8ocVTvGo1AgPUpcqKWVdI+LWA84Bc+dc9WB7KWatLAZAG60WXrIQGoMYS8j2KGWkk/h+L+sjkyJbsA9dzKbpXjQEewl7BMwva8/4JMzEKcz+AMSeAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WPEKjW1k; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WPEKjW1k"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-897002b7576so29278966d6.3
        for <fio@vger.kernel.org>; Thu, 26 Feb 2026 23:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772176280; x=1772781080; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LZWrXsGt92i2jNWCzZf5c1NqNbhN4VjR6hbKjqqSDc8=;
        b=WPEKjW1kaJa8bEF7/EeR3G3+jgGi6bQSa3dvIq+yWI1Ofa+0cunF8gZ0dACtNmcguG
         tVoDuZmWTTcDRkO9OvlRFWc/pxBVk36AkbmrdAIpATJerpJWnN+cnHOy8hNm2wteoaSj
         BkqE52r5UyqFRxzcoSIbFxvfApNK+2oJ6+yjTWSx9nfVcjz2PZXlHo/BmgUZhutsVymr
         x3MwzKG/xBZFcgHbd33mYr8VLsQxbobwkm1jLEjTeRh9idqTLKG+TyZ920gCIpTgk/+p
         zBXhtZQGsZgFMEypSz31hlEvzYE3M1nU/Sw3XXI4EG7glUJv6SN6CuKO2oKvZhMqZDti
         LPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772176280; x=1772781080;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LZWrXsGt92i2jNWCzZf5c1NqNbhN4VjR6hbKjqqSDc8=;
        b=KIj0wLnhlD1BWqjTROOO2daeaWHHi1NJRKHLmhV4EPDHNBA0rafkoeP1gwifWFefs4
         1QxgZhMja758ZwUXlI+uH4XxLdkr1TVizirjT3F9NE4yVdhq/+Ftgc+f3Ea2SNP+0nDD
         1esqN90UkL709tJF57tkApNLLEYzrg5JeTV1QAdeAMarlyftKxlthFQ7pUBJutdXS8jY
         v2hwDJ/arSQxc7xG42W2jkU94GA7GiZ5LEvIAZzOm6jvPpbcLMaD+gt+oMHScq05WB+J
         aZ4VlGAjW6Eu+QCPGpomLdA9H1shLjdniOrtoAJfvd6D6noabeCuKcHeFMpE7yMw0+rZ
         MLAA==
X-Gm-Message-State: AOJu0Yzk1UdI/OLu4LtSUZaRoYOtYkrL5XaIDb1I+wRV4mlnDIgeh9q9
	Kh6HOKD8G8slZ4jtwth2fimLcLUppXeHb7E7TY3U8KEvGFwccEn5YA7s68j0
X-Gm-Gg: ATEYQzyoJWMbj3/evIVFcsqvlIEfH19EoOSo1FTuZeIL6Qhjpfh8edpPtHzk3ZyU/bb
	UaZKJikp5x9cDux4OoLw4fwa/6KONCOBWBAru4RBUKZjtFdn6GNGzNh/QDLuUQYHP4wcvS0fryf
	KpHb5G9jlVs5eI5Gn6sUVI4qSEyZ3eogRkLySwkILzc1Q2eaS3XnhybMqEptc2NfJleTb9J2gY4
	TyE6WvKTWZ9eS9yDLMbls0Xesi6pR6YNBA5Y1nENBBCJSWr+kgGXwLvd/BMJNxKiJsVlze762nP
	z4OXWUgNxRGglr8Y0xLvhY9pFbqZDpN6TcUIP3tC8uJ0ALbK6zAhsbgJPrTmoe023hcSZOWjZ0N
	olaLwlwQ4ubUQW7mNdK/OS1+D36JpG2uYlU9fPzIFJHNw5Xag3LwjAgNaLjEHiINj/0K2piv2SY
	m6cG4WKlLcSRrltQaQTNawkUwpoLAsEtyE6KdSPox4Agg1JiPwXlBmNv0RqxlU/L0EVz40W7XuD
	l0FukBdGrQC/qJni11Y
X-Received: by 2002:a05:6214:21e8:b0:899:aef1:139f with SMTP id 6a1803df08f44-899d1d56c9bmr28387516d6.2.1772176280213;
        Thu, 26 Feb 2026 23:11:20 -0800 (PST)
Received: from runnervmnay03.11pwefhiinsujo4kbf1egfxbic.ex.internal.cloudapp.net ([64.236.144.99])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf678156sm463662685a.18.2026.02.26.23.11.19
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 23:11:20 -0800 (PST)
Date: Thu, 26 Feb 2026 23:11:20 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============6804547403232544878=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_v3_0/8=5D_Introduce_the_end=5Fsyncfs_option?=
In-Reply-To: <20260227055538.2334916-1-dlemoal@kernel.org>
References: <20260227055538.2334916-1-dlemoal@kernel.org>
Message-ID: <177217627949.2936.4433595798401846609@runnervmnay03.11pwefhiinsujo4kbf1egfxbic.ex.internal.cloudapp.net>

--===============6804547403232544878==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: failure

For more details see https://github.com/fiotestbot/fio/actions/runs/22474967521

--===============6804547403232544878==--

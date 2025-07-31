Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDBC2222CB
	for <fio@vger.kernel.org>; Thu, 31 Jul 2025 17:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753983274; cv=none; b=uwm9yjZDA7xRcEAn5MKVPqsHv+VGwmiyuf1+trXk1Sw9+KXHxI4+dYE1zI68Ngpjg02iETr8i2uP5mcVf+f6+GssDtFhxTpiFPRtfJHxwzGHY9A0WUiZGJ9Wg3bFEN7wazVfQ6aJw74P07TgLiw3U9K+zts35czYrBZe5PJL8Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753983274; c=relaxed/simple;
	bh=dpq/7g+L/eZLGb1EI+V/mroRTOD8nD4YSQeHz3rd1HI=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=IG/4p8GiLX3j0iifKJTnWtabFkiDJm0a8Z9P8YaBSAXdybAiApZsPbeO3/N1HsrHP8SqnNLtyciB4SSq+CkMYg+W6dZfT8fdWnnSXxEl6rBME3sCx5UChc08v33jZzwJ1GqC0kulgt6t8Yq73+4tVaualQmTZZotnvgrDZRiCoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FFmojb5n; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FFmojb5n"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2406fe901c4so5576345ad.1
        for <fio@vger.kernel.org>; Thu, 31 Jul 2025 10:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753983272; x=1754588072; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dpq/7g+L/eZLGb1EI+V/mroRTOD8nD4YSQeHz3rd1HI=;
        b=FFmojb5nvNA+RY1dvf02TUy3+uDTmyvAxq+1kaKyhFV28rrTS1tcHgrYP3QtBjMMHz
         7NxoXo2SYP04sq5IBNz63UZY7Ge+Idf+ktGD3oZ13ITiG973gZfDJkAFQlfSrFSGqAih
         6dyFKNa+OuJThbWu0p7PTyFqw8kpIFbyM2MozoiPD5TwzQVYx8OjkueYh67ai3Dg8dcl
         QKdqfsXvcXHls2tLdNCSJzYl9mYjcYUrT8L29KiTVX0XCAeGp7fTV03ckprgWnIKvhso
         32/oa4jZzRSxLH4XYLv7r1axLLuNCxPvxXfw0pcbyhbBHavWYhvEhX71Bz9VIHsAHBig
         cjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753983272; x=1754588072;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dpq/7g+L/eZLGb1EI+V/mroRTOD8nD4YSQeHz3rd1HI=;
        b=tXEDlAlO4wGvRhsAvle25cyIbHBm+3HWhuY3/rkmJcaJkI3ovktasr/Gq9cxrXmZHC
         fsTzKu/oD8ZHiXqfr6MZl7lhNu1Yf71IxzpaEuoCtbGLJipDrfPGST0usBN5GxEWrk2F
         EfO5OhS12HRRcRK9/AkGXOeu6lXXgEHuYB+QMG7XQCoU2OZZW70YrLwuxS1FK6RPKf+T
         XJe3GhYSLRTPVD/Rw0Od3KGhLzPbttQ53lf4vw5cEJQyF1izkImxpgw9yQ4MV/m/NmO2
         uhqswRUtBNt2O4FC1M4mB+OlLEb/zg6BzaQnfknKI7Ir5bxqU601uGinRin2ZLMrXqwe
         XqVw==
X-Gm-Message-State: AOJu0Yy88U/LMpfReXbpoiGLHZ45fqx6LZf90lpvy7lX+NQ4yVM/vTFd
	U0YQwXse/ke0YFww95cfqfM8aKMqdibzAv3YijwxfNKAJ8ibGbCBaneHE6MA
X-Gm-Gg: ASbGncsK+45/crbGwArLs57jC1CL2V5oIC3hsaDaTch5nS9UDCUg8M5taGHJ3cbkKg9
	ebvr56/EriQBAbgzBCxJjvBGFFJ9Veq1hUVZufC2CA1XPKs0CBnRlucupwbg49HyhiiK4xMCm0u
	3UARr5BUcvT51GL8ATz5/SBhbPoU0TcSFU60OkF8dcuQBEarX1DMFjFtzsW2m/jYmHGyUcsimEo
	MLH8J3PHP2gCIGEia2NMRJT9XNh0lYxXEzXgQewH+vAZhCF9SvmuHtD5Qo1nZ0CY2wkFeBIoxhP
	Aev9LwVfuryVBQFLrD1vgbUXxIEDmzW6Aaw6xL715ICxcO/YOnN1ZKtimAzyX1T0TGGQ3wPZUQa
	meh8UAIrgKROend0zM0218s73bVMKfq8D4cXkKcQPH6jcFWlQ2UeAphaRojScZU5G+lnqQFqHnc
	MwBRCw8FK3xrGEhAVjfOOhgqIU
X-Google-Smtp-Source: AGHT+IGYBSO6VZT9DAlHmec/MNNvXoH+cLwCVQtPY50+jPcxFnrur4Dgyv4lwr6OOVnUGbl7lNysLA==
X-Received: by 2002:a17:902:fc48:b0:240:5549:708e with SMTP id d9443c01a7336-24096b58964mr103911025ad.46.1753983271718;
        Thu, 31 Jul 2025 10:34:31 -0700 (PDT)
Received: from pkrvmjbmru5nbw0.2fvbbrm5ht2erfgp2g5ajppu1b.phxx.internal.cloudapp.net ([172.182.201.163])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef65d2sm23033905ad.31.2025.07.31.10.34.31
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 10:34:31 -0700 (PDT)
Date: Thu, 31 Jul 2025 10:34:31 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============5895245494588416844=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_1/2=5D_filesetup=3A_make_longest=5Fexisting=5Fpath=28=29_static_and_const-correct?=
In-Reply-To: <20250731122011.539660-1-tomas.winkler@sandisk.com>
References: <20250731122011.539660-1-tomas.winkler@sandisk.com>
Message-ID: <175398327071.2702.10905516177775066660@pkrvmjbmru5nbw0.2fvbbrm5ht2erfgp2g5ajppu1b.phxx.internal.cloudapp.net>

--===============5895245494588416844==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/16652224455

--===============5895245494588416844==--

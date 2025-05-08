Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE172874E0
	for <fio@vger.kernel.org>; Thu,  8 May 2025 19:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746733781; cv=none; b=dkHNGmvY/YTsHzUC6NeQgkTvgDmdmgXKrKgYOnJWZHFwU3nx+oQVCKviGNAyBJASAUsIwoUAnrLUvRiCQ8TR9BAKYR7zSMbj0MiVECSYsXwsEZG6DjAIJytAd5aGM4QvoXTVGoE4w90W6doxYKg4GM9hVZyqtP/9bVbEZnrkMGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746733781; c=relaxed/simple;
	bh=ORqAVn2/FmLZrYp1++GP7NYTWikTGIYqy8Lq7qnptRM=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=SnKo1PiIalx06bW9gf/Qxk4fh/DMQf8dUcQ1NpA0K5GYcTD9ubkRAhCPsNfj8Wd7c3AE7lzUCeOcRy3uuhGyf/iolpACrDvzI9NUYe2jBVjiIZkmEu/RRTahs/qtvC4Je6zisZH+t5LxTl8rqAlw3zHsPcVcU1HFNS8PPerDWD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ReqbRejV; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ReqbRejV"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-af523f4511fso1103600a12.0
        for <fio@vger.kernel.org>; Thu, 08 May 2025 12:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746733775; x=1747338575; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ORqAVn2/FmLZrYp1++GP7NYTWikTGIYqy8Lq7qnptRM=;
        b=ReqbRejVZyDiCLmEJnMSJ3hKAzUB6ciJPSPOY5f8RSROcs+gh4dnnLmIh2fFcp1cWZ
         5I4lMxCUaouuJwydvBRUtyVoEi9UV4iUnkpsMmoCGB2r1j5sCstmZFdgRrSISljNVF5+
         k7ItZerBRJ37DYN4jJv8oBvljorl8Ag5fuuQ3RGtIJ5bZZ86il3kKv70aRmUYeOpjpDh
         MROCSAXRS5C2Cv3bB/ftZ8iSlu+eAGL3xb1H/yoSnJLzGWhsmRSgaYqBkwtez9i1KgLw
         rzijpJfAb4v2HwYjvh1t2c/rW8HQdziN9yAe2TOHmgTnsViASCE8dgpBX54GDTD4BJCt
         NBKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746733775; x=1747338575;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ORqAVn2/FmLZrYp1++GP7NYTWikTGIYqy8Lq7qnptRM=;
        b=wnOHixy5S4wbZTbyz0S86i4SsURFU1L9jcoU0Muld8UNTlZP2SUpIjU5WxRnmrVzC7
         2oa+V35IfQTjzgQfVbpBUSJHA1jamcCQt3YX06bj97o3TQNKewZdO0YzP1vmErsCZoQA
         MByL/MadEXL3dqVzkbP6iTHqsFBVHaRzBBs60MAGJYF4VXGzrXHB4J6/Db3MLn1/IfsX
         YKZgWe+tSn/Fhq9Y2EAAb5TxBW8OOd8a225qq3jW4OIIkY677NXBYA6dbXMyFnOgmJcn
         7mcSiaYUuVpAOCOipsOEa+G6hH7yiCSpBqRPL+QLXWLMq0UKk8OWjLfJdlAwRF9nuogG
         t8gw==
X-Gm-Message-State: AOJu0YzGzupFdRxspXTpp4Sq1aruH8wEN4JR5J1U9f9tJbfDZ840578M
	G0NrgoIvzGoEJfmKmK5HIDkjD4bKoJqzvsO5Xc+N1ewV79aHWsI4iaA0
X-Gm-Gg: ASbGncvCWIS+hbZvSed48xHGQ+ffl6GMlx5DX7zCaTMvfvVgCUVn+EI3H5M83dFUgCr
	/tQkXKq3buA+ZanvmweR+RCiHmXzsaBvqhnVbkTT4/X87ptD4LHZKoEVb3oeW3rVvA8W3+qZJBt
	Rks32iSuW/wPphsaUxaCgkByV3Wu9nKSWkOrQfbf/bvnQ8uLTmIQUDfB58Pb/msu+jT8z/efSCf
	83Nc/S+sXj3HstDx+LkNlmgMC6JB4UxDktvboF96R6gmJ0WQxGMC8n7J5ejKupxha84jrIJ6dcI
	gR9jkQALRaDky3XF0/00YB/m5fR5t1pP2qn1Vulo
X-Google-Smtp-Source: AGHT+IGIskYZ+DQRWDxAAi0XH8rxpL+7+DimWEvA2GjdQJrPue4zroI6993zPTbccCRPkaFLVf72yg==
X-Received: by 2002:a17:90b:52c6:b0:2ff:592d:23bc with SMTP id 98e67ed59e1d1-30c3cafda2emr1199904a91.4.1746733775125;
        Thu, 08 May 2025 12:49:35 -0700 (PDT)
Received: from [10.1.0.132] ([52.234.41.116])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30ad483fff5sm2887143a91.1.2025.05.08.12.49.34
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 12:49:34 -0700 (PDT)
Date: Thu, 08 May 2025 12:49:34 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============8332210412640817891=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_00/11=5D_verify_pattern_interval?=
In-Reply-To: <20250508185832.3702-1-vincent.fu@samsung.com>
References: <20250508185832.3702-1-vincent.fu@samsung.com>
Message-ID: <174673377441.2581.14259152939735507019@fv-az1694-607>

--===============8332210412640817891==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: failure

For more details see https://github.com/fiotestbot/fio/actions/runs/14914258938

--===============8332210412640817891==--

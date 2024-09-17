Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6059126ACB
	for <fio@vger.kernel.org>; Tue, 17 Sep 2024 02:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726539810; cv=none; b=ZkBV5h6KfKXrThAVMVU79quELPuyYmTL9dwTggaZNAflhlzZYj4d+ytRIOr10OgT6gTiZVNTBaSQLmTU1GQ23ef+yMshAsUh6v4cBZviK5Bb4PkydviS24gTQSf7noZUGFHnaHzz5Vg5I6ga2zOeBNyI3GI3nh6/NF3UCc9iLVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726539810; c=relaxed/simple;
	bh=MK50eOWSC9QzgB/EEFDeigVOrQ+I1XvCk0eW2ps0bxA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZnZPPINnBEtSrGs3eBkP/5wiCknxyYdnrWx8dkjQHPdVNoKSpHDyj+GrGgAjw1O5Cp7FSu5qAqUFGmEkSjOEHNmXae2yjD0F0PXLbyILa/pmShulkcjuVXJnhWFCuBxCsHmo+7ArLja7ZdTi4cRgz9G9v6YGhGAxMeJIJUiNmlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hUy4p5E0; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hUy4p5E0"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-42cb1758e41so31917195e9.1
        for <fio@vger.kernel.org>; Mon, 16 Sep 2024 19:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726539807; x=1727144607; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V7ip2yZfRwMn6DrO3JmeaNjFBfSVJ0A+GnwbbMfaKrE=;
        b=hUy4p5E0j4YfsdwxLegzdMRR1e+Mya+WgZZBhaQxuL6e46r90oC3iLPY13hHzPfMx3
         ICpqpMJlyiCRTHr1P4nkctK37q5XM5/hdS4JrYlaAaF91TW021jfergI25MtM0AxEyqV
         pS0T57MlEJhaKhRKrtwGkp+kTTWN86s0UALGUQb4WbKIYqwzxbakSR/T30PAXpG1yFJw
         htAnqI0J0cTz9liQXcELqptlS+xPx8Ykr8qhAlayWI4FJ/7AkJgeVo486BHsIE5Qx+Ge
         k6M0uX5A4WbCq1D9OFx7tVt6qvzEYECS2cYVHkV57lGemCEThPRECQUymGyB+7TJQLnf
         opag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726539807; x=1727144607;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V7ip2yZfRwMn6DrO3JmeaNjFBfSVJ0A+GnwbbMfaKrE=;
        b=LIZCav36bT1PPwVuKHdpfiik5bhfTbNyHaDKkXXcN/13Lcf+FkoqalBMsBe5w/RuYA
         weLTcv4rHEfq5xGPIAsJG0EH+AjsfzW64gzVlcZ9QzuXytiVmfkL+6+3085mgydSbWPH
         7h/hoYpKll310AUMlbUDW0tX4bW+QKvNjeBetIbfOlQyj0Ii6HsNeUGhuH1N/xgh06vd
         JAgBhPHY+rvokHzhKQZbNOt+XPKHVaxGTL/X1HfFlfLE10qU72tYg5+0SWmEVNzY92Oy
         bYun3Y+NXrIICQfSSOi9LHGTrFnbizGi5F0xjjfdA8eKK6UMPMuexrmDHzCOCTsP6XTP
         GlTg==
X-Gm-Message-State: AOJu0YzKxwpiI2xhtCE1Y6pSsU22ghUjtIKosSU8NSods9Si5ko25r15
	UM+axlfU0cEEizz3hzzuoYOkqsP+JxztN+eKE9ujBpRcHnlCW3Gq5Zvzfi8f/2I=
X-Google-Smtp-Source: AGHT+IHvBkzZY+xzmdDVPAqxuNk64PcGZF5CLQiFrSNS/XmkAZb+JOwshhN8qgP2cgcb5ip7CL30Gg==
X-Received: by 2002:a5d:6d84:0:b0:374:ba83:8d73 with SMTP id ffacd0b85a97d-378d61d5179mr9024810f8f.8.1726539806485;
        Mon, 16 Sep 2024 19:23:26 -0700 (PDT)
Received: from [127.0.0.1] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378e73f2001sm8355460f8f.48.2024.09.16.19.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2024 19:23:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, djwong@kernel.org, mcgrof@kernel.org, 
 alan.adamson@oracle.com, david@fromorbit.com
In-Reply-To: <20240916165347.2226763-1-john.g.garry@oracle.com>
References: <20240916165347.2226763-1-john.g.garry@oracle.com>
Subject: Re: [PATCH v2 0/9] fio: atomic write support
Message-Id: <172653980552.75199.7258206217332889604.b4-ty@kernel.dk>
Date: Mon, 16 Sep 2024 20:23:25 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Mon, 16 Sep 2024 16:53:38 +0000, John Garry wrote:
> This series re-introduces atomic write support.
> 
> Some time ago support was added for O_ATOMIC in fio, but O_ATOMIC support
> never made it into the linux kernel, so fio support was dropped. However
> some plumbing was left behind; specifically, we can still pass command
> line arg --atomic=1, which sets thread option oatomic, but that is just
> ignored.
> 
> [...]

Applied, thanks!

[1/9] os-linux: Define RWF_ATOMIC
      commit: 5ba34480dc222db47d7813009eb95a7543790dd3
[2/9] os: Reintroduce atomic write support
      commit: 40f1fc11d4fc6dbbd3c0eb5852e24126dad5fd4e
[3/9] pvsync2: Support RWF_ATOMIC
      commit: 80226c53d994e8a9206ed7acf4a4dc75a8691792
[4/9] libaio: Support RWF_ATOMIC
      commit: a79319fe6efd138ae346aff28b528682fbed0a7c
[5/9] io_uring: Support RWF_ATOMIC
      commit: b1552b6e655dba1b1d4957c04a19361654ab38ad
[6/9] tools/fiograph: Update for atomic support
      commit: 274a69eab08837e4e32185f2944e3b98dd5258c0
[7/9] doc: Document atomic command
      commit: cd3de3d7700294f28d52cc781d1ce3982c12ba7e
[8/9] fio: Support verify_write_sequence
      commit: 2dd80ee4598bcd69d1413fd2f1205cbffb56d787
[9/9] examples: Add example for atomic write verify
      commit: f23208c8860de515f025af6ac34d6a227f277e67

Best regards,
-- 
Jens Axboe




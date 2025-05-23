Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3024293730
	for <fio@vger.kernel.org>; Fri, 23 May 2025 15:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748015214; cv=none; b=X5yp4TWMnjvkuz87KQsWzmjvHMVEbN3kPHfW636Jgvj2t18uQQjGLFl11hkimGppZQsiD3ntC/295sszul1ZYlGo3vdvd0wSPk65UnC9B79GuTEj0GnaqTT+Oci718MJDiCqnRn6FJbkM5brPs6o5f6c0AjAF+6m2jAOlKSWSeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748015214; c=relaxed/simple;
	bh=ZhVmYAqp1NvV17b16R9zt5Kuu9a33yk3/CNPhm+JBCg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=d3GRh4uAq+p7FdQNTAztG4pBMhwjyOgN+lyTC8bdvc8Sn3cKHG3uoghQziSyjHR8o7TCpQGeEg6BGiiB1H59N0/LgC6i99GIjNejSEuMXekNQYrK4sNqCZ16xWbNtGtmPO+a4K9ZJhaN7fCUwkk18bNl4KIYP7snwJml6udqZBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kwbb3bzg; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kwbb3bzg"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3dc73b1bd7aso127125ab.1
        for <fio@vger.kernel.org>; Fri, 23 May 2025 08:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748015211; x=1748620011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=govX+mddcRi1/xwrMm5J1kbB2vmNe7UMYcP6hD6R2nk=;
        b=kwbb3bzg0ZWWu/tCpZZ+Pak3v3trOA1PvlbWI80LR/1p8a1e2RFp2i0t67jAEto81L
         vjkRS0hJEQXix+/Cyh6OR+3Wnc/2tFqeJlht5bT+Si+5GI/oX04I4Bj3uQmmNu3Kgez8
         sbgo/vNp8eeysooGz8n47mtdvYQMGeIbKle6mpRCCC3vQZ8Kx2BQNoHt7nHYBtf1u84O
         HDk5f8UyI12K/rmIJCoYZ+exqAfz8TugVx7t2Uh0r7iZYyb8BfXYPRs4naZXdrvu+opz
         9zTBVUYpzrzjpZ0Z2XyMLFuFJeaqPzVxhEXtlCU4v7Efw0lqTAxe14Eei81MrZMCRYJZ
         pzww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748015211; x=1748620011;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=govX+mddcRi1/xwrMm5J1kbB2vmNe7UMYcP6hD6R2nk=;
        b=nllP1XGlrbKo/KxghHGMWiTAGMssfw4Q4w5OOkPVj5bDoqkdm/OVNupLICmILNH0+g
         wPSLbqa85oqAVTW7jQaYxU0m7QHVPoRfreYiotyRwyHFcF1rLPgo3WAt8waK5IdiyiCd
         kO9NXKidmsGqyqk1jwjb4wDax9B8jjxnksAZ0i6oKj2rvwn/YxLR9/yN8pQ219Zkk8y1
         vaE02rIlWPzN4gkKxwh8LiqdZOj5PmeQ6c2J0NnQDBTe7dmK1VDH69pyP1SCRXLAgUFC
         FnI7C97fi1jcME6ICrSnCuQ9qGnvT2O6Nle2ImuygCvH16swDmRAa6LFXDieZeAPVvFy
         MPCg==
X-Gm-Message-State: AOJu0Yy4MRNqPsbsamon9nyO1bI5szZL6sOcMdnDHC1wJUUQlsu4hwgB
	7cYq41klGGLC+vOoLf2vz6w8wX3hsnefg7adIxSc7642tS+fRvnlYybnd58b3UYlNRE=
X-Gm-Gg: ASbGncvYFJ2U7sxagF/K+G+nbWzhKqT/67ux32m3KBkcKxhqnWoBRHcpLoHhQt3A5k3
	fd/d6eZpjitgqO/+z3LibXxN3vfWch8E7HPDvqzciFmzimBU0dOKMCNEsUl/Vryzwo5h5dfi5Ns
	/OIEjgDlASaSJd/FdHtvrm2U7yAvS2OHEM/31Qdo8US+/n/6yUxDAh/vsyswDgc8YXQ46srVduW
	K/eDy8/UXulZJTpPO8czCWVRXU4DJRqlEYz5SPM+/VvwxvKScWIILlUHhY3y3KwzpI/WlutDcdK
	Obtg2DVYwVmigHNhS+dAKBKaeJhsRJCCHy0DzAJXQw==
X-Google-Smtp-Source: AGHT+IFD7KgJdYAEr1srT8x0jceTYUoGraccMZbqezAYloji719SmQgwiakeobcI/xLTBQTywXd6pw==
X-Received: by 2002:a05:6e02:3001:b0:3dc:7bc9:503e with SMTP id e9e14a558f8ab-3dc7bc95208mr174704465ab.2.1748015210784;
        Fri, 23 May 2025 08:46:50 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4eaa3csm3596524173.143.2025.05.23.08.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 08:46:50 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, vincentfu@gmail.com, 
 Runa Guo-oc <RunaGuo-oc@zhaoxin.com>
Cc: cobechen@zhaoxin.com, tonywwang@zhaoxin.com, xanderchen@zhaoxin.com, 
 louisqi@zhaoxin.com, runaguo@zhaoxin.com, leoliu@zhaoxin.com
In-Reply-To: <20250522104032.17519-1-RunaGuo-oc@zhaoxin.com>
References: <20250522104032.17519-1-RunaGuo-oc@zhaoxin.com>
Subject: Re: [PATCH] Add Zhaoxin support to enable tsc_reliable and
 arch_random features
Message-Id: <174801520980.1284246.14557236446849527284.b4-ty@kernel.dk>
Date: Fri, 23 May 2025 09:46:49 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Thu, 22 May 2025 18:40:32 +0800, Runa Guo-oc wrote:
> 


Applied, thanks!

[1/1] Add Zhaoxin support to enable tsc_reliable and arch_random features
      commit: c348db31ccce60f2808dd84c1f43f36a1556141a

Best regards,
-- 
Jens Axboe




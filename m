Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DC721B905
	for <fio@vger.kernel.org>; Mon,  2 Mar 2026 06:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772432727; cv=none; b=fZGujEed0VsISUeces5v/tEPVtvdgmWCmmDGo1ixEjhy68I1OpfwuCnIbkPUNft7H5sbD4YvwfKdiUOXheYN6IFpEz/7qD7HBM09KCo7EbuSGXk3GthOcvJYW1qrYHtxkwvpUlX/bZAbhZYvmofsjVE/r8fwWrwt0mfdwb/G3vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772432727; c=relaxed/simple;
	bh=y8lV2Qe+P89zS1RasloqZRxAef//2VF1jAAZNt9mSB8=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pFSFw/Pn62JzBGG7xAjlPgqfPxRGWnaWn/8tmaEMa7vay07q94h1ZJjJ+AFgUeGd2OxjHuZRmPyD3EkpOzIKz0sw4wHf/SYeNSRcMAQ7FiWjI3M49ouYuNyv/GUrKp+RzS+vYRzFbV761vGPxBy5oE0o3fArHZOQo+hc3VGrmnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dxEip6W5; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dxEip6W5"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d4c85307b2so2934530a34.0
        for <fio@vger.kernel.org>; Sun, 01 Mar 2026 22:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772432724; x=1773037524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PTK/XgTxBFHO0YVKdsUaIQWTQ0Sobg9d8FNBHrdshHQ=;
        b=dxEip6W5Tos5zSqlHlFQ4lUMaSPV5vk7h946UuUyrElDOItvJYlyHfpT2VJ3eD8J0Y
         a2CkVfiFADGz8ShLJZ2m9NgmFU2cYCgDPQ+e1GTKnBm07IzxhQy37bFL8hPMrSL1tIkL
         tTJ3+lGpH5rOYioEPdwaFCjxXpZfK5gr7ugmh3Yf4NPUZdbE9ldrijU1PFThrExlN0OX
         7F6wQfKESI7NLOLjiZBw5gwAjUGzq1GV6m+5BUanhMALAzEEt3Wb5DZlxyLoL5RGgwNg
         32Xr07tFqe5aP3zyXpGcJAj+yq0QN/Ik40+zrepej2Q/SwBgn8u9Zb5yKzEpnTEtD8YP
         PdIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772432724; x=1773037524;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PTK/XgTxBFHO0YVKdsUaIQWTQ0Sobg9d8FNBHrdshHQ=;
        b=jFN/l53BY/7ihdablS+Mbz4sN8kv+QINl2eaQp/7nynnLoVOmzPbx66htYSCCPTdWg
         iO+je74PKI9gPkGWw8EliYC7TVc65p4Ow+x2KHJzkumygeiKc6S8Sgmes/dqO+RiX68j
         ItTD4QdTPGaiscGi/gbUqltHs28cNKnDbKsMlLJHdgcFDfaPRRSYubuD6XIdMvX00n7E
         ar+V0J8V+Mh4TfHGeINf4NrCOWl0JNUVAISg0YRad++FPEMuB3GMnfmVrS4ch+OWKvCK
         ne34oFkWBACFC9H31OlJ0qt8xxwoiqcRIYe+JeaFwpz4ZbxGBWxLtxWiMyb1bsAui+E8
         pSZw==
X-Gm-Message-State: AOJu0Yz4cR241opGsuQiPLYZ7srRfRR2+EvZqm37JwV46H1ki6r2+gLA
	+3yrxcwBds+sJqm28L7EdEiaGFMSBZgWuN/soogBB7Uj2A+jj5zX6Dz/ycHLpBhobgZKEwr+HqH
	Ga01M1ZA=
X-Gm-Gg: ATEYQzyqA91/Q3J2maW1K16Mje2jgkJa2M+TUPzNMJTnyL/iHXKuLPjio2WaD4qmssi
	UiDwqs7aeqxCW5Y7a2dZJSR02CA+GmXWd7OfJIVFhUIldBg9EKC11AdRwohXtuL7ZDP2pGigfQj
	KoDPp3BAeqKvgm9AdCoKy5RBDMrvIg++H3s1xnjXChoCPBfjafaorwxyaIE37dnCnR89PwPs2sP
	yoNK+3p6N2PuhILg93zaFZwT9Yv97ZF2GcROGkr9wxaZPixirnfZufPLVfE1QLgm6cNn1Uq5wlm
	X40rB0kXqW85ms7WjhVBkvT73IMQVVPUiw/Xxziiy51CSU5aBVALL3lAWW9UfDLG0S7vPX6pARK
	UQwiA7r4tcqCFgsC/hdF6mSXln5t48m7lk6qy1zIqXAitA7ALW96pN3AluDVGlFI9RRGPcUHSYO
	02xlORj7KXykjDT0O1s4c122g1HUNZv5vIHnB0zDzdqsmrvmB+ZtYRWidmAm0d1oqq0jvUoEQZ7
	kTs
X-Received: by 2002:a05:6830:2105:b0:7d5:17fb:6af6 with SMTP id 46e09a7af769-7d591af2b73mr6604507a34.2.1772432724126;
        Sun, 01 Mar 2026 22:25:24 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d586625e4esm10103371a34.15.2026.03.01.22.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2026 22:25:23 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>, 
 Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20260227080712.2422380-1-dlemoal@kernel.org>
References: <20260227080712.2422380-1-dlemoal@kernel.org>
Subject: Re: [PATCH v4 0/8] Introduce the end_syncfs option
Message-Id: <177243272309.70160.13155028457561830604.b4-ty@kernel.dk>
Date: Sun, 01 Mar 2026 23:25:23 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Fri, 27 Feb 2026 17:07:03 +0900, Damien Le Moal wrote:
> Jens, Vincent,
> 
> This patch series introduces the end_syncfs option and adds support for
> it to the main IO engines that can handle regular files.
> This new option improves the precision of file system benchmarks when a
> large number of files are being handled.
> 
> [...]

Applied, thanks!

[1/8] fio: introduce the end_syncfs option
      commit: 4d3aaa40f6a85112a81f3c3a0b1847d5294a1634
[2/8] engines: sync: add support for DDIR_SYNCFS
      commit: 53a8cd6bbeb785c63472f8b6c43e1b1b2adb99ef
[3/8] engines: libaio: add support for DDIR_SYNCFS
      commit: 1029cb755006b7196cd6e41868c145924837fe8f
[4/8] engines: io_uring: add support for DDIR_SYNCFS
      commit: 126e0100aed69c5a142d1a77124b8d67bd9dd5a8
[5/8] engines: fallocate: add support for DDIR_SYNCFS
      commit: 95cf3a61065f8967e249c8f4b0f858ae10972293
[6/8] engines: fileoperations: add support for DDIR_SYNCFS
      commit: 0ffdffe2b08766e4c1d07a351c9fd05f2fb2356f
[7/8] engines: ftruncate: add support for DDIR_SYNCFS
      commit: fdc5efbcd9ae636881308a9a7175d745999dd2ce
[8/8] engines: posixaio: add support for DDIR_SYNCFS
      commit: a7554ee21d3f4a799969da2e54a66e7081c1571c

Best regards,
-- 
Jens Axboe




Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566CA3597B
	for <fio@vger.kernel.org>; Tue,  3 Mar 2026 05:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772514322; cv=none; b=jf6mEcV/4W1LqCvCrsnTXlPDWh2mRb0lf8oUe8ueLUxYKV23Efc7DECcYdm/wdsQEgMAQL+9eIb7okADnKf84RDCwBUVIud38pRvn/L2jojlkboQzjEmjkEf9dLDlK9p5wjpRqoYGw1LvIv8QlkXAd/zXaPHS3fSwpe42OX045E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772514322; c=relaxed/simple;
	bh=xHkvhRB0E8rgjl8FyuWVdDunPm7f6bC9utkZlVWlBu8=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=f1hCu7Il+ZLO37bpnAYWi/E8q+cJMT5EPT5kMOpA415HccoKM4SlWF7m4tWhxjGypgRuvaWOLKmqgpQRljLvrMIDT7urOB9uJo/WUKH78JXuJrcjwNcmI08pTfOHaeRKLYFI3f8yOVyGPaXM/0bF94FEmtubV3bOHng0PCCdz4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MO1X3ZP2; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MO1X3ZP2"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-89a000f5adeso25129376d6.3
        for <fio@vger.kernel.org>; Mon, 02 Mar 2026 21:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772514320; x=1773119120; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xHkvhRB0E8rgjl8FyuWVdDunPm7f6bC9utkZlVWlBu8=;
        b=MO1X3ZP2zhMbb8aJLtDqYa+owTt05XRj0KzHKGcwt23vrseFtqaJacC2i4gvL4acfl
         4ZTt6G1zeDsHzrSp9+83h3AdFqdIN9SUEeTviGttEp4hFAuiju7URq0ROQXP8H8+mK+q
         2XUOJ55emU5/Qci1M4QJktMCae/FVMLW4POvwHAkuFgczfIxlJN2PmmpL8HNrTJTYclV
         rj2eEBPCu8buY5Xyu6ObO0P0chtJXDNsNasbqyz7Lr1cwctCHpUkKiFEu8klO8+3BnKl
         Nq0ujGctUlqjpFgfueXuSkTqKK61uiedT9hvl030L8NSqx+E59sz3LeBOU+iDv049Zwp
         MFXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772514320; x=1773119120;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xHkvhRB0E8rgjl8FyuWVdDunPm7f6bC9utkZlVWlBu8=;
        b=p6703Yt0jC6WPuxlIXCgGybxISb+1ZKM2C0Y9ji744ezw1LytO9u8znHt3dn0w6+x8
         YjPU70R84LQyK3fmsp+hTq6ybWGMv70iD6u/ZC4uIdTRYEYq9Z2Ah8RgoCJa7s8n/5DT
         wIeM+uWCGh5kC5wX6rS3MkEnfK6cpZvx0ta+XbEg/kc4jXKiO1NzmnirVPAzIptV9ZeM
         YIORGmeVkbDDcy+Febj2VNRqztGVkP8qN9DUCZqbH4UhXn2coT5G0H+NXbMP7CvXHzm2
         2wrOMMueGGIoIu7Sncb503d+ogz81iDzV12N8G9laqBFuMsS/IMkPkz5FZ19UI8WXFE7
         1cRQ==
X-Gm-Message-State: AOJu0YzOxmIUwWTbEajPwic4iQBQj5UP7F+tiZiw8JJaBZ5ri3Smz4Za
	riD3B/X9ZeVwjE3MpgWqlaf5de2DZqNRkngdjLhlznXliX2AXO/tZjtf+dIO
X-Gm-Gg: ATEYQzytBDiyVmnljvQbK3H8DO0SG6i+URfpmXhxeW4B7+tuYuJiE2pICiZgFgh9xHl
	pLbwf3AbGhlghs8uQiv7ga0a2EgEziL+nvUVnpDudol0At/FIJJS/P1weAECUs8roNcnvbasKVO
	w9gis/bT57kPGLkrtioLg9xFSv92VOjWR7oRjTHV9Zn185cwWXuEN19vM13mSnCgr+eSz6Ki6Gn
	JgNqxNnkvKs6Xr09ZKam2Nd8iMQTfgl6URvVvGJtrHVi3WHIJytSOiECG2CyPtCmbnTRlF8ybWS
	XKxY8rVq62SVM9VqmszJRzZODmB4SNNSCSjtUNNiBTA6o5dUgaHdpAyYiCtMAe2K0diYBB9t7bW
	U0toKxh8tR3JTpK+30SpiJBg1aYOYwMu4KIQXHf58XpOHLwJV0cSitQhZF/XPY6f2CiM5kwOIh9
	UYJr038A5IBahqwOhdrai2slxzKrBS1xra7lsLm9804wA5goALYWQkIwdaKGdkfWq8Dytx/+l36
	bVtsO+T8cbjlFQLbOdvACg=
X-Received: by 2002:a05:6214:529a:b0:89a:b94:3cbb with SMTP id 6a1803df08f44-89a0b9440e1mr9005016d6.22.1772514319914;
        Mon, 02 Mar 2026 21:05:19 -0800 (PST)
Received: from runnervmnay03.xbqmit5f5f2erozg2hxxbijevb.bx.internal.cloudapp.net ([172.174.223.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a083a95fbsm13372956d6.38.2026.03.02.21.05.19
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 21:05:19 -0800 (PST)
Date: Mon, 02 Mar 2026 21:05:19 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============5862524193917957228=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_v4_0/8=5D_zbd=3A_fix_problems_of_random_write_with_unaligned_block_size?=
In-Reply-To: <20260303013159.3543787-1-shinichiro.kawasaki@wdc.com>
References: <20260303013159.3543787-1-shinichiro.kawasaki@wdc.com>
Message-ID: <177251431920.2966.16379380951101332102@runnervmnay03.xbqmit5f5f2erozg2hxxbijevb.bx.internal.cloudapp.net>

--===============5862524193917957228==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/22607237700

--===============5862524193917957228==--

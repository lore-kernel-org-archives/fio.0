Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2ECD40F73E
	for <fio@vger.kernel.org>; Wed, 23 Sep 2026 17:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790185500; cv=none; b=IVW3HL0Wmdif2bn8cCKSyn4C6yrlmUchEP7tdyW3mEfgwcCxU7ssAIC5m2RnvBb3kfI1IHGiHbde3TYh1BK056adVXIL3qzizoVOVqQ3mPLIByElMAAivUsen+X8xGY/JvI1C+++orXGmxFPJVNzbGcKrxshsO+sQbeRsoaD8lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790185500; c=relaxed/simple;
	bh=rLX6zotQgV5WQ2sByimlhAKImUsUv2WHseyNqRdKiog=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=n1C6J/TDTJXQ96SJd9sM1U/kS3Fz0ldnz20D/szDfqgbRyx6HMKMkWmQU4QGAO4QIN2Dcumku19KEM+0CBowrxkO5bk2g6VgTHNcSIs0tajAG2tamwkx5bGsIv8LFfuWHqMwd1lKK8dYRU0aPozcPPweegBBRkBfPwYV5tEngiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pOkdLO9V; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pOkdLO9V"
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-939eb3249c1so96786985a.2
        for <fio@vger.kernel.org>; Wed, 23 Sep 2026 10:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790185498; x=1790790298; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version
         :content-type:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rLX6zotQgV5WQ2sByimlhAKImUsUv2WHseyNqRdKiog=;
        b=pOkdLO9V5XZCN79uy4cFx7bH+K92e3ufZs4+lt/B5/xOGI9HuPmOdOHl5ybnJzApMA
         sTgWxQbwUpEM7USy1fv6ZYkvkM36pVbEzjr6MSdg9rg6DMXIuEdlG0D3m/y3lZPfSlqB
         1XojZ1jccn5t0rZJucoM20RBBytvKcAdkSV1pRyjIxO3fKEzSqDvKaZ3DwyzoePHLPqN
         IxA96Id9sLaHAipRikkmto2vXGP5Wn3yfUzu3dzE7d8SbvQBKyJxnjaOUZcxrCXwQy7p
         xQT+Mvvp1CcsdbCniA3Yiify63nWHAwECE9OB+HfPw9ViljLsqA0LNQ151gg4LlJmnFV
         uVVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790185498; x=1790790298;
        h=message-id:references:in-reply-to:subject:to:from:mime-version
         :content-type:date:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rLX6zotQgV5WQ2sByimlhAKImUsUv2WHseyNqRdKiog=;
        b=Vs08ZCTHGu7e1q7e4Q1s083FULBtpbmgh8Jehbkc5cAfvvNxqqJhtUI1JdzPE8+YIc
         dAEHDg+I7SrjSj997zZ6yxsuEcIIUWxjdXLxoiLgTzTQoAk+Ywq3/WhabFtJg98cffop
         i31buOa0FnX7FK0X4nz4CyZGCTQ8aWLrDJTfqwACrKjyGC5SH0nDFjdgfleQX7U1TlCX
         4dFmqiLFXpL/XHWoTkdbVM7HH0xixV42j69QZD7SYwC0lEELxpxkUhn6NYaOB9d1Cgmx
         EnVuuUL2PRX3mMrOHNAxLfmcJwaE4NEHGxICgbPSlenrFNVgq0PWahvJCfJUyToCYQR0
         XlpA==
X-Gm-Message-State: AFuF++kl3trR2LvF29elnJG/H8cncPQ67WQ2w1jspwQYmKKmvMryHB+y
	f9XdHTA4UhZYgGozkWtDLD2oNiVMH5T22si8mC/mT+NLuVxXMasvxgrPaIG8
X-Gm-Gg: AYBFou1/L5H8QWwfo4U0ypaOPztMyuip1x7LqV2h1t8yJ/OCBadFlgw1gkGxSYwDDZz
	GnYCzrHCBCWeX1RvfgBNW6e8ToKAJpLAloGFHqXDjSbwaKQEPloWNeR+OPjsgxTgG2LSChj514T
	2MB6p8DR35UM72IPuzAQ5/Gu0yYuMJBEJgRGB8Ki5LzJq77XfQ5yQriB8KuvyCWnzSx1VeTfSIH
	OPzdvePyvjBwQ0Z/9lzgkFOHI5gUmi9MYps9SuTRhnN8TR1vpRf+FBiIWaFY0JDoi0etELVGwO3
	HXUr9SXsRX3Xs5pDRwdXj523HQCVASLceAP6mBDxaljoQyvcbjS/9i2zGfJzIhWRKYVSEYerNRm
	c5u1j7ryxizeeP/ZbcLxZsu/0HzmiaswDDj85kEnvfmYN7m8fjLccPgKKsbCExsuO41YCXlI7BL
	897PGTv+voKBJ2hyn4J5mhN6hDyNsS2auo6Wh/X63/XH9KlLnpEdbB8f/e/dodYYrtuA9ji1ZKm
	DpbiPoYnMHIUUKRfBOo56bC1Cg8Fmd/bcTIHhMn32uvnyaCfs02xVbyWoz9SbvvHoi7HMs=
X-Received: by 2002:a05:620a:1b91:b0:93a:583:49db with SMTP id af79cd13be357-93c251af744mr491011485a.39.1790185497738;
        Wed, 23 Sep 2026 10:44:57 -0700 (PDT)
Received: from runnervmlun5p.0auhaxe53pruloeser5wrueatf.bx.internal.cloudapp.net ([57.154.232.218])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb1e29a8sm24445871cf.7.2026.09.23.10.44.57
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 10:44:57 -0700 (PDT)
Date: Wed, 23 Sep 2026 10:44:57 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============0110494319210511088=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_v2=5D_examples=3A_add_mobile_storage_test?=
In-Reply-To: <20260923114314epcms2p2b46e183f11d17a26e8e055132a47bdce@epcms2p2>
References: <20260923114314epcms2p2b46e183f11d17a26e8e055132a47bdce@epcms2p2>
Message-ID: <179018549711.2673.5673953740739366952@runnervmlun5p.0auhaxe53pruloeser5wrueatf.bx.internal.cloudapp.net>

--===============0110494319210511088==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/35864168491

--===============0110494319210511088==--

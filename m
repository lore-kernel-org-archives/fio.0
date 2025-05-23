Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4FC1A76BB
	for <fio@vger.kernel.org>; Fri, 23 May 2025 07:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747985906; cv=none; b=hQOT0mIA9oSir8xAHkK5rxlnTIfAGwRrjhmDBSQ42dP2EMZ5hOBK1xpSO8DKvHZNvfqZ98v5SaikvZITSgpnZoNZJh9Pi/M6+nqPKPNyWCJJd/XjzMRlq1XHdNcI41U3PvISEfzaYckoZJqpuTKiOl0256zjEaqHqjZwR3g2D9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747985906; c=relaxed/simple;
	bh=wezGjAZzf/a4TWAVx+n/uJPIN8jSfPr9i68ACgC+gWU=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=rgxf5Uiie+Bq5XUN+bIlzhN6v7mfmiz8khp66jMuSmliXzmRzesDIxRHIGT0h4Nloxqzy0cTRRC9ncqlTVoTKTprkrvhZDS5IBi5eNXBjl2XRoV/rsKHXRZif3JHvEzjIq2TY+9Yd8LrAYh43Ja1F9ifQDEVc9iBxhvygFFTWI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NiJuzgUt; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NiJuzgUt"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-47ae894e9b7so154296721cf.3
        for <fio@vger.kernel.org>; Fri, 23 May 2025 00:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747985903; x=1748590703; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wezGjAZzf/a4TWAVx+n/uJPIN8jSfPr9i68ACgC+gWU=;
        b=NiJuzgUtQYEGryJm7GJG7DjC08Pch47Z3bVXKzkTPXCQ+24ypx94cUzcPnctbGpSjq
         wlcz+RgEjWnCOrE4R6E4KuRyxk98gdsPBCEq2KJ79fT0bGznI+ek8yX5lQfGy0+9/Jjf
         vuyruTckHLOOrqEHyQQ1/NU4pdAbOJ/hs/zOtNrQpe2rbD6bGU/Ha1GiGW7BkZd6R7OJ
         MQ9C9iUFea520KhcQOusfsn8hCrCF3OQqJhBC6ihADJ7zBAPNg2EjQHe5KfOKiBmpCV2
         MSp4iY3rp6/fy6yVh/JiTiG6VQjD2YFbY8POVaN6JB/yhnBrfyCrYAztEfEU1MUZ9R88
         I0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747985903; x=1748590703;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wezGjAZzf/a4TWAVx+n/uJPIN8jSfPr9i68ACgC+gWU=;
        b=R2mpfHw9ukoyHwr7ZKrccz+Rc8ugSuHweFfKrtFMZGItibL1Pj/EdyIhQhks6HWf8x
         0e5wCxUuRWubsI5YthpqOwg+t+Wzec/zS0E52GTVq5GZldLUt3nbBLa29KXc8ZP06uVt
         QZu+6qsg9Bb8jeBxlWZeolZ5L3SLYV49QiNR7Kozk0gMRGVyZGC3A4NT/2aFv0zHGSSm
         uuF973M5SAj93RgBmRTYxBMG6L2RpaVadhYqT205jte/1tNekCm7GGmegP9TVu0MLGN8
         a+/+m815f0kMOMMIYKr5pYZ7F3tU24IBQo+lq4ZMAZ/NVwSQb8LhXWTpoXH4vC6jrsTd
         nzjQ==
X-Gm-Message-State: AOJu0Yzo618DcoBNTcLoEkpzP68bn/FcacFpFVXRN7gklAVu2Np9fGLS
	o6vnpustKRqkjf3QHoZDceFLVbZWVoYGGwF33pKP3W6v65Gdh2KiYqi1oxR/V5k=
X-Gm-Gg: ASbGncuBGlq4oREkZOjiWP9VN5rpaX6vuRfeAb4Uoh2LGUtoyKoMaSWsUQDTYyPZRdr
	shFO6Xyak+Yk6DiXHa8yRVoyLFCk1zeg470GZDPP03SRfTHzDuhsL78lcwA8RY6OWz37iNINb5h
	OeEqCYZI6+EJ04bHFoemtkz1yH7gcn13Z+MmfBfVeH+L1emqWQfZeXU/pYarNUuXjLUnOzlrUc7
	0Qcfh4ZSixclMkxBvDoSAgw+MRMmMWu4CBMlP7gLaZdkuN80HCEFJ8diO5OT9yQ0Tw/gg8Xu8Dw
	5Qo+BI1faq8PJNx+k8hCPBmJS/QvgZJy8RkaG6QcoSiQRxwy5risXmrldYX5XwU4rHzF5KBajH0
	By2GkcSRB0dGaN3g5enROXo6+4GMdrKo1acgeDFwbZoq5UdmeZ3E=
X-Google-Smtp-Source: AGHT+IFmLj8QLF35SnrR6fqn1qIlqq/4bKWCRoFh0evw1euqmdmrnLrAEcbdq1FKPpfAEqOX9qwgew==
X-Received: by 2002:a05:620a:430e:b0:7ca:e971:8335 with SMTP id af79cd13be357-7cd47effe07mr4992341185a.8.1747985892571;
        Fri, 23 May 2025 00:38:12 -0700 (PDT)
Received: from pkrvmf6wy0o8zjz.phsjm35sxllu3kbyy1grtpjsrd.ex.internal.cloudapp.net ([172.183.151.245])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd468ccd22sm1141491185a.98.2025.05.23.00.38.12
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 00:38:12 -0700 (PDT)
Date: Fri, 23 May 2025 00:38:12 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============9007793393568309347=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH=5D_Add_Zhaoxin_support_to_enable_tsc=5Freliable_and_arch=5Frandom_features?=
In-Reply-To: <20250522104032.17519-1-RunaGuo-oc@zhaoxin.com>
References: <20250522104032.17519-1-RunaGuo-oc@zhaoxin.com>
Message-ID: <174798589185.2695.16933192631855653586@pkrvmf6wy0o8zjz.phsjm35sxllu3kbyy1grtpjsrd.ex.internal.cloudapp.net>

--===============9007793393568309347==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: cancelled

For more details see https://github.com/fiotestbot/fio/actions/runs/15200130502

--===============9007793393568309347==--

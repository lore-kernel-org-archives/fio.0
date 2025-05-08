Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A71A2868A5
	for <fio@vger.kernel.org>; Thu,  8 May 2025 17:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746726585; cv=none; b=g5kk98SPJGePXiWwc8l2L//u0kABLs//0TL++FxN5O1tpXZBEh2RASK2IWZE8Mi3qkz/oBThNsIRXaKvTuXfPbM9NNXsVJ9jZcidV9hrHQehmtABxycfbmYWmaeh9RNHa9sBqo2tVXmX2eBxdeE1r7t6KpL3zVX6/aJYxFIIHG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746726585; c=relaxed/simple;
	bh=Hq7Z1H0ejefo/uuyXbnq48wQmsDDfDVNZ6gGCuGOwjg=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=P50zuDLoKRgNXWi8gfb1jZLaMkm5TPftmPXzDpVE/NUqENZxBN0pQ8IYYJs1vdWcMrf7fquzCMlrQPp0FaEMWb9s2u5eyvJrHepnB/i7TREBHtmNpVTWPAPnE/Kq+h+GmMcEnQW6nzQgDQWZlNZXL+QhNF5haHtpKvUdwdOM/dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I01n7xim; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I01n7xim"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7415d28381dso711613b3a.1
        for <fio@vger.kernel.org>; Thu, 08 May 2025 10:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746726580; x=1747331380; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hq7Z1H0ejefo/uuyXbnq48wQmsDDfDVNZ6gGCuGOwjg=;
        b=I01n7ximJ8sXTS75EXMI5Ggdrv8FLmrd6qFrlb/UO7c4HcTyPPEYPm31lbgndjkPyl
         RpEMxlayj6xhqCW+pZljXLinA5Scu3KO87ziTJq0fMzeD8GlA0kMm6KONVPqwleBF40n
         7lS5aMDotRG/eKwxDBR2Hyk6dOj96XPnK9K4O80yR5Ed+L4XvFMewXh4bz26tYvfDXbB
         Evt0KN3usq0HAy0BP5v10N84hPX1Q2umgeSPRRmEQGKWQgZQRHEzx9W6lUFb1jLs/nBN
         RqARDfZBOdTMXA6Qokd+WBoCPWMeoVfKR53EZxJwMx6fhe8CxTNnQopRA2PCxcHGWmU9
         mE1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746726580; x=1747331380;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hq7Z1H0ejefo/uuyXbnq48wQmsDDfDVNZ6gGCuGOwjg=;
        b=oX3/MfqLMymvVzLjMSbojS1ggzseWvmcQgwxz9UYxKrG2OhempSOQ6xlqCmdtxGVTb
         xREblRA+9zKIsk9mhNWarInmB5Zj1gkpbiS6u67mckaJL5d5/YKpuhZ8fJWRubyGdcMo
         atNF5qmORewlHrEf/gxqwAHxsoBwBcVZke5Zy66IkZb14k1e7Wpo/83h2xJy6kLS9JVO
         z+8sk/mnhXjIKm5c/Z3teHVr+xzAOLRKhpUTHkN+2zimzK3K33TjJEj+L6ZZOHBLpJ3C
         T5zIVWJpsqwb88XqNVnqS2Bw1u+f+sZ6oMokzlXyqg4ZSTCn4USerpgVI5pb9VZ2p4X5
         kKhw==
X-Gm-Message-State: AOJu0YwOAWEbrd/gGAqIHJi70oL7Kqxdr0flMYOSdX8ja9MJ45BrbRP1
	KMSpTTCaJKXV6pTi1eDKAZ+HlxAYBvyT2WQ2Cw0Zekdrkd2r/hO9E1td
X-Gm-Gg: ASbGnctFjd0Czrv1R8X5h5AhIJuXdgyX0PGu2n8rxf1NpSN/JEwy46I6lkaYV95eVdQ
	WZgMIQ2HVzgAd9pRjhfKvmZjEYUxK5UGGrUtg2stULOP/BmxalQdAp09/3CLFGT8/L4uZsi9PAK
	O7aH87qjTnEF2yG0qLnM/6a9JcQ9NCBrWM1eITrn1gQbVttCaXLG6+2pVGs220Zy9Owa9FBvrHh
	CPCwtcPwiwowTlng+6nYP3uStX7qslNmIryjvl8TvH8Ejwtqp/RF/oUWXCD2+9NuqCXE0dGcKh+
	fHQLdodjDwTtSmAqvTSOJf8L2UbTbbV5WgdMYAqGeSLIXjnmNv0BM09maE43/epL2VTS4FKaj1W
	5Pcm5JhQUR7NH2bRk681OJBOJqWfOYYL2fQ==
X-Google-Smtp-Source: AGHT+IFMAlabdNr4uHoJVWKEc4W+26pWR5QT3itBHd9T+ZF8kp5Szo13DjRgwIq/dhGKND5Dk6PZ0Q==
X-Received: by 2002:a05:6a21:3116:b0:1ee:dcd3:80d7 with SMTP id adf61e73a8af0-215ab8866d2mr152544637.0.1746726580620;
        Thu, 08 May 2025 10:49:40 -0700 (PDT)
Received: from fv-az1947-897.2g0nfkfy2auuterbephzfg3d0c.dx.internal.cloudapp.net ([52.234.42.90])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b23493257d6sm128897a12.15.2025.05.08.10.49.39
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 10:49:39 -0700 (PDT)
Date: Thu, 08 May 2025 10:49:39 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============6049667873357734883=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_fio_CI_test_result?=
In-Reply-To: <20250508171444.2113-1-vincent.fu@samsung.com>
References: <20250508171444.2113-1-vincent.fu@samsung.com>
Message-ID: <174672657915.2551.6280722384516463133@fv-az1947-897.2g0nfkfy2auuterbephzfg3d0c.dx.internal.cloudapp.net>

--===============6049667873357734883==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/14912501902

--===============6049667873357734883==--

Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A638C2749D5
	for <fio@vger.kernel.org>; Fri, 19 Dec 2025 03:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766116432; cv=none; b=Ds+Q7MF/ogAhWzBzffZ9j4Q560V8gJf66pC6XfziXbEOzF0pcO2YX63++mhvn+QLxW2mGNHKn7ztalbX2RvkS8mUnP/z6bSspv0xHeJuUGcpdV8n1/5ciIm/K0t1g8PIP5aXJZr3bnm/R8z792JJ1DsfXp7rhNoaC77vXjfv4gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766116432; c=relaxed/simple;
	bh=+BF6l2bnbqcD+M9xEZXFcy2r3Pu9HgPVTboymx1UtR0=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=Gj1/k3sJafXehr1CJE/uVPcJ23cK1NKzKAbAY/LHG/ExruOtm2EpcB+uiR/MPaRIOqUeXLi8RA7ZzXkJXBxLudxlkaY28ZcQNHrgxLFCcKRDYMbT6/4Dr6ob+hGzdGOSfXNe+7kZB6aE+eAHd/VDJ48y+uZFHzTpns3vXi9gb34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DABAPmEm; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DABAPmEm"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-11beb0a7bd6so3386494c88.1
        for <fio@vger.kernel.org>; Thu, 18 Dec 2025 19:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766116430; x=1766721230; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+BF6l2bnbqcD+M9xEZXFcy2r3Pu9HgPVTboymx1UtR0=;
        b=DABAPmEmuVr0WNR7vyHpJYDvGGncHqEGuGS52l894CAu9iKSzjn/XF0ivRUJ8RY0te
         hIAazDBWdfJD+rB11q1Y8CFTvP5Lt1X6PenyMVQMMkE1Jqw6mge5IMBmNbk8f3TYSc+T
         HWYw+ZOy+/RiFbvJP7/12N2ao7LC7D2ggra+NPbAwqlSoK3GyM8kl2mouwSWDb4Xt86+
         D+w1hsBZBm/lcw5Ssd1QP/2sCjYarIl8aEO0S9mWtBQEnlfHPJBMKn4VTUwY4JeFAq3Q
         TpQSVSRiO8n3XyE/JV6SmrNU22E3eVMbNjeEPDnwTCw7LxC64Zau/yMaS65og4FmiHjb
         5iAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766116430; x=1766721230;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+BF6l2bnbqcD+M9xEZXFcy2r3Pu9HgPVTboymx1UtR0=;
        b=nfntMSQHyCox41KpVSsJ2CKBlun23AHHwxPKqG+IYi8QV3ZNnY+jgdobgrtT0k4L9T
         UneUQiNb1rmtkIbNOuC54Qo3x0PAfPz7oBVv/C8H/ffp5micCgh5pXxqn7Pc+ksqZQcH
         ckyTVLqZPm/eJbsRrHdlRRstrlgW3wEp/ueiOrRscKsIbdneaOIzyPywDCZcxcTcSGUe
         GRgAZIaQsT4fXBtTjsUUX1E8cIOZ9QS7Aaj32UUtprGpAgh3QcVvaxnNWmOzbtMc9Yjh
         QYBxv9ifDu3cp/hqc/HifFQYFR3c44Wrf/3ycgKjIIIKYpgkNHhP3R1vEN96T0tNe3Rg
         Xg8g==
X-Gm-Message-State: AOJu0Yy3n+lK1sQncA0nbdAdjseutWOERMfNhPREuMjtRAVOB6kSBbAZ
	aEinAgHitvF0w7yGpwcDUG1oDY5XFocvno06Y45xzIrWts0BWNniXsmLj1B1
X-Gm-Gg: AY/fxX545ng4yrpIjtBOZhOvdQGBTDMxkGly322+VLEF2pVkeZKYuXqjaxbw2OEaoWm
	ELIfyaskeRPEd7ZpdygK+N/TILwMIZVHB435DDy5xkz+4GC1siB8VfR1QHt7su+BsOrcLeklQ/C
	lGQosFytjXo0GCJJgdCILhybp719rqP2+Ui4ilVhLCfeyvLujmH0igC6m8GUbAR0TkrwIwRMOCf
	SoOgdYTwN0geaB4G0eDN9DXUOa9PtxZ5h8VN5gzCzREiBPG6jL6s2Ydb+rabiX2zQfSTmOaXZx+
	yIdZpn6XPNz/8kwHrG9cX5gXMl7OqugOClZhqe2oWJWoD4fCVK2YIHlHZrvTIpGvBxEPPW9YgVM
	szNYyzO5xVu9cnBblgXjjBUnJejSbmXNU5chchKF2VpHPhl70XB0X5CwJuweMFdWk7TPIhfLMPw
	B6bdcnQn8BKR02qTjCIhh8cx9nQRyvSVXbhRFwDS5E+KqA3VIv9tR/aitJ2DvslotvLmK7e7G6h
	GTqZllz3w==
X-Google-Smtp-Source: AGHT+IFKcaNzOPW9au8/YMEeu2cCY7oo0NZtuhoTrUfyefzxIeF5if8WNEgVUROgYM1cYvf9h+aJRA==
X-Received: by 2002:a05:7022:f406:b0:11b:c86b:3870 with SMTP id a92af1059eb24-12171a687a0mr1783840c88.4.1766116429532;
        Thu, 18 Dec 2025 19:53:49 -0800 (PST)
Received: from runnervmh13bl.mmi2fnf01etepo0d1tf1o4mopb.dx.internal.cloudapp.net ([52.190.182.115])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724cfdd0sm4407611c88.4.2025.12.18.19.53.49
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 19:53:49 -0800 (PST)
Date: Thu, 18 Dec 2025 19:53:49 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============2239300917707988091=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_1/5=5D_time=3A_rename_in=5Framp=5Ftime=28=29_and_ramp=5Ftime=5Fover=28=29?=
In-Reply-To: <20251217161722.6357-1-jack@suse.cz>
References: <20251217161722.6357-1-jack@suse.cz>
Message-ID: <176611642869.2749.1473288198543309723@runnervmh13bl.mmi2fnf01etepo0d1tf1o4mopb.dx.internal.cloudapp.net>

--===============2239300917707988091==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: failure

For more details see https://github.com/fiotestbot/fio/actions/runs/20357805338

--===============2239300917707988091==--

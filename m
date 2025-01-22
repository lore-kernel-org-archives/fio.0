Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5835D249F9
	for <fio@vger.kernel.org>; Wed, 22 Jan 2025 02:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737514800; cv=none; b=YHaAJ0s6xYkfEaxWpOQHAigwrk1z15JYVeaRFXTKg/Sc7n3Zc460zT/P+URB9f0SN2gFgQqd5HTdGk++5S20BwtEYySa0ZzqNY3AZbYN27HJF0OVDigf8CBVd/9aBCgC4Ehj8FZ7jxSnI+BRG9NuewOztPdaX1PytPGDsOxpT80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737514800; c=relaxed/simple;
	bh=NfxdpnUKQNO/pss8hi4Ki0y0L/3xuoqW3nzdNAxJzC0=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=A8CbJ6orgiffxGY397LEK91k+dCkzmPUSQLq537VaRwk8PhCJmVEluQenCGSS7qIbd3ItMHeebxEwWGXxtwuEPmyCeHmLBI0kPQhGpddcOOj6+RXpSyquyupk1Y3I8bhNuQWDLWEmUlgCihcnoauaMtBj2lq0F8EWygWypMWuUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=maw0HaLw; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="maw0HaLw"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7be49f6b331so589917285a.1
        for <fio@vger.kernel.org>; Tue, 21 Jan 2025 18:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737514798; x=1738119598; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NfxdpnUKQNO/pss8hi4Ki0y0L/3xuoqW3nzdNAxJzC0=;
        b=maw0HaLw+qsEa2vAzJSrvoTVM6JDcNcca7MDGnxETkjnFzipWqWqAQnNbQ4rRnv+rm
         O7tfHfwq7ftRKfkTh9YmEVPUMJJtHHwdRM4fWW/8q0WW0o9lHcONhnmiYgrCgofDlEoB
         Kmqc/m2Aw1qD5XBpwe2b1cwMHyXBu8aoaUoY0yNC2fGkYZ4ywhHf/sZNZDQr3GkcWF7o
         xHgkVP+yq9gAfDaWh6+FD0Yt2ygcRrdBBkczGFSMYfuj9ei1DSx83XZJAGRKbVzWVkXE
         wIbY0ob/G5xtmAuf98lPfTIoXT+YJY3J/3NRsMx4h2XlzeWdkDfZvGMgHvourMireu1r
         YXeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737514798; x=1738119598;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NfxdpnUKQNO/pss8hi4Ki0y0L/3xuoqW3nzdNAxJzC0=;
        b=qoFUC6ZHLyvXZt8Vy0Yhby1MTHWex6GdHjP5lwEG5iWPZdiq5NHp9cJIGy51+Nz9mV
         Q6QhM3VO6if+ZRaSXbusmrb54nRdm94up7wVk1iV/4kJpOxKcQM1UJ73q6RwWAoavRft
         CsJtd2roLLqoWBbMkfwX97+N0ZkqW+YO/jva1bfOQMEB/a+A5HkKYpAuh+6awuqMXycU
         lvLitHzwfEsKcdiqEaEtnjkN/PWJIbodwu9zd0TukO7WBBegJIt/2G5DM2XyMTbFF+5j
         wzxTHzg02f+LAPZeHZVcSuZaNiNSurQjqXndYIN3OJtB4RIeCbeIgEMK8YCWL8qNXmiC
         l6sQ==
X-Gm-Message-State: AOJu0Yze7WxGQKwImTmRLAQ7TMRV2qcHnh71y+72wi2It3oNVLXua+yP
	S9wMJhe75qnLL6LAxHI6J2JsqECYTEgD9r9v2Gff6FS2D/NXnkPAxMt1
X-Gm-Gg: ASbGncsUIXPZ/v+A9nEEVqKIeoyUMDCuaZM2aenGy+QnrFPbA2wjsUlsI3l2Q/VA7+4
	i320qtZEzrnBfCD87SeLNT3Q/VX2pRQkhUhzAP5wLral4wn9KIBTYrST4murN33OMXYP2Ni6+GU
	0xjfzjpmf11mGQGN+73KDYDJ1OjhgQsiKT5Q2lSaFbnEbtqdjmzjG2A7ogFC7TCqcU/n/t3ghq+
	7S38kaDFqTla57ILJ4d3LLSm61vLh3x4hrtjOS6dHqhYUJwpJ3n0bqHWI0wG9C7mRhenZ6wyWEa
	Dmrn7FmggftBOusQEGzpISF7Daqi55FUPYpnMqNbUksnNQzPYJ/Wfh5dQuVsWyA4
X-Google-Smtp-Source: AGHT+IGHxBzZdusDNkr95N2RZO3ZIFcv//pIcbDlz0rAOfbpwOpdZmNBPmmrO+fkzBkvlUBui/ZPrw==
X-Received: by 2002:a05:620a:8808:b0:7b6:f143:44e3 with SMTP id af79cd13be357-7be6323efbbmr2877009485a.32.1737514797957;
        Tue, 21 Jan 2025 18:59:57 -0800 (PST)
Received: from fv-az789-398.ieztu3jclcrurakx3eg5vmcnoh.ex.internal.cloudapp.net ([172.183.230.32])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7be614d990asm620465585a.70.2025.01.21.18.59.57
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 18:59:57 -0800 (PST)
Date: Tue, 21 Jan 2025 18:59:57 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============7264202904265255697=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_v2_0/2=5D_zbd=3A_fix_open_zone_status_check_for_non-write_jobs?=
In-Reply-To: <20250122013835.1223725-1-shinichiro.kawasaki@wdc.com>
References: <20250122013835.1223725-1-shinichiro.kawasaki@wdc.com>
Message-ID: <173751479677.2494.10108657408406494863@fv-az789-398.ieztu3jclcrurakx3eg5vmcnoh.ex.internal.cloudapp.net>

--===============7264202904265255697==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/12899960142

--===============7264202904265255697==--

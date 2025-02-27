Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF3422541B
	for <fio@vger.kernel.org>; Thu, 27 Feb 2025 07:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740641289; cv=none; b=K5BrIKpGhggKCpD9o0kJ3fd/bBo9uxLXZ0CzTh2VNGkisSYSdlxeo5FYtpcTwVyTNQhja3sk74/sNapjfX2Ee+pmBN1oKdFwfEyOG6fs2cK4aOsaFjOYL2gTqjalt7JS1oFB0VHB+++dxW08Hy8TCGGQirZNC/4p7YxMjEfL8m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740641289; c=relaxed/simple;
	bh=x92jnzHhqvd2OY/lrvmShXIXtK+8/ahorZ3z+9WJkYE=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=IjPnREB/iBD9cfrq7UKseD6nrvNJfbkpvzPjON7koRR5ENVSlGjAvdH0F0OGpO5iRHw76MHwhf/SOIdMY3ea4TZK1yQRjemVjBGK+wTW/aDuIoXkUU3Sesn/0GnuXdfroWLUnsyH7q0RMOr1UlUQ6BSXKIoSy+4mbG9JHRibIUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JQurz+vp; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JQurz+vp"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6dd15d03eacso6697456d6.0
        for <fio@vger.kernel.org>; Wed, 26 Feb 2025 23:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740641286; x=1741246086; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x92jnzHhqvd2OY/lrvmShXIXtK+8/ahorZ3z+9WJkYE=;
        b=JQurz+vpngPWBxDdVdllXCzJJp+/A8sxFNn0Md9ouRfEZiI5IfcpkiL3XYq4w4kNCD
         5kosEN1mZvaKGBEqwtDryjsBJLYMVBZm3tJOO95JdwVijelQeON0XgF5w9ikSQyP+uJ+
         hdMpWdZb6W6hHARS2TpKbGFBLa35ghPBoK2t/jkLOdqz4wY+iJRmQb3wCi4Qt0225H8V
         vvT7CGM7uF4VZz5YJB2ALseIu+jcWk+fgn1PYaLLCxSzfBETm3FXkwSPgNl8RqF8Sv2k
         Utq9sLLcpYqC1kzF1/23AXviz1c6WeJUHHnt0q5A4KXzFIKy8/FVXQoH39xH2vj/AQJI
         FE6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740641286; x=1741246086;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x92jnzHhqvd2OY/lrvmShXIXtK+8/ahorZ3z+9WJkYE=;
        b=hYywiWjeSG7e0tS7gPc5ZCYGP6sG+ekadAxRaAI/AnYe9uK7KVaBh1rcdyJAUs6LWL
         Bal/iEFb6bOE2sWebilXuH5y7yEUQau54JcSsL8cVJv/Wso5yRTt1ubFalxHzY9XXh/9
         r7ZYc1cSukH/+wrUFfbgnVQFJv3BU8i1fSMAIO35R2kV+syMflIrB4/3RsmTgNGGJ9b7
         yCNxqbBBK0YFTWGIGAeJx/JIWAYvYWmA8I+PJHVaexcibFby7rUbXWcDJ2dR5N+GUXyv
         ub2TfHbSNrwS0TkFeja8xyWSH/XSLwr5MfXJf1fSKBYVgoBrbZNJZRBbrhYLCV6zDFIv
         qdxA==
X-Gm-Message-State: AOJu0YzwuO8+SKEHsLZv1kHmcPwZEwJkIbIzWDRA83vJVu/VKZkiwlC7
	LbUtXuiq0FJ/Benxnzf/dxbtME6fTarw+9v4Gb8vOLGIttm60mMJyb8S
X-Gm-Gg: ASbGncsfj18/m62H/IBUS5cmR/vBxEIOwm5aRP8YGmo8nNhWXF0OFDDdmfq+s5yp9Kk
	PRj1e30AvvUSKRNGOZT8z5/WSAHXL5Uu5sNItHuq98IBjONtreF/wXbPf5czJXI/b/RMt1JJ8IF
	m6Wcp6j7nKMxsSmZcaS0HU4F5yAU6Yi3PwSvc2SPWcbEGqd99UF9WneDAyZgeLA5+yfL75bga0P
	D2DVwxR29gubBdjAgBdk8hxY2CcP7/VambdOh2c4gR1oTz1kYB9seOu2Ru/ss+WtdO/H/j9IbyS
	jDjh/Nybw78GW9Xb9xkKupNsqDMphBPkKukk/mkJE2lHNEuAbZkIWtNM8A4VVi93Tj+0RtieDDt
	W8VKj39wVsFFNQ0EFWyE=
X-Google-Smtp-Source: AGHT+IFfx157OTnDRp7rp7C2FxInlHAcqY7wtv5cO7A7NZ/sT9joo2eQLEd8KAtylgHMv3SVbBl0Xw==
X-Received: by 2002:ad4:574b:0:b0:6e4:61e9:a2ae with SMTP id 6a1803df08f44-6e895798cdamr35703526d6.2.1740641286418;
        Wed, 26 Feb 2025 23:28:06 -0800 (PST)
Received: from fv-az798-925.t1jpfi5v53he5mesy5vnoifecg.cx.internal.cloudapp.net ([20.55.229.208])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e8976ccacdsm7374176d6.87.2025.02.26.23.28.05
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 23:28:05 -0800 (PST)
Date: Wed, 26 Feb 2025 23:28:05 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============0003283945569786501=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_00/21=5D_verify_fixes_and_a_new_test_suite?=
In-Reply-To: <20250227104727.1794982-1-ankit.kumar@samsung.com>
References: <20250227104727.1794982-1-ankit.kumar@samsung.com>
Message-ID: <174064128542.2481.3375743033037557489@fv-az798-925.t1jpfi5v53he5mesy5vnoifecg.cx.internal.cloudapp.net>

--===============0003283945569786501==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: None

For more details see https://github.com/fiotestbot/fio/actions/runs/13560919839

--===============0003283945569786501==--

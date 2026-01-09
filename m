Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99ADE246766
	for <fio@vger.kernel.org>; Fri,  9 Jan 2026 09:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767950352; cv=none; b=J0LHl3fXJQXIzMk/QShQVoaGEcXZFRNPY5/MGvFBn8GtTuUQ+xuDJueE5ZXMmLNF7ICtGoZHESU0l2eQkgOfKBfeAQH7bAaIcnNF2qyEZzQh6cxHS9EEo3L3ay6gAH3i7bIYKEpcsORIAzMh1+0CjbTgW+SXrQ4Z/jHuj3icaFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767950352; c=relaxed/simple;
	bh=wdNJ1Xu1BPi3vJMWop1yr8vVzxBhqol2M4KPuqIQO+A=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=dRyLgUoad5n2QKoyLRyDbRANIoGN8xdYyQbdB18XyHAVqhKR02FEjGqnr7bh5W/bxcrGyfhAfuDC6PVJwIIk13SNn07+fj2PuOiujopY+m69wLKkNfQ75B7kFSSO7vTLghGB8kjELGzV0I+aYX/AzK5qX4jZ4neNK3BydLcNzJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EzWs4i68; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EzWs4i68"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-11df4458a85so1804089c88.1
        for <fio@vger.kernel.org>; Fri, 09 Jan 2026 01:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767950350; x=1768555150; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wdNJ1Xu1BPi3vJMWop1yr8vVzxBhqol2M4KPuqIQO+A=;
        b=EzWs4i68E3kEayjWFSsXgrbnhmXK/DALYwGOsUv7vgphCKyuk8Ej1q5QB90R44n6e1
         HNEh2S7hcI2Zd/whrAZSuUHkaUQhrYiMF4jRIS0zU8Sa0wY/V1S7yRWyaj7HC1e9PMsi
         Vpw8MHtp+QAO4M6en8xINS0aASi3bXlDnvGlFT/uRhG90Wkvm+YJrXl5K8hAFjQe6OyD
         qHVn7GmqjOl7+8KrP14nW8FjRmvaGgSKCTHvyBicwaKWZVpDtxQl+Lcgzpfp/9YON++J
         IWQuFVCSIEi5tINEbKhl/AVZCkTyj+La4voFO9DZb3Wo5jD9GF76z8aaiNTcmIxx++9a
         M7JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767950350; x=1768555150;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wdNJ1Xu1BPi3vJMWop1yr8vVzxBhqol2M4KPuqIQO+A=;
        b=UvzUZZlqdvOtMyppkeph6GlRRb7eUXQjo48IDNWQBm29qxWu/ttIs2fBuQ/z2Esdgd
         6a2kxSLAFtlhWYwZqotSORTCVlKjVCEoq4HIZ+aP15VCtZnMrhc4QomBSyaET26CpRFg
         DDdUmcAgTogS34Xu/UeYRUlXJ/QMLaofFbjAwx6hqe9e8+FlCMj4CglJESVTISlpw2Rc
         CfmCLlNxpHVjo0GVa4G8kenmeDvMIIUb/AMWQu+mkkVsRKWrQGhn+0yZ2HAbvz+vSQcn
         AeIUwnir9z6Ya15krUzdwkRgEIMupQsb1O6r/QAwitWOnJFUAubRhfZCqu2Bo0PtMumi
         GP+g==
X-Gm-Message-State: AOJu0Yw9GhFZSO+BcqnRIO2lofPRSI3c39/d7QD8/fqA2d95qPh+5wHY
	WU0PyVSTK6OFujfvuGtE3BV7BhLBu5JEEOESvvZZbXE1chg6aMf8BDkcYullv1I=
X-Gm-Gg: AY/fxX56aQEJUcANMN3+0/HOHLN3FeIXh9FIOhBAj7/NZQ+gGGfZSJ0zNqP2aX60d/5
	REu2TlzB7QYUEM0sRs+zgOAX4ccdr46bYXhYHhARd8hCaipmhRRV4vn33jpNF98ZROHYdfmwYWt
	2miA95x/+HJZhnqn4sBzLyGWqsml3sdFAaP79vyt6Zgf5x0rSLHNSXLmeQjYfytEOQbR3RSzx3o
	u4qwcMAmuSPgjgP4SDwVYiKiwUfCOwK4MPd7kstYshoguI7PtTxIixAP3kJXE4kNchHh+rQR3RS
	OX9Zowz3lhEtIFlQWOrXUuGDtAfUESQdpNyqHi8K62Qd65zBUZmlPGaMCyTinD0SYX+VxOAKpLi
	hGnW4Do3VvfYd7CUXOFPF75Kl/Z4aCADX7khoRgFUJdpA12yiCqLfjMqTaXY6Z4p9eBtglftkK7
	oBipjpUFGoQ1LVpdvuLdoZVpb9nHqSYpoWZ/MQDAcw9H3oq3AZneIyzavhKgbicUgboxM8kX1Lg
	L26xfHmex8oAx3nvuE=
X-Google-Smtp-Source: AGHT+IGh6qV25GraVxz5uIhGPi7N8TpESzf/GJXiMXEEJDVRjKyNGVACayDo6+okQ4uR1ih3sv6GGA==
X-Received: by 2002:a05:7022:e08:b0:11b:4351:2687 with SMTP id a92af1059eb24-121f8ad0889mr8476613c88.17.1767950350441;
        Fri, 09 Jan 2026 01:19:10 -0800 (PST)
Received: from runnervmi13qx.slnpmp3h1bderar5ewl3lqggrf.yx.internal.cloudapp.net ([52.161.59.145])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121f243f384sm16240268c88.6.2026.01.09.01.19.09
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 01:19:10 -0800 (PST)
Date: Fri, 09 Jan 2026 01:19:10 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============6553157021421965971=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_00/12=5D_zbd=3A_fix_problems_of_random_write_with_unaligned_block_size?=
In-Reply-To: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
References: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
Message-ID: <176795034928.2774.11757970908180874735@runnervmi13qx.slnpmp3h1bderar5ewl3lqggrf.yx.internal.cloudapp.net>

--===============6553157021421965971==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: cancelled

For more details see https://github.com/fiotestbot/fio/actions/runs/20839657240

--===============6553157021421965971==--

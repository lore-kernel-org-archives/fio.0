Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC12277C9A
	for <fio@vger.kernel.org>; Wed,  8 Oct 2025 10:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759919594; cv=none; b=Yz7jO5gUkRlIQEmQGJxkAeSXMRByW0yOEoUE6kUeHehJ5OZEGMrTItI83Fw4zm58DFNCv28Uwb9n95nFsXOuCfwK1lh8ZuA34BZLUQSUnTvaak2csnxQcpbTiO3gcWy2l6Voj48OVXCp9HU1UZXRq472annFoAJSYoYWtfBUgbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759919594; c=relaxed/simple;
	bh=Fu942MLG7MY0z8ZTKWbFQzZChewva6BaPC3Z38I8dJM=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=tctWOlLFsX67PyLP/jagXAJh6mtJ34nndM0BksKJ8P/f9/u4hzeamGLb9meRmCsXs/oeb4mIPqcrCR+5wby9NN4kHJ0yjcd82Jl4HwClbKQjDc0yLhT0UTxDt82ZplqXD7G1EP6KLuDBhn2KSKZ574VxJv2vqZ0g4zwG36B9HEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dtyJ/nZq; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dtyJ/nZq"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ddf60466d4so81498141cf.2
        for <fio@vger.kernel.org>; Wed, 08 Oct 2025 03:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759919592; x=1760524392; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fu942MLG7MY0z8ZTKWbFQzZChewva6BaPC3Z38I8dJM=;
        b=dtyJ/nZqvy1qyxTpbSOPTQVYj/RVFeTDC7K+aUxbMlk+scjH5H0U8yg2lHnrASEjaL
         SFDaWaSEXlPeLGNg2lTC2T0bg2YTR+l7g/PFlJif9JR0sNaFEnveRtnywH8fGC8XsUuh
         J2hEwQdUOHUVn4rGX4lJdBi4xYpMq/S51Ie8Ub1Tw8Q38q1hD6F4VFq+N27Es3I38AMv
         4oRDBt0k9xbMNr0GrmAypeNgz4FQPwM9XvBdDF9/BAyxMJJtGs6ghuHM63ikiAeGTijN
         cqMywQ+tgqtng0F8WAlrpdsMYhFvWPTaBqrTP952/X2HybmG9h7SJ4YxsGNdwXWjJ/YF
         xjtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759919592; x=1760524392;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fu942MLG7MY0z8ZTKWbFQzZChewva6BaPC3Z38I8dJM=;
        b=jA4bAJ0fSlMawCE667NxiYolC4ucir8Bin7ZoexCB6h8So5d6bBRMOMyMhFUh7Umke
         xHSXZbfBnVRdsVwttxgR+IX7LXMgXd7RnOJJDPGMututcgteWrEwY8mv3GP2KfESEYiq
         fo79GkbgMWsFQq/2BRpfCmg3pi6I7gSvi79vYAxIomXMtjvo0NiU71KeO4Eczojjj+Ac
         NDsPyChlZBvaLh93JcZvM4IFfuvz92UZtOV+SRX1g0q/zqyFqFEpGIDs6DoH1VjQYVY3
         s05PP+ZnD/4k0TU+DDHX81Hsti6umWLgWVWWFex2UeUeI3fcH3sWxVjorH3LKcYf+n12
         Y03Q==
X-Gm-Message-State: AOJu0YxGTwxosVZKZIomyLSGotovjCDOdpa1VX6Qhyhs1OvQSufPDJ/F
	M5BnCY/p7WJqRR9ZKZYgNMgSkLpnY5okwG05/YzpXKiq4Ba0hRso3tlkDhBT
X-Gm-Gg: ASbGncsVLI8mDqlz4Gu+Dx/n0J5jLGJ083b5u9V7y7dmsGy+qH6JUsrusvyqCupOG0K
	yVM5rQiLcmoBA8XbFnSz33xsnYWYz6Ks+j8T/HDpHQ1H1g9nkIzKM64Zg8bGEkdUVNNPTlTIjXe
	prK1mHdqtH3BIS1t1qz0ziq8K6xDhnugVYQxGasE0Fn32zKCgnpKD3M5ADfCR/oa13VmavRrySG
	ui/XiRE9RDxtG/1aG8KXj3L/XlwYTeIkTYyhwtYT3L/fliuyQK/ZSO40nR7KQEnHn6nOCB7LrrG
	VigWHEOCU6sGiTTZOO7PCcykAfnsB5D3mvaUb8leEmoCkOauIyNv9QEQ9t7VHtLgXCDOW2MscVz
	dx0NX+BQvPb+9Nzoqr223IUA9xkThsjkJvqy6lsfiYpwFzY1LyVYiNE9y4VRYYlfl9tByA6l3Hn
	O5KZdWDvKWw3MObdGPEnCLgcot39jlwNhGdqHSd6my
X-Google-Smtp-Source: AGHT+IFxafkntmtIfuKUjg7prLM/93GNGkX9CqJjJRQvADtUX4Hjns8Tc9e8RpQ0E5MNoJWA/bTE0Q==
X-Received: by 2002:a05:622a:4c1b:b0:4b5:e7c3:1dee with SMTP id d75a77b69052e-4e6ead54342mr35715891cf.47.1759919591801;
        Wed, 08 Oct 2025 03:33:11 -0700 (PDT)
Received: from runnervmwhb2z.l25leanymyvu5jhxmyizakpyod.cx.internal.cloudapp.net ([20.161.58.233])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e6e7c88cb2sm21618511cf.26.2025.10.08.03.33.11
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 03:33:11 -0700 (PDT)
Date: Wed, 08 Oct 2025 03:33:11 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============0814044486076388558=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_0/2=5D_stat=3A_improve_zone_reset_count_reporting?=
In-Reply-To: <20251008094847.1628954-1-shinichiro.kawasaki@wdc.com>
References: <20251008094847.1628954-1-shinichiro.kawasaki@wdc.com>
Message-ID: <175991959108.2759.15018825704666667332@runnervmwhb2z.l25leanymyvu5jhxmyizakpyod.cx.internal.cloudapp.net>

--===============0814044486076388558==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/18341297967

--===============0814044486076388558==--

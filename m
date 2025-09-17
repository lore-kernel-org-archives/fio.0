Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FC6328965
	for <fio@vger.kernel.org>; Wed, 17 Sep 2025 13:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116129; cv=none; b=SZHL914bB9tshpVsFcm618I/ch5rwCk43nWrhdmeRqSlPasrx8RPfqO4MjqLwTB5QucAcoPzsDZH/iol2DBdylCZ70lwZKhpW3fHJAMFPeH9bNzuLEXI9KP3h/XA87gyUvMNzAmnm9RoZTGmWvZF+stBLze2nHG51JnTw3c23vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116129; c=relaxed/simple;
	bh=a0Mx5uBBo79h8+dNfmiy9XKqtsw9amE/rLFD8aNDT+o=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=hegledZWd4tmBoKZO2+6ObDuiMkCrj5+YhiCS31+zhdnIruXZ0pXuFIrSWUQj0nA9WvIZLw36vShLsXzGehktM0m2/w9o/r5La7dFcT3784ffujr6KykhBMR9U+ZuOd+GHbxlFBdbwcQt2PRS8SRcH80v+EvMRYcpWjhjEYrPIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k5BD+UrZ; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k5BD+UrZ"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8117aef2476so672369985a.1
        for <fio@vger.kernel.org>; Wed, 17 Sep 2025 06:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758116127; x=1758720927; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a0Mx5uBBo79h8+dNfmiy9XKqtsw9amE/rLFD8aNDT+o=;
        b=k5BD+UrZEG1mVl4YCikBGz55orCueuAeYAsGPD+Vj7QgLms/04vVfeWucODd2/PIhs
         BTFqO8YsYe+IFrlIAwJYoyg7cIjXzW/rQAstR/l0GpiAu8aLdq8CrehMXqBy+JCSW10w
         6qXztHCwDfghJTkcIUcl7DEkJe88QjCECuSBKDmF5nhONaJCvIukJ8soPNJDgI9vqtlW
         d4l1/fXCflj4X5Xc7IJ3IMvtGAwIL7hRNwkNDEtHoCpIcwh5liK8id1FpzAVu1+sS8E/
         Ip12duQ3zjseG143iSBfZWUTxvS85ZUss4DWUmwW6Q9h4bMbotZ4JuvSSQllNy3G8GiR
         EinA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758116127; x=1758720927;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a0Mx5uBBo79h8+dNfmiy9XKqtsw9amE/rLFD8aNDT+o=;
        b=DEqot2g495IdOThMzVp0MGuUKk0qlwwK7Yzk+eTPMdauNUtawLpgup6gkDvDOLNL0E
         OgEgkTXrH7of3oeXHmYkoTxG4sqaTAeW0AjWHJZ9dVUor3U0OnvJ/ku5w66WB7C4aPrE
         Z6172gqQ2yJlUUnPuy4W0S1kvGEiFXrVxv0JDzuM//jGNuGXJLctBAxY9vBB0Y4r0ZEw
         se29JChCDiJA9kzRIyGl8IuQIqd+4YxpCwSCCxEOQB7mfnnxrtVqPVYkhyhAQvtPRlIv
         I1dk9VxqAjxMB2b0eUDsCozW2xAeLJor5o6Y2b76+3JdW4eFlmn/XnGE5NhNLm260YfN
         8PJQ==
X-Gm-Message-State: AOJu0YwMB8L/PvAd6ZXQLq3lVwP7yRgZBqzqZEsHeoTLeHWFS79VSBhR
	ATHhkVlJWH0XdC665RKeJl7p5oCc7NdN/TeC3g4TysIdRVcStRS6LCQMHUg8HYM=
X-Gm-Gg: ASbGncs3Qpkb2aJPbQotu7l9skjM4Zn/GqfhT8RwlscqaB2QtkzR5XVv+FGR6FUi1WD
	0noOvQ7NEfAw8kNFEHcrRr+1sr1Z33JQw83tUBujZEViKW+Ex4UKBBTGwySBD32xNKS64I202UQ
	WAWVJwQDO24Q+PP3p2hSsLBo2APfxJQF0PQqOD9w7H84cN649DGV0zOpXGL00q03HvXjyyJMku9
	xXaXCiEGF1kSJl/1uL3WVVAf57FqGlQV3hhVZZEgIexA2LQLEhq0joG3b00YltrU/v+6/ve20iu
	a5ydliP1l7SfBqyfymXqs/Hu3ooHPQLJIcF6lkIjF/fF+1+tU9856WcjabziY4r5fvxZSBazPGQ
	GFUBlL/4l6RrY9pnnj2YvcZs3qt0HzfdEFYrInCooANq23ktHtkF854bYhabnD/RX/SLf2YUskX
	/lq3FITiyI1twqbfBZ
X-Google-Smtp-Source: AGHT+IGSF0S3SqedDtVKYdA8UvNOqOhg1O3gpYTvWsi3eHhh5zJZK+A6SZGXpW9GniEqDWDRzwtbgA==
X-Received: by 2002:a05:620a:1a89:b0:829:538a:e41e with SMTP id af79cd13be357-83109e982cdmr211976085a.4.1758116126435;
        Wed, 17 Sep 2025 06:35:26 -0700 (PDT)
Received: from runnervmmq7i7.blvezttv0b3ejdl4gomqurzhhe.cx.internal.cloudapp.net ([20.161.67.211])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820cf8c8b87sm1132411285a.68.2025.09.17.06.35.26
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 06:35:26 -0700 (PDT)
Date: Wed, 17 Sep 2025 06:35:26 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============7447493889687389091=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_v2=5D_t/io=5Furing=3A_Vectored_fixed_buffer_test_support_for_nvme_passthrough_path?=
In-Reply-To: <20250917065838.6204-1-xiaobing.li@samsung.com>
References: <20250917065838.6204-1-xiaobing.li@samsung.com>
Message-ID: <175811612569.2717.14055919629818473049@runnervmmq7i7.blvezttv0b3ejdl4gomqurzhhe.cx.internal.cloudapp.net>

--===============7447493889687389091==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: cancelled

For more details see https://github.com/fiotestbot/fio/actions/runs/17790127749

--===============7447493889687389091==--

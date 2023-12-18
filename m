Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67685D742
	for <fio@vger.kernel.org>; Mon, 18 Dec 2023 17:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lwvQTKqx"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-50dfac6c0beso4336395e87.2
        for <fio@vger.kernel.org>; Mon, 18 Dec 2023 09:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702921180; x=1703525980; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NANUnABI9A7L8rEJp1ZfZ9mG8tLzE5BlrW2tOuyeubA=;
        b=lwvQTKqxLIC3h2slXVYtvSAKzjr4dQThHuYJbQpgXfjuNceDVgtvTpPQbeKF3Q082h
         GEjDu4hJzBFL+/FXP6Ed+0GThAI7MxxyjwG/exncUnFauXyKw8n24CPH/zLEd8X9jmhB
         gxgcFD0Gwo1o9CQphEg6Mps793d1V2PXfgDgJbzZUGunNbV0ciVGbqu4ug+OOUkab+Kh
         ymjyt2POH9rOzBjCX2ZF/kiouW8U4QHMSNwcZz8JcHVcS8mR0oxGCroZBhMv+T4pkPS7
         b70a3nhT3ZIE1J6ddCRex5Bk+FXVLKdM4jHXMmgcLVcT2NrQ1KL9Cle2Axeca4rpXH+4
         B/pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702921180; x=1703525980;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NANUnABI9A7L8rEJp1ZfZ9mG8tLzE5BlrW2tOuyeubA=;
        b=c2cNvcnF5uh8DfcMkAw4qpl5C5EcRJOYk92zL6jbTemYlMNiKzsNZCCOIx+luFowzN
         LvluykFPDoS5soW9Am7fmeMW1dE5aFG8VGE+d8AP13YXBRxCGmn016AqiCZgA9KWxn+b
         2LLhTJGLrvxl43QCLaEitjlzx8ujwIsuux9dVGBWPgrAdRXX68Pdfpb8SgiWoAfQeTLt
         EcV/0SDQWnbE4BgUEe7iWn+cCB7tck2riVjm8jpFpnCyRvsxTcMxiuR1Ml7dNRSggovo
         IgRZ8ERm9r3/Sh5c29Eo+6ZwTvpCB0crjalt45YmzN/7tZUs7P4Q291vDWNX4Sak6zeT
         cMLA==
X-Gm-Message-State: AOJu0Yz/maAY82tP1WzykxrizzP1GzirIxUzFN7SatveV1F0Irf/5k3Y
	N1L6j7wTDMRsVcIVsftVElGnF34386bdsYlkWYpQZC1XLBFcBQ==
X-Google-Smtp-Source: AGHT+IHAf4NffLJQelkIX9N6otNrib6pBRzlImJC/u6Auvxpqttq2isFIZc+Vcso3HkHNgjMrFFgqmVtj5iim+Yuw6U=
X-Received: by 2002:ac2:598b:0:b0:50e:3e73:a565 with SMTP id
 w11-20020ac2598b000000b0050e3e73a565mr586185lfn.52.1702921179524; Mon, 18 Dec
 2023 09:39:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Surbhi Palande <csurbhi@gmail.com>
Date: Mon, 18 Dec 2023 09:39:28 -0800
Message-ID: <CAMBkX3eYd_xuHA+D+LOw3RX_P-MRRexByd4L9_dzoD-grOaRWA@mail.gmail.com>
Subject: Configuring FIO random writes
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi All,

I have written a small blog post (1 minute read) for configuring
random writes with FIO.
I hope it is helpful to others.
Please do let me know if you think I need to add something more to it.

https://csurbhi.github.io/fio-benchmark-random-writes/


Best Regards,
Surbhi.

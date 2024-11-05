Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD983216A27
	for <fio@vger.kernel.org>; Tue,  5 Nov 2024 21:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730843957; cv=none; b=RLdYZPTxEJsK6xImkzS4PbyQcWx2qFPe3QWPBSuke5XlMCC0DsajmLaOlhnGq0yA+1EeWdaxGiYNgdeJyb6HqWqfZDORr8dLSGmp6JBFtQz0XCWkUUaSsOPyzwrG8tyz4ujct5Mhs2ICKdoms/ghuMQ7gwjG3c7Pbl4M4k//bBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730843957; c=relaxed/simple;
	bh=TUFAXMSSeo/lgRy8dgvL8AGHlaPHZx4hphgkiZDi65I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rnY+JXP6wFl8XDMDtC5m1hDFg18HCh9MfcMlX/kdNWIGY3heEs2r6/IlnK94UqdcXo04ZEBNEGhiOrrCQd5IFKiNot37bI5VWZ1t2qV/TRAcOwjE6g4+RLyFjmh/8OR+eSGDYSaYWdpgoi6jG30sntDMRJrXO05GM7MzqyHs8kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EuZlL/Gs; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EuZlL/Gs"
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-84fdb038aaaso1794691241.3
        for <fio@vger.kernel.org>; Tue, 05 Nov 2024 13:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730843954; x=1731448754; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TUFAXMSSeo/lgRy8dgvL8AGHlaPHZx4hphgkiZDi65I=;
        b=EuZlL/Gsep4Pdz3ju4uTcoZ1xWRQxEsJFjikY6otQ/7/tZIvDzPaixnVr5f8IDDnSZ
         WRH27IwxT2bgyWm0+MF8QrHcaYtGy8K+0y6CePsUEDawX54BtD1DvvLdLN0lox2bVOKu
         BKP5VozG0v2ta9nWD9uv6yx//9ZGC+TvsS6gF1V/oDsPahhsupUwF/9YXSU7HUBisnbh
         b4rC+jy/B6EiW22LXUEp9dvVXObdVgkXblPyxwlGEvVG52Y3FhSZV/daWSxO8G7nb0TC
         9WSAbJHCeb0LnlqkF6betvfA+S8nW+DDI6XnkZWk4Vn0uXoqyLl05NvGaZ0xicQiADEI
         XUgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730843954; x=1731448754;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TUFAXMSSeo/lgRy8dgvL8AGHlaPHZx4hphgkiZDi65I=;
        b=l+YgoGSQosgV6EI0mLSVyohr1t/XDOmZL7hamFQq9GAmQeBvriK0TFAzVhKjeBK9z+
         mvYIGH6CDCogMpXE9A+D/ASJ3eMRupilZFu9iJlCvE77S43qZsjOjvKS+/lqPrcyaQr3
         4v5ucS6yH4Kl8udhgbUK28QK01A0SkZj6ngsUuy5yb7cmm44D62oVTA9yStgh5tsdGiw
         b7bPmCpFAP5OTEBV4UQneTV3iGNwrHA6UZThJY0NqCLVA0IODjKwF/G8JvhPW3Cz4SoT
         LrVfR/CT0wjQ67+LVGANq08qgMhxVZ0/k8zyCTG8+chXfRMDmRlNxJ6R5xmCrhl3Jm91
         B7lw==
X-Forwarded-Encrypted: i=1; AJvYcCVIHkVU9xZLySF3CTRnixQ1NX8QMRh73FNO1197vZIyIbsh95CHq9oSK2zZLNgq8c28Yfo=@vger.kernel.org
X-Gm-Message-State: AOJu0YykrwGm7eEnFME0KW0L/ktcnTXOnJRBUCUDlTBZLJKcPsA9dpBy
	j0IxMnBSd5Ltx9JcnRQb9zEvlxaDGkMjCRRVROKTH7wDBB2K16MH0gXaAZp37mxkNR9g5TeUs85
	bJ5SGIZUg6sks/kOaO+23tdBVaWE=
X-Google-Smtp-Source: AGHT+IHYMdj9nYU5G6h/sFDz2hb1ECiYu0oEVbxoU6mP4/ujMbClwZPWOwyR/jX3kFqME83TSo9TlEhnsDRluRwXEBs=
X-Received: by 2002:a05:6102:5124:b0:4a7:4900:4b5a with SMTP id
 ada2fe7eead31-4a962ddc4efmr16724752137.9.1730843954391; Tue, 05 Nov 2024
 13:59:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5c833f46-a124-4d0d-ae07-5e9ecb4648d8@gmail.com>
 <PH7PR14MB74195A055EE5BF97F7054A32A4522@PH7PR14MB7419.namprd14.prod.outlook.com>
 <422c7d4a-5b9b-48d5-adf7-355947d18014@gmail.com> <IA1PR19MB6449DFD774C96F404487D5E4E5522@IA1PR19MB6449.namprd19.prod.outlook.com>
 <c59db85a-2106-4c54-b5a9-808c916f7f5a@gmail.com>
In-Reply-To: <c59db85a-2106-4c54-b5a9-808c916f7f5a@gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 5 Nov 2024 21:58:48 +0000
Message-ID: <CALjAwxgv_1F69huvkNKPLawygqQ19k8OJVkezXFkuV59Tf33ug@mail.gmail.com>
Subject: Re: blog post on fio write zeroes performance
To: Vincent Fu <vincentfu@gmail.com>
Cc: "Terekhov, Mikhail" <Mikhail.Terekhov@dell.com>, Adam Horshack <horshack@live.com>, 
	"fio@vger.kernel.org" <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 5 Nov 2024 at 21:33, Vincent Fu <vincentfu@gmail.com> wrote:
>
> On 11/5/24 15:45, Terekhov, Mikhail wrote:
> >
> > Does it mean that in the regular case (not write zeroes) fio spends significant time scrambling buffers and IO performance is lower than it could be?
> >
> > Regards,
> > Mikhail
>
> For regular writes on contemporary devices the time that fio spends
> scrambling buffers is small compared to the device response time.
>
> However, if you want the absolute highest write performance or are
> really pushing the limits with a device, it might be worth running the
> job with zero_buffers or scramble_buffers=0 to see what difference it makes.

It's worth noting that even in the "not write zeros dedicated command"
case some devices (or things in the I/O path like filesystems etc.)
can detect or compress buffers of zeros and thus are able to achieve
(unrealistic) higher speeds that they cannot reach when "real" data is
used...


--
Sitsofe

Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A408E1F462F
	for <fio@vger.kernel.org>; Thu,  8 May 2025 21:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746739729; cv=none; b=DVmxhrWcpFq5DQur+ph28H8WlpUoyR77lDwjpfyVH1mny7OrBTiXNp27XW5w3+eFk3ElzwBAF3WYXTtpMmKA0YppXYESD31T9XZr2whBxxiujmWk6fCD1I1ni1ubhF9IVn/vuPMP5kNfSTEg3mPF2caGlrKlWJkKSTYh/KYmGAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746739729; c=relaxed/simple;
	bh=wNgHCggtWeDyavQhX3Bvl4ZtaMwFP+8cquUiEukEYIE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ppnh6jqhlsTijFoA0WEPCgxdtukCMHSfuc4IiZ3GO2uTxvCdfAZRlrNo2ZmXGA4LoYxwVBld3kSxSxgGfR1xg5ZT9HPdr8ngGPkxVnA378KSNGFy75lYTVXF2YhxISgFB5F2ZSSw98ohfBekkR4Y8oRLQ1gUTmHnWAjDfQNcWt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jeuejnl4; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jeuejnl4"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22e8461d872so16151065ad.3
        for <fio@vger.kernel.org>; Thu, 08 May 2025 14:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746739727; x=1747344527; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wNgHCggtWeDyavQhX3Bvl4ZtaMwFP+8cquUiEukEYIE=;
        b=jeuejnl4O9OzDZIjaoJgZlKT1mv+dgoZeDM1zLrgZ6ilqzCntsuuh0/7es+HNLA569
         nWibozD3oibGVfNXo1FRJrG8EeNXI9Ltu3QrnJfwPQekHxy4vkBBzzRdl6a3BKUeV0Jp
         2zpoyc4FwrfCde8FEqrGrFppFMHY9+FqQByPdvE/51cnNPZmJJOGC1o39LF1hNU7HAmo
         aKkSdoj1PYzaahHgiPKpJSEKjMnG3gN7U77cdSRFT1BIxTWmNxhHQv3PVMT4p0GGxfhr
         r0CnkaC7zgyRDtpemS+rgFUmEUJLEm7wgRX5iDpY87maAfKkXxGGkLX0CXd2dulD3sZG
         Ow/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746739727; x=1747344527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wNgHCggtWeDyavQhX3Bvl4ZtaMwFP+8cquUiEukEYIE=;
        b=tLN1U5Fy/IudYyIrMbS+tJOQoLzNg1zSOu8l16N8KyWZTcrPyX393Ta/0a45cgMJjS
         eDARD3/nCd7qOG7+Nhu8E/G+U+UpNl0UHFtaO/UB71TMuq95C/QDgABz3SLtb7KGg5aK
         7DX3Vyx3tffjyTFcSNsmkJCtOe8RoXniB7+3Ug9JdKqAFxSvJ/g7aj/S8P+5rsFej3Me
         9hx1bDB380iEKWAEp+y+0VTBHFQvXF0mDLxA/XHLoCrekMDMCWLaoQCjrry+FoLPrZS+
         XagrT93XLgJ1nN1cTHZ2PhiBIAEKeWzV7Oga/3eh8hBz+39OLyJfciE88zSsnv0xHjKe
         P3Dw==
X-Forwarded-Encrypted: i=1; AJvYcCWsn54eHfEEY/EK21AqF5i+tzoOv32nxva8LQJHd1wJbRREYR3RvWT95QiZQGPfRZ953Z4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+Lb09W6yxW8DlwszGYWraml9QvBC6jI7Sbyk72iOev6GrBZT4
	w4jY5Pde+OnHTuU5GgRNwen0apo9ISgOlo/zMGf6gicdqU9KYZafDzwWpIR7ygvMPlKF4KOWlZV
	/gzX1N1BXL1sfc5NM593n684gENn1UNlx
X-Gm-Gg: ASbGncs5jZBFHyXjtWv27YbwKWCAJnY9YGc5r1pRajQEgpA92oGKfJDq8lJDSnfYNDO
	boDHLdaHr1TztE3YTdqDxOYfa9s3lU4AxSgTgg9fK2CiTxBMiArj2ygo1/FbxscCSdwvJVQh+RS
	xfWp9Ep0yAYmeXAXHP//mEL3R02Ovi6f2Q1gnlAs5F0AjlVNjvMCWPtw==
X-Google-Smtp-Source: AGHT+IGn3pWKYi43FZvkx5DRMNO5v+lB7LIcYvJ3KnfSZnawFJ2bj/zeqc4BBfYJJ5tt7hZyAyUl7Lp7poUAX2EBptE=
X-Received: by 2002:a17:902:d2c2:b0:223:33cb:335f with SMTP id
 d9443c01a7336-22fc8b0f5c6mr12294765ad.3.1746739726772; Thu, 08 May 2025
 14:28:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250508171444.2113-1-vincent.fu@samsung.com> <16cf9fd1-968b-4349-903b-9a58eb0c9945@kernel.dk>
 <CAOp=CX=dgfwZqbjSqxHgRSRZDLkifJFEWemeVvpBMcdR7WkADw@mail.gmail.com>
In-Reply-To: <CAOp=CX=dgfwZqbjSqxHgRSRZDLkifJFEWemeVvpBMcdR7WkADw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 8 May 2025 22:28:20 +0100
X-Gm-Features: AX0GCFu7jhNxiNqcIrO4QKeyxDwO2SItV39XVB3OqTIraVEJ7vS5gj5Uc7v3UzU
Message-ID: <CALjAwxiq+jeuvvhRF3CDv51ttb4Fa3seLNzorH=z8N56dxnhOw@mail.gmail.com>
Subject: Re: [PATCH] windows: fix pread/pwrite
To: Vincent Fu <vincentfu@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, 
	Vincent Fu <vincent.fu@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Vincent,

On Thu, 8 May 2025 at 18:33, Vincent Fu <vincentfu@gmail.com> wrote:
>
> On Thu, May 8, 2025 at 1:18=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
> >
> > On 5/8/25 11:14 AM, Vincent Fu wrote:
> > > The pread and pwrite functions for Windows posix emulation never actu=
ally seek
> > > to the requested offset. Fix this so that the psync ioengine works co=
rrectly on
> > > Windows.

Oof! Good catch!

[...]

> > lol, how broken is that... Does windows have any offset read/write
> > variants, or is lseek required?
>
> I could not find a better way to do this but I am hoping someone who
> knows more about Windows than I do can weigh in. Sitsofe?

Sadly (?) I'm not a Windows expert (even if I've occasionally played one) b=
ut
according to an answer on
https://stackoverflow.com/questions/3852758/equivalent-to-pread-pwrite-in-m=
svc
the only thing that can take an offset with the request is ReadFile/WriteFi=
le
and this is done by passing an OVERLAPPED structure
(https://learn.microsoft.com/en-us/windows/win32/api/minwinbase/ns-minwinba=
se-overlapped
) which in turn can specify an offset even for synchronous I/O (see
https://learn.microsoft.com/en-gb/windows/win32/api/fileapi/nf-fileapi-writ=
efile?redirectedfrom=3DMSDN#synchronization-and-file-position
). Unfortunately ReadFile/WriteFile only work with Windows handles but I th=
ink
you can get one from a file descriptor via _get_osfhandle (see
https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/get-osfha=
ndle?view=3Dmsvc-170).

--
Sitsofe

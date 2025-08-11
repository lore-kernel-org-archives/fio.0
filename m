Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0863B72600
	for <fio@vger.kernel.org>; Mon, 11 Aug 2025 18:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754938558; cv=none; b=ut/IBMV1dmcwQ7ZiWw/KsgxN2G+JfGnYfrruJKHSN1nQr77Or1+qMm/zSi5QOfTT90nS9JRyNzEjnViHSCXNvvmX3YSK5ZhDJFR2mNrAsIh0oVX+gsxQGTE2af9NZHZ+vryr/A8zhnXbB9SH6wdkFKi9KV6JhR58HP0smEegupU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754938558; c=relaxed/simple;
	bh=G/sx/Szt1SfMcKJ9sKIm+AAWynFDN5uYgT838Asi968=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oHDIJM1a8+HivFMNrEaDFXwjen5KJ0XpZS4YMi49ukogtMDE1X/hQMGbSQ36hlNLwHeTa9rlRrP2AmA/p1EuyFTlzrJYV8yc7zvaUX8pVGcRirliTQQFwnCqw0Ig0IV2jHGUFJRukTsF6jcsv6Xivoht03+/dWSItGIkiPtQHl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fgoedgN3; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fgoedgN3"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-4fc9db52e02so1420564137.2
        for <fio@vger.kernel.org>; Mon, 11 Aug 2025 11:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754938556; x=1755543356; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kez/crGXdwWd3Rhp134kT5A8lhY37LpxfO9GjA5cQwA=;
        b=fgoedgN3mPVz1mDUg4w/uCOt+2uA4RQPFe8y9Ydk/zzy9HFBy/LLAE+2wPmRtyX2YY
         dEuCF99G4nnWFGd97/d6WRB0IYUNMc/xN459MYG+YzmD3BmYmxkkheVIhEN0rNEJJw8v
         a7eQQmXodgUeh05Mlc+i/zZ25Jj2tPjv9bo8cL3bOy4+hvkl4VWMLpzGe+HCRXOvbeux
         +nIyIinHnLVNCIj3iWWEdOcVggODZTcqAvDr/1GSQjNMJa/J3Tcq+djKQ+tOn9i7tDrL
         aDhmg825dn4uxHIa1hW0yN8oqaXEPZPYpTpo0il5E/EyMuLA/b4EIPRXXzrDnmGXkIp3
         uPLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754938556; x=1755543356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kez/crGXdwWd3Rhp134kT5A8lhY37LpxfO9GjA5cQwA=;
        b=CeDkpaB8XoWiOuB8doaw1CH9WRIdLkujJTfAQvjJXECUfLWw/SNB8ibvnIQZnnp6nm
         8vAhhTIxSOM1X0ztP/xMhHwDLmml9ZjwPQr3unkWOErL6PPdxXogwJ5X79KOfije45cx
         QL1S+ptsmMSUS/B5CzHnvI3aWVPngPDjw3iTYftMgLoboirkcrLo6VZU5yACdz5D9ExI
         236qxqVhaR6276ostcL1mIvRUExpXU6ywD8/IE/XPVT5C1ZPX45KrpyK3xc+l4Vve5u/
         JUeSLwF+B5VgHpUL6DPsDU/bankyOF4HLGabuYbWmJOpDSNUW+O/yqb2SStAJYAjYvab
         hFhw==
X-Gm-Message-State: AOJu0Yy6ULGUpp8vPCvjQWVGhguHbuZubd/fJmtVROppnExmFueT9OT+
	2RIGXE3Z7eE00LGC+Sc5vFJj0D2BXBgNmAlrEVkMMvzUus2XtPWX77frBYd0zh3HoiF5Z0xV+0z
	ljzKinGsp12U2P6pP7tHCwXIb6cy9Qcl8yg==
X-Gm-Gg: ASbGncsOPiCybTHAFnUHpMPt7LaY2EX28A3yqnixVvRslF1O+8hSzW3ny5W93PymoB6
	i9t4/wCMSiH0c72V/4bR4ZB+MHSwY+vVubtRmtIG1gvPp4MglmEFKZh2q/75p41xh23VKAelG4b
	w3d3nEhI5O6UQyNrQ2O1kRd0V6X4IRfNop7ZpFEt+tBRw4nId0vVtx7njPA0rx92WzOqOBW6fvQ
	q/ZhaWi
X-Google-Smtp-Source: AGHT+IE6Zfmg/1pFiqmWThl1mp7iqcKsvFzvy7feJ7GgMLp9ckMF6VlYmNgDuEwdvbjK27eOQHZ1ZLlvRocxgHuAU8I=
X-Received: by 2002:a05:6102:f11:b0:4fc:1233:7a1a with SMTP id
 ada2fe7eead31-5060f0cfecbmr4643799137.23.1754938555714; Mon, 11 Aug 2025
 11:55:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250809011555.948564-1-shinichiro.kawasaki@wdc.com> <175474971142.643727.4390148010932341386.b4-ty@kernel.dk>
In-Reply-To: <175474971142.643727.4390148010932341386.b4-ty@kernel.dk>
From: Riley Thomasson <riley.thomasson@gmail.com>
Date: Mon, 11 Aug 2025 11:55:44 -0700
X-Gm-Features: Ac12FXxohn-yYH7ykCa9JKq6N79gmhwvL24NV3809eBC1uBFAdRpXmbuieu4dEk
Message-ID: <CAM4SYzyzYAP+DiL9sCP6Jwog_ZRzUR6YToSNfad+9vHNg1o7nw@mail.gmail.com>
Subject: Re: [PATCH 0/2] verify: fix issues of verify state handling improvement
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>, 
	"Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for catching these! The sync error path is a bit subtle but
the version bump is a facepalm.


On Sat, Aug 9, 2025 at 7:28=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
>
> On Sat, 09 Aug 2025 10:15:53 +0900, Shin'ichiro Kawasaki wrote:
> > Recently, verify state handling was improved through GitHub PR 1951 [1]=
.
> > My thank goes to Riley Thomasson. The work provided the fundamental fix
> > for the out-of-order write completion issue :)
> >
> > However, I observed the work introduced two issues. The first issue is
> > unbalanced calls of log_inflight() and invalidate_inflight() during
> > write failures, which leads to fio run stops by aborts. The second issu=
e
> > is verify state file data structure change without file version
> > increment. This patch series addresses these two issues by two patches
> > respectively.
> >
> > [...]
>
> Applied, thanks!
>
> [1/2] verify: fix write tracking in error cases
>       commit: 1e6ca399f8b5062fcb4be3b043b7355a0617afb6
> [2/2] verify: bump up verify state file version
>       commit: a52833b3295f0fae160eb3d4937a371756d6d929
>
> Best regards,
> --
> Jens Axboe
>
>
>

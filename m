Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1AAFBF0
	for <fio@vger.kernel.org>; Tue, 27 Jan 2026 01:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769475726; cv=pass; b=aYtE5IMlHtk9LylqxYSfnmApbDHlWbcFCXAbGC2272Yxz2wybniN586LFWlLQqkaM8KGOrKpG5WPtcIU2+4/nvvcdY0f0bR/qsw67fCfqZJyWs2Q3J3PRAuyu2PT0+C9l6W3J7Ao6A7Xx3LrQtvCJ6Ww0q6jxBdRtnY1iQkN1GA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769475726; c=relaxed/simple;
	bh=3jzabpDVALi2EBGt2zoZaEM9HpwDUVdUAxxtmimA6f0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n5eZp/e66S9TgYoW/rfNg2GnSsscbXZz8NLLNVWfnfFraXoVdc3znS0csdNUg/8TlOAJuzATQ0sNqBTPFYQ3bxMKt4MUxYzgw/1qj2Cxfv+Pcgy3c36BrYqxok7gGv7FT+TECcTv3JcRKfD1Xc3mCmj0UqIvZw78MNMPQZy20A8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TkQnTlUa; arc=pass smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TkQnTlUa"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-383153e06d6so45723861fa.0
        for <fio@vger.kernel.org>; Mon, 26 Jan 2026 17:02:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769475723; cv=none;
        d=google.com; s=arc-20240605;
        b=SLc5yZUAQ/jZtsHL+PRfj9N9lqH/sDvlBvvvQ2dN76gHqlAnbQhPxyTGwsE9pXY0Tz
         QxD/Ui3xe7hf/0u+atSl19+JmxPiYixMS/zydS4UtAFScDfyCM3LNl67E0ejlxN0oh2f
         JpAB44t60eU76h0xOmlzs7nUqPcdDmIrz53DstEudHpd4+VIg4B+U+JKVY42ibOfAFD/
         5jNBeSOVTaGQNb0R9Ac1zw3+d2EuGrfUubvDxDMAYIp8WADR6aTNvOd66hK/RAkhpdNn
         MN87Db/MSoF+7VDSgGTSEz1ue1JeCgH+l8uN3UEuQAn3O8x28Hc5nuIHXmCprbzl3uqI
         sgGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BsGlZRajPDQZtJcRnwsV6UUZHA/TctDsIoSVkkPGaJs=;
        fh=gL87eSS4wBti6cZNwPiXv6/aOCcYnKaiDV7C9q1zHRY=;
        b=R7fkiJ60oKzkFWfbBmPK1pOunN8qsb/Vst/z3fmb2Hg+EWuTvCCVtld653Q+apl4yd
         rwNO2F56+1AQdTVZC+CMITy1uZGIInSiSzcZeimg9Tj3k5P15INha906RQ6ve0ELYN1D
         QRrKLWE/wozpjLhrMIBAiSANG+mZMq4JJb77xyhm5qBWwz4UDL/DzmD5fTP+Jb74CAGw
         C2bmmVz9QdfKwXLx8L4OHH0I2n0bdoiO6UXt6/i95UgwYG0+taN3qHbEQWmNVzDenbsc
         nydzBODib0bMF4IvPQFB8K3ZpIAtiUYmdOJv127z9AH4HTyuXe7QNybPithtqmgL7T5w
         Popw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769475723; x=1770080523; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BsGlZRajPDQZtJcRnwsV6UUZHA/TctDsIoSVkkPGaJs=;
        b=TkQnTlUa+APaVEn3+L0V/pPzxX7YI8BdtbJ49a38x0FvEwqaBhjwz3ogQAyLq8wUSa
         k/8CAIofGQOn9wnwIh5EiwgCmHKFAl+oQFbETxiZWKiqlRWS3MF48CbnKX5NSVlCluYr
         7RhOmuyRymDvtknd1xR+rJtbXHkcPEtNyWXHsXWeXrkNQJB7zJF+zmsNWaCcm95uQBww
         Amxgf0UAHcgg6V/dn0irozGFQCMdd6jBEBi7hyo6S0gfrmm0kI+FXh42tOkyf4JF9lvS
         VpIQK/6s+epG7GE+871f9frJbikJtGcv6hG0Pl7edsIBq+UzW/3izGTb5XkaQ3Zk2j95
         4tkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769475723; x=1770080523;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BsGlZRajPDQZtJcRnwsV6UUZHA/TctDsIoSVkkPGaJs=;
        b=AmYZxRhWT/XbWi5EGjDJkUFyCipblr9Q6/BZvMFa+F6XLK3RqosB/7AdtjqaMgJzCA
         rW3kmk6EHTqREJRMc7CJQ9Nnpg7w0UyJFL57lLh9NJJML4W4XanTKDVZS9QW1DHjJeCl
         TJQiGK8E2d5//o8EV26vEx50eMeWlEpS2R17AcrsDAZz6Os1sMYJ9LCUF2gkVrqsqDJj
         jzLZu5V6njSdFNkZ09tvxKlYE/CRXj9g4G8eIpbWa6QR4AQsNQ4m0fTuVvXzLDYoKbmI
         ROd9O9zsJPaHkyl4hYv79yclngZWpmNIL7qxs+GeASDAN/2bV3LyHF6YIGh623ODCyrz
         odVg==
X-Gm-Message-State: AOJu0YxvcG2bCpiE/IthWD6nTZIVbmgbs4OXZMLu//aFdcVUdakeM49v
	VpqLmr3wE/DzeSlYszndZAn4sfFliM+ydMbTVjGhL+nqXtn0QkwF2ue/a9b/iolzkR8T5TswWHa
	i+fFbWFPEyZxfgisW1a7ACqEmv5t33JKdpQ==
X-Gm-Gg: AZuq6aJ6q5G8ZKo62Dqqcu0wMzZmSoBDDmeKcifiZ/tu7GvJpMQe8j0blM3aDniRGgh
	xiupLwmrFbn7gerq7yQs4DBe5Q6gD0XQEErpQysMar6h9C8Axi8273+2d7ZC2wTklm2ySMl8zoh
	UpMrEKDKq7da9ln3ZmM9VmvRF107RdFWiT/+Yq72VuGl3NtyYYLMlKYsu0RjeqHC6vcADIBA5d1
	3du9JcGBJT8OEpIm/uiBmIhrSvD9A87Qu0GXMlCPEiIU2mnSZrrtY36XVYmWmMQeZbWwQ==
X-Received: by 2002:a05:651c:1542:b0:383:1232:379a with SMTP id
 38308e7fff4ca-3861c8728b3mr38591fa.2.1769475722732; Mon, 26 Jan 2026 17:02:02
 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126061721.270448-1-dlemoal@kernel.org>
In-Reply-To: <20260126061721.270448-1-dlemoal@kernel.org>
From: Vincent Fu <vincentfu@gmail.com>
Date: Mon, 26 Jan 2026 20:01:51 -0500
X-Gm-Features: AZwV_QiGw5fX0dMS5bwvblFzEAPaOg2FpIYDwcbrfHDAAa781Q8x8aC2EYLSDec
Message-ID: <CAOp=CX=dWPmgjKhZFK8BDKA57qyYJKCJkYBKYOLynU1n6bi=ug@mail.gmail.com>
Subject: Re: [PATCH v2] Introduce the end_syncfs option
To: Damien Le Moal <dlemoal@kernel.org>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 26, 2026 at 1:22=E2=80=AFAM Damien Le Moal <dlemoal@kernel.org>=
 wrote:
>
<snip>
>                 }
> +
> +               if (td->o.end_syncfs) {
> +                       td_set_runstate(td, TD_FSYNCING);
> +
> +                       for_each_file(td, f, i) {
> +                               if (fio_file_syncfs(td, f))
> +                                       log_err("fio: end_syncfs failed\n=
");
> +                               break;

This seems like it will break out of the loop after syncfs-ing the first fi=
le.
Is this intentional or should fio break only if there is an error?

Vincent

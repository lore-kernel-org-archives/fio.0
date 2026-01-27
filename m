Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6D627FD74
	for <fio@vger.kernel.org>; Tue, 27 Jan 2026 01:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769477993; cv=pass; b=GLPH+iqkj6oh7IE1bYD7i2K8MnCe/IqPpxFE6C3AUJ1KT48z6zw5kTk0rRFRZlTsj5OdmvbhFrkv5y5fSBk4+a0SMuO3ofah70f1tlL9gSnUiL4DsSV899NzVVap3gtCHCGTbohu1k1EcW05yHSUmJvw/2ZMQGUfHfo12SnIoJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769477993; c=relaxed/simple;
	bh=efbBBJxb2J1OseEdDzcI/E6Ra3nWVYyy/VULpqHC2Yc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fr6yTd4ZZRWvpHwa7j6L7OXNoq1PzTBskNAG4Gg+vPMK0+M8we/hJi9BSzewVMJC5AxfGKQjotySfDJN9uAHivASwVf0YRv7VzOTrmZTb+DaLRcTqab7IwrZZaDepf+UjIXt7SQAn6zxZjUnG++IFi9UC6ULe3V2n/VUdLsNjEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VaJSeXQS; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VaJSeXQS"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59de2d1fc2cso7104595e87.2
        for <fio@vger.kernel.org>; Mon, 26 Jan 2026 17:39:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769477990; cv=none;
        d=google.com; s=arc-20240605;
        b=by7oMt5Jc+rAR1p/MD7jAg+wgyYHa/vNBOVnojvW0Y6P0ULOS7nxU5mrbnu1C4UT+S
         u8feYW/Apeq3fJetG9S9mf7aRsu9JKAhSqgDnGWHkY7f5IwGW5SlPNLqeIYdsAgHBcq+
         wA1dooXoEPHSnWMKLBfxsmoeShAf1K3nrd78mI/UL+pGKrzRVheZt02bHZs7l5vMG/QR
         69yD8azAljmk9wQB6lsOe3gBeTaBQa+Cua/o8ry2qWGKBRMyqpHKlIplGC3WxHUYkRxl
         MRk0AqRZMdLDkPDrhLh3WSBS5avtnuwl/cYYCEvz1NEB4K+dCLOC4j27IptYad9alaZZ
         WDrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SZcCnc3uh4WrwkVdffZeu24xvGTV6K6yoygFVeaVHgA=;
        fh=k5DC5lFBnQoQAJUtOXIH+fI5BBFj5/t3YdQ1lYmC4iM=;
        b=FPrr7TamQuR9GwKfpwvu05YcnImrnPkRS/eH0auCg0FBM6S9vOAaNnfrCooVcwNkTP
         viuyZvWzD3Wxoz4+AxezjweHRo2SOoFqvcDXROHqQUvfU8xS9B4rfKjUNvgx01NldIP+
         f5T0ZQOhl3S/aAqnR4KVJOJEdmIE/mc4jsgZAacRgfl7Ciu5RQHAko1uuTUwpv1NiaYQ
         ovlcotwoohzfRiITtGIpp/Oc+TWahtrvo7s8+7trNlJMY4i76nCzNkhELkzpiO84xGRL
         pHs9Hg5PulmLmPbTpRVFs4G64057wbSe6roduIS1KgZg/pK/rdYK6+0QXMMaGMhfZMwx
         jMpw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769477990; x=1770082790; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SZcCnc3uh4WrwkVdffZeu24xvGTV6K6yoygFVeaVHgA=;
        b=VaJSeXQS2UjerFMknVg+PSHfNz49EwsAuZHOvbZxf/BntqxRFJKGuVDuPhzpPuW0EU
         Q6By0od9QC9AlsG1fDVAvuAZ1+rhU41U3zfb8WxiuPdRvfd+7nGeNlKKP3RjMtZGf5MG
         lF5N/5QppHbod8bQJQXAy+4DahTcad88XSJ7Hr+bCbNZhZ/iUIX4zRs6QTcd2PsJCavc
         mIAMTl+XgPCe36SlPX7WFHbzdk2fpGNcSZP0unxkDHnHSlEBTVUBxXh9NPKtyIt2qRak
         u2Y81nJDD96Rwp3a7MDk/T1WL8+wX2CqtH9F8Crg5uuBpotLJe0gb9c7mwGn3g5XwmbN
         bLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769477990; x=1770082790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SZcCnc3uh4WrwkVdffZeu24xvGTV6K6yoygFVeaVHgA=;
        b=b2BwDiUQNcCDDJ1bsRMuGT3hMDyavwuI/IWghylqAbqkOd6orKwyqAXO8E/YEskqEG
         ddczGVZVLGNLd6fcF3wyGH/fBXeKK6E/E1w6DgmzKBGLaErcCr4YqTDe8H7i9XShq+dP
         D9/pTZj1+Cb8LRh4UvwYQUS/Ktu5qp774vz/9tbgEfFRgsv/334bkJrvGOd7xb3Q1fZI
         /DXB+zrlleotUd5kw2Uod/AZfyrZNRmYB/kXA6fCGM0vz8c3+rRYjoadfmLwKv/Ez7XZ
         2RP0qsU+0lM/qToqakdaw5YUuitGCJkASdbrJ7VvY7IQ/DwzJwYDEh1zf02XQEy5yREs
         BJQA==
X-Gm-Message-State: AOJu0YwW42J0J+arhhzjarWJfdDiHbVttnnJsNybEh3fI9jrsvUfL7bC
	uaZ998BLiWrzlpxVm/bRBipoj/hcqnR2br0XwrcadoLzxvzoO6EDiwin1HgCm5Wt/bY0OSGmZPk
	Ggu7+hjmLX2KmBpPmQpj7UH4z1M3yKpCidA==
X-Gm-Gg: AZuq6aIaQXpkWWiBgV+4RmYE04OWoTPB2NA3ghXkF5eav/2/6f7p/zsoxv3uMnRSlga
	fKm/LazxtP4HYzoFiNo+96bMxyA9sREOnJitxlA9+sAyGfcKsY/2vz4IZTyEKiJEZan7+Y3UwvD
	hV0hIic9gR+5H4MGSF9kfFgWkSJmqmQ97oms62WghRfW0BQie8+8Eqlk/IhHZZ3e2AAS8wp25Z+
	yyw4jD6Lm9OszzCxqZwCFq9xLETDwm/7j068aE+3UsDJ2jalgTwRCrL23U8naI3B7liPW0zDxrS
	CY4F
X-Received: by 2002:a05:6512:61ab:b0:59b:7319:1177 with SMTP id
 2adb3069b0e04-59e0402b0b5mr4828e87.38.1769477990101; Mon, 26 Jan 2026
 17:39:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com> <20260109023603.2848421-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20260109023603.2848421-3-shinichiro.kawasaki@wdc.com>
From: Vincent Fu <vincentfu@gmail.com>
Date: Mon, 26 Jan 2026 20:39:38 -0500
X-Gm-Features: AZwV_QjqGDMiaLX2gR0vrLfNeH-YPXi7Sz19FwJLg9I4GRVQWqe51s9X-larbRE
Message-ID: <CAOp=CXnX9zorei7vwO54OvxBeFEjsKzgKXZaLqDOmu24-X9bbw@mail.gmail.com>
Subject: Re: [PATCH 02/12] zbd: set norandommap=1 when zonemode=zbd is specified
To: "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Damien Le Moal <dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 9:36=E2=80=AFPM Shin'ichiro Kawasaki
<shinichiro.kawasaki@wdc.com> wrote:
>
> The random map functionality relies on the minimum block size to manage
> the map of written blocks, in order to ensure that all blocks are
> written with a random workload. This is normally fine, but in the case
> of a zoned block devices being written with a minimum block size that is
> not aligned with the zone size or the write pointer position at workload
> start, the last blocks of a zone can only be written using a write
> operation with a size smaller than the minimum block size. This
> conflicts with the random map operation.
>
> In preparation for supporting writing a zone remainder smaller than the
> minimum block size without using a zone finish operation, disable the
> random map feature by setting norandommap=3D1 when zonemode=3Dzbd is
> specified.
>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  init.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/init.c b/init.c
> index 76e1a86d..9320bca8 100644
> --- a/init.c
> +++ b/init.c
> @@ -665,6 +665,19 @@ static int fixup_options(struct thread_data *td)
>                 ret |=3D 1;
>         }
>
> +       if (o->zone_mode =3D=3D ZONE_MODE_ZBD) {
> +               if (fio_option_is_set(o, norandommap)) {
> +                       if (o->norandommap =3D=3D 0) {
> +                               log_err("fio: zonemode=3Dzbd requires nor=
andommap=3D1\n");
> +                               ret |=3D 1;
> +                       }
> +                       /* if =3D=3D 1, OK */
> +               } else {
> +                       dprint(FD_ZBD, "fio: zonemode=3Dzbd sets norandom=
map=3D1\n");
> +                       o->norandommap =3D 1;
> +               }
> +       }
> +
>         if (o->zone_mode =3D=3D ZONE_MODE_STRIDED && !o->zone_size) {
>                 log_err("fio: --zonesize must be specified when using --z=
onemode=3Dstrided.\n");
>                 ret |=3D 1;
> --
> 2.49.0
>

As you know, we try to avoid breaking existing job files. This change
breaks 3 test cases.
Fixing a genuine bug or clarifying previously undefined behavior can
justify this sort of breaking change.

It seems heavy handed to suddenly prohibit running a test on a zoned
block device with a random map. Can you provide a stronger
justification for this change?

Perhaps you could instead emit a warning when a random job is run with
a random map and then condition the relevant changes in later patches
on the absence of a random map.

Vincent

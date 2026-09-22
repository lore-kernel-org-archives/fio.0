Received: from mail-lr2-f12.google.com (mail-lr2-f12.google.com [74.125.230.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7222334C3B
	for <fio@vger.kernel.org>; Tue, 22 Sep 2026 00:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790037406; cv=pass; b=i+dy/Qa8Xj8g2o0KojZhtP9QxqnIbgKDoxt7nYGpfsECZ3PkrnQTOh5ykYXkD29qYBL19qXxMOU2FHaDeuUplbsO1LvrkPmb04oP56osjMgV/wGQpV3TTM5lJ9Ykzvi1walVHB/PXieKU0j+nZu2mbjtQCE5OIhd/LWP1AHHV/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790037406; c=relaxed/simple;
	bh=etSECS+xnVAC4+E5Df3Pd/TRzQLGG6TudMef10m0ycE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vz3VgJR6L/gP3SuwUS68JluaLAc27Q+V5AMgPAseBwlOlig8o5wJnjr7+FhXQIxFgbtSOaL2zg9bWWwUZafgz5hk3zsFRk78rojAtSkl9eDzMGQ3MNgNKeaHHD28uOegBsuJB6yeqDdej6Uqn2EBMzR8Bnw5XNvfS7iIfMof350=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rL9pbNZr; arc=pass smtp.client-ip=74.125.230.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rL9pbNZr"
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a49bc59559so24474391fa.2
        for <fio@vger.kernel.org>; Mon, 21 Sep 2026 17:36:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790037399; cv=none;
        d=google.com; s=arc-20260327;
        b=S9GyprMD4VhGQeyGnTxBbU5KAAMME6xVs1qEJ5r1SsU/MBXE5Da39xEr3Q6e3T1FoM
         NozazklPNiWkD7/j2nVYM8HCsWRBSuejfaXxD9BnvBRiBUjNxaPVy0umCFkMs3WD3DVD
         X7ZyGlM3s9r72gwGtN8kRqLKaZQegAmskR9uxth/PGkDbXP3j+3/Q9D34AzZVs2GnVX+
         ffCALMrKpH8Z7p580ZPckwrjnjexWMyGhpQ2CQonX3ro7/Zdhj8LStNosQAaGJPD+ZDi
         AxL9YnVjxVoZdTMCP+DT56jdVbKW+k/+S00br0C136VHmWdKd+CjetcB1LxxrLXbZu9Y
         mg+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lRuWAHk4kyFK0hEZ2+Q09mFD+fHbjkKBlvXtZiphLS4=;
        fh=Kl6F7yvf4czyo/eedW04ixGw46+/QQw4GW5u9O7r+QI=;
        b=l27z92tFBkez31PVNw1oRS9rfHzGusc2eBhweiQlOV4PHNf24+k1lzvMkycgVMSEyv
         MDzfQGoCSJn5zjY0ELShpojSo8zlMBRWErHqPs/7A3olIyqm/mNivJdaa76siYOTiThK
         5k90UnKFnNJSRvOu1I26nGbUFEI8KssfPoDl1CYvJGpM7isYcLUStCHzD92V7miTSQKW
         uchaOedckTDA66324vxnwnc2uekeVPigYGWgCv54hHwoDWhpx/Nn1ZXoFBjtte6dlQjo
         SWDY6EWHX5tTuU5ZdvDLIDLzDVKoPIqC9BuhBdjJiJ0AUboR5FJy74sZzFrVqeU7wIqt
         UxxA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790037399; x=1790642199; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lRuWAHk4kyFK0hEZ2+Q09mFD+fHbjkKBlvXtZiphLS4=;
        b=rL9pbNZrmSlP5kqthVzXaapK6FCkHVeqIsc7EnbmtIr6gicBp6MSmzejNUzgE9wdCT
         mxRSQNdDnCX5jQlcPKNTwWZ2gscS/7oL3mkD9ujj2k9uF4UyGm0JvePxZAAlzM68erNo
         Uz6vlbTCcwcn6oZxgYSaRrMaOeB2hsznTZNfZWedrH+/To8OLAWAVOmNuefNqjpA0cKc
         PQ4iJmWhhFTEFQJCaz2Ezy1IPN+YWaHxpErxHc0Uxi5MO/u7Nri5l/BPJd85BnSepoBq
         yjWz0Lnsqtm8BK+5LUuce8Acc8VlLWvo1VwmfsMbbUqHttHTdqn6gdxXVsM9WjyOk0GN
         TQkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790037399; x=1790642199;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lRuWAHk4kyFK0hEZ2+Q09mFD+fHbjkKBlvXtZiphLS4=;
        b=a3HdfFW4RB8sORTqHVdRwX2ZKTxwm7l82c19H+8qmSAa7FQtd1GQ9Wxor9Ad8hehtU
         h/ayYkkY+4OIpS2dRbLFYrp87ajmM3lqN3OkZisVKNWZmIUMhGzloITKhurhGXkChvha
         bf8OCO+SF3f4iW3cEqHB5JT2i2aP53EmV8eaUYnmaDwdl+Z2NCqDoCaNwI9+pSKq68x+
         han3ymKdHILXzK2ykABo+ATdK9FooC74ELQbJIAGm4Nzs13yVGjTmOEh+vWpdRPD4NQ2
         VIneN2+hL4hKUIObqWGFUuRsnUwCT5ALjdjOmnSkBzfBVXfqUbrfT8HXwzxD+tUNjN2+
         iSSQ==
X-Gm-Message-State: AFuF++lsXRZveZ/phIcm/Sp0XjP6VXk48nyN7gq0TvrTs3HpXQkOUZKG
	Lor0vLT1vKwvY4wi+mQ1tmE+u+QYxQFJEh/qPTCbioBPuSbY4AcQ0r0W4MjECwdXBcD/tfb8370
	xP3o2RRKTfyHXbhbIiyHEjC8AJGviI5A=
X-Gm-Gg: AYBFou0g5sPTBwcANlsG2VCS1WqTAM6NbvSSHYE1vRy3M5PHsN1OKwyRZAQ0R9SquCR
	64XLvREbX3/4I1JYDtj1MZEjOt1XK+xqy9DWsZwJLD0fZVPcnULZZTx4QuDfdOHJTAmqB6xwq/y
	Wzz+gjxLuqZINkuO6R4EvkwEPOh3m4yEJ3Ws9ngENZDLV7icWdUHojpqtkmDGbecSUYDT2BTKRC
	EtRb7zmPEKyd2NEjeSxWMPqK8A7jVBjN4QBAsCnUPyF8+Z/pdtbh9t7su4pbhlE2Vd9ZMdUX/J/
	ET5nD7LaWJ5DGFUbomuKxMo2/bOXrIHP4gnvtmBs4ob9L2aGqXMkI5FLYYzjhxa7xOo/IIpeT16
	Gvl3lqfWGzr/tKhL3/3OB1Q==
X-Received: by 2002:a2e:a988:0:b0:3a5:e541:4236 with SMTP id
 38308e7fff4ca-3a5fc04b1edmr27758341fa.13.1790037398586; Mon, 21 Sep 2026
 17:36:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921025521epcms2p34a2d819339601929f469f71ca7014901@epcms2p3>
 <CGME20260921025521epcms2p34a2d819339601929f469f71ca7014901@epcms2p5>
 <CAOp=CXmANYTw3at495z+G3S9injh2nLpgOP=_vQ3LBtbaF-G_Q@mail.gmail.com> <20260921232021epcms2p5c738e175300ab42e01655efe7535dcaf@epcms2p5>
In-Reply-To: <20260921232021epcms2p5c738e175300ab42e01655efe7535dcaf@epcms2p5>
From: Vincent Fu <vincentfu@gmail.com>
Date: Mon, 21 Sep 2026 20:36:26 -0400
X-Gm-Features: AcwNN1XBkXDtJcI16_H535hzxgvRIDQH_D_vAPDwrdIFWHTob-Ybv0ZJgO0Fjs8
Message-ID: <CAOp=CX=timCvNWUNpkR-sRpwVJ114mzew4-CuQbMTvj4v_tDSQ@mail.gmail.com>
Subject: Re: (2) [PATCH] examples: add seq-rand-read-write.fio
To: jieon.seol@samsung.com
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "jieon.seol@gmail.com" <jieon.seol@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 7:20=E2=80=AFPM Jieon Seol <jieon.seol@samsung.com>=
 wrote:
>
> Hi Vincent,
>
> Thanks for the feedback.
>
> The proposed job already has direct=3D1 in the global section.
>
> I considered modifying examples/ssd-test.fio, but kept this separate beca=
use the workload differs in a few significant ways: in particular, it uses =
512 KiB sequential I/O, 4 KiB random I/O, and fixed-size runs rather than t=
he current 4 KiB, libaio/iodepth=3D4, time-based configuration.
>
> If updating ssd-test.fio is preferable, I'm happy to rework the patch in =
that direction.
>
> Thanks,
> Jieon
>
>
> --------- Original Message ---------
> Sender : Vincent Fu <vincentfu@gmail.com>
> Date : 2026-09-22 07:59 (GMT+9)
> Title : Re: [PATCH] examples: add seq-rand-read-write.fio
>
> On Sun, Sep 20, 2026 at 10:58=E2=80=AFPM =EC=84=A4=EC=A7=80=EC=96=B8 <jie=
on.seol@samsung.com> wrote:
> >
> > Add an example job file that runs four basic storage performance
> > workloads in a single fio invocation:
> >
> > - 512 KiB sequential read
> > - 512 KiB sequential write
> > - 4 KiB random read
> > - 4 KiB random write
> >
> > The sequential workloads transfer 1 GiB each. The random workloads
> > operate over a 1 GiB region using eight synchronous workers, with each
> > worker transferring 128 MiB (1 GiB aggregate per workload).
> >
> > Unlike examples/ssd-test.fio, which uses 4 KiB I/O for both sequential
> > and random workloads, this job uses large-block sequential I/O for
> > bandwidth measurement and small-block random I/O for random
> > performance.
> >
> > The four workloads are serialized with stonewall and explicitly use
> > the psync I/O engine. The target directory is supplied at invocation
> > time, for example:
> >
> >     fio --directory=3D/path/to/test examples/seq-rand-read-write.fio
> >
> > Testing:
> > - fio --parse-only examples/seq-rand-read-write.fio
> >
> > Signed-off-by: Jieon Seol <jieon.seol@samsung.com>
> > ---
>
>
> If you are really interested in device performance you should run with
> direct=3D1. Otherwise you will be measuring the performance of the page c=
ache.
>
> Why don't you just modify examples/ssd-test.fio? That would be better tha=
n
> creating a completely new example job.
>
>
> Vincent

Jieon, send your patch as an improvement to examples/ssd-test.fio.

Also, avoid placing the new text of your reply at the top of a message. The
convention on these mailing lists is to quote the previous message and inse=
rt
your reply at relevant points of the quoted message.

Vincent

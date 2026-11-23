Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795476161;
	b=JDsMm5lceBraiugABU/1yWfXzc7dhBVbm3Bfz/nriBlgNaGhmcw4AFLDSaFDBPI43pQR
	 rKxzDlEg3qI3vTucDQjFWg2aSum+FoXgRZhUCEOoj8iKG1c1yE/sDZaZQSu7notXO+9bG
	 A8k3eZKcMXeNl2ANyP8ocUHQs/JaiQF2/V996H7UvU199CoWz4aJCWGneqiwTNGMTSYdc
	 Jy0WG6kVVJ6fCPFJF1u8zJwuQ84JMw3Tjy83BgFkSsxqmVAtNK9P9EtIZHA6mP9p/dwU/
	 n1O1mVqiwkgZT+bN/ey7WNGpabl0MxoqrlI51EnkOgvr86uhcHBYn85wVbtRQYqmdoQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795476161;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=vYi2llh9+xZEIAQ5xRLNSAw9ItpjIwXlAi6LIYQfJOA=;
	b=hPr6t5xpEkZvdrTKlZFhBuOdAiiznFkRrCM/dA1cpXsF1+tZ/u//6fo7fAy6qUBn6ln8
	 /mBQZRkA3k9nYBNZPQzK8aTBW41HmON8zmIAvmkha0CMdQ97W/Ap4ab9G+jUJ53dKthtA
	 WPrmiHwI8F4631CayjDz0xJWYNtc84hWGBzq9lq7LVAphMoYYkHXQu6gsH109eXuJe+cp
	 lszQcnqjOsWY++M4KbkPQlyoreFoThdEAGIGnZSXyFmzmOyt+Bpvy/+Ubz+nWbDxpEqaf
	 tBpeEwMOkxbqVMNka6tlKOUKV4CUcV3msjyPCeqRD5UCEPPfLESvyKNDI9Q8LdZRfTQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i4CAtw8m;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.45
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3824F606A321
	for <fio@vger.kernel.org>; Mon, 23 Nov 2026 23:22:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3824F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i4CAtw8m
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5be4a2d94adso3484921e87.0
        for <fio@vger.kernel.org>; Mon, 23 Nov 2026 15:22:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795476159; cv=none;
        d=google.com; s=arc-20260327;
        b=AI9XrTexJWcalJAmpYr2xSkjqu96oFuMwRIV8A3PjODsPaZCycuamjJ0ncMau1WK7F
         PWW1Kny+MwsCLE6gypyLNc3s8mYRe7p7+2v4Xl2eUXQ7uIqtrgnc4KL7lR43BQtFqvO/
         Mxl7mrLtHN2dema+JpX3xjRdWyQfockb0cK+3JY64X5WvuDgtC0baNPgFEWLysoTcq5/
         y3k4WFgsV1y0cqnIH/O8zpUnK4bMzvnY9pWW0r5ZmCFrq1f5GHpYDB7nzaivD3daRddE
         sj2xW6l+QBSI4km23Y1eeWEzGDFpRvb4Z+1KCHiiECWzjRjGtvWlKYj3YThBMUdYTFZZ
         zEdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vYi2llh9+xZEIAQ5xRLNSAw9ItpjIwXlAi6LIYQfJOA=;
        fh=KL7ocyCi8wo5NHSBJvo6lb6F81rZv995ihw3PDTBT8M=;
        b=cMpfV1WlGV4unW640XjPz0ah5NDXVRAYgWHBOCMj5SAyceRLbVPS1RUWXy7ai4uz2x
         fvLfJDVyaD6OWNdzsY3WqMxBSVytxc/wyi2YiqETlTDI52zZHRQfs7Axkz7HCYdzziuN
         dicyIOokJlG2ZKwsvEpEQOVRUyffZD1H1ZDUyNNXMXwMGXOb0nXOEIRjwWRw5NoGYimX
         Mfgy8O3G9jKIHknqyJ1G4Gvfx6QCPq76JRn8dY5lrXWAqHU6Gq0CsuRoniRUlp56opuH
         BBqV7Mzj2qj27O0tpvkilWImyOYtIONPg956ecjhBpVnt0W+HV9natfdH95GogaHK2qs
         AnQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795476159; x=1796080959; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vYi2llh9+xZEIAQ5xRLNSAw9ItpjIwXlAi6LIYQfJOA=;
        b=i4CAtw8mPeAznTt50+FJaD8lUBo0rsX7ZK6VxlqeHv+tG12j8XbdYEg5OuzWuDs4Ds
         S8HXNvToXRl+O5vgX7B6EvC+hb9FvUZdENxAsmJ/4UCvA+n1L2yFEGgJM4r8Q1GOY5G+
         ZzPp1DyPl3AiIXVCk9qQ7IUm3T1uGJmiCB1/D6237oU59TkdhQqy+Kv/EvdbNUK9pcJM
         pJzdWYGCDzDDltYetEtt/9CoDqjlY0z0MEGWMcRQzyTN7GTXRFTwZBD6VHW0B2Qzup7c
         vIK24LIpR8blY2gm2u1NXezIgeOaVqe8wifoWP+wQzuAoIsa+upkeK/M6WV/7RCtEVux
         mrvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795476159; x=1796080959;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vYi2llh9+xZEIAQ5xRLNSAw9ItpjIwXlAi6LIYQfJOA=;
        b=lnQ1Dk3dnWPySu2fJBw+E6cjLuI2OUssThvPVWXJB54UaVCMrFk3T6usFyb21J4Ud3
         pmQsgmQPV9njrxGXQQBFhxJnn4a0IOPd0rY1gvfVP9qDVENEolnquFgSFPDGL4u4MhwS
         sal5e3KORpGz0gXxM6rvygmegd/BD8HMuyiO3sdJF8iJYSCaxs2nBu/Z3J7JkdD5njZs
         31btvyC8YKdOXXbsAggXI2w1is1t/yL+lycL0Onqzg3wYP61+9YVjnvHLmfrj/GXGwd0
         FNn0ewNDRoB/ewv/EuYQ9H16imIlCq6ymLP3tZ2Tb6aChqHeUmLJDcukg12dEeptPaiu
         N/oA==
X-Gm-Message-State: APuU4Z9NP8DlwA8zCsW7x/vNMJtD+ZHCQFI9AksMMtgZWJ5FR79qxFRe
	q7tp6LJXZyAJA0TRAknTr/3I1g0WnJSclNHRyxn+QkaW0l/xOvpOrCz4vLxNS8d0RafeaKu49dv
	Ufan44dxni3pE9iw1Cs3hd/VGtnu43Ws=
X-Gm-Gg: AZFdTZcGbfdMAENhIj7ItMz/th9+mezILbLlZegcZPl7b+v65PJ/otO9MlCqaQJnQ6a
	hzOX1C4ojoUr82AB04tdTSuh6p5N/cG36ze9m2oB6pDbSFwRaWUnrnF6HapP/NlsTGPMyBsCd+1
	OzU4UkKIXCicqemriwINdkkhe4KPx8JiC4oQYDiywMVNDevIutFbBaMyJkvPzcNsu78plCNEDke
	IjqYuampeqkGIovRiW9Ena6uSNl7URiV6JhzlaHFhV1w/a8nZdb5XFBar9Uml5LcdMEPXkvnpjT
	NC0jQmLB0qh72FuPF5CXb0mwFyHJbUP6lG74pLZ/nPcLR2c4hH09AGe5hWrV8vOC70Nvl34Vmlg
	wEO4iVTRbpHygi6hTFQUmK9Bi/iLZbCnMQ2YWWVMcWu7LbuLrjEJNkgAIPxiqlKhw1Qo=
X-Received: by 2002:ac2:4bc5:0:b0:5be:50d7:60f with SMTP id
 2adb3069b0e04-5c1bc7fb764mr3566538e87.27.1795476159135; Mon, 23 Nov 2026
 15:22:39 -0800 (PST)
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <PH8PR04MB994107D250DB2434D563DC57E88A772@PH8PR04MB994107.namprd04.prod.outlook.com>
 <CAOp=CXnuSiNwChAbsWhXpCWyJb7NGFL5EMnL4ZHk0pRm3iaMWA@mail.gmail.com> <PH8PR04MB994107DF1ECA9BFA2015637E198A452@PH8PR04MB994107.namprd04.prod.outlook.com>
In-Reply-To: <PH8PR04MB994107DF1ECA9BFA2015637E198A452@PH8PR04MB994107.namprd04.prod.outlook.com>
From: Vincent Fu <vincentfu@gmail.com>
Date: Mon, 23 Nov 2026 18:22:27 -0500
X-Gm-Features: Aa3M54oKORwjDOgFhwjl82Ll_gP-S2nb6YD5ykz2YQ8k0MplPfEr5GXV9VJ3aTw
Message-ID: <CAOp=CXkfXXFqC4XbsOLzpDC7FR9-p06HgdAvVcDATnpW4jaqHw@mail.gmail.com>
Subject: Re: fio Write Workload with Verify Enabled Aborts with
 inflight_issued When Write Error Occurs at Runtime Start
To: Siriporn Swart <Siriporn.Swart@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jon Whittaker <jonathan.whittaker@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 3:49=E2=80=AFPM Siriporn Swart <Siriporn.Swart@wdc.=
com> wrote:
>
> Hello Vincent,
>
> Thank you very much for getting back to us.
> Jon tested your patch, and the test completed successfully without any er=
rors when using the ramp_time and verify options together.
>
> We have additional functional tests that use fio to generate I/O to the d=
rive, and they also rely on the combination of ramp_time and verify. Would =
it be possible to incorporate this fix into the fio 3.4x release as well?
>
> Best Regards.
> Siriporn Swart

Siriporn, I have pushed the fix upstream. It will be available in the
next Fio release.

Vincent

Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6886D22DFA4
	for <fio@vger.kernel.org>; Tue, 13 Jan 2026 02:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768272698; cv=none; b=KpALbJh+onhnsL5OLCif8oyGVRYfUBI5aGiTNXZCqlYNg70dDK2RVQ+bGObUUUpH1sAbppsNrNJNWr31GOf8Of1ritAS3eYCRWOnA77vV4hV7/Xls0tNWi7Brh1wCk4oFexHAA3lhoOJJFQwfB/pfLjnK0EpzT3PzwB2296Hcbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768272698; c=relaxed/simple;
	bh=KRX0XV7q17xLiQjT0KdWhNEejW0dWtVJsTYMUFZIhUQ=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=YDKrbDqw1bVaX/kCeGr+gZSg0PFKLR+Pqp0C9/JDhYpn+moa4MxSjz8jVv0Ws8VKw7YF/2te2FHpVzN4ZrfUymOev2r0uwkXN19OkUXI5TaGQWeAyjN+6lyumksPUADJy8cCa1x/e6diPzlgASD1dnoDLx6s03G6R9k+sM7igCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PnOxLq8G; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PnOxLq8G"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-890228ed342so74974816d6.2
        for <fio@vger.kernel.org>; Mon, 12 Jan 2026 18:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768272696; x=1768877496; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KRX0XV7q17xLiQjT0KdWhNEejW0dWtVJsTYMUFZIhUQ=;
        b=PnOxLq8G49aiLHCLC1661Wy55kUVeJK9EzUQZ5qRhr0+CKuJSNOCV8blLS3xf/Ruoo
         bBq5GPC060LcOen5rdrmMCderkl6DRkrVfiSmKhlkhrQwOdnirdy6KVqNDeCwBLiQTRW
         h0cpJL+qIEJEVLvjY1aFb9QbmiCVPyrw+yIuo4D2TldXqCOHNw+Xc9JL5Nr5y0aHz9jo
         mQI9dGdSb8Mw8agxjabAh5gTjcNz/UfV7arMIGd23C5S/ro6/a6TOPwSGMlakpPriXZr
         KwtM/dhjrCHjnFHQdw6HfYruXKawiJE/SpafpNZkJDuHZBsMo25hhcGzDRLqDUMoXsHG
         QB+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768272696; x=1768877496;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KRX0XV7q17xLiQjT0KdWhNEejW0dWtVJsTYMUFZIhUQ=;
        b=LkQ8RJxqvQuss+i2g1OJ1zt2OvZ6cuDNR5G27EXcvkluHIxVwfO0K3tQhmOypPsXMG
         gcrhCFopYtljdxCfuGuGON+Y0fcjOXT5OqYzJeYoqvV8vokeE7Fm/yJJcNsK3lhvrKMT
         DCmpmTBpHRILqQn0nTJsaxqv0otK0D8z1N0GshNn2s7/FJx5Apx8bBZU4DAbVNRLF1Yq
         druumhLWG5GTsJS2J1p8qHIla8bJFa764/hE8cIvJtJi7ykL0hqxu5ek8uSNUI/F7fxz
         leDms/M5Nq11VX61Yv2/PWZxEG1ZqeDJ/VuCWPtrpa11GBvkP1GQMBz2l/yPs7jzoEY1
         Y4Bw==
X-Gm-Message-State: AOJu0Yy/HxH8R83XZei4G277HA5HkNfQn1bgjwhXLxFZNt5oiHoTpbI0
	PbJBemz4ScgqP3sVtVoQdsGmiQSjLA3AYur9pVruaJoQtkOxYWoq6kW5+Tco
X-Gm-Gg: AY/fxX6XgtNdUrEmQ1d4tnA7N6Ot+5KbGHaxvXU8fFmW4neBEdUDYyjvDUOZGui+K3F
	rLTJ2FckP5CIlUmnoju8UObQrzzm5DarXMBnNvw3deV6Cwil7DIcxxd/3MO6wjQZgsmhzHWp7MF
	t3CLqszNlKpLc6xTVQ0vc4KiT3hU4LlhznnMxpA1DTlbQeZd/MrYHsAoAecTjOk8mHbh6tVAU9t
	CXqU3X4ctAa7eruPobU5mQ7LzKxhhesNRc6uKNujDLgMi3AjdhzSl64q6YgflmAqE1/xTvIEMm7
	+6uhYRUGxvASIontvLzRwdN3kufrqisw29sGc0wi/xydAvhFHCvO4fo1A8b93HOAQYS8dr6fwpO
	OvugrlDmKXIcIdSZYf0bHOee1Xz9NXGfhAojVM1x6nCwckz2rpMU8I+FeE2G9UFIkpaxwVIgrrW
	d4g8Sq2WJ3NUvAuFLYlxKD9qr2b0PjKVCOomA5ZkZ46NqZjLfXLp9QMMAqseKzJK8Qf/TfLk4gQ
	0/1sQQ+kqLEZVmfyg==
X-Google-Smtp-Source: AGHT+IGGINl7rrq9d2LscH6opMAQoRoy+w7bQTx0NCp+1XZx2xgM6sIvgf4s9H+F0S21owlir6JiMw==
X-Received: by 2002:a05:6214:2f13:b0:87c:208b:9556 with SMTP id 6a1803df08f44-890842422c0mr306220406d6.30.1768272696062;
        Mon, 12 Jan 2026 18:51:36 -0800 (PST)
Received: from runnervmi13qx.co2hjx4eohjutbealrn11xq3rc.cx.internal.cloudapp.net ([9.234.151.83])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770d2cf5sm148991466d6.1.2026.01.12.18.51.35
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 18:51:35 -0800 (PST)
Date: Mon, 12 Jan 2026 18:51:35 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============1084227618934861622=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH=5D_fio=3A_Add_ZBD_support_to_io=5Furing_engines?=
In-Reply-To: <CAOUciekiQpCBKAkAmnNF_3P_tJyL0uTGZdpq8eYY1V0Obrm8mA@mail.gmail.com>
References: <CAOUciekiQpCBKAkAmnNF_3P_tJyL0uTGZdpq8eYY1V0Obrm8mA@mail.gmail.com>
Message-ID: <176827269542.2753.17426120779170250723@runnervmi13qx.co2hjx4eohjutbealrn11xq3rc.cx.internal.cloudapp.net>

--===============1084227618934861622==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: cancelled

For more details see https://github.com/fiotestbot/fio/actions/runs/20934261242

--===============1084227618934861622==--

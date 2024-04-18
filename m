Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B994168B06
	for <fio@vger.kernel.org>; Thu, 18 Apr 2024 15:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713454171; cv=none; b=EeCYeQeFi0dV7U2om4bX7Roba3Tt09DsFfN3oRkvrqUtTYrnQSSpa0OsWt0NZxjfPJEK9Tm4GdE0zEKNimrLQxHUwOJcMktse8EyDYg8mqsAYihyk/6l7aG/UZy2xh4Y/n3BTDiEiCeyf6121NtYWKStvqL/aVJ2eMyez2+waDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713454171; c=relaxed/simple;
	bh=VCuQGJxObp3mLSHswefiBwQor7kTYD5hdgnz3yLH9dc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=PXkZVjM4M6sryP5+8Fv3jareGZ8oOeZijTuZfKI7UhMUp+TCaauSKvoyl8Ux1QQGmKvp7Ys8XaZxHBdKPAKz9I0MO0EwucyDT5kHBSm1iuYKXP/SoMAvfQZZMYPo/17hLDyn6V+9gxlI3vOq33ZrJyG3bh0vmjTmc1S7sqQi/A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JetM+cOy; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JetM+cOy"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1e7af7eb4ccso214755ad.1
        for <fio@vger.kernel.org>; Thu, 18 Apr 2024 08:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713454168; x=1714058968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=62iG1O7gySMBJ6xKvtHY/kvYkJz0zkdQgVs8KAetBiw=;
        b=JetM+cOyt7RxiIhraFRXrw7hnygAf8b81zp8sC4UN/U87fhexTaUjpmFUk6iBqWk4Y
         lYE1mMgkZugjQzDMot2yR7BX5aqJwY84azHyyzypUqORdenSEMsZSURV9ctyBPLR90CE
         cMNZA4YzywqZQJA2hLOoZFcBA5Nn2Nd1REZ5MUYX1QmSV7aWqhCpnBMKSKp+R/gOkhdl
         xgLy6eO5uTQ9xGqa0P859NnLIOgbfz1wR2Hqyx82CZt0NUkUohVrgCD6Pi4U+ltAufLk
         JGmHpcmUuQOVncbyLKSMcSXmWgZHBg5x129b1CfHx/KhnWso1xAVSUayG5I0nSnBqmmu
         aALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713454168; x=1714058968;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=62iG1O7gySMBJ6xKvtHY/kvYkJz0zkdQgVs8KAetBiw=;
        b=JlbZlgmoe4qvRTWFo6FJEvowRl8Q6lLqMhgHv2zMSgRu+YzcQ5lww1JIVqlDhrW9e+
         qYi2+Z/qlyEmkXqAog0ASat/DruANTF9OIHVLIH+e+G5/uQ0yyvNDrQw+DTfASgCg0Ua
         CH2ESBeGRryF79bWY9b27aygPuHtH7N1cxupZHfqf/OeHMWkgMJ6Vxmb1MQ7SdgwJ0G+
         9k8SoeAcx/63L2Dj1XsSnUOXoMQxTux34GfyFTjejHJXTO7H+Tguz1jwmxktuAVUc8gR
         iKQUjK0uN7wFND4PeEnYwFMK3BB79jQMsjSIWh+qqw9xTGudU+RyBEcKJbr3u/uiG+PH
         FKnA==
X-Gm-Message-State: AOJu0YzTeFxzLz7hbLEwB3IgNgnc2mSukwppRQGkiH/ZbeyrjN29bc3V
	TQ6uNUUFq+uxVsgRzJvXeuC1/tOQPdOwjYhM4jUV85/wO2dMkQFncaw1l3510Mg=
X-Google-Smtp-Source: AGHT+IHFirioOa9SGmQCYCfC2IKJgEmosfUG65DvXqe0ICn5Xelv3IGoqq9bFPJvBFViXLGjCnieaA==
X-Received: by 2002:a17:902:8498:b0:1de:ddc6:27a6 with SMTP id c24-20020a170902849800b001deddc627a6mr3380208plo.2.1713454167660;
        Thu, 18 Apr 2024 08:29:27 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902704200b001e5c0ac3279sm1667249plt.74.2024.04.18.08.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 08:29:27 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Vincent Fu <vincent.fu@samsung.com>, Chana Zaks <chana.zaks@wdc.com>
Cc: fio@vger.kernel.org
In-Reply-To: <20240418092222.20543-1-chana.zaks@wdc.com>
References: <20240418092222.20543-1-chana.zaks@wdc.com>
Subject: Re: [PATCH 0/2] Fix bug with rw sequence offset and io-size
Message-Id: <171345416666.438203.16815296406613301554.b4-ty@kernel.dk>
Date: Thu, 18 Apr 2024 09:29:26 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 18 Apr 2024 12:22:20 +0300, Chana Zaks wrote:
> In readwrite mode, when io-size > size, we break too early and start
> looping the addresses too soon.
> 
> Chana-Zaks-wdc (2):
>   Don’t break too early in readwrite mode
>   test: add test for readwrite issue
> 
> [...]

Applied, thanks!

[1/2] Don break too early in readwrite mode
      commit: d782b76fc9086dac25d674a9439352f9fa962db1
[2/2] test: add test for readwrite issue
      commit: c6e2a258fbac28f6f421eef1a3be2e5ad5f5a01e

Best regards,
-- 
Jens Axboe




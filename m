Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3DD2288D7
	for <fio@vger.kernel.org>; Wed, 11 Dec 2024 19:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733944213; cv=none; b=Lx4s/x62gVe6qW16yNsOXH19yZONVWcbG0/ivqbStmmbY1efYV9Gw/ZsB88Q1g0Lo9VeKIwyJuw07OBWjuYKAknuX0+2Dzctj5K02Y+bIf87hiRQsQyAlN2g+qtANaCg4Ncs+sUFyisZ9EomtOZMAipqR1CzFfHcD+ZwBtSDfOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733944213; c=relaxed/simple;
	bh=SiOekBPmA2MGIuK18r4qccBdc8UH6u7R0koNmD1V5fk=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=OwD0qGuSZ2v/TW8jHopi/5oHD8tGAUsoGFq7Yek6tDSdVOfVLfg4/Upw5cx19/Ykol88gYO4NM3J4b3h+htuZwv9Z/GIFS1U7MYeTLfZ0sfVUfvSRU7eA//tK1m5s07VOo3OBI8eNni1Bobcu0ubZ0vwJtNqrbucDu5sABLIQ3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QB6nBQNK; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QB6nBQNK"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6d88cb85987so9185786d6.1
        for <fio@vger.kernel.org>; Wed, 11 Dec 2024 11:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733944210; x=1734549010; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SiOekBPmA2MGIuK18r4qccBdc8UH6u7R0koNmD1V5fk=;
        b=QB6nBQNKrWqNE6a47F6LO0ag1TkR7PtxYclhuqLJnA1zxGAOQYEkCWBAorHNblNTpi
         /FzD57EsQn7Gb3SELouFOSiQ+V+2HdJHOA8uVjcR4wemLx8rbi9W6Do6/0RlBG2MkBKb
         Rc6uxQasyzNb3IE9dskuP6f7uCs/0l3xWITa1oOPYoRYJ893PKwptqQRaf7Ne0QFHhu6
         x5q9RBjJVwrnQnrWvGThDZiE2AZ3SoILlDXzjw4dHiBaX2tSOw+4j08fSVkqdfhnliVx
         MZH8Ld/f3avw89xp6EZvg8bHS+rR06KI4lAFmnEgYzh+6W77Cfei5sQavey1GTv8+ILX
         vHFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733944210; x=1734549010;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SiOekBPmA2MGIuK18r4qccBdc8UH6u7R0koNmD1V5fk=;
        b=ZC/Y0Db1sx7NInJ6GiuyStvYbrEYZKXp066Z8murwqLZSu/gWWyUS5aZtI20VujgRp
         d7xtdiIopAO0HZhkRV4NneM7uZCm6afQ52OzcZRXpLEPVraTTelO/hoe1nKLLCIWqGN3
         f6kn9xjLWU9tO2bCVm0dHAFGXjXRfRJ3cJhuAjVgQqmPmkcCQnqum+VspVHtGbOynPeQ
         5DwO8SZSULC3nayyAP/1vRP+bG5VcJXWwcwU0ENUTCXEaw+5sPeoMY0qddGWR0hTq7+H
         t1sQa4gmwKa8nKhE9OQ9+U9GudnmLlTN9dwVKUYCS5E/+L+3Jq/Rj6EXmVL8xDT+Nh8G
         m4Eg==
X-Gm-Message-State: AOJu0YyhBoaX27djHbGImMHTwkjykkzZC6zMT+NddXIe98uOYyoPNC5+
	XTxhKwXNDrVX33+uHseJxFy4uLT4bI0vFCGWdxUIHAlUXBMK+zXc9M3zICg=
X-Gm-Gg: ASbGncvBFMYaFMeM8bVHCN63Ez8IQbxNXVtx9or2J97XuZPSQbAdUU4zHpAqhRkDXf3
	OtRbcUiZzq9RLWVf0PUysHTb91YL/oHSSfX7G1L9noEdERFDdInFTPu26rrJSBaTMK60eCj/wb9
	8zH2hpe1WxZKJ5KhfPteKK0cu/Y9Vn860uw4aKFe4GO+kA+CpH5i3Lf8svp9ulYNUkRhVNrgZnt
	cBvR+vtqP7vT+i6JBg6xdf14DlAAmSz7XXbxXAMeTT3Bd/NdMq61zCJ9M7RH8xsrIzDighwLW7y
	A1KWuAM+6RZwgoeUjgTLA8PKLCGb26tDhBW1UKKgXHfl87EUZg==
X-Google-Smtp-Source: AGHT+IFm3+O7JdXTOwLRUtgLzkhydtvbW14+3tzLA6iTxOUUpbNJ+PYWF22w8ONy8r5Hq9O4LYe/Zw==
X-Received: by 2002:a05:6214:212d:b0:6d9:318:824b with SMTP id 6a1803df08f44-6dae38d10a2mr7421486d6.3.1733944210181;
        Wed, 11 Dec 2024 11:10:10 -0800 (PST)
Received: from fv-az1380-153.0iobsfatwvhuvgmqxjqze0bk2d.ex.internal.cloudapp.net ([172.183.98.203])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d8eeb132e1sm58917236d6.35.2024.12.11.11.10.09
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 11:10:09 -0800 (PST)
Date: Wed, 11 Dec 2024 11:10:09 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============5772155555063731806=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH=5D_engine/io=5Furing=3A_add_write_stream_support?=
In-Reply-To: <20241211184438.106449-1-kbusch@meta.com>
References: <20241211184438.106449-1-kbusch@meta.com>
Message-ID: <173394420935.2665.1119793574064409734@fv-az1380-153.0iobsfatwvhuvgmqxjqze0bk2d.ex.internal.cloudapp.net>

--===============5772155555063731806==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/12282914835

--===============5772155555063731806==--

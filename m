Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F16278F4F
	for <fio@vger.kernel.org>; Mon,  2 Mar 2026 05:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772427987; cv=none; b=ddqDrqb9yBTRVn6rD/NghP+YqWawQ6/QGefrNbRkqjtqDkV9FHsaEgAFUltgTLK/8RcYrV8FuXlBMMPNU7SilP0OQAbV1yvTpY4lRCPtnVM8wDh7sBPCRAdP1uNIBMbOLwcgC3JIvC5qBZ8iMER1StFh9t1qZuZS0jKp7ZT8bAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772427987; c=relaxed/simple;
	bh=A5g8cM9WiFILIMBjykmV1YzuWpjR0dILa/Ijq+xZKrw=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=BwrWKyQhJECZb3wZO4VoN19WRho8H12JpzgmVxrHhwXEZc+KiJdmFgAO9AtY8l97J1yYBXMs2vmsMPT5dw5idwrNUwt561042IPQsZmGKI1q5j9JDTVvpCQZJEF8XrA8sy5V++oe0CQClxHYKuZiCIZZhYlIsT7tr2ZhjSVfk8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XD6lZALh; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XD6lZALh"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-66f747175d8so2246604eaf.0
        for <fio@vger.kernel.org>; Sun, 01 Mar 2026 21:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772427985; x=1773032785; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A5g8cM9WiFILIMBjykmV1YzuWpjR0dILa/Ijq+xZKrw=;
        b=XD6lZALhjd0IGY1feLsYErekfFUjettO27kAYhsrebRT9izwez9m2KVRqA8ktIzk8Y
         rJLGXjbsr8N1fLca6T/j9xsxqrHbKUYIUsY8Za8TBRxsBnyS5AXixn5ZffVcWQxDSHV9
         9bDwdwnnU4k/9EiY0zwVsF8MVT/1fRiVoL0EXybOMvi94v/I8m3Bhs9Csbxwl98VHO8n
         IRa4V8w56oRLWpXZwmikNRZBJ9T/OaL0GqSyuzd2wiqfmUUmmApFzWXFyHUIm9JIfIxU
         ZdY0iQzBAn7PpwVh1NtTf9VHPobvtJ18gFYLJzia+Qa8OYRjiv7lmChYNv0s6gmB1BgQ
         xlSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772427985; x=1773032785;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A5g8cM9WiFILIMBjykmV1YzuWpjR0dILa/Ijq+xZKrw=;
        b=LaUikQNJ6hjdFZRZCg5neV2XT5MTuVelZoFJ3vq7Y3BaFzmApxXdul2tIp/1dojgxd
         mEQfQT8WUmaUguWAtd0Nu4lPX/c8U57lsguoYSDyWIKGNwf4bmX50P1X395UkPZsq8ww
         bVAqVT7r9ReK+MIXDyu3WIBcIBdLfBTaHSlDT9IEYx59/TV03Obd0a2W2vLrTDcI0bTN
         35CYK6zoXOxHMR6N2fO9RvRmoLvj32c1deGANHv76f2crE7cKuh5784aHen6yNZk/yy1
         10+JarfT6zM3DwmVQXljDTmhMYPWPC/zxkThvLlmfe8DSOw1SZmpvkAPKEbmVC9KozN/
         ijHw==
X-Gm-Message-State: AOJu0YyS+RngC/KBYCt5Myh0gig84fglkzi6X/mmOa041QC6ln1EysEp
	9eetBBeT7pY3AhHsbVUiXibLxtV59B2boCUMrhC+V06Und49NRKlwuTa2t9qaK4=
X-Gm-Gg: ATEYQzyw2cdXk9n8NBDJh/qKHWasyWlCSq5Lj+IRkbsjRIGJQiJpWxreCJvDelwOAa1
	TcSjYjLSbOiPGId1IyvcRcalMdM3R0n2OnqtwBhgAeLQQt4QZHA7i5bfqP8BxfWC7H8T3rZ18A1
	4d5OgKYoZ+UhRBkW4Yhqrro+/3htatZy8+rrmfVxUUTsfw3xXaEfQy2p72a0iocoFSgQCWWR7Wt
	JdP+y4jsvf17fdNq+1Bo27OYZZTycIqBT+n8QMd1p4EChQ7CuBaY34ZD1f+KRGtzc81UDGJwVc3
	tfSfdZNdCo0k3rKqQtTXMue0ysls6Kc8Plfu/Rbx6JbpXe3yZthNAO+SZ/NgDFu+6NfqUhQ//+o
	EtSloF/2l208RCXKydOdyIBZ5sAYXJ8HbpuGE40OEgzcsy0GoyBKV0y0g4wrIcmeU1EIwFLo65k
	ZrhMO0sKkBfb5vHydMHWsXgFzd7p5n8Tq5D30HVcXdnxowZ/xt2Y1Be3VE253Kr+0/wHxKDVnVg
	ktWsAkTjajI1guLvGk=
X-Received: by 2002:a05:6820:228a:b0:679:ea08:8fca with SMTP id 006d021491bc7-679faf4508dmr6157566eaf.60.1772427985157;
        Sun, 01 Mar 2026 21:06:25 -0800 (PST)
Received: from runnervmnay03.zcgjtivxx0bezdo1xtk5c3ssug.gx.internal.cloudapp.net ([52.154.20.56])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679f2d9b7bfsm8507924eaf.12.2026.03.01.21.06.24
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2026 21:06:24 -0800 (PST)
Date: Sun, 01 Mar 2026 21:06:24 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============7591772084365854598=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_v3_0/8=5D_zbd=3A_fix_problems_of_random_write_with_unaligned_block_size?=
In-Reply-To: <20260302022609.3526823-1-shinichiro.kawasaki@wdc.com>
References: <20260302022609.3526823-1-shinichiro.kawasaki@wdc.com>
Message-ID: <177242798420.2931.17116493950766867186@runnervmnay03.zcgjtivxx0bezdo1xtk5c3ssug.gx.internal.cloudapp.net>

--===============7591772084365854598==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/22560369343

--===============7591772084365854598==--

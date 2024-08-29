Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FF28814
	for <fio@vger.kernel.org>; Thu, 29 Aug 2024 01:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724896165; cv=none; b=XPpMiUrR4VzwoDFuw/tznT0wpJHdknqH3vRnIDfkCpA4l+Niik9UhKLfpXSPf1hYBkvaJHzlwebjCBhpZhYJIEgPgM0+TRPRVjWeRgeowKnyGtkfNxk6mo7IgFSECVL9z9rb5D0y3R6sGGGngVjZmqt6ea12LLJ8QiedHmd5f+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724896165; c=relaxed/simple;
	bh=zymY+bYr+di9LTNJQfZvz2H74IHQESo0beXnX8j74us=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rzP4jM0Ym1bLndoUNdpK+nmwHFZ3eKj8YGlG1DZ5FoflYgAz6FNMPQtbu/zG+CMN86BZnxBnzQLy9qAUhtBtEZidre0oCIk9BYXogxyz+plHmBZUHOtq87fFoMzx6fvKDoL+AINSfJLKidjG/FHEUY21eGq+pXLvVe8xQyiqQ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com; spf=pass smtp.mailfrom=pcpartpicker.com; dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b=YfbjjKah; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b="YfbjjKah"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5bebc865578so14805a12.0
        for <fio@vger.kernel.org>; Wed, 28 Aug 2024 18:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google; t=1724896162; x=1725500962; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zymY+bYr+di9LTNJQfZvz2H74IHQESo0beXnX8j74us=;
        b=YfbjjKahqL+uRT+o6RxBAy5pB/5Yt4hAdDjsSp5C+mvxJG0pDJXZPI/kBJMpV2AidN
         G/2iLaGXLPG5r6h46B4tPNRsZzaCy7XDC36Pa7gKdCMnrme3SCu3+T3j6eXgOc0jY/IR
         tcGDsABR8A38+RfMh+VlSJlhS8ZuuP5y6KhKTAfSyOvldVUn7JQV1mw/ysSuVNOGTnmX
         OqhuO7qwsAzvPvlw3GDpJNIZqVEkp/MFF87RA3juY9OyCocIAXa4DYzH96FLVCQFUzy8
         rWBlHH+7hvx1lBBoQhcYCOpfnF2NGm/JRhaP6NRznftvG0Ht+pdlZMNDBcXx0G7eB4Wy
         hQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724896162; x=1725500962;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zymY+bYr+di9LTNJQfZvz2H74IHQESo0beXnX8j74us=;
        b=ixJu9k94jEofhdMvjzpNTzk10jrysu4KLb3veDxt0RAmmEdDI0CgDsacyyup67rRMj
         O8Tf+Hf12Pu3u3SNvpiiCpPWmBO65SU3RdL4nadNRpdp3gKOaQ7WpaJ0voiVAYLABfXA
         nodTJgboGWB2lv/AHll1N1RIF2bOHDJNG4JrMQsOK+lsYNGt1LUNa53qxZYRtAnvZbzp
         gaGRP0zx4iv2v2jVh7LuiFxAjWqX/7Xx8nVN8Yq2OgQSyXgb/Wb3C1Z9V0lqldnE/wIo
         8jw7NUFfeIOA1SRZ4qkrLM8JXcnt0YJmpM28L3QQY7txTzJQRhYkUv7aNO0If+ytdTf2
         aEuQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4rT3ja6Dm6CVp5/YBIp2lRSZDc65vlqtUvKAWCddYmpVSBULNo8Dm6wyj8B1VnwLPwgU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZBPQF6TELhnPaC9DaI4Ee81S2lj97JM3wsRP7/liof7tPe0yg
	47aBUgLHFEoLJzK2t+QWiuR1itDO3zC+9bO1kJg12K03LCHYPe2+f1r1wYp4idY7i6mdPWMeyCa
	OUY+lGpSDVP4T1pM+/87RJV0JOALocIIWfHWgHg==
X-Google-Smtp-Source: AGHT+IHxkWmev3VoE4dUQHV0o54BQuS+I6acGdPl42oVtEjvosutKUWWT1bnvgwsWV4G5E14m56aOD6dPlZxARQt2SA=
X-Received: by 2002:a05:6402:26d6:b0:58b:e3b:c5de with SMTP id
 4fb4d7f45d1cf-5c21edb34a4mr477071a12.4.1724896161581; Wed, 28 Aug 2024
 18:49:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240827070850.947037-1-shinichiro.kawasaki@wdc.com>
 <d056a445-52c3-4407-b792-fdd2b6be204e@kernel.dk> <696d408a-b36d-4648-8eb4-93384cf2d65f@kernel.org>
In-Reply-To: <696d408a-b36d-4648-8eb4-93384cf2d65f@kernel.org>
From: Nick Neumann <nick@pcpartpicker.com>
Date: Wed, 28 Aug 2024 20:49:09 -0500
Message-ID: <CADqNVTrByeG+ZzA51YuUgSdZ3=k=isBJ+jwdDKnf0aLDGyHphw@mail.gmail.com>
Subject: Re: [PATCH 0/9] introduce the log_issue_time option
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org, 
	Vincent Fu <vincentfu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2024 at 7:59=E2=80=AFPM Damien Le Moal <dlemoal@kernel.org>=
 wrote:
> I am not sure if it is that useful given that the entry time field does n=
ot
> directly correspond to any I/O time. But to be consistent with the other =
time
> fields, I may be good to add this option. That is easy to do.

It could be nice. But I think there is also a discussion to be had
about just dropping the field (eventually) in a final single file,
every I/O file format, since the entry time field is fairly redundant
once issue time and latency are both in the same log. (Entry time =3D
issue time + latency + delay between io completion and logging)

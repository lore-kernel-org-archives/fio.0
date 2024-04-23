Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D0B26AC6
	for <fio@vger.kernel.org>; Tue, 23 Apr 2024 23:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713915615; cv=none; b=DktGSYKBWYO+mYaPRXWAW5CrC72dcddb6a0mDjOEN39vT4pYbxPCnVvklAZFXMx/BytfEXVVt2R7eaOsTnjtw2naKzrNHjoB+qmjC4xSq5ZF4qpBK9bHRfgJp6tXanBjV6EUifeUamJBkxmFDagV7UAwbRlLmR7QUiRnxoBpooo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713915615; c=relaxed/simple;
	bh=VwFUsgGlRXYZYth5PaAk5tbaSfAUnq/XD+2xN+PxSvI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Yc6H1gT/tr3MTBrphlLGeHSgOhOYi8kX44uQWnJGNhdm7Dh+qKRVwisoANn8omTlgcn2o+KjiYsDiY2G9I3u+Z2olPkEyBvRssM6x0cddqm1YuglhiwjoXIhvc7HAReVEMlNnNUqyi3KnZfkNvKgEmnr4MG/SrnAgdLPW4vCJq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com; spf=pass smtp.mailfrom=pcpartpicker.com; dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b=J/kpwsVr; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b="J/kpwsVr"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2db2f6cb312so107805171fa.2
        for <fio@vger.kernel.org>; Tue, 23 Apr 2024 16:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google; t=1713915611; x=1714520411; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VwFUsgGlRXYZYth5PaAk5tbaSfAUnq/XD+2xN+PxSvI=;
        b=J/kpwsVrOsIiIcHrCE2OcBpsr/BgyMyfu82RcMPWCRVGncUZPdU1zG3d+6RcZS+ukg
         2hIH6laNC84jfbwEaXsDYE5PWUsiNRBgmorgHMQBq+avfX183YiEANYrDDk8ir65VbzX
         3olpwFEGBkxaEfFDYbj5krUaz+7z8TlronHHBhPQOaR6tZvXeZkdEV0mPhOORv2NktQQ
         F5w21LDKmmFReRgTifhwh35X+F6/L0w9p7zpVkq2Rct9juqTbH1D6YzI5DgbkW5nHsx+
         VnCcIGqdvhWGKBxm6zuoZO8CDKeJyQRQ7oia3Lc+MfIN1qRfaMW7vA6ZytZ/SQGH+EPm
         WSBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713915611; x=1714520411;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VwFUsgGlRXYZYth5PaAk5tbaSfAUnq/XD+2xN+PxSvI=;
        b=V+yjE97n2QqePy8y9pi25XhtT/gkZA+eyKQgn/jpfVq9JZYug94sWoqSuUWOmC/9uw
         zu59LrsAN8nZDxvS2duBqfQC7jYq1kG3VI/Yujr3HK3s0vY48QvtU90nSOkTb6kVqGaw
         jNKi4PukABtLgR+eZwLkg8vf0TcvatK6TcR9f0GE7Al/Q+vms1BF6i7kZtRaFq+E33v6
         Kl5yCv95xejrZGc81S2U3vTcxXff2XmEYX3zlFSR1VpUT7L8hOKTp5jC5q+eAWC36pwE
         6hhw2WrF9i3CWX9wrtEpMqxctcbu6Oqvtw/T8TJMyuFZ/OcySiHI2DZSvTybFcqI/Cek
         xQbA==
X-Gm-Message-State: AOJu0YwrFY41b3EWsWgQ8sNAzzPPA4qLDLrlzhRlqbd+2F5hG3HscyZA
	fOuSJf4i+795PFibBUO0xXv4WGsmQGNoHGdRwszNQJeSbJ4203C1+HxymmqNnfmKPuxO/xxUnS9
	215pcvLMry3EnGUz0dFi3fpDbN/UQ/U8l7FloqtzaDd3tBymn
X-Google-Smtp-Source: AGHT+IHOyn5yfoMPFnC4UXok1qSVMXg39uydZnJ1rjutKO5WyLPShBLHetlrKvB76aYSH11PSiVqCAjNdq1EkDnCYbE=
X-Received: by 2002:a2e:b385:0:b0:2d8:95de:23ed with SMTP id
 f5-20020a2eb385000000b002d895de23edmr502421lje.17.1713915610761; Tue, 23 Apr
 2024 16:40:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Nick Neumann <nick@pcpartpicker.com>
Date: Tue, 23 Apr 2024 18:39:58 -0500
Message-ID: <CADqNVTq4POWDi_aX9-gx4DkzGXaWfPd64tMmj2_Ehseq1YzSeg@mail.gmail.com>
Subject: Trying ot better understand when requested iodepth is not achieved
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

I recently started doing some higher iodepth (32/64) testing with some
high-end consumer SSDs. Of the 6 I tried, one consistently led to fio
runs achieving a lower percentage of IO at the requested iodepth.
(Every other SSD had >99% of IO at requested depth, This particular
drive would get as low as 97%.)

I was trying to understand how specific hardware could affect this. It
would seem like the only thing an SSD could do to cause lower
iodepth_level would be to process data faster than fio could supply
it. So I would expect times of unusually low latency.

Instead, looking at the runs when this happens, the drive is actually
performing unusually poorly. There are some big latency dips from high
latencies to much better latencies, but the latencies seen are never
anything lower than another better-performing drive.

Any thoughts? Happy to share graphs if helpful.

Thanks,
Nick

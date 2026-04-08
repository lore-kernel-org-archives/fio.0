Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787911EB5C2
	for <fio@vger.kernel.org>; Wed,  8 Apr 2026 04:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775621539; cv=none; b=duYFcBQWuHk07LMnsLJwFrdfpxfvWgd6yxZ3Auk4MMU7M8ZVE5Dg83IOpwrH4Tv6l1LTR4YrfaZacNNvm7zq195FJS94iCYU/grMQdcWwJXASNJNdxLJnYN3SYVKlCNX5qBBqE1IyxciDFxf4fYLk7GepaVbbkfdceIcWnHBKPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775621539; c=relaxed/simple;
	bh=oemfGkOEYAO/cWAk/wBx2JBj/WejP1bd1zUJxIVJH6g=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=SOA9iBWGKxtyzMEN5pXMD+G3yo9sIdCv4lWWffJS4wSTVO7hgh9FI76YnY1FYf4m/+od85zZgIKpDwMlxv+9RLrhxtOyRZtHSKiyveIlbvisaf2W/Fo9bIj2VD02bFgLUyCer+ilwGRJCTk1CAvueVki7XFUchAEO8pveplukpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d7Qpalr2; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d7Qpalr2"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50d59d249fbso60494051cf.0
        for <fio@vger.kernel.org>; Tue, 07 Apr 2026 21:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775621537; x=1776226337; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oemfGkOEYAO/cWAk/wBx2JBj/WejP1bd1zUJxIVJH6g=;
        b=d7Qpalr2o2a41j0wA502ORu1Hwxt4LyTTCjsNt8nQnksGYrs0doprtrhEL9PTgFkwq
         UHbhJs0QBcYzwY2hy9NlacP9IrkvLNcsCmoaZD26lgVSG8RBrVJadbPP/Dt3HyLtSJY2
         EuypT5llc3WKzjXPC4MWXlgjhInfeNAWxXtkvdhYuDd//rYeSroeIQkhMA3eW+1XVBql
         uqaoDEqQD0IgeJfJ3BEYU34FOHVVhx1k/6SVIqszSu91CdIGDfMsmdde/hKYsbRN5Jfi
         dXt85ZysNO+gG08SyDmklMYNKXm83jOHt0S1FYCJslvfgHJ4roF+tPwUWh8z3usihI2U
         /SDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775621537; x=1776226337;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oemfGkOEYAO/cWAk/wBx2JBj/WejP1bd1zUJxIVJH6g=;
        b=UVj/ozn+9wA1CR5uToZlTnKuhxxj/YiWd8sXwrRFyXEmuAm47wf/ehT4Wx9i4lI4d1
         LkJNGbsJC7a0goORAn2361MkSwHwQXeOg2LfaxOVkaUR5BW/cHCFu7Y1bGURyv7PYcQL
         6HoiS41rIX24AerC0/k0jXyI6xOwuone8RevWu9YzcYllgqjGqeFmSPlvXpg72QH27X/
         z5Rr7VZJIG0iZrmVEslXPQBeaEdjpZHaT71CM6fGq2uVPZTw0GMgXCpZq+bKFwPm5D4k
         yN42bTzELBttV8AIXmmnBRKP3auc796OFe0bkJ4AeGd9yDqXg9vWTUKc0/4DBjjOYEtC
         S5dQ==
X-Gm-Message-State: AOJu0Yyyli6JyOB+VrFF6mWS1uL48mrSZL93PjAyztOVrT6azrcbcP6Z
	kjWoQzP7z9yoZVnjFxa/Q5sDmLnk1mGnnNoaRTYyDc7o9t/0i4Iyh/A6TCIo
X-Gm-Gg: AeBDieszGEISQWhqcX2PmHt598YLBmXvauJM+nn1jP/R59sS4BHueyZ5GMGkf/IfCWj
	mdjoRxWJ4wvcN5Llhxrvx10AH759HKROa2fGi+zbzWnqql/7YXTlfjP/bOeG+AFNbcMHiVE9SVl
	EiApx4W1rOm7HOrvctZ8BievgZV4cN5Y+bJdqAJPsQr7Z+668cumG1bawZGOtmk6h7xAmaSSRLn
	FHeQx8m9Du74/G4UzyRLGpzaItoBxcvkHsO0OUJKHnCVIbHxPeJvu+ukY+5HpszQkKpp9wpIPRm
	KaJeEDY6vlMfUg8kFFvnIzIQiiLyG/XUOIO++GjmV+REgN/UM0ZCzSMGQotkJn/oIdQnaeD5PCt
	fLLWoG+bijiBN/DOrmCZGwr4KekkQBh+DKTa0xB5KXbM6FPcOipkUGzDhEqIA20s73D9ZobAjHB
	Dcskd+HtkG3RdbZml3e9m3I+Gdxkhnpkj56VQiiV787fhVD6MfuO6QvciWRqCf3leKfHNN8ZFeK
	z0GTpcYq3hmGPns1GOpJ3JAKp+CMLkPww==
X-Received: by 2002:a05:622a:4c8c:b0:50d:74e4:56b7 with SMTP id d75a77b69052e-50d74e45a92mr244743791cf.4.1775621537323;
        Tue, 07 Apr 2026 21:12:17 -0700 (PDT)
Received: from runnervm727z3.teyjlkhzkogudgnizfo5inqstd.bx.internal.cloudapp.net ([20.228.220.113])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8a593ded920sm157018896d6.21.2026.04.07.21.12.16
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 21:12:16 -0700 (PDT)
Date: Tue, 07 Apr 2026 21:12:16 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============8853930146241383094=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_v3_0/2=5D_page=5Ffault=3A_add_mmap-backed_ioengine_for_anonymous_faults?=
In-Reply-To: <20260408012004.198115-1-npache@redhat.com>
References: <20260408012004.198115-1-npache@redhat.com>
Message-ID: <177562153596.2884.4791408134544411354@runnervm727z3.teyjlkhzkogudgnizfo5inqstd.bx.internal.cloudapp.net>

--===============8853930146241383094==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/24112588366

--===============8853930146241383094==--

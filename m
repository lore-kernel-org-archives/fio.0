Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4513A40DFDB
	for <fio@vger.kernel.org>; Wed,  8 Apr 2026 02:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775613705; cv=none; b=odVJjRKYJDdZkeCuJ0lL9n/PEtfOkRFrohUacpgueLzORiRxdgE/ldv89br/gNAQvQU4l+x/wX8qgMYOumu2M+q+1fAKPFKPGbxe0+vHrT6A2QKFZKr5++IJl2MSGbKNQgXaj8vFtJvPJ278V4yYfziMNfyC4QJBMzAIbBBiq4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775613705; c=relaxed/simple;
	bh=Ogh3295tA2oMryGqIQ/chkbV91IjTNn85qBO8S6zAY0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=HWLLxsjWcDdZU6J2wbNDeAJpI0Wl00rttDoqwyz7MKH5o7TmiyDJcbVxTXxPOptqx45FKv0O4ewojQSlngiPz+IdF3utsxd3goikkja8tpX/53GH/BvJJezxXj/x+6Ho6tHsJBWaPBXQqRUEk/yuI6CifviWsuncYGgiY7Loh0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=TN7CeaPS; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="TN7CeaPS"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-40f387a688dso4398315fac.0
        for <fio@vger.kernel.org>; Tue, 07 Apr 2026 19:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775613702; x=1776218502; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wkntze7IWOjwpKawDvEj+Tk+RmH7MV3NgPw1ch3MAfo=;
        b=TN7CeaPSBGA9IlTBa24NcfutFnYeVFb+kukXn0jo9cYkHvw3RjdKu2i2/JyB8W2dab
         F6AFuMSOMkDgCPgGuQQKYcvkbiCqPITFDVl1Ucpuy7JQseqyBbj06/DOkSvAFMLOETmP
         2vrIhm3sepjzf22BQbROR1c034g26x1pv/kekIJJMKhuWkvVwcPztep2LPKk685JNOWj
         NrDscaJ2ZQNPCZWn3SeFQLZqtqB3yj0qq5M78Z50PlcDIZfAbIj+7EA8ZdNgbqLN+8TN
         ck146zklTWMMfLhWxnf8ZgJi8uMfgmyk3Cd03eD+150UUAtrgoaIMaLvE4uK1wYRWs7D
         aLEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775613702; x=1776218502;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wkntze7IWOjwpKawDvEj+Tk+RmH7MV3NgPw1ch3MAfo=;
        b=OGyZX2v9v5m+AEeaC0SnT1OufnjI7Cs40dYkI+rEa0K3sRK2535szYxCHnWINmeYFl
         sU56YshIZohSV/XcnuTgtI0213G4v3+BYcDn7rs/d2e/v4EtAMQy4yNRtiigdfyAttdz
         JnD4+FWMasUlUzg/tcIHmx0nOoUI7C3pEvlGTdwwTEtpa64MfThgs0v1ZvmgkxOtc6IU
         CRRlGrKqxXzjGi0igiPY+5p4SVjhP6NmTnZhshOixET0HpwjSLgIKKsk6UDfK9D5tqSS
         DTFj/8GKhlwgPGD4sfGIsT4vNsRknztW1gDb8E0vMYBTaUqXt72sLlkqtvEXY7UDI4OL
         o2uw==
X-Forwarded-Encrypted: i=1; AJvYcCWWtCbnshBVYGMmr6yCHtPWw2xkKff+UKXyH4isgpunv5y7Ns0WSZ95Ro40tlRWiCG07h4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxl8cXTo8ijORoFVZvXF/miLRNQxM8ExGk9KeXmkRHWa8sX8DXv
	wu56peBSSmh+dzcWPu0v5FXkFqdxtNMy/ZWe+gd1DoCg5WInwvFxG5rx0dOptut/Kcg=
X-Gm-Gg: AeBDietIYObWhvXqfe6I5KvNQ92Nu2BvF2j1f75LQww8IS/jk8g4UAtL11WyMFUlBHa
	PCDbyobk0FU6r+d85eQFQMdRahOezjFWmb8vv8mZ1MzXt58y4fttLjT7bVBBqbIE1hxapHGeuJp
	GFR6X/niS6eEjd6lVMA22PpjDWEJlEkFzOf/KRUJVdXGyJTEU5qR1G3WYUVirWZsnb4fQXMJYRD
	gFz9LpwMmDE5WCAiNVXOnGmWZGps58Daj/5jiD1UVB5FNGj0BUTW0UpL/xVFSetT7I8rdGHEZiT
	laMSLSzrpXXNcKxwYDTaZXGtkEIZ+nxenUq9Jq3QWCgzGX8wXVyOd+LeOKj3jCFq4cMkV6n0+pC
	wIQdUEFo8SJxmIaJNyviTr/mZQ2uroN+MLgodDtWvxr+6s2AYaMg0KHVKWUfe3f8aJ3lyc1aPFO
	nqjEUIuT/tTqcqWsZceA+NIkNi8iMN5OKPz/aXQl2+RnFtSRHIlAu6SA8ih5NhETlqzwVyYdaWm
	dTc
X-Received: by 2002:a05:6871:4507:b0:414:93cb:b992 with SMTP id 586e51a60fabf-4231007cfa5mr10942987fac.33.1775613702111;
        Tue, 07 Apr 2026 19:01:42 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42344076923sm9152528fac.13.2026.04.07.19.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 19:01:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: vincentfu@gmail.com, fio@vger.kernel.org, 
 Nico Pache <npache@redhat.com>
Cc: jvozar@redhat.com, jjurca@redhat.com, jhladky@redhat.com, 
 peterx@redhat.com, spetrovi@redhat.com, david@kernel.org
In-Reply-To: <20260408012004.198115-1-npache@redhat.com>
References: <20260408012004.198115-1-npache@redhat.com>
Subject: Re: [PATCH v3 0/2] page_fault: add mmap-backed ioengine for
 anonymous faults
Message-Id: <177561370059.278381.14711080737139189772.b4-ty@b4>
Date: Tue, 07 Apr 2026 20:01:40 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.15.1


On Tue, 07 Apr 2026 19:20:01 -0600, Nico Pache wrote:
> This series introduces a new page_fault ioengine for Anonymous memory
> testing. This enables using fio’s existing framework and job files for
> memory management style workloads without relying on a filesystem. An
> example job file is included to demonstrate usage and lays the groundwork
> for how we plan on utilizing fio to test a number of MM related workloads.
> 
> The first patch adds the mmap‑backed ioengine that allocates anonymous
> memory and copies data on read/write to intentionally trigger faults.
> 
> [...]

Applied, thanks!

[1/2] page_fault: add mmap-backed ioengine for anonymous faults
      commit: f5ea7d9e1d7c07053f23e764b281a5e47bf01ba3
[2/2] Documentation: update the documentation to include the page_fault engine
      commit: dceeff3a1dd87b5194c84845d77096b3cdb3cee3

Best regards,
-- 
Jens Axboe




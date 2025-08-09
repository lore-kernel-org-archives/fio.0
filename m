Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD4524B26
	for <fio@vger.kernel.org>; Sat,  9 Aug 2025 03:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754710892; cv=none; b=lARE5RvNIubM4MokPA9xyEC+HbkBUjo6STm+SpFmnVOkLrmzRljFYvw0S2j5zzfoH1Q1AKzfojk+vww5qWYsKbkcOxRHg/ksahfWmjyHVSwZxjQb4twK9c1lNtCRBrI0jNnrMb3+5anrIgzV9UykGngXlT6/5BIoPv6SP3JWZHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754710892; c=relaxed/simple;
	bh=PmCabUVG7trNZPbmGelIDJJMuBba/vE9J6orwd22wzc=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=IxMNj6wiebq2iDJOXa2AVkF8ofkkRFoXXpVJLSUPJbcQHtT0Z7fBpRc75iDv7RGmUzcs/+sP9Q2bg5NQnv0cMDLehkgeBBT2kxtvI+Uay9mSA0vcpMwiGZp2UydR3m2muAfORysuv3ItbQr9qolSolys0IanVjDLmUI8Gam2JI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FQ+aJX9C; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FQ+aJX9C"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4aeb5eb611bso26421391cf.1
        for <fio@vger.kernel.org>; Fri, 08 Aug 2025 20:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754710890; x=1755315690; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PmCabUVG7trNZPbmGelIDJJMuBba/vE9J6orwd22wzc=;
        b=FQ+aJX9C1lK4DfqCxPXCAn7XMe/WyZaTa1ELQ8vahOzg4AfD9luNzf4QriLffCS+ij
         /1EWtc4nyp13UbV30ux5eSFmfCEG/sp3xM0BAZ0ujGzKXS7VzPmIBrSwRmr6C9LRxg4Z
         IHcv1yQsab61TEgYynIJTG/Bm9/hcJvIRicpe5PMadLcOX3DGbVGdE4lvaHlFV/Cg4BD
         mRNKYm2ChYGHETafk9ar6Y08J6JQMcJmeVRmhKGLYwc6fLuMR4wegs721nl0uEoasNvz
         AV233RH7DVyXjEKA6oGB0trgcyLKqAG6KqNJY8Is2poaYSsDZRYF6ah7mfbEBSzyVToI
         F70A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754710890; x=1755315690;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PmCabUVG7trNZPbmGelIDJJMuBba/vE9J6orwd22wzc=;
        b=ndMt0JgmevWSwcE0TSVCFGcxBPQCK3hihTlUWrSsuj8VlersMIeKFIU3Rdb7KbcV4z
         ZOv3ZSeOTN1elavilZ9B0bNNGE9yKuPeQQsyzkPVNwRu9++2WHymH1D2WdQNLFBxuA8f
         7fphGb144L2WmV+lCdramjTDDGy1x+PL0A3fhZVSMdmJHnCMjMdZ+sVfRSOVcm++Wj5w
         YVfQvNDcNoUQS/vmUp0U3SYXyN5n7WREf25dBkC7iueIULebMhMVOpjseswcCzotxA4C
         eeuUG7ewlfXUovSXXyMkJBOqyOVTSGB5t8C9+HrcbVX75mwp5AD4g63VmxSqpdPNFn6N
         kKiA==
X-Gm-Message-State: AOJu0YzuhAHNyx9+KsfY/cg5eEieVo6mNRxCX0tYuMK5aJLXMQJpWesO
	dY7EbWcp4eP8QYZ6PiobxacgdstSRC/dtE5VcThSmTJG+2WgN2W62DhJo/ISX5c=
X-Gm-Gg: ASbGnctI7aDfJmpif+ZRlSlLnnuAjg9r0Y9FAUOBsLTPWgJ+vrc2BytR5SL7DjZ/hPf
	FRaKirOzoQq2Zwn1IwejgUL0tZBaAf018VeR8YImimv/pFXU1H1q7kvPzEfsdvikVI+/TH9Sajj
	LN3+ALCegup7a1JexXmSOXLGlIhSWQFpqCJWtwfs7nNH07cgCI1c7uS0aj7csJzP8rnF9jpflGi
	ixYnjknLPJd6tXI0FuVKPopd58UKaq7tBx5iETeFOUDo9fcAKu6Q2cJQkOivVX+rCad1LpdeC04
	LVAHdkdyP9ZioYkyeTLYWoQ0uqS2Os/sBmWlWYQQTf/i0uA473qEif1sO7KWOJmEoDF8iu7mjI4
	d0qf2ntt5y1+iWXGQRNImTiQUfQkcFpDf6NRc4OvfczSFtMS53mSeEqbE5Auwl1ZXA2en/hFdGl
	M4S/iIwxCjZ/NSbXxxBA==
X-Google-Smtp-Source: AGHT+IEj0OzArPJFGLuf71+GTlvX+hviTsa8T8DgSpfq60ortIZNQEeLlgHcwU6rS9io1vHfnJXsdg==
X-Received: by 2002:a05:622a:5294:b0:4b0:b39c:af01 with SMTP id d75a77b69052e-4b0b39cb116mr54530271cf.4.1754710890026;
        Fri, 08 Aug 2025 20:41:30 -0700 (PDT)
Received: from pkrvmsl9tci6h6u.co2hjx4eohjutbealrn11xq3rc.cx.internal.cloudapp.net ([9.234.151.82])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f5947dbsm1183329685a.12.2025.08.08.20.41.29
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 20:41:29 -0700 (PDT)
Date: Fri, 08 Aug 2025 20:41:29 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============4193981770032119180=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_0/2=5D_verify=3A_fix_issues_of_verify_state_handling_improvement?=
In-Reply-To: <20250809011555.948564-1-shinichiro.kawasaki@wdc.com>
References: <20250809011555.948564-1-shinichiro.kawasaki@wdc.com>
Message-ID: <175471088931.2698.14735495449067973573@pkrvmsl9tci6h6u.co2hjx4eohjutbealrn11xq3rc.cx.internal.cloudapp.net>

--===============4193981770032119180==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/16844506570

--===============4193981770032119180==--

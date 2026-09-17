Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537D94E36EF
	for <fio@vger.kernel.org>; Thu, 17 Sep 2026 19:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789674435; cv=none; b=ojjauxWwHSPHed7PtL9CB2Pq5aYYhmtajYdulcWCxKhiobmyoPZTsV+kKe3dVBJlWKbs0tZzdntyWmFS02M/YvaIhhCdE50hKYCZvi9Jx+P0BzcjYqYZ0TKxCvOrghjJcvL8wjxMdpCh0dV+KLHj+QAtzNmcQUAxGzTXi/5gN1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789674435; c=relaxed/simple;
	bh=oMrm7jm7gZJ/qQrRMJMXU72m+i0TEUJ2e3xqf898Tjc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NGmkTd11Mnaa+Bydp9cLcLUUCOuIcw3CVdARs6Jz+Z4LYhSEryPLCguBd3B2i4wBRargCX5Qb6UgRKBW5nznCYKKoywxtau6tGKJBP2j35l62TKoDCFgMX7sWUEE2Wm5GjtpDjhhxx+VATUpgG5FXRNLIPFrWMKrDpEQO0gxDX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Svs6xVl5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OrI+ZGKx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Svs6xVl5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OrI+ZGKx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789674432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oMrm7jm7gZJ/qQrRMJMXU72m+i0TEUJ2e3xqf898Tjc=;
	b=Svs6xVl5/EEZF9Qsr4LWIJcVNAhgSKOJFBh9tY0kKh5ADDfjRN5vYbMCvSmNyKz9QVl345
	ndKhq4LA1HGnC77PSZ8pHfeuRIaGZNy9zWSTphHCwS2W60387qa9ew9yKJ0AiMVscj+ZjA
	mjFCIiqSW3iy2YzcFUK15jcKqVWaick=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-z8xObMaRPZGT8hvGoe_KNg-1; Thu, 17 Sep 2026 15:47:09 -0400
X-MC-Unique: z8xObMaRPZGT8hvGoe_KNg-1
X-Mimecast-MFC-AGG-ID: z8xObMaRPZGT8hvGoe_KNg_1789674429
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-806004ec379so1210045a34.1
        for <fio@vger.kernel.org>; Thu, 17 Sep 2026 12:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789674429; x=1790279229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oMrm7jm7gZJ/qQrRMJMXU72m+i0TEUJ2e3xqf898Tjc=;
        b=OrI+ZGKxXPIO4oxkBQMnrqK+RhFfpwbtQ+4tNKYs7T5+5OUksLUlgLjB3MvYNN9vqc
         67aJbFizN25QtMbHtXrR3IZ5SeLKpO57sGsXzg3sqJDAfY8kZs9XytqKMrJGXs67uxSP
         TNJW8nQhmIrs8Fas78d1RPC1vYitYisGHeYiwhtAmPWDrVFgWIiB48Wk0/W2pagWeCL5
         GZeqzni89DDku78KUcGqea9CELLyZweKCys6NVAAepGJW9j/2gHMLP+dTm+xJqqYXsnC
         d0PRCqSrotLwzKY+yzrp5AASxKPDX7RqQRsOXPWVPEoGPwkJwLlgM1yGLcp6NqK+abIq
         +4AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789674429; x=1790279229;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oMrm7jm7gZJ/qQrRMJMXU72m+i0TEUJ2e3xqf898Tjc=;
        b=btQ+3zEUOweVp3tw5YcpRcUPM4AMGzK0MV32xXwKRt9nKz0npFIUfumw8auOk0P1cM
         nVTxGUQLcI0G5UCT7gbT0PRKImwX6Bm3uJhPYvWZ7XonQSJ5sMPs6uLH+DjWrUG+JxO+
         IusRm4+XqWRUyAQ4n04NzUBII7tMMat1G4MJ6lwFiyPTQ8pgU5v7gb4z8uwiBAORu0c3
         npvTsIhnTOo00v0gz/1IOKeH5Y2Rf9qrScprvViJQczgT1LntS+xe/yKGH9vL/9Pt9Xv
         O6h6hgcKyHf4WfSA1JB1Yl/FGIIb8ysRjwop8DdvpSqM3WJfZ58a9F+1mX1C/PRo8ERP
         hVsA==
X-Gm-Message-State: AFuF++kBPpjfAMuJ2yN4zkF65FZRo/QpIsgPn8GUSMcGdNdgeFVnk2XU
	w+Dnsp3TSdkdth5Jl7BpCcuzOznqxiXaIL16vbfZwNTrNNNwDYFl7p7cMv7qR5wDi0f1m1BrFkl
	snJWSE/Qybi/1Yb3klof5h8/FxKqfr5KyGNfZq7Y+L0ofu6DnZOJWxFBSOU/8cTShxsbwStssxY
	16wiwob/kHEi2FyBZAVz8/ux6zMOCT7hUFr94O0Do=
X-Gm-Gg: AYBFou2CH8qi0WOC9n0TboBQCPbCJ2xwUNlEL1hAl/PLm6NzoQs2BeAHATABYLjdNhS
	VAP/DCDicfOnCzfcbItsiZ3e48fFr/glSz1h2XVj338GL0rWzbnZ76bUYie0lLzJXkJqIjzKDo9
	ZvUbdLKwj9cE7IFhKB4nTI8uZlWpH0WoXqWWktdGbFiuS/NcgCu+44yDpEKfvVnPOmVGddfQZV/
	BxJHMLLqahdi4giE1b7r1A7Ko0IhB4yW+l+AXyiEMyP3UpemEpk1Ws2x0wjvmBFn+eZD4hAJmv4
	97YuKqJZZITIAu9HoO8QbYX2XlIMnwbaPsl33x3w6TExZdcwoiQM4hF292YQPA8EnUHG40m4+Jk
	fsREHb/pZt780cM/L5WGDhaB0D4vdHFovod6oFQ==
X-Received: by 2002:a05:6830:258e:b0:802:8acf:6e67 with SMTP id 46e09a7af769-80de045e0a8mr191678a34.5.1789674428812;
        Thu, 17 Sep 2026 12:47:08 -0700 (PDT)
X-Received: by 2002:a05:6830:258e:b0:802:8acf:6e67 with SMTP id 46e09a7af769-80de045e0a8mr191657a34.5.1789674428326;
        Thu, 17 Sep 2026 12:47:08 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-80c466a2e63sm3828886a34.15.2026.09.17.12.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 12:47:07 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk
Subject: [PATCH 0/3] Tidy up some client/server behaviors
Date: Thu, 17 Sep 2026 14:41:23 -0500
Message-ID: <20260917194706.2264798-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Someone got happy with AI scanning and reported a bunch of items
related to fio's client/server architecture - an architecture which
is neither authenticated nor encrypted, and which *by design* allows
arbitrary code execution, which is even documented in the man page.

A couple of the items stood out as probably worth fixing anyway, and
I figured it might be worth being more explicit about the security
posture of fio when the server is started listening on TCP, so that's
patch 3.

I'm not wedded to any of this, tbh, so Jens if you don't like any of
this I have no problem with just dropping any or all of these changes.

Thanks!

-Eric


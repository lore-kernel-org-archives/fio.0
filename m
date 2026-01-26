Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52236225397
	for <fio@vger.kernel.org>; Mon, 26 Jan 2026 07:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769412577; cv=none; b=Jb1wG4Z/U72586AcCKaavk5Ngp8HzSbF7p4RuHJ99cezOOKEH+amp9BE/QKMtY+C+4pgrJ3bEpguNKDrnWYWYYQ+POZ2STZ1HhSuxtMIp1Oo9I8NUYQCcw9n2CX43ZhWRgcrwl0/spuMp4mlYij28p9jqpMUz3EejMc1xwKIXGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769412577; c=relaxed/simple;
	bh=b2JvrE/naZBqiymORqtGeA2jmZaFVI9CS4ejb4aD/S8=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=qt75/q4/+NaPQUHr198uXyeAUNvF7U1xzLx0vLNLLPuBs//+oichNO0snx/EBNaZJsZ04Sw0W42QvZti248f/6k4F1fPu4gW9MzNKxiOzZs0A3wGGcDPqtJpxsJOu/7y7YqdgsDHeX+CfjjTTQtsSTaaDOhZqTgO6wCVTGAsA4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h/7InQh4; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h/7InQh4"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2b70abe3417so9704728eec.0
        for <fio@vger.kernel.org>; Sun, 25 Jan 2026 23:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769412575; x=1770017375; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b2JvrE/naZBqiymORqtGeA2jmZaFVI9CS4ejb4aD/S8=;
        b=h/7InQh4SD4T3dz8WpncX8YTdYVb9NRNJG3kLmBNiao5PkMzdwduArpGs7hasQw+MB
         jHxaqDKmQ33AIyYqx9n26tGXtav8yAqpgYpOwDljpUPbO7pZTbLbG4WQ9WFkdJVHKK+Q
         CYVl1uQlgZuQupLkgUzDkJRlJrkFH4bam/ioO75skKlVECL9fwWN1aAk1wlLfPUed+pA
         DkkMIZUN6VLuGUI86E7PEYcTdqNGfijO56Hyp979igI6Y2FD9JHLcZ2Po03hwxa1fSvN
         M/TXGlli0xUNhlMxuddyIIGcH74125kgFCBwz4bfmhNuZEj5BxlEclMMEj77LEEL5xZN
         naOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769412575; x=1770017375;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b2JvrE/naZBqiymORqtGeA2jmZaFVI9CS4ejb4aD/S8=;
        b=QfPpHYGNmaD3C9Zjx32WR3xk+VXA95VUjdiGQNuL9C4rbwyQWG45uc/MSvbEc1GnOS
         4rCyeVigx7hesYs1kRlyfTbZieNQOLwm/AUCHtQOmtug9zKTZdcEhZunzXfOJWgtGu4/
         JKeYb+JrnfaMk24Mh7ij76J9okPN3N7/7gNxPANM3rgazhGLpCIDar11Rx9zLiTahxCx
         x/zavH8OiHCk90qW7uaamwNQASCEW7LpDw4HXIj+PmO46R44rLflH1hx2rmYRt4KsVc0
         yasv0Q/ernqgJdXgHu+uNeHCbWPVIKYP1YYP/IScyMPXtzayv5Gt/ykqyOD8oHB8lf5H
         4mnQ==
X-Gm-Message-State: AOJu0YzPqAeMj1cH+IhEgxD8qivqfhre7i7FVi8GulrhHUZ0y2YmSp24
	bm6nsNz0yyU0gf8oNPJoOaAMcPXl/+MHyXbNi2Pah/Jw/67ftqLJkk4A+9P+
X-Gm-Gg: AZuq6aI6yC3Goce3WQvtdmV2dDGlHg5cT8Gwyd1gywvd35rMwkQEzPOi89IZx6nXRwb
	D22UDZ+gtLa9uu1kpQFLOABjE50+QmowQn9iLNow6+N8RKevuYR3wBTw16pxxi7VHOf+mTZEBfW
	xfZ6coDDozneDO6ydv4+tI5GayD1nli0vG/AeOgowhqmHuhOvYqvvauEcLxTokV4e6x04uNti9Q
	xep3gCBCgIc2NJ8x9kH6yjYfg/FzkVCgPLd4f2mpnWmG2MQmuO5gvtXc3DxPyMgktZUVRSfEZmm
	E0cCwll+fQXJPG/szqohyxoOG6k0Z7ScUMFUH50RLWPv4HjeaTHXyrwvBtFprROOqEvHcNU8CGD
	QVOwa9YhAaXVW8gbFM5MkZBltm0vR8zGxAMCqLioRl0Ps3CWNievPJSbVDGNjRWPwPfL8l7Pci8
	wCy6fXKWF7wcsxWS6D5JnRwqhKjrlieipqifZ5Oo5Ezh9pgJo6n/JWhYGITV46vAd2Mrt+aebNO
	OJsBgdhdg8=
X-Received: by 2002:a05:7300:80c2:b0:2b7:2664:aeae with SMTP id 5a478bee46e88-2b764813484mr1553665eec.37.1769412575024;
        Sun, 25 Jan 2026 23:29:35 -0800 (PST)
Received: from runnervmymu0l.si5vesnirltutgysy1tpxjbuwf.dx.internal.cloudapp.net ([172.184.220.145])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b73a9e1dcesm12361850eec.17.2026.01.25.23.29.34
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 23:29:34 -0800 (PST)
Date: Sun, 25 Jan 2026 23:29:34 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============5847149885700066229=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_v2=5D_Introduce_the_end=5Fsyncfs_option?=
In-Reply-To: <20260126061721.270448-1-dlemoal@kernel.org>
References: <20260126061721.270448-1-dlemoal@kernel.org>
Message-ID: <176941257387.2826.16498352510281868989@runnervmymu0l.si5vesnirltutgysy1tpxjbuwf.dx.internal.cloudapp.net>

--===============5847149885700066229==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/21349020694

--===============5847149885700066229==--

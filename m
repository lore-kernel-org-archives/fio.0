Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F31201004
	for <fio@vger.kernel.org>; Wed, 14 May 2025 07:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747208322; cv=none; b=F27nSzm3idIFBvpzAWi2PulTl6LPy9OSAtcKKXTN8eOZylencBh8A2ff440d7ZX/SrYc4aISvuSw3v4iyjs5BCQQtal0P738t3OJWKyY9RP/ov0Zb4KzSBkwqt7G12NkK7wlqrvoeFQIt+UMvCmXvyDK1I51ZZzDZMjU1vsGDII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747208322; c=relaxed/simple;
	bh=Cy6apkhLk2LVVL3Xw8h5WtSCM9Cc6FH4qXWTjNDP1Ws=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=JN0GUu/zu1NY3fbDrRA7Xd/tvnozGFLeCn+MrfBMGVtKm9HPZZbHPV5NyjbzzCCQIJQmBbIcq9mJHxP2Pt5Ri+VqSdfFL16rOIojJx/EcwQqVEslJfpE+FIYtDRJ+oLf1/kxx4y4J2MHYu9Uz4o2AlPCIhyQrpEvw5DjKCqsrz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nl+LD+Em; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nl+LD+Em"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7c5e2fe5f17so729852885a.3
        for <fio@vger.kernel.org>; Wed, 14 May 2025 00:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747208319; x=1747813119; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cy6apkhLk2LVVL3Xw8h5WtSCM9Cc6FH4qXWTjNDP1Ws=;
        b=Nl+LD+Em1eckYXvgaT7QIFdb7ZYKywPZav7D1uqjWYktYEaksQRgCnPv6PPFHv6a0a
         A9w/tU8+CfTXFxLS8yHN5Uqd6xJQ4e35YIiXB2mZvIrTvQWtE+R+9As+jX9BHUSBCT+v
         hyNpBfyBA3gEnB7asSrIGAMMHobhLDhYdPQz3bRGfrt1cdybuTUWK47Cjortd7vS/n6h
         H5fIjwSv41r6ctIQQXUkbjdkGnzZq9SRnAalfijWS3WwsgPJgKn61j3K5ZfkyI/I0btc
         1+3a54tgDIIdh3jyYSlzLgVgXa5yOE9qq8ZPOzU/VPVx6jHctsusn74hcxw/8Q4hjqzW
         b6XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747208319; x=1747813119;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cy6apkhLk2LVVL3Xw8h5WtSCM9Cc6FH4qXWTjNDP1Ws=;
        b=FfBqi4ij7gMDGfWP5TnM/yfJTL/KVmx8nfsRPUsM4+JbD3YYt3p+NUlsSvQAe33Rn9
         DlSGzhzPQE0GDbfGPN9HQx+xYgxIdAutWjHR25M3AyNlhK/xd7aphMgl9vOO3ZNBBcfT
         bwvOJZ+FxDvDRAjrTKj6LBhVFUutVKiPAYjjKGmIZ2vwEKIIU4fd/gYze65DqQGQUBW6
         +Rg0UhvA4jnIKxHh9BOdEXg8JTI2L/xiocYQ9b3WYLjHy4fkK1p9ArQN4du96BmrdK+L
         YwERoh8dvn9OKreKNMW3KtunnuQyuDMcC8dUDhM7LVLuMpvjijWdJ/YttQAkOSUls6hv
         zYEg==
X-Gm-Message-State: AOJu0YyAUoF17JSjiuPy0tNDsZUci5At3ZFMrFPgVGQNpCS41DCMGqZr
	yBDqzDKH4+O5pDzo8WAFLZQrggiNsnqztl63FQEkBtGzqvBocF7odrabKes=
X-Gm-Gg: ASbGncttpIOD2ppTkp+06TtUE0NePrheXJcLgMRbYd++1cR2CrRpuAPCmHq/bCKGMmN
	rX7dbjIbg8cvXeUXP2yUC2bLJG/pHdRwH1TiaqDRg7lTyjaH4Oj+uVxbhrGjn20kuf7Jd4ITQ8K
	zl1qXUV3xYgIYSLvZ94AWJs5mku/oDaFjLv8qXZYfZxDe6acT115JuTdbvin2oEhiFfiBsFoPqy
	9UQOqz0tfs6m3Ag6bQmE+qPg1kXNl9UOIpncVywWj1mDjbguE7VFesDSESfQpQdeTsEtnvyFs5d
	CoVWDDdyipw72AvAEXKjyVQUI4ha6qmFYBHGY3r2UOKUFv/AhTL8MdWUvYiE36BjQdkIaMqUTD0
	nDMsZDsLQw0k=
X-Google-Smtp-Source: AGHT+IFLoiqYYUAj2k2pEceeyudYVIkPaBrflXy7gutQemqRXlWVMZpD4sPWy6OkTRfIek7LIT2jeA==
X-Received: by 2002:ad4:5048:0:b0:6f8:997d:fc83 with SMTP id 6a1803df08f44-6f8997dfe2cmr10371996d6.23.1747208319370;
        Wed, 14 May 2025 00:38:39 -0700 (PDT)
Received: from pkrvmberfyhpb9w.internal.cloudapp.net ([135.119.138.162])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f6e3a538ebsm78289956d6.113.2025.05.14.00.38.38
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 00:38:39 -0700 (PDT)
Date: Wed, 14 May 2025 00:38:39 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============0229583340617597848=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_v2=5D_configure=3A_Fix_libnfs_cflags_and_libs?=
In-Reply-To: <20250514070754.38281-1-dlemoal@kernel.org>
References: <20250514070754.38281-1-dlemoal@kernel.org>
Message-ID: <174720831864.2588.3701981224545773281@pkrvmberfyhpb9w.internal.cloudapp.net>

--===============0229583340617597848==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/15014621445

--===============0229583340617597848==--

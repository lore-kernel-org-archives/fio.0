Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56EBF507
	for <fio@vger.kernel.org>; Fri,  9 May 2025 03:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746761936; cv=none; b=NpBOs9YkTEh40vVrlmni5Q5ybAFdnNfoRpT3BD4DDz1Ap68lMHdvf5sZcGE8TFNqCZdOjEPKbqVPebhXX9YH4H7BqKiUnVAijzWWQQRaAyZaWukPomXI3mUAfIFT7wXSe4pPL/sZTeQzV9u9+nRvaHIg06Qq7ULqwt6wJX4eIr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746761936; c=relaxed/simple;
	bh=d9/fPcWPieTm5cR3jyjjciL5Z+gYrvikLENPFG8Q+qw=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=U+02SENDDIzI8zMWH//Kmrm9PCfAqCW/zgHIv8xKoS0dyaFXTdEzGlJVC7teA9uFADUEa3YfWNTtu/+F8bV4WYeBlYszFru5bmgBUH+Ivm3/IgJum+ItFFnGfrOlmQ4Ac3uDo+R5UOthA0Gxx78J1xGDijAoUhZMg8f01JrYbKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F+2h1/Q+; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F+2h1/Q+"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6f54917e575so15176916d6.3
        for <fio@vger.kernel.org>; Thu, 08 May 2025 20:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746761933; x=1747366733; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d9/fPcWPieTm5cR3jyjjciL5Z+gYrvikLENPFG8Q+qw=;
        b=F+2h1/Q+T7Vs1cQgaIdZRLE9HlQNSx4+WGkQ57RUrfelsDLJwaTN1RfaeuWbdTdoLb
         /vlkfuBTqnT6X0veaTO8vluzQXXtkJw2bJOKtS96hteCubTBupSPuoCuYG9ZI0rY9B/G
         B/H1O40LOI5xZat1J16ZqPm0LhcPCX+b2oDt2rc3fXwE4NJ+5UMRF6Y1eD1JrHWoSn3X
         uhroMWkpwJEKfin8hRUjI4rxZ3hWra3UsSH8OPqtmKSC/7zIQsPwq41YxqIduqGmXe5J
         JU4ndnvtIWc7uqF2QldiA3a9nQsC51t8ebAZ9a6ANa9HTOFTFH9OA0ZVjoF+cmAxVS7t
         cvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746761933; x=1747366733;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d9/fPcWPieTm5cR3jyjjciL5Z+gYrvikLENPFG8Q+qw=;
        b=MFTWkenFTi2696HcWLFmB8qdCQam8+aJ2ICvVxuJR7/KILc+L3UDvzm2hieHJ2+4dK
         iRqLNEQqrdFgw6HDzP6Og7xOXQObe/+/meK0VBMdgeq2ADqw8QNKsIoC5H5TwO8ZA4u3
         1535as/TjAk95YElseVb42SRRypqV+PyXUELfxXo04RVhyz6zH5mjTq8tUNt6S2J+0eL
         lVkogmSlDa4w07PpM1GLRlTG2OKxcIdB5OEQNIQin/xhE/wW7kFdtvRKFmLzzN7tQ1Na
         4HJJymGiZdfdbf78W9bjKrCQmDzuO8cekB0ImCoG0wNycn1Ng506BhCvOHMxjazbDU3g
         DiYg==
X-Gm-Message-State: AOJu0YyOxzP1s4gh1mUsz0XybwPVQ/6P5YPCF/xu/YJCC3Y/bkKtr5i/
	JPFkHhjvkKWifRJB6xNDGddgIzVWCsXlcgtMyjyLJHWxzZPFcE5utueB
X-Gm-Gg: ASbGnctLzqGNPbnFbYhfjz1qQ6Exu92ldNVfU+CRhelKhd8NIhELePh6FHPzGBkuNr0
	E7L14dOYf20OKS5yzGwsDjY63FQyUGOc5A2RFMbcjzXps5LGu23g7agoyB3/gPyNmwQI/96Oc5z
	CUcgJTvmtu7YW3rpNKxxRoyNfYxpyZ7U5Iyx1P3YgzoQiD4LASp4nIt6LgO+dqoAZiBPCy06eMv
	O0Fu4E17jX6LmgpsWMZAGmSV8CfFl3EmvbmnPa/VO9+vuvfdQsKfSSD6+gKud2hKh3/5CUyKqNL
	LviKdzE4qNF42EHXtIeebJh4J9QqN+Jk5ltLp3gNjo/zmF/NoSgqlTvL5umByvhZWf6sVaRNREQ
	s4jqT+RcLZy1iSowUE9V+IUtW610ah4OchQ==
X-Google-Smtp-Source: AGHT+IG2FcRwu3AvbAE1VfbdlLgDPOvpuj8WmecJJ1ypD4V5cPgbQ1yW5k9RgMiSrqrE1/5/JVMqgw==
X-Received: by 2002:a05:6214:2462:b0:6f5:107c:7db2 with SMTP id 6a1803df08f44-6f6e47bc8a2mr33466826d6.9.1746761933350;
        Thu, 08 May 2025 20:38:53 -0700 (PDT)
Received: from fv-az1390-675.1mbnz0gfjveullqkatgmntqlvf.cx.internal.cloudapp.net ([20.57.78.113])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f6e3a0c0c5sm8101866d6.53.2025.05.08.20.38.52
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 20:38:53 -0700 (PDT)
Date: Thu, 08 May 2025 20:38:53 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============4998077450925987514=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH=5D_man=3A_Fix_recover=5Fzbd=5Fwrite=5Ferror_option_description?=
In-Reply-To: <20250509020250.483865-1-dlemoal@kernel.org>
References: <20250509020250.483865-1-dlemoal@kernel.org>
Message-ID: <174676193267.2563.512606775293040270@fv-az1390-675.1mbnz0gfjveullqkatgmntqlvf.cx.internal.cloudapp.net>

--===============4998077450925987514==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/14920402647

--===============4998077450925987514==--

Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A71B265CDF
	for <fio@vger.kernel.org>; Wed, 21 May 2025 13:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747833635; cv=none; b=UgliY6TcAPEYMeeUGdgr5Pl0eRwDgb+kULdiJsKMlPPZBZ5gbVKbtlqzNLd5YA6Q/bExuL+MA8pXd9kGyDHlbWiq7+SzIcQJG7kXVy+m62klVKgT+/ktvMgtE2YxtmAyXH/MN9kOIv/VkJB6gvp/zoF1S/m+Ogz2vscjFFiyiIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747833635; c=relaxed/simple;
	bh=oxIhTmla4RezxA2q3w/rfh67gwtMSak9HDhKJbhShq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WqccM8Dy2gPpedh9cXjdiij01BPy0oXiXCNIGdHXHDHnBTOJz8KnDmdR/0Mh1Z0W4QwMyArdOJLm3p6lhD1lyFvinF3/hgJ0XaxIOxjwMV/wlKtCw0JuzEcw/SVYx8uiAd37GdUdjXtKXV4u24fY7j4R+vZAWKxzK5JrPRnhYzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EG8HRr4j; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EG8HRr4j"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3da74959554so22821085ab.2
        for <fio@vger.kernel.org>; Wed, 21 May 2025 06:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747833631; x=1748438431; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9G/39dQx4WLM5OKkPrxBp2IeAd8dmzIK0VRSIjxVYAY=;
        b=EG8HRr4jX2EKEKzAGlWflBnHTq4mGwYmfCSzdnr7qE2aZRaUfXDIg7j2G4G5o/ECFb
         okasqmFKO+UCM3wiSQmDUitSlrYnhl7x31NYWWdDQZWJHUI8uvZCFVaQSNIHbElUxtz8
         9gYOCwxFhq2oFWbWXYWwkHcOPq3mvrAZNpRFUwOW4RJCXTo0uShKyxqL6qq243Qfr4uc
         HeqUeV1eswfHTVvToD1WGMtK7Bm35rxQ5aPgeuiTR0crcE21YtHktjGHvxzjuDsV35Qz
         luddzFfTSKnUdqcwkJS5PBm3ybnqIr7DdMzmXGJQMOpeA0cUJIexZwPvKZvbUDtEvyw+
         4zlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747833631; x=1748438431;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9G/39dQx4WLM5OKkPrxBp2IeAd8dmzIK0VRSIjxVYAY=;
        b=rsQojjDBLbsRWVqRfSQsK4ti4X0o42ipaMrG0+EDxAGrbJWYXft2VAzKtq3+qT8R89
         kN55Wg/7a6xgC7eC5NYKDTXexShmTqjWdAdbXDrQE05kysvbzrUYBiVe7dsrc4mc89ef
         k71nJHSF7iSrvBDlPl65RXzA9lEGSx0/BPKZKLgLZeWehwJkQJsal2XMWG2M9Au+Gxku
         mz/VSJiaKbadKkfLpAkQhccfoo87Af2XqotCJZdMSx3t6m7zlnvvcairAQAJV4fTOUsF
         FDkEXwOdqiODW4YuhglzsNOucFU+lwsM7tjlr3JMc0o2cN+dBzYCVUxJyjttx4gdA8J+
         aMSA==
X-Forwarded-Encrypted: i=1; AJvYcCX2F9BqnTt2Zz27gbKwiPXMA34otDuNFedqj9AuxumIodMbANKmFqPcl2daC8yd1Vb3MZs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzwzb3wDbNhnNrL5f0K5uLg3eM7bwSdGOkkGK22L3iRo2yCK3pi
	K/FxaLlnoGc9L6J/rco/KiCRSxl6WPopbE+cV4jDWWXGozFXzhO6FEvgE0RLbAmZO3s=
X-Gm-Gg: ASbGncsj1ez4f7ZT1jmQDlTBbyK5QAizaURE2T99LAda9KfDDWslTSXKCovOKlOLDtO
	T5/3gniL/XYPJ+lEAjG3XMXa9ZogHO6CYZbWYCUYx3PkR0OEz+spJZlqoz0eRhi+hzioxQ8gaWG
	qn7WsZZx98qcmv31Zi5vXWcGX7WBVvhquGWQbIYPo9F72pDbivIBs4vBeiGIUfSH+S9SZKhGH2n
	lX4skyXVqYQzuJkNeM8fmQEGfVz0A4uTO7bqtSTWf5qF95QlHE6EfQH9Ak3gp1lq9yt7UL6rxhi
	YX2ZYmbTm/OPUUMofuSmOaTZP7ofIzqR1QEjkoPnnjdL67gE2G+MNVWznQ==
X-Google-Smtp-Source: AGHT+IEkQAgpCNjNiWmAQUdgRhciJrXJeDsjq98ib6fSgbhbslop281WZ6WJTQX0/aebKIiluboX2Q==
X-Received: by 2002:a05:6e02:9d:b0:3d3:db70:b585 with SMTP id e9e14a558f8ab-3db84375cd6mr205590615ab.21.1747833630991;
        Wed, 21 May 2025 06:20:30 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3db843f7a32sm29297775ab.34.2025.05.21.06.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 06:20:30 -0700 (PDT)
Message-ID: <a6d5bbaa-4a99-4027-9bc8-94920fa9f02b@kernel.dk>
Date: Wed, 21 May 2025 07:20:29 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Add Zhaoxin support to enable tsc_reliable and
 arch_random features
To: Runa Guo-oc <RunaGuo-oc@zhaoxin.com>, fio@vger.kernel.org,
 vincentfu@gmail.com
Cc: cobechen@zhaoxin.com, tonywwang@zhaoxin.com, xanderchen@zhaoxin.com,
 louisqi@zhaoxin.com, runaguo@zhaoxin.com, leoliu@zhaoxin.com
References: <20250521020421.6862-1-RunaGuo-oc@zhaoxin.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250521020421.6862-1-RunaGuo-oc@zhaoxin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/20/25 8:04 PM, Runa Guo-oc wrote:
> Signed-off-by: Runa Guo-oc <RunaGuo-oc@zhaoxin.com>

This is literally the same as the intel one, why duplicate all
of that? Just do:

diff --git a/arch/arch-x86-common.h b/arch/arch-x86-common.h
index f32835cce33b..ac26126ae84a 100644
--- a/arch/arch-x86-common.h
+++ b/arch/arch-x86-common.h
@@ -68,7 +68,8 @@ static inline void arch_init(char *envp[])
 			 (unsigned int *) &str[4]);
 
 	str[12] = '\0';
-	if (!strcmp(str, "GenuineIntel"))
+	if (!strcmp(str, "GenuineIntel") || !strcmp(str, "  Shanghai  ") ||
+	    !strcmp(str, "CentaurHauls"))
 		arch_init_intel();
 	else if (!strcmp(str, "AuthenticAMD") || !strcmp(str, "HygonGenuine"))
 		arch_init_amd();

-- 
Jens Axboe

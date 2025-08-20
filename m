Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1884263F54
	for <fio@vger.kernel.org>; Wed, 20 Aug 2025 14:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755699020; cv=none; b=tyGEr4zzZNHN3k3s+fm4qM6TwkRXPLyaoZ1GatN/k/1u6m6kyG1xj3PJuGyRirwEB+9kLZE8NCqBBQPUIL3HVldV4lAe4Idb069cQi+OTzZL0UqS42oNddcDNY7Z+1tKy89lXKzMdVJtI+kwGRU+V53JFgQjeEpOS29jGhgbYDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755699020; c=relaxed/simple;
	bh=3aLdX+ri0M87DSYl79KfmrlBYlKoVk0EfHzh2ycJCes=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=gZh469x9coBPkZAQoM8KjYis0anpEfXZEbfYYhnCjeMB+SqVIU1rsRHnNvcvBhPsG7x5VayrYZMMMJwjMs7z+zareDtM3Ujtfdk00AXxsCTxfWOSulISI8LWitN9X5SIGZzQEXYOMhXxms3DZk1zJDh31ETDRxQVOdXkhORfBrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L/qyx4Cq; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L/qyx4Cq"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7e8706491ecso961513785a.2
        for <fio@vger.kernel.org>; Wed, 20 Aug 2025 07:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755699015; x=1756303815; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3aLdX+ri0M87DSYl79KfmrlBYlKoVk0EfHzh2ycJCes=;
        b=L/qyx4CqM2bLu4dU16tiVw/nJyaK6/aR5xPezdXFljvW9KjcddcYpzHBtmrHmhChBA
         45FuKRjmh4my5sHyZtcNf5yO3rGnfHc/mhplHkhNHpOdh+6vQsY5GeLirAuyJAvkfgOa
         FH8t6sOH2zmYlNGsREeEjOqQ4158xsxe/x3wRXQgmMg0vmGigfpfl6006YzG49lZQ1Gw
         1OWkEcR6P8WvHzONoIsreOTUT37Fc91HdUGHRQ83tkvSaYUc3AC2BbVMcIpel+AVGnuo
         UQSasLCeQH56VWPPg292YEoRzqVmY6EACN04vhYpMEVpPDTcPg7Pls2GlqyKmsL5Wul2
         jcxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755699015; x=1756303815;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3aLdX+ri0M87DSYl79KfmrlBYlKoVk0EfHzh2ycJCes=;
        b=dQBao5QpZbWxrJZ/60RVEnqF6X+82KMiMcvqDsowNKKGxcmpWhMOGgQiHvWCCdridE
         HMFhSvzmxivWz5aq0aWCPM5brJ/iWVYm05pQG7OfIyVPv/rPPSyu5RYAfbn/a8a4DWYV
         uiCbs04K4OeSV4hyaE+lqXpRy/kuhYy5o2I+RKzHc43+Y0Dv9MC/WpkvNiwJntOArGHM
         4vpyZQrinEtEBxIKzCD8dAikX1QTVS5N7ngjcd4oA824IpJwR0fRwRyypHpd6WODx35c
         xy06ub780ONxWN/8QxkZsw/JOi4uFm07ZvCGsLx0kqOupuYuhQad0CqhddkGSmHpRdtE
         Zf1w==
X-Gm-Message-State: AOJu0Yz5f0QJjHAnRDGuY1fTzqKbbHB/O/j+8DRDhtDGXTtkalLyrZ9b
	+g4K9KeGA5kBfHCvpdz+8WkpG8WBZDlhg16EZsa6yIy5j9PKY67b6dPVyxM5
X-Gm-Gg: ASbGncsBVp5qkFDoR+TellWqc8PTFZEAXKl21sVoqT4zQ+UpO2eJ/3cA7HwXzYx7zB6
	86AVPU3b0KVrbgPNNxdRiZjG/lGIk50JYcWuuk7IqE+gytq3NXiM9vzrzSLkb16W4Pw2aTrUMGg
	hz6964Fxc/Pb0Ke6hA0Lb04BzQ2vl3Fureag4RdhbA90frt7psRq8sbHBqZRDRT+z3V54u+PhyL
	Xvz2MaS42MhazMajW6QXNTLOcr6jwApjkw4hspsAX4VPH6oulY2hZOraduXHbrgPVSXxFBKv0/v
	gEQiIpzChmKWUXWWoL/BWYlkzCgKkC9NM7T5FcDU8niwa3HOBloVjRHlYJBlDHYmtA7PaL5uVHw
	fU1O8WACr6J1AQU9b4f+WQ1ngLTZmy3dl9BneL5K3Sr/rrSer0Zsq2iMD25i/KHJgRMzaCTZ8B+
	/7CvJ5tFM7L+fwFRQM+1W3vn9dV7ePReM=
X-Google-Smtp-Source: AGHT+IHqL8SeF58fYURGxi6OqtSJGiGKrml5tSmn9MAXtCNO/bIf0w5WsURURqH2oupRVPyUJtqj3Q==
X-Received: by 2002:a05:620a:2808:b0:7e8:8939:1598 with SMTP id af79cd13be357-7e9fcaccb3emr372375885a.35.1755699014875;
        Wed, 20 Aug 2025 07:10:14 -0700 (PDT)
Received: from pkrvmubgrv54qmi.33sgugtnw4du3buqgugdbugj1h.bx.internal.cloudapp.net ([172.208.86.180])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e87e04abd8sm941365585a.18.2025.08.20.07.10.14
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 07:10:14 -0700 (PDT)
Date: Wed, 20 Aug 2025 07:10:14 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============1054388655131881313=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_0/3=5D_fio=3A_fix_static_and_const_correctness?=
In-Reply-To: <20250820130321.73376-1-tomas.winkler@sandisk.com>
References: <20250820130321.73376-1-tomas.winkler@sandisk.com>
Message-ID: <175569901416.2723.15310936737193123079@pkrvmubgrv54qmi.33sgugtnw4du3buqgugdbugj1h.bx.internal.cloudapp.net>

--===============1054388655131881313==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/17100188602

--===============1054388655131881313==--

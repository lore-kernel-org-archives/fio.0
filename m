Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316864C80
	for <fio@vger.kernel.org>; Tue, 13 May 2025 04:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747108816; cv=none; b=eFGwt5i+pDTS8HJode5UYGHlfx+KOOmrz0i+v85wOdlC6xqpMV2Px2aHmTiwveggQ8Lk3UR51ZNmJ39OraL7gpP41CGkNuae70yt+ORzQYBdKceC6HvlsgZPedfrn/+VGDjWwIZ7BGuo2sgE+Ay+kdVPg/FN322hbKLHQWcKguk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747108816; c=relaxed/simple;
	bh=qHreBeouXjaoBFy8d8P+gDpoO36XScg2HoVfuCaEqbE=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=u4NdLOQ+DybRMiFjSBc2nyTNjTBJGoE+fGrWwlQ60urCBkz7mIOhsFU9yKhDaLT+2XsSnJAJBB0Uqmv2NsNwjPvHkcIIfaLICOXpNWWig2IfvcQYi8cLere2NORY0VhPweCjFRqwzOAttbijNxEdARGUsGvQ452cCQUqXYVNBdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LQoLrZuM; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LQoLrZuM"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7c542ffec37so619617785a.2
        for <fio@vger.kernel.org>; Mon, 12 May 2025 21:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747108814; x=1747713614; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qHreBeouXjaoBFy8d8P+gDpoO36XScg2HoVfuCaEqbE=;
        b=LQoLrZuM/QxkkOyz62LNp6/asRmVvIfqIxCRysjjh/e6+JLT/APoBdjEJssQwXArd6
         sKE3wctyS2Kn9+mbKGqZqTZjgcwnIS49gAzFs8+BfzLvPqjCOOVB6nR15MYnqj4Tte3M
         JHugfu9NDZEz9ZV5lCvai45nIIIWtPDS3NKzovIcNQd0NGHJVC9WLG3B1UP2zBVRvQbc
         7ivEkFW0vSX5NmqBSJVTaod741BjfL6NfAg0CkghXg57xoXke8wKZe1pePxxkJcT1d8f
         7bbtFT3QzHi/D9+slftyK4KFO9TEHA6muLzWlfnW3FvlZne/o69Cnl69SLs2s5dtlFKm
         am3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747108814; x=1747713614;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qHreBeouXjaoBFy8d8P+gDpoO36XScg2HoVfuCaEqbE=;
        b=PkYMey8XUbZR0BeT0xpv43h8t4O4gc0aLEMeWe5s2RC4R9QEPjynCkuKrh5mZyetJH
         3G8oIvVOpRAe0O+XinuOLz5ai/CcFczn3O2p6mZpAMwNX0vMKDaBGRj5IHXfsxpbpv9h
         9ZV5l/Ma0RpkhlIcniGxZ4qwIw2ecyXeuD2f8+lOu5qJ0cE7UpWDAcMPu0vxp3Z8dkWd
         1omqxwkJw924n15nbUVwkPrg5ih0w6jFJzHvI+uHNiSs/CSLrrIpEY2WrMDV/Y8vqt9a
         DxrutI8VQJPUkYWyv1H22yq1jpkBo+rHKI5hPZ1CdHZ8Z3Xj2z6CmbbTUee4YQg7qp2Y
         K4vQ==
X-Gm-Message-State: AOJu0YwliOijNcP96RHIKclcAhCv4rHmssbkygP2UH6PYMyHR4Jeus8H
	WFUD5dEVOWziffA1n3WxoKs5A5sONiMQwES7dYYl79E9lkAtKu5ubGH6
X-Gm-Gg: ASbGncuNsHB4cAUu+GyExlio/Qo57HLpHgA45YhQ1+1NTv/Ak+4D5i/ttpmYEc+77cj
	1fcU0qYXS0ePkefvwHN9jfUw0Q4rPQ2kt5VV7gJMe6gS6d/xF4RThCQ+rnauOZ8ZxIQZeD5/VSi
	Q/6GbPUBCQnICA0mESqCzLLEA9qwuu5D/LuuwDyxB343NWO+jldsAwZxCLJ+U7W2R7rNalwvDCa
	v16bA1Bs+NN60Udp03JYENNWqn9DGHo+OppxuvMzlSspmvQZQiCJFJREDl9+m1LS98Eew/Nlnuc
	HZg7yIi/4H42mQtXuri8tkAiofEVAvFvH+yKnjz1E/mOOXlV6pXw82vm+scSdsRV00eUK9jmHtw
	wNDG7aAHIe+kaTxxAbPs/25jPJLejdZvdW59xczP6hR0=
X-Google-Smtp-Source: AGHT+IHcUbGO9ID7VJ+8gsPQv5tz9LuQYFEQhh8REd2N1odN2Dy1K30w3HBlCXs/oCoI3iA1ZK6EfQ==
X-Received: by 2002:a05:620a:4013:b0:7c5:53ab:a74f with SMTP id af79cd13be357-7cd01154926mr1869251985a.39.1747108813720;
        Mon, 12 May 2025 21:00:13 -0700 (PDT)
Received: from fv-az1690-142.qpzrwuosrkvuxczmeamxp1lsch.ex.internal.cloudapp.net ([20.25.193.0])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd00f63c59sm646700785a.34.2025.05.12.21.00.13
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 21:00:13 -0700 (PDT)
Date: Mon, 12 May 2025 21:00:13 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============3168410138746109590=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_v2=5D_fio=5Fsem=2C_diskutil=3A_introduce_fio=5Fshared=5Fsem_and_use_it_for_diskutil_lock?=
In-Reply-To: <20250513031837.74780-1-shinichiro.kawasaki@wdc.com>
References: <20250513031837.74780-1-shinichiro.kawasaki@wdc.com>
Message-ID: <174710881301.2586.4586100199272502902@fv-az1690-142.qpzrwuosrkvuxczmeamxp1lsch.ex.internal.cloudapp.net>

--===============3168410138746109590==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/14987685708

--===============3168410138746109590==--

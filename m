Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E132C2349
	for <fio@vger.kernel.org>; Tue, 10 Mar 2026 22:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773181054; cv=none; b=Jq96zzRyY6EyF6ibI3alhkzVswwROdnylCKolKlqDr1FCUzNQtrV1cqE1HF8Pd/qsro+2liUGk3beEA41udtaZ81KVb/POiEGTDSZJ2VdvYDnfFO7tE98UeULB7+5MAPGqNEsMTGQgWUS2f0pjrsl2qkAkTOv2DdoZX+/XKkEao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773181054; c=relaxed/simple;
	bh=aQJQOVh8widZxpm4EdcYatepjSQEYg7T9zdZYxdR/YY=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=AWVLV7LYOORxtgxPlH5A8zKeRKjRAUoNN+S5QZrq+rkfGp3B9f/VLJilPg/plGDT+TnxDFC6ltpiVGMKuVkQnI91eXlgTrPaQpAbnBaOIiy4t7PZLbZz0101ZsAT50j+FoQ2F0Qsy4ypDSomyQ4XO2ApcZKKaHnAKHniPSX5+vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WgNXrtLo; arc=none smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WgNXrtLo"
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-12713e56abdso370684c88.1
        for <fio@vger.kernel.org>; Tue, 10 Mar 2026 15:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773181052; x=1773785852; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aQJQOVh8widZxpm4EdcYatepjSQEYg7T9zdZYxdR/YY=;
        b=WgNXrtLoe9w1V4+do7K7jr61bPlKAmpU+BUjwYoQ4HSC5+PfhaCQ3BhM7moQx1n0Hx
         kTTfUl3gMojXK2HYyFyHgZvLhUCYTNqO/nMOU9EHoCJilc8zk7raX3plEX8tkcmx5/UY
         31bDoDq/LuaBy/9h1FCyxVsoxrm101slcwLxVq8uK+sqwqTiiSWDtSDdYH04cgVXbuhb
         xnVWH9MFRo6r1xjQj7Y+cJ2b50XDoDdOfaFAhI5afZpU7j6KlOMWEq0VLL7IeB67oJeC
         o436N7E8O0T6CvF0rbV1UeBLfKImcjtnv4e1KE6O1vsePafElmM5UYguhldHkxcauTkg
         iqdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773181052; x=1773785852;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aQJQOVh8widZxpm4EdcYatepjSQEYg7T9zdZYxdR/YY=;
        b=jufovYxvJVLicKdLVT4+/qN72j/rZY4Dq1cDQc3jDeZA+749HtDS2YMlyPhE9X1mmd
         zjCBW1jOM6opLOLxPuHTWIkPfGl8BLmMEl/T34LnGOo+PpJEj6a9wTC2Wwl0QNVOddR8
         SNBXnyvo3KfRWR4vpqE3CRD/7gAhiBf7o+T++8QPcuBt5KgoqkrJ4pJrYdm3swr+OKLP
         vGUOfo1Eb2i3Yz4rHKE/x0+yv06TCfFlF2zfdF1MR8lF3AfRUSg7F8ALiMb38yrY0kLB
         +49llN+3R0/yKmkQQma9oJdfvKZC/u15smSwhWj7Iq8DuLIjLatk5AXERrinKeoX8beE
         Ctdw==
X-Gm-Message-State: AOJu0YxWlE4C1QmWr/tfeMHC0hWM53m+SWfwdJDhHf1lHNViyRlhLmHO
	wNWbMQBzDiS8nwRxXqc00GOku9m4zwdV1hT/rkV8gKosrnfwrtGvQ1GHbKpI
X-Gm-Gg: ATEYQzx+sxgTyk3DVCnWP9p+H9hZ77ruybd4p9L47DtI+QKq1+DmhcO7CnTCtUHQ5D2
	wKfWLokaZxJMkMx5/oAFldONzmPb63jtV55PgWfzFCpwNFkY6JY70Qyo3WiEemLydl6wbydaMJC
	ZICfMeGF0b57hCgEgso1SkNa0Nzyc72oKl+A+31ecDWby4lfANsSulqEUMHxtwA6+cudXkZPNid
	y4ivRp7NkWVfdBeFocVVqeGx0reJhw8Sm3XMhAsoNNV9doTOhh7HYoAR45tMK8IAtw8ocRYagL5
	z68S5oZsEadfNlCd+cgnvpNz1qbTSZbzYEucD+YS2KsMFyYZ5etV+v91ZUYfeD39ZDqQcUvcKuV
	/rTIOUv/j6PPjuIV57TBN9nR3r/o4qZTNIsALCKKgC3vg/YUTlbZ1W7V17lDXNKNLyd39d7ggsa
	ZMaoyBXyTjjjmnux2/E2pkUp832nrSv6/928ryTKqXfZFxsTqzWASz7gELb3LBvky//+FERNHba
	7wb1oJXAi+BG9QUmT4cxz8=
X-Received: by 2002:a05:7022:238e:b0:11b:f271:835a with SMTP id a92af1059eb24-128dde07d15mr2388277c88.3.1773181052227;
        Tue, 10 Mar 2026 15:17:32 -0700 (PDT)
Received: from runnervm0kj6c.si5vesnirltutgysy1tpxjbuwf.dx.internal.cloudapp.net ([172.184.220.148])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128e7c1ff96sm259622c88.8.2026.03.10.15.17.31
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 15:17:31 -0700 (PDT)
Date: Tue, 10 Mar 2026 15:17:31 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============5017639243086882667=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH=5D_backend=3A_correctly_handle_rate=5Fiops_combined_with_bssplit?=
In-Reply-To: <20260310205804.477935-1-dmitry.fomichev@wdc.com>
References: <20260310205804.477935-1-dmitry.fomichev@wdc.com>
Message-ID: <177318105067.2968.11646866370151995760@runnervm0kj6c.si5vesnirltutgysy1tpxjbuwf.dx.internal.cloudapp.net>

--===============5017639243086882667==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/22924864499

--===============5017639243086882667==--

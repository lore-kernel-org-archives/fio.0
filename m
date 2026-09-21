Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ED54D4898
	for <fio@vger.kernel.org>; Mon, 21 Sep 2026 18:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790015939; cv=none; b=A51S+krN5Q8D6/LEWlkH7v0OPDwweHARIscROazN8QJJH/HeAlUuWBYpIZci9+ak9AvrMSw/mmeOBXOIeMO2Cpux48w2qgot4Y9NU1SOdVHOG/EMFewdW2Gnqy9eG4wQL26uyqBPAU0WPEmmYv7cJi3WPPwiAMx9wRuyExNxEaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790015939; c=relaxed/simple;
	bh=6JkR8PQCBEWdT33e7Ce9b5WopBHF9IpR7OX1UL9snj0=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=MXQj/dpLb2iTlPbNxGPRZ/ZLOa4AdkNA7QRuqYZ2N8uQnjdu5pGxfP6vFPIx0IKkpoY3nBo4ZDMiIF6ITnSMe1Nxb32mbwu//SP1+mQ/AiwZ961n/aPWqnT4TWLIsoONKei6i3flZCp6IV42hkW+2LQIxk/tX3EZYB8fLI5QAGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EhD6APJj; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EhD6APJj"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccafb74fso3200333a91.3
        for <fio@vger.kernel.org>; Mon, 21 Sep 2026 11:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790015937; x=1790620737; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version
         :content-type:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6JkR8PQCBEWdT33e7Ce9b5WopBHF9IpR7OX1UL9snj0=;
        b=EhD6APJjxB0WTnAxWFxiA3Vwr3kZjo4MCPh4gl2Znp5BH2aO7ARkci1euXPJFNLPeQ
         V6B8SbiXbppwZJq14LXTR/fUR8uIM6QjSJ/ggFefLO3/tCoE4vJEGWS3h0Dh0fxLEE9L
         chdWJsQx7X2SPpe3N42GA+IqSA2hpdaUgCs7+JMi1/KOjIjzgJQEczI3qsJhVTcwwrzZ
         PvH9j5Zk//PPhOSBOabIK/ddZlqWKv4zlVimIfab7rDBMTKQkh45kgxZBZkBwbCgQzxn
         looOMA1daHQoZ9/xQ0Ue7aK52Ras8bRtx3n4v0gNmjRkGL90cbiPSNvLRVttBPL311PR
         m+Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790015937; x=1790620737;
        h=message-id:references:in-reply-to:subject:to:from:mime-version
         :content-type:date:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6JkR8PQCBEWdT33e7Ce9b5WopBHF9IpR7OX1UL9snj0=;
        b=lNJ0JHkIImgQu45DaeSAVy7lH2UbjtNzKA5MrswSPJ5Od7oBd4N6727uE4X4z559lv
         vxfIWYRy63JP3LETtTG9KeDm1/lUCwKBjFiSEPwcRSvNQKkvB8fK6FQsuX80qtuZKxBA
         5zKM6ENUltHfEENVviyW/zkWzRG8hT+KKjsAXr+Z8h6Tiy+N1LhUDY44F0vICSu0Do3h
         TTFS9Itfzvqc50NE5PrtspGSzaTaAOEh3kJWL663OC3+lzvyL0Fulz8w154IdPsIFsTn
         5scUG6IAttVf9bKEPZ9CP9gfBhJ2MqvfxyUzAHRCzRIe2LOQEXMZrWt/y5VnW+LxdGp0
         R/Yg==
X-Gm-Message-State: AFuF++mp4uMVjD6IkdakJZAms7d5j7llMavzIcek4xiymM+gH8CiABtI
	iYSPHB333P0IwTSChqbWMA6//cQsNNTsm637+bwUgYcks44K2xBjSlIHZz9U
X-Gm-Gg: AYBFou2Be39d6bTy+Kz6kSXw1aH6jhQkFIcwGxHufXMOyEkslrut09WoVblMVySxRSn
	bDp719v0X2tpbbPJOwCvA674lp2q0yE83g/u8z5HR2agKE4FGGvzmyo8Ch77juRQvPm4Qm5P5YA
	WB+swBcPi60UktwGgdVUe3aI+D59kBfAMYmv6wn9SGIJfEqt7ADVHgyI1vE0py2YdWi1cNm/qBO
	DZG+0UAZz2p5OUSUAovO95ktrguvjqyzJ3Pesu4aru/rnw/yqIaE4a3qpRnWtcXYkrP7bx8fD3+
	TLZIZxoJZ/cgzfh5wnZaxmJnRTbfmIMnxykkhhnxQN0W+Li04nrOVcsujKuZBtBtMkvggNKjBml
	5KWffOwHQMB850aLxI1hNSoCjHMnsgfVdscNkJt5vTiNAJDFj/E/tUOaiSQ0CXdl6vKN3zPDcTs
	9ac2B0KeXN8lyvkvGWs1GmqH5kePjSusoYIzukiqSkxg7/7ditnuS9J59vRO8qSAMwMkh9AXNjz
	34ez8+1miJ1iIqgBpM0AJNMDZEPuCz4TemACUJoYgtnI/Eg7lEY2IMXrZ3iytvDI9vH
X-Received: by 2002:a17:90b:5251:b0:39e:6a7f:eeef with SMTP id 98e67ed59e1d1-39e6a7ff09amr12350530a91.20.1790015936952;
        Mon, 21 Sep 2026 11:38:56 -0700 (PDT)
Received: from runnervmlun5p.5v3bw1acg5aejpxxefstvhv1fg.xx.internal.cloudapp.net ([4.246.70.112])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a06997b170sm94410a91.10.2026.09.21.11.38.56
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 11:38:56 -0700 (PDT)
Date: Mon, 21 Sep 2026 11:38:56 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============8302396413462376405=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH=5D_examples=3A_add_seq-rand-read-write=2Efio?=
In-Reply-To: <20260921025521epcms2p34a2d819339601929f469f71ca7014901@epcms2p3>
References: <20260921025521epcms2p34a2d819339601929f469f71ca7014901@epcms2p3>
Message-ID: <179001593631.2909.16026965515973449474@runnervmlun5p.5v3bw1acg5aejpxxefstvhv1fg.xx.internal.cloudapp.net>

--===============8302396413462376405==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/35567772288

--===============8302396413462376405==--

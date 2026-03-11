Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EA5243387
	for <fio@vger.kernel.org>; Wed, 11 Mar 2026 17:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773248937; cv=none; b=A81eRuwrGOIvOMCjSCG+0UffdJxTW8EQSPW1MnMFmRwQ40jMS0tRIqKosX2lAvO17+6JbCs0/kipXFvpO/ihPwqepi7BtahcaXQ0wWlSIlM3RDX5BLYo0CJAYU8lIgnt5aIrPyDjB3/2DVHeWZrTVsPBr4IDhCZLVPkSS9irLHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773248937; c=relaxed/simple;
	bh=/I7Lf6TFlJ++N61bLz0TzvcmaJh4lZTj0YsZjdt0H/s=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=XWWRXIz5nCZxbV54459LkkmxpI24DRygdNRHaEypid6O3Gm0+bhl9K3xOilXPaBnUjWpBjZSwDwc9m2iD7kIogGsNo4xo0Oy6qzfpvI5vPjRFFQ5b3XLvsDBTceGRvcTnPiqik8lbhyo+K7GRAlbhBEEoBGg/5DA9CMlo3VYhi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S5D6Y1fJ; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S5D6Y1fJ"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-899e87b04d8so1157376d6.3
        for <fio@vger.kernel.org>; Wed, 11 Mar 2026 10:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773248935; x=1773853735; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/I7Lf6TFlJ++N61bLz0TzvcmaJh4lZTj0YsZjdt0H/s=;
        b=S5D6Y1fJAOhi4PQ9+8OfgNWzLSKUNrczHJqJvrY3rzRqbL+0Eo+Y8fz1EEwv+z4CMb
         kUuTxmFlKsKYagNzjphJB7C79SUup7v0hSoWDNzGLzY5pUoqDHOcfjchHb3WXVXs9Bj/
         ri3qlH3NiBMLUG0Yq9d0/yGN2z3A9F4d8RQkie6bjSGAuXfJkdaEsSjYI5i9T+FvD+6m
         apGPyybfLs5MqcWiV0J99w6himydljz1e2lzkpAxKGIWrlOf7UpEfoqa3s1MPXs70fr1
         N6Yx7CnERnSL2PpdUQeQQgCuTz+Vdy7KbCs/UpHwvjKN0/7Lb3RZHQhWjNN+g/qHvylA
         UZ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773248935; x=1773853735;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/I7Lf6TFlJ++N61bLz0TzvcmaJh4lZTj0YsZjdt0H/s=;
        b=Q8x+xckK8UI37NhenUXa9Uq5BMxzu6yResaIW3Sia0vU+Wx25zYmHb9KIlgYIdky8R
         uYLPUEmzPv9a/sg37EXRXmKDXuApkmHSl71uldBAy5KsnTI0IpYYNBV0IhkKDEjG4mlB
         /9P2MxQ6zpIJAGNLqWEDIHDzytXwh6PACIXZYIlHEt4mSnpQs2K9r51XQQ2Y+x2GwsDa
         PHyTRDn4gm3nJU64BqEDjRhhew7Pjcyu9fhjB3IuBEofynMoIhZSobRDovGf9w7cr6Qs
         kHIOqyZUihNSB9d5wy3xYFT/slz/n5YtQNJ6V6kTSmZQJLKk795MTe2CeDznr0urTgx2
         fMvQ==
X-Gm-Message-State: AOJu0YxKnK6KUqXzp2fPX4YlpKKOCD+VvgUG0mjQufQAfpYrP/2yv/4n
	10Me12V2RvWgajYx7YL2zZsjduP6CSYxegRk0FvflPnjp5dl0uSzVSgjziiS
X-Gm-Gg: ATEYQzybOqu82V1t+Jkb6hShesWs/FGiZVHX1y5xUIurv8YYXbI8lD5UNAlSRinQe1V
	AJNzY9v5BQWK2ukuC7nUnET1iu6tCQ7W1Imevbh7/4vL8c7mpOLwXRyqHcE49LrmnPh5sGRP9uv
	ELWiuqwKcA1uUyqnkbb3IgmPjlK/bNKzoa0urDv0kMQh0n0GtedmqAjN0BbBWuXPjN92AtSVB/O
	x20mbZyY56y8UtFduxlQjw7X9CuKBc6linw2LwxzG9vJhB24/ckOabiJNAbE/2KmhGCmljKV2Uo
	AwO26Bk9Q5kcVQ/aqNE72GoPtxalKLkpHBRk5RtJEmxdthtj3RjkTIOpVhqOTebcJH4JKd1jpYi
	RlHq+wUtyiST0iocnB/Sqsuu+28PoT2cS8z+/1hLNRckraWET8uXfgcCNgMGNPFbHmRcY6qSXbj
	MK3LUrntlsWzg0Vycp0HO+9u+fER+QFcLVK2i9Rn210Z0Eo80xJlur6AZTlfDku6Qp0hDaMu7yE
	9Wx0pDUW9bKYkmKV0oU
X-Received: by 2002:a05:6214:c47:b0:89a:629:2203 with SMTP id 6a1803df08f44-89a66a252fbmr46842826d6.11.1773248935500;
        Wed, 11 Mar 2026 10:08:55 -0700 (PDT)
Received: from runnervm0kj6c.udj4xtdpj5gudbzd53otcxfj5c.cx.internal.cloudapp.net ([20.109.38.226])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65bed6ffsm17649716d6.16.2026.03.11.10.08.54
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 10:08:55 -0700 (PDT)
Date: Wed, 11 Mar 2026 10:08:55 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============0698964213552668576=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_v2_0/2=5D_Introduce_a_page=5Ffault_ioengine_for_MM_workflows?=
In-Reply-To: <20260311155114.198006-1-npache@redhat.com>
References: <20260311155114.198006-1-npache@redhat.com>
Message-ID: <177324893479.3035.16012283356298453936@runnervm0kj6c.udj4xtdpj5gudbzd53otcxfj5c.cx.internal.cloudapp.net>

--===============0698964213552668576==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/22962368664

--===============0698964213552668576==--

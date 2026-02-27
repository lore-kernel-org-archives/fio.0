Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADF8376BEC
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 09:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772183264; cv=none; b=I+E+6aQ/VAbHWPGpg8m7kt56Mlt28Ko8pvZQclW0jspmSAXuWjH9kyeqHdQ3d8H7l6JZ/pG1j3xZEOPTbXMPKgMGt8U2+61CvAm0nw/ePlnTwfKykQVmGdAFTJ80y4T/SpRMx+5mDOorRRqassIMnJawIe4L9bdGS1niFrbjJNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772183264; c=relaxed/simple;
	bh=3jjpoEooyv60mGQvwCnxAEaN6zyW8MMmTuq86CC5Gek=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=iOXxvEcaGhSO67oi2J08HuVZ9fHFAPekdb9l0M+oIVyRH4IjLnZlxm2Nd7hsLB/dZ7bNN5LQEBB6M300rCP0n4FZYpHcTPC+HcnXkMpz7QLU7t+JVynxSOW2oxZZ9KqJLf6PaMkt3imO+KjsVH7u+6UzJJYNiBzz50Aq4nt14co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JjMc0yZC; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JjMc0yZC"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8c6f21c2d81so175387385a.2
        for <fio@vger.kernel.org>; Fri, 27 Feb 2026 01:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772183262; x=1772788062; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3jjpoEooyv60mGQvwCnxAEaN6zyW8MMmTuq86CC5Gek=;
        b=JjMc0yZC4OyfxNoppLtgFoPe7iETZvllzvLBqApjsBWnTkGG/+vCQ6D+2LKmDT3zYt
         wKiqTUF7tyi5cUlI9Igzixhc8AENdb5Is9XCJLeq28RewdP00EwbAHNy9tbek5Bkas6v
         bAEl3Kx+f9KubRXZ3Pe2JiZqxlX1kHdY6zCtDhMRldBVKMJmt5GxlHb2R5liWuryEdmF
         q4BEmg7Jv1wKKzBmARQcH6lJoTsc333fTG2rgVN103MlhaYfhwLzzvPkIXydTT1Bnj+u
         dUZMYRqwe/476752re1OSllkMn9EWLbxSac67g9fbLLDJfMN0HH6yArRTpN1EMSqOV0m
         zuKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772183262; x=1772788062;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3jjpoEooyv60mGQvwCnxAEaN6zyW8MMmTuq86CC5Gek=;
        b=hw5hSgI4DpZ+Dab0YbfFxEbNROr8VKY5RhVUaeTlatQSE2u0gjl55UydZjZDKm9md3
         pbK0z6nohUwOh7G/9lg6yUx1voWSFWvBbLLGca47TPvpAmBEdXLpng7ZCaVWCS+K3QnD
         fMlEh2uocXhA6aQvenT9ST/yo68w6Fp+CvbmDktNGkNwbkdjJ4flAz0JHYfjd3dxtuiV
         2EuUpY8zuW9cf934WmRYzDk6Gubi3/gPf8HuutKaL1lQAZP6VRClOpdGTOQAeuSV90UX
         /Zkje0tukjgdY40EVAFDXjQt1ceM0C3Cv8JeWa9r76EaPiIphV1K56PvdvjlP7F8yPAt
         qjLw==
X-Gm-Message-State: AOJu0YwY9vcbeEZTTM4dp1k5pFHZjW+RRdSJMlzACBeC1gN+QKlWmyu2
	q5X2v0GkQMadYsQcvNNPDw8GvAZdaYPQ6cpXEsC9af+4TgLQYmlqNMd6WhGF
X-Gm-Gg: ATEYQzyyhURcydXnA5VnqDetAeYJ4zjx/Iyh2XkWLEgMBkwKgJQHjcF6nFBwXoY9aQH
	mGoz0wFjwGVp40sqQgd8vF10dZn50d9R9UsmRWpnQXHYTV8ZMZomzu4C5SJ+42Q4ifmnJmcGvRP
	2Z6eKCA4yC7iZQLCY1NR/cFabSRuPKkOUOyj8WSa3j6B3RXb9hDPWHScftOqLD0BZRCwWXK01jr
	ncBEscgSwHD7wyOmoKNKDgkgEF6w/QUZOYraaLQ/A84KAqpwp9UyyMaSUPCuJTX3o3KxyF4GsQ0
	My1HBWY0MCdguc9PoAbYUu/HuVyEr8TEKtaK0B0j+yPoBD0F0Ye8Hr1mmTfPg3V+94NyHGwvqhM
	i0G4yd4vAzi96F/zOKMaUYKP7dHzMHL5nRrFNdABrwIKYABAqHVn1ZVY8bZSMukiJWaKXmPZSdr
	gaaGlzc44GgP/7Zkk0ra9WB1wlsgTEjCX+VL9tYBM8PHStbORHQih5hJp+pBPf3baR+UQDm6Sqc
	orvJnVX6TLAcfqcaWup
X-Received: by 2002:a05:620a:40c4:b0:8c9:f996:81f2 with SMTP id af79cd13be357-8cbc8e55bf9mr234542085a.17.1772183261586;
        Fri, 27 Feb 2026 01:07:41 -0800 (PST)
Received: from runnervmnay03.hwtsxnfd10pere5w5mrmckzgyb.cx.internal.cloudapp.net ([172.172.87.66])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c738d56esm37365786d6.36.2026.02.27.01.07.40
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 01:07:41 -0800 (PST)
Date: Fri, 27 Feb 2026 01:07:41 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============3109393587229724275=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_v4_0/8=5D_Introduce_the_end=5Fsyncfs_option?=
In-Reply-To: <20260227080712.2422380-1-dlemoal@kernel.org>
References: <20260227080712.2422380-1-dlemoal@kernel.org>
Message-ID: <177218326069.2938.13525619575899054761@runnervmnay03.hwtsxnfd10pere5w5mrmckzgyb.cx.internal.cloudapp.net>

--===============3109393587229724275==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/22478787678

--===============3109393587229724275==--

Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB50825F98B
	for <fio@vger.kernel.org>; Wed,  6 May 2026 09:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778060327; cv=none; b=MQ0KqU3J3Gz3vJ7BcXGNKbILPXqy2TthIz6sXkTULgpN0cP1chhhGYd6kBZQqWbbeNyeIxNN12QM8KdktdsIp4S1baFLETCcA0cZXJyRfRY1w/x49euiDKPGoBYeaSyU90+dE6RXFQbzx0lGQdEJa6MWVH6ECso8j9N/6RFJda0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778060327; c=relaxed/simple;
	bh=2a6UeW3rhtqNeskODnrry7w+crTVjuM1ZRcbShzqZ7w=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=Fqzot26ZAPj3JuZaw3xJVfHVxn0l864TpuQvBvELOHJqUwg2B2exnKLXKjAA40/J0Fsjh9y8KG0y9IuacG4JMvqiNb6QjoSEsrnB7NV+84LxjrCDO8PT7lCO7fEsY9DqsZ+JiT1iDwdaRcgQB5BFarfDa9SPbExzCsz1xDqkSmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mrT35Sdp; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mrT35Sdp"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8dbbc6c16b2so96163785a.0
        for <fio@vger.kernel.org>; Wed, 06 May 2026 02:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778060325; x=1778665125; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2a6UeW3rhtqNeskODnrry7w+crTVjuM1ZRcbShzqZ7w=;
        b=mrT35SdpX4WXBR7lE1JD4z/9S3szQaI+bRSFRSZP1xwONXEs/VktT/DNcAgFoasGGv
         OcpCLzaL9VrTa7EmylWeDPcjNJKpHWifzY03HP+tMwWBjpsaLrSMPqG/y0d+Cj4Ckdsq
         b2bAGPJcgGymjGGx7b4wr7lVOeOecSMiwau/+dyPd0578NLF6VedRu+F4zGRFVznDVbS
         RrjVwz2Z9b2T8ysFKSIoJYNNQWnF0g0aNAZ+55p/JEfYBARu1K+jmdYWJ2WC/UEoUgRs
         T+W3zi/UGv2YQghfCNe8xr8uKEjOARIrwGHtmcgF7+5DYQc3euz3IoJb+2hvDfXyRDqn
         9rUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778060325; x=1778665125;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2a6UeW3rhtqNeskODnrry7w+crTVjuM1ZRcbShzqZ7w=;
        b=DPDKwdC+ahvJUrRF4P2bkZvT3lF/BUfWjsw6RstrlU6ckYqDQjxsl2zI0jB89vgqBx
         /4RqmnBd0oaxzENVX0MgXvlMRyhemRa/Rry6gQ0o8nIJOM9ILB/dsUUbid1G5UjmfUiE
         7uCWMgkk7+fQS2Dhn4SVArqiqUggoHq15Z0yCFS3gYVpnPjv8B+lh8YwCXr8wPvVKPC6
         04WhK4bH5IhWko1dSzVuqRoWOzSADeiHtgpOv5S3xLkc1OriNH6QsXDCByJIFwVvokTw
         syUaTyutH6cSj7FrvFgexuAwfiSqFqmRpzwXIZ4m2xR5qRYzPN9rWXmp70XQa9z3qjEz
         EMwg==
X-Gm-Message-State: AOJu0Yw4aN4b2MgP8mBOdocCgJUwW3AVic6fgpPRkrY54QI3GjfxGa3M
	9PKJQPy++psfZ+iXr4OsJswo4J4Rx0HBqf2WfCwmk56kGCtUqtU3BER9z2YH
X-Gm-Gg: AeBDiesz3ZHiVBkCHQ2sWPIjRlyeZ4cjHfDDGbyWHkhge+NWS4gwtUwqC8/fWF4Ox9l
	MX6DE2KBDRNf/w5mLA2htfIyM+P4I16xdcc96HrM+MzEQoK0qnCKBRJd4LMioNBoARxLkTIEglj
	wAL97pHrD8NUb6hdFvsZVC6dTDiBtcP0bh2g8a2wr+RqdSDmCjNJbBCWE1i82WfS39Ndefd6IMn
	3UBpGmPnTJGwj3zH/NB+MCmxrmv1BWJQIfDAU/qG++pwQEIZ5iaWF1Yqz0lQDMtFFtfHdCoJwpa
	vC9+dzn+JGWPOo4tQznb3M3crb0TRSOTq8bj3f50VP/ZHwpQQs4TqpVS9HP7vRWnN9JlWZuo6iA
	Q9sbqvtbwwOQ8OowBoEGk4PfhCZ5AfiojhhaJ3dUU2/xwQek3USG5ZVkVEzpsTtBRnRWG87x9Nh
	5/d/OwiqbG9IzpdalNMRzLBxqHPT+FbbEWQ8BoaaM+4jUyaNO1xu4ZDs/E4Yidto6EaycCmyx66
	l5XhdyEv4KBAj58uFazHRS6D95X5mRCVg==
X-Received: by 2002:a05:620a:4105:b0:8ee:f43a:bb77 with SMTP id af79cd13be357-902e2f35a3bmr1034043485a.37.1778060325377;
        Wed, 06 May 2026 02:38:45 -0700 (PDT)
Received: from runnervmeorf1.teyjlkhzkogudgnizfo5inqstd.bx.internal.cloudapp.net ([20.228.220.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2c91c807sm1779435885a.32.2026.05.06.02.38.44
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 02:38:44 -0700 (PDT)
Date: Wed, 06 May 2026 02:38:44 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============3943500728567414030=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH=5D_added_new_type_of_random_distribution?=
In-Reply-To: <20260506065507.2858172-1-swethav0411@gmail.com>
References: <20260506065507.2858172-1-swethav0411@gmail.com>
Message-ID: <177806032463.2994.8305816637423765999@runnervmeorf1.teyjlkhzkogudgnizfo5inqstd.bx.internal.cloudapp.net>

--===============3943500728567414030==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: success

For more details see https://github.com/fiotestbot/fio/actions/runs/25421974783

--===============3943500728567414030==--

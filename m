Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EEB1B85D7
	for <fio@vger.kernel.org>; Tue, 21 Jan 2025 08:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737449367; cv=none; b=bLulKgwhvqTEwUGfKYlnIxpXeJGvsENGh/97XdfLI4jYNm7jDtEHH/fHsKg+8+iDct7yCEeKMRebqwuhtIDPof1NGt5f3nIBCxW6HhDJl7HzsUsEUYa1xZvOmZYrEHHZdXuqNs7WXPmGyEdHoHxhSVVS5yk40HMWbwc4s9UK9Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737449367; c=relaxed/simple;
	bh=tmjbdiNMvoRRqvKsifJ0Cj74cBxc7q8S5bCdlYx2y5E=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=rakv3fecpTCKMzoa34znCBsO/ZBAP5g8hpk1b8jvWyvA7i5mCiKY0X/Vkryw+0CxyCwYLyv49VBnmz7hTMHzkgKelSFgGIabyOxWuxHPfWqqFaBVeiywvPQWLxjyrPXDGzfLcLLS7d4/brfnwUZ8kM3gYFXBEKlsctQmwmlCKIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aV8seQJ6; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aV8seQJ6"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4678664e22fso51048011cf.2
        for <fio@vger.kernel.org>; Tue, 21 Jan 2025 00:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737449364; x=1738054164; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tmjbdiNMvoRRqvKsifJ0Cj74cBxc7q8S5bCdlYx2y5E=;
        b=aV8seQJ6NHDIgxMi2CzrHdsFk3FMCuuaDs0CxP8EqCfLXwlyKJcyjKqo4+lo2eya2b
         6oVrmQCmCnLF+Oc1lvFUEp/DqiwnPTYV/CTIA4k1+XzfnEVpsiI2vj6yIxwnxBDSX/7v
         BlMV2z93Ecgdtt8QVoUNH4JQM6JzA0lklWw7Vj2RnGfpw1QlyieeVkfJZ+gCXKBqqC61
         yo6CXkQjEPmMjQpwlQjXZVBjFnew6+uZwfQnsC7h9O4rRcBrYmmyRInCP0R+KKPxEV2A
         tNFaaVZ0ZbMtQRTnm9wLCZBkoUJUbfHQwzg43du17hfM5oWiWEc9Ymvbyt4MLLPffTqy
         REhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737449364; x=1738054164;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tmjbdiNMvoRRqvKsifJ0Cj74cBxc7q8S5bCdlYx2y5E=;
        b=JmWwTTVV/HqMh6KyEhXQctoAYfumaA+5SqwaB+jGF0AOxvmtFKNCsF+C7Mkxr1IaC9
         0aI4vI7mpjc7SBGVyCSKIINPg1WaCcJ//j1WQkdXBgweFsTczRibTFMX3+9Fn5LmPqrB
         RNdpmI3MHjGCt+hkCB5kldUOiHEoUibLNAyx65tmm+fkZnXxV8NMyFM9xJeTqFLdUqVp
         cSzy+TlqGM77aZ+9bAXJN3r3paQMismsCgfPztPYReCCGL+phfN68tMVO6D+17Go88fV
         BMZwJrk9u3qlWE0KyVnbinciOSs8WGrnPFnNCtZ1tPPj4Y59oHP2BNlzE7jY+s5h9bpI
         rmAg==
X-Gm-Message-State: AOJu0YzyMas6YA/Oqm/EnZgPkgccj6X5ZTlAUganR+fkZRJfJs9fxczT
	8pOdY1X61bWhI6XIXkcfxawkOTsAiA5CJRMYKnvvXk8fRXLoxFwYfzka
X-Gm-Gg: ASbGncsr8IUrh5U5JBoIHmneLMqHAc3Eg2sEYZW3t3GCppm55TRC/UdApiPiuGxmrX+
	7tuTdpJ4u6XNZXo5yA33SChJBtG97wgUyJwwr8GY6XUtlhQbsqPWazVTa3gEqLbBIMFaG282h+q
	NOovG1O3qwF26/Xoc8xdOamFo7BHFRwkfNwyKEKY89/HMuvrCdI/W1gvsYH+kweOHcrpcy0njSQ
	VCZH57ArdEPTkKeEHVlL+gOduKXZzrmFdbPO1s7ZstjTACL6yWhMLGkp9BPDNh3q8DcccR/icAT
	nd7hQAZu8DR97ddt7Y/nuKYcLjXN0M6CWY4zAWadD9Vd1mXlVwFot86VYpE7HEVhqzU=
X-Google-Smtp-Source: AGHT+IE63FEpPXYu/ebhc2ILKN8JwxDJxneJzoUudNJAhESRbNMwHtY5KIn8IvOaryaTP0Eo4mPxlg==
X-Received: by 2002:a05:622a:311:b0:467:672a:abb8 with SMTP id d75a77b69052e-46e12a1e603mr259124281cf.5.1737449364383;
        Tue, 21 Jan 2025 00:49:24 -0800 (PST)
Received: from fv-az1944-303.zvagubjpb1fenlvaxs5xdggbeb.ex.internal.cloudapp.net ([172.183.199.185])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46e10436015sm50920521cf.77.2025.01.21.00.49.23
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 00:49:23 -0800 (PST)
Date: Tue, 21 Jan 2025 00:49:23 -0800 (PST)
Content-Type: multipart/mixed; boundary="===============4239189924489584758=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_0/2=5D_zbd=3A_fix_open_zone_status_check_for_non-write_jobs?=
In-Reply-To: <20250121083913.1216619-1-shinichiro.kawasaki@wdc.com>
References: <20250121083913.1216619-1-shinichiro.kawasaki@wdc.com>
Message-ID: <173744936322.2484.15711602914622285195@fv-az1944-303.zvagubjpb1fenlvaxs5xdggbeb.ex.internal.cloudapp.net>

--===============4239189924489584758==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: None

For more details see https://github.com/fiotestbot/fio/actions/runs/12883126116

--===============4239189924489584758==--

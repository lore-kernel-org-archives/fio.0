Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073F2146D65
	for <fio@vger.kernel.org>; Thu, 22 May 2025 06:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747896548; cv=none; b=l9d8mI2SlVR81mn7Y94lisrl4T88U/vFJuJDNDvlP7gdlUWH8vRJHR7Scj/cdmt6WhgafUJ7Zk9T2hPLaYNDHL7y1JhDsbR1ixTZtVO1jZv7jSlbKorOr5b7n/xIqHl/Q87juxQx+sgv/ZpByjYXxtxuEshalkva1kINYkAkVE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747896548; c=relaxed/simple;
	bh=miqhds3YRqywUuDHH58iA260T16TwcpowzMMUofdyQ8=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=HwErYrn+/x+rfRe+h9x/fQj/w69KIm8pK34l2ZLcHr4KXxfrWzo+aqfXyluQHW2hnUFZUFV5mHFMY75oTIzUKIXYRo6iHDd3X1srUaqGAZmKcr5CfeSkjRnVkfHt5wGYrWrNlGEBFJSHHEIInk6AdRd9yIY0vxnW28wgvdIGfzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O5Nfljnd; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O5Nfljnd"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-231e331baceso59886045ad.0
        for <fio@vger.kernel.org>; Wed, 21 May 2025 23:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747896546; x=1748501346; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=miqhds3YRqywUuDHH58iA260T16TwcpowzMMUofdyQ8=;
        b=O5NfljndwBglDRo4lYd4RYgQZWF2RwxJJGUBZ2QclMORZlUzy+yBs7I1o4i23z3/lh
         /Po1NzcqjNG+94M0MBC0EbIxNoZIV0kbdXchKWa2QENO3xnpTiWgG6eQNfXVcqiq9fES
         MComp+xq/PcyMy9NqBNwDUwJTQ5RIcYd+sr0LJ0FO22Yd3nEzhpynXo3nfSMz8PyhBu2
         e4/E++TanPEzejimMotsEjZCe88SfqPQVREDlGRkxDw46YGlldVIN8+TIqM1Rvp1nAgs
         X5bcDDHuGEL5clzWVlrLEv55lAj6uAT2ecSjqb8LB5lm70fjyWGZGGDyaXi3iKWb749U
         guIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747896546; x=1748501346;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=miqhds3YRqywUuDHH58iA260T16TwcpowzMMUofdyQ8=;
        b=sEwGzgpA38uNm4FUuc1N4/NQ1voWeEI3O+0A+Q2QOcW9/hsAFh85ousvO8iNqUYWDG
         2dIyIdjZE+d6xMmvghJcYKJOJWEEN0dwcKb61IT4+Dq857Ue2yWdOttkM6K6QSxIpp0O
         YLuyAkj4LbXF6Sx4MLMp3eGvhXPg32+D2VHr6h6YhY7KEGTJqvNopOmQz1SCzftvbai6
         yokJ6VWSYJ5Z7Ju7C/TMBBYybcSGIq0KmlB10QCoHK+aHbxYsMHREpi3YtNbUJrq0Q7R
         HhrxC2EvgqWJRJtzochewZPxhoN3ybH/Cb0UPYRwRsCairGiqxl7LLQfrtFx0LclnXNc
         DnsA==
X-Gm-Message-State: AOJu0YxTKL8mVffu9lorZdwNbMgj8slAcER2pIf/cXsmW35J+deUEQQd
	SDlF55os/uY3EGfepCwjnPBYsnYEFmKme4Ub/dWEUn1ZnyVxsiilczwvDjw3
X-Gm-Gg: ASbGnct4EsYVm97TMZW/HUJ3rKE6KtcchNYFYuA2ejHuHGrwesAkBHATHUdNSmYEJiM
	vXCPcafTtZY6ADpP/5RQ/5Ol+RuOTJHNzjckixkmuX2qYqGcuusdgxqjqMwTeNRgnZSD8RWOcTP
	slwjLdk539AEKAy4GzoVeqfNKuZfUoFFcEiQWOrDOQVqhWH/XCGbb6flVpvFT2Hx9DPkLM423QF
	9Y+7EYE6XYVpy/yxZWc6qNlBuEj5J/2rdWskFL52WL/ZuH8hkTtgSLFmHC/q/n3LJqwX9SD8z7Y
	V1X0knzP/1+rtFba2SN+aWZ6g1ZjIOosFt9k12dUhvgyFv+o
X-Google-Smtp-Source: AGHT+IFh98r/7TgGgrcVQwzLw1e9E6sIZ4BcWIBGAAFTJLvWMQQDn2c3nvqydS7Ql7D0f+eGkVivdg==
X-Received: by 2002:a17:902:ea0a:b0:22e:50e1:73e with SMTP id d9443c01a7336-231d44d78e9mr326040055ad.14.1747896545883;
        Wed, 21 May 2025 23:49:05 -0700 (PDT)
Received: from [10.1.0.125] ([13.73.50.40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4e975cdsm102172575ad.154.2025.05.21.23.49.05
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 23:49:05 -0700 (PDT)
Date: Wed, 21 May 2025 23:49:05 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============6821161908620218287=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH=5D_Add_Zhaoxin_support_to_enable_tsc=5Freliable_and_arch=5Frandom_features?=
In-Reply-To: <20250522043703.8458-1-RunaGuo-oc@zhaoxin.com>
References: <20250522043703.8458-1-RunaGuo-oc@zhaoxin.com>
Message-ID: <174789654500.2835.15253151106943081248@pkrvmf6wy0o8zjz>

--===============6821161908620218287==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: failure

For more details see https://github.com/fiotestbot/fio/actions/runs/15179641974

--===============6821161908620218287==--

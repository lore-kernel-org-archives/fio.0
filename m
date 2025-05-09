Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E9317BCE
	for <fio@vger.kernel.org>; Fri,  9 May 2025 10:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746787382; cv=none; b=qYBFg0tfLk/XJylCy7inj7FghgDd9zsc6CAKL+PZ0Lwet6Rs+C9O+PMd2xfv+oZ0tvzI/AbRlj8yvKKs+amehpHONhFXU0oxbdcWxgv6kwt4CMMKhKE5VLS1kEe7rD3JeojtZMGq4grTCNtp6k5HiRbusUsoyhKN1L1plI+MQ1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746787382; c=relaxed/simple;
	bh=hpxOeCB0YrI3F/H3hJvFkXK62Fnd6YQn+Cz7wzXUnEE=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=s7UDR5/oVBGIRxBo64Pg3pPWuBwG9qRxYnANq//vXSq9dAfFauPrxlmaQ6caYhgsxACWyLnE/ljoy1OflHiLR8+pvaHeaT7xvesn7zNJHekX/xrmjkqC28EZC51PknSmb5ietvy3o/L5R0+C7XFhDW0ZORR9WHqAdEF7mSxDqTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kcFv37nU; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kcFv37nU"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-2db9e29d3bcso398690fac.1
        for <fio@vger.kernel.org>; Fri, 09 May 2025 03:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746787380; x=1747392180; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hpxOeCB0YrI3F/H3hJvFkXK62Fnd6YQn+Cz7wzXUnEE=;
        b=kcFv37nUXLntAw/haNlZl2mO5sKxemr/+4uSnjiJi1b2RZl3zjXLCuhnfQHwJV/Rc5
         lcUH3w8I2BtVgQvooqbMj/uKpP2J50HMBtBiM7wPQ8v6MyGFh1eBP2LuJHiYMSaFy+IQ
         wa8bfMsmeJXhZmTQ+7NRk4MCkYy/UTHhZY9RmNXcZ9rnVlclVXvndUpUn44BZ8AWR4AJ
         v7PRd4G+JhPd8weBB8hjqCRA41U1GTdsoiqlIFNFc2G7oooGB+V94zwWJBmE6yXzF0qU
         AFIfexvlij4V8TJS3EpqjZ3DlEM/8g4VQBp/JPDn5Zkq+3/wtjP10rds2/iEvLVCk0P9
         nYkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746787380; x=1747392180;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hpxOeCB0YrI3F/H3hJvFkXK62Fnd6YQn+Cz7wzXUnEE=;
        b=YxWJd7bYR7Ikarilp+Kdfi75aq7pCS76BygVlHesp8lbZ728HcnbugKKucXLcfjL3S
         RsVD0GOtNCGIZiYEUe7qJp7Rcvm9euq4TctO4MhHl0km0dqhTyfFL9qW7YCbupwRJbVu
         nh/wihHmau3tDKkTQ92tj7TZYhyvYLAvimJYU0Juw5wD2tx9/QIAm1Yn97qTFJmO8Tpb
         t+HUbGAc9l3hrVDBUi1sl3KMBKOkhzc54SNcjSc0chB4N23vj+dHe6Gg4ZzsDMU6lvRj
         /f1Mp2+uezlaW0Iq3fyCz9thZfk2ebNsuOUWzcZf1QgfGSIC5PJ7aRMyKScZ6uW6WRgY
         EiSg==
X-Gm-Message-State: AOJu0YzFE2pY+GImWW8MsEpU/J/dF++NHsr8UlueOBU56qAf+furgAwQ
	8st11AL1p8gBFB9SKjSmQZ/7PjQJD5fC92xNZ6QGfhtmChwfZQM6ETLY
X-Gm-Gg: ASbGncusfCpefZ4nyLt00kBKrLZLRA2uqSRfzV8XNzGrMppMeQTxezLvCv/+ve79CUp
	CDzSiaoYFnK6aW2BiDutfOHhRu5R+vKIJgdU7TYABsR6aUt/P5OU7RiCjWkxWnDHF67CHZ6Xxlv
	Vl/QjiRJ8ZIxeZ2F0fY/ahq4A1iUOkUY8KkLyywGUwsm3EdV3II81dbXd2cWI2s1kj8kuO219c5
	EzcI2+dQ6PfqD7L2+VVcyluwzL0RcmzDX27DHLN9/f0iDLfKtvefF58WEqmDplABsqJL6bLMCI1
	1q5Z9o0m0KBbMYNybhXgzefeqjxKw5IMPwK9cUEFvjqiTRB06FulQ7BPiVDzZLnzegmDSJ1Bufm
	jBEGthXCf+Q8S40yqMugowlsrFs5eL+YCVmY=
X-Google-Smtp-Source: AGHT+IHUXYc6f1TNmjL/3OPz8N3HTmtje+WRLRnj9zB0W1nnK/NqUeMDYA61BUYpTRRTifjzItnTaA==
X-Received: by 2002:a05:6871:741c:b0:2c2:3e54:553 with SMTP id 586e51a60fabf-2dba44ccb15mr1691743fac.28.1746787379710;
        Fri, 09 May 2025 03:42:59 -0700 (PDT)
Received: from fv-az2241-379.aqwopcj5yepunc1ch03eqj1veh.jx.internal.cloudapp.net ([23.98.189.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2dba0619ee9sm555310fac.6.2025.05.09.03.42.59
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 03:42:59 -0700 (PDT)
Date: Fri, 09 May 2025 03:42:59 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============0502277411790948125=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH=5D_configure=3A_Fix_libnfs_cflags_and_libs?=
In-Reply-To: <20250509095022.706951-1-dlemoal@kernel.org>
References: <20250509095022.706951-1-dlemoal@kernel.org>
Message-ID: <174678737925.2574.4979100499263122391@fv-az2241-379.aqwopcj5yepunc1ch03eqj1veh.jx.internal.cloudapp.net>

--===============0502277411790948125==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: failure

For more details see https://github.com/fiotestbot/fio/actions/runs/14926760429

--===============0502277411790948125==--

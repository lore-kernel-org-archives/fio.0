Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819C2259C97
	for <fio@vger.kernel.org>; Tue,  4 Mar 2025 17:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741108259; cv=none; b=gc+jCgl8BPq0PD0+FjjIngj7mfI6SB/pvSM5FY/WCMTyT90ACAdk13S/S4uXtDA51Pnj1GIOHHPRxKgbsNlNIzYAnzhgq3RDVPsQqpP1TJrxHHwvo7eN2HXh/WsvwUVTCmBRGcRVTZbbJNM7072Re5LiLCID5sKQ2/Kt+DrwIec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741108259; c=relaxed/simple;
	bh=6IV7LYfPeSYkNzmzdwb7DenocbbutCmNMmiz0v2DtEE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=YKttgO3xh9hnXRpkUMMfdrm2QFcm8tvVGPqfLk/pJVohsXxYMqYAgrGuUg1EtrEytjuVdEDl9gEPgK7FK+zKa3LviNlTGnOtoW1D3orgL7obdBZP9fA3tx8My8mpnAicJriS77up5pEWUOmKslAEFlRpncPOItJRiCf95f+b+4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bN5sH283; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bN5sH283"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-abf48293ad0so588591166b.0
        for <fio@vger.kernel.org>; Tue, 04 Mar 2025 09:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741108255; x=1741713055; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6IV7LYfPeSYkNzmzdwb7DenocbbutCmNMmiz0v2DtEE=;
        b=bN5sH283Gydw6YKaSb7Ke8EWxxsZR1Zhx/faSSg5Y8VghBqVMx/Hf7hAZqQ37tElei
         2nB24NZA/Sjr8ardbnKDMwdSfza7ftBL3zQipPDTyisLLUCuQsrYQr8M+8Ev6EbtCkHA
         bH6um0jzqNeU7s25/665ldQjwVEL/K3Cgd1KdycMwRz3iNWxZwIhGiQV3aZnUJsAlHip
         MALvhxS9646TtMJG9mmHZpIJeOUo+76q+m96Gg18k02nDRxYzXiiRCmIHgOO6axhPPcP
         iuLYomxJY0iVkLqMlLWXRQSiECkDYK2WckEkIKfHO20L/3OkZS8RdybUTwW6BKTvnB/e
         kWuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741108255; x=1741713055;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6IV7LYfPeSYkNzmzdwb7DenocbbutCmNMmiz0v2DtEE=;
        b=ua18iACdZP3eoLBYRwR4uKlBu4s2G65bsIK4m+vCBWhyfs2lSXrqibFCaSXW1oer+l
         MSQ4q5r0Mwft++2fHtwpE1cK6bX3C+Jvs+m55OdlQNN4YOKBVqobH134FDyhXlSf/mXb
         UtzbQW+7kI1E+ppCruwmunZXxEpl+mc11RLqiinHmXVGCLqZRRMBk/p8NCxpAZc0dGrC
         2/2/QFxtko9X5xTeFCjlxP9r9G1w5n9T3jnWQHHQ3Lqq/Vo/+pGqZMKUowolm8NXPXq1
         BzZQwdoQlfi6xNbYVM0fuR+QbDELu74VUiltzpLziqAUYEx9l9lic5RwMvPVJQZZb2UL
         on+A==
X-Gm-Message-State: AOJu0YxS/7xVlGN6iA6UxjxfgxoiYnOjtpLERlVoypu3zhU3cteXv0cl
	u4/2vcnxgI3G1cx2Kdg/TE6QcOHDuPIeDdZfKq4M3iz0lKQ2bipcxIegKB9cER3sx7wljXOh4lf
	D/m1WDh9d9CzcLC7YY5KaFDfPevJ+qAup
X-Gm-Gg: ASbGncsOBBoyLMCf+2cHaDwFI/cmj8uk+7llcra36eoK26oyeeDVKEslH+iUfotFLR6
	Hag3J3l6D9JTOACTtasO8kXpPpKMbYbZZhFrve3glxeu69D5uZ4nKi9x0PY3+L0Z1sJrf3HDaxh
	J/YPokFYJsnQTVcUJaZDIH44HgaQ==
X-Google-Smtp-Source: AGHT+IE8ZlYZAWyAkigcPBSootthLqMHb+/T9soKqVVXvB4nnWljriYICbibM909mcAMTpGB5G5X/Ad/RnafrRJiUFY=
X-Received: by 2002:a17:907:7249:b0:abe:e981:f152 with SMTP id
 a640c23a62f3a-ac20da9a5aamr3233866b.37.1741108255257; Tue, 04 Mar 2025
 09:10:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Matthew Eaton <m.eaton82@gmail.com>
Date: Tue, 4 Mar 2025 09:10:43 -0800
X-Gm-Features: AQ5f1JqDh83KPw0ApNc9avHBfUfSNZEFScnfiWGORaG4l5Ajc76gOhMF7ta3a2o
Message-ID: <CAF+0mv==PAAsHhBhhpvd964HEzMTYVZ9A32vc6FFquDf5rqr3A@mail.gmail.com>
Subject: Version mismatch in fio-3.39 tarballs from snaps
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all,

FYI, the fio-3.39 tarballs at https://brick.kernel.dk/snaps/ have
fio-3.38 in FIO-VERSION-GEN.

Side note: the download links from https://git.kernel.dk/cgit/fio/
have been broken for a while. Any chance those will be fixed?

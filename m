Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F3E6AFA9
	for <fio@vger.kernel.org>; Thu, 22 Feb 2024 20:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708632968; cv=none; b=ZH0Pdi/0o5IoNlV+rgVSPTlRcymaXKX45G5PVHY6hQa9NvhBBmw26PdB5qT0jf2WUcxgeclWYQkyYthkt39FzuQPI9ewIb+whC7feXf/ZtHrl7iDkiV4cAfYH2ldep7TW8c7sAN/t3jyip2BuAEJesnsRl7lQasZRIPNVhGAn9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708632968; c=relaxed/simple;
	bh=ymxrq8EjZbWZRi6WecWgx4VBLRujzki4Dsp2nyv0OxA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=YaBSaBr2qu3KgbfgwLhuePEkh6U5X1/4bhsIc/gd0FsvF7+Yk8IaTJm4L0U+6gIVWHCyWGj9Anfcu8JpoTMpXc0wyczIRGXxM/UfFvHkfvWIruDzo8HuQQn8NNOeSkWgADU2+3Nd1hPQyfiw/L6o9aWN0yjLba12FBVJjnv0FBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eNubSaaF; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eNubSaaF"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a3e5d82ad86so15506266b.2
        for <fio@vger.kernel.org>; Thu, 22 Feb 2024 12:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708632964; x=1709237764; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Pj7v0mE0W2g5YpneHkkfxZ4zMvFLKHSe0qvEzt0NijM=;
        b=eNubSaaFZeDbKQkLkZIwWof4hUxAGTeZ/w6O0d7GasbBapWlEl2DeEs0Q3S+jDDQyz
         rzjj7ezNt8bUGaTPJRO21vLLNeZbilhvefio1CEYj4huH8NqrqMWZbaevaE8iZO+jmpr
         L08F2cufAHosHLGTI8T6ucThFDp3517S9dxkuL9bGOsbfacaKPWUPyF5oFk046yqtZgZ
         uzvoi1NFspm5/C9sdqoAF0KlnoUrDzrFAOFg38czOetwWAHcdbfGDG+5jdGbpw/KpVAr
         x83YfoGn2hm77iZVv0FKH+mj2IILSeP6Q5joMw6o7YpFFVzOUI9ZOn7Vgxmpj4E059w2
         rfXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708632964; x=1709237764;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pj7v0mE0W2g5YpneHkkfxZ4zMvFLKHSe0qvEzt0NijM=;
        b=QH9/N3RJcvFrlyWAp9Dz2MQaByNA9GT5/06XjZ4sSiF1delaaGC7a6D+aK0eIeXgSs
         8EjVM1ipeGWcqlfnCgvGSt2iF/sCTK1GNcIQQqTGqQvqpqi4qHc0yTrlaUfl7tNg516E
         cvTG5hQabUeFR8yZBkciTkEwjiWRRdnFaMrT5moMK2FYShAIbax4yOtunwx/7vnKTCiF
         rl3yUYKnWsw0ater1nqusL2D1/8DUqVjPmqVMS+fZOd/EW4Jtf3rbYaIu+WQmcS9sC1Z
         vSjFBDO1oIcjoXFVWG3EW295ZSZibxVhCKOv3CdSaHoxQztGfsmXMrIoqKrMakiQK/nu
         WEVQ==
X-Gm-Message-State: AOJu0YzmfcQdb2bSweBCYlmeXGe5jljqu3oSux/b9jfeyyXYo4uyeOw3
	NCddy27IuOA47rdRkd/9LLPgUpcN4jz1IwBBBX/U8D4iAUdxKYcWjA/rIsAdmDGgF6I1vukrW6z
	h9I9+O+iZQn7hwEiIo5LU0eLtmzWbZXqWUhg=
X-Google-Smtp-Source: AGHT+IHEFqEOv4QnSXEnLjgdGR4GYKcKrocLAYgiBQsY8V4HJvnVq8xvoEV9n6H4in0CsZOl21jdqJWPQr8v8owtrlI=
X-Received: by 2002:a17:906:e2d0:b0:a3f:f92:ebea with SMTP id
 gr16-20020a170906e2d000b00a3f0f92ebeamr7094648ejb.5.1708632964200; Thu, 22
 Feb 2024 12:16:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Matthew Eaton <m.eaton82@gmail.com>
Date: Thu, 22 Feb 2024 12:15:52 -0800
Message-ID: <CAF+0mvmpbx+tcfrH7gz0paXhwg9WVGtD96NS68_2_WsXNKgC3w@mail.gmail.com>
Subject: high cpu usage when replaying iolog
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Using fio 3.36 and the latest fio from git I noticed high cpu usage
when replaying iolog:

fio --name=replay --ioengine=io_uring --direct=1 --iodepth=1
--read_iolog=test.iolog --replay_redirect=/dev/nvme0n1

cpu          : usr=50.27%, sys=33.79%, ctx=45686, majf=0, minf=11

When I revert this commit the cpu usage goes back to normal:

https://git.kernel.dk/cgit/fio/commit/?id=b85c01f7e9dfc468eb78faf86692433e6105178d

cpu          : usr=0.23%, sys=0.56%, ctx=219444, majf=0, minf=11

Is this a bug or expected?

Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4059F383A2
	for <fio@vger.kernel.org>; Wed, 28 Feb 2024 10:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709115318; cv=none; b=ANsMpko9eGHMvwibLK6f/pVnez0QcbjfPfa9oDj19kf5RsQvSCqD9NDiZc049QYrwKMQMcqYFEJ1apPpREZIDQWz7rQDj2oiZCU1TcJlqJ5EUgl5H7f4cRDEuQKGegpMZNBAke5WQ8kWQj047YslaEUgDBzIRqKe3FNJNpZ2D1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709115318; c=relaxed/simple;
	bh=s5Pawt4N5/R1deeJWuuZ0BdiMnvsYGUTih/JShYjlGk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=mjzZpjDeL8oNcRIrMB1FuGRFpCb34eTh5w5K6BcW7jAFrrgJw9gG792J69IAeLx3fVzIgl3xgQieins2Z6a384CDBu0J3RYDlNLjmY4BIm2R0svUVldL9pFFeWzWWHMmxWpCCFpij2f29CsooslPqOpN3pEUSgoSW+LM5D0ypc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CfIhQyxY; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CfIhQyxY"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-512b700c8ebso6508984e87.0
        for <fio@vger.kernel.org>; Wed, 28 Feb 2024 02:15:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709115315; x=1709720115; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iH2Lx9Vll5irYn47AAv5ep+IsGu4coOTO6k6RyIZMnc=;
        b=CfIhQyxY4Gdo0SXyWdlZQzOLiK25mrN4Eu05Ae6ryZZnr5+o4Jltk9Dg4oYXGYDEz0
         3ORE9jvJcZxNi0O0XtpvRX0biYYxI8IOttwF7GccY7dawOk6o9pS8anoQ5AMyTqSK8uo
         VznQh3VRYeYEQvsxfQDJ2tVOnWr+ppLIe0hJC8hQ1VW2v+NYtzAz6BIoPzY7G/SRhwEy
         ga+wVxjZbyTNQuA86iA3rLdLrLPE81fRaPyGK7/cJkYA7h9v5/mztVUqfYkfnEGlvDXN
         7l43FNF5h4Rs0Sd82qiAewvQn6Lc4qjsvw77G0+PvXWJNDAxlZRAYNLhyqwNuOAJfG/o
         /8Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709115315; x=1709720115;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iH2Lx9Vll5irYn47AAv5ep+IsGu4coOTO6k6RyIZMnc=;
        b=IqC9XyaqJXpd2Szy08K81lcyLipoNeSvUTEjcxodTjTc9ysXLCRuKgdbMQyXZ+L4rb
         BpTk9yDY0FI7pGOV/d7rhGTrBJZKhMlLrEWfGZnMSWv2s4F6W0fntdU1OA9hZ1EMt0UM
         MFUkhWWFNwLBI0A2al4oWnk7OYimvT6wT356xNix2NU/V0EuyzwHAKLeOz+qjcQbkZ3B
         1hO7gU26HPxOLpIQKFuiDeHj6nVhQhbSXGVh2z5zEue/jYVxBKVYpYXXUP1qCIURHgA0
         fCwbGHoledxZa8kU7vUcQFdQ4ijHqhCJAwpniM3Zcjzxr+/v0zeem4CO8px69gLgJu1D
         V90Q==
X-Gm-Message-State: AOJu0Yx8EfMk6eAaZr6gVzPosKsBukNL/90hxXEZLF/hSddaY7zkAgMQ
	y0hc5729U66sbHVro1ZN/OZPxCZrNHC1DefHKxNcRAqVprRJqG8KtSU9ziBDJSzFsHFcT6wLu3H
	nnKuvm5ipdITDUo5j7Bohf0Hl5aQjzMve0uEReg==
X-Google-Smtp-Source: AGHT+IFoYb1GZ6NIA+ysYzMVTC7GYPQPg0PSY4c5b0UJvra8PWRYscfR9T1xghcWwp3ZL033vxHpZNvDJIjPssjNzaw=
X-Received: by 2002:a05:6512:3996:b0:513:13ef:187 with SMTP id
 j22-20020a056512399600b0051313ef0187mr2629620lfu.51.1709115314784; Wed, 28
 Feb 2024 02:15:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Donald Casson <donald.casson@gmail.com>
Date: Wed, 28 Feb 2024 20:15:03 +1000
Message-ID: <CADRoA0D_2YzTt-HLSpGQ_c91MzfTGB_eAKYyHzwDCfuCAi92BA@mail.gmail.com>
Subject: help with many files and many directory layout
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I am trying to create a file layout of 3.5GB, 122 directories and
8,500 files spread across the directory structure.

This is what i have and i can't figure out if this is something fio can do.

[thousand-files]
directory=/tmp/fiojob
filename_format=a/b/c/($jobnum%69)/$jobname.$jobnum.$filenum
ioengine=posixaio
nrfiles=72
size=3500M
bs=8K
rw=randread
iodepth=128
openfiles=1000
numjobs=1
group_reporting=1
runtime=600

When I run this it doesn't do the mod function and just creates the
string repr as the directory name.  Is there any way to achieve the
file layout I need?

Many thanks,
Don

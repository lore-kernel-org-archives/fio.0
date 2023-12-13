Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OT0dv2fU"
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71907AF
	for <fio@vger.kernel.org>; Tue, 12 Dec 2023 18:01:57 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-a22f59c6aeaso45182966b.2
        for <fio@vger.kernel.org>; Tue, 12 Dec 2023 18:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702432915; x=1703037715; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Dcx0re7itUyJwh132YsQAFyn1PIiisKdssE8TJAfRaQ=;
        b=OT0dv2fUFEaAcn0ymINVodnU7Z5YDmpTRdDUO5/XUD/IfY+WYOLl8DJmAlrYp1rE/a
         Srx8KmvaTwxsZP2YZnm/WcNDpvJkCQ4q6D9qqZd98KE5/xFSMiUAsTp3v7nHP7e1lvQ8
         znT7eVSrrKb/yngyXKw2K4jmUtYJLfRJet95COi3VYSZ1vERJTMeHEve4o9K+6/Uh0v3
         qpoDzumhgI406GD6DDk5IPwCvsJSVioLatuEhChu5CLepajc7ha3XZayHJtQ+5x+fvjl
         /wzxxurWuDmIiuC1Ztlrsj6NIQLgifqFxElVD1VrA6p2SgCR2YRhLWeCt1g7OwnVqLE3
         ZFiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702432915; x=1703037715;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dcx0re7itUyJwh132YsQAFyn1PIiisKdssE8TJAfRaQ=;
        b=oDb1SlrFn0FWla0RR/Si7A9ie1wnsX2EwMBV2np0RR0wYOQfPAqnMFjivzAjFB0dy9
         vgfUqNSSaJGoM65Xj2Qs5sCvhKcagjUVTU+PtbtF4yBZ4dBIJ5k8R+RCCDYJNdcXrFkS
         xkULJbaQRbrOGpM2f4iaxZCqOV0IQ2aUr0Fp7Lf3zEM9ezOUMbge11G2+K+qWbvlZrcK
         /Kvc5lTpA1P8vRAqjH9J+ssvPJSNmuX1vhq42sQfq23u3fffDD0rXUBlmb1JEEJjTo9U
         cBd66USZdxqE0NNfZ3zHJlvw7X+JPW2bIMXEkMMMY0tcerico7YjJunZzIt6aVTTECtk
         Zfrg==
X-Gm-Message-State: AOJu0YzvcbuAVhJYCKDhL0jxpMkUJmvx4As1ZzNZQKvNsaw3MzakvhvH
	T3VZYt1TC/QSYpJB+Wlota8vIDJFDVrdMz2PktiVXYWvdns=
X-Google-Smtp-Source: AGHT+IGW5YbzvWl9VYWKI7PdoENZ5DnvPE7F0E1cBop/xULBd1vWG3OXcM8OgdaT/gK/iNvGipbLsQ84lEfWTZZn+WI=
X-Received: by 2002:a17:906:8472:b0:a19:a19b:55ff with SMTP id
 hx18-20020a170906847200b00a19a19b55ffmr3682510ejc.143.1702432915481; Tue, 12
 Dec 2023 18:01:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Surbhi Palande <csurbhi@gmail.com>
Date: Tue, 12 Dec 2023 18:01:44 -0800
Message-ID: <CAMBkX3d4d2ex+pTnS9iGL+uqbdaGKL3MYnt_HRhORAoosf07PQ@mail.gmail.com>
Subject: fio - write benchmark help requested
To: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello All,

I am emailing here to understand how fio can be used to benchmark
writes in synchronous and asynchronous mode. I have wasted some time
in running some benchmarks the wrong way. I am sending this email in
the hopes that someone can throw light my way.

As I understand it, unless "direct = 1", synchronous write will occur
in the page cache and thus will not show the storage device's write
bandwidth.
--------------------------------
*Synchronous writes that reflect the device bandwidth/iops can be
performed in two ways:

ioengine = sync,
direct = 1
buffered =0

OR

ioengine = libaio/io_uring
direct = 1
iodepth = 1
-------------------------------------

Asynchronous writes that reflect the device bandwidth/iops can be
performed in the following ways:

ioengine = libaio
direct = 1
iodepth = "x"
io_batch = "y" [where y < x ]

or

ioengine = io_uring
direct = 1
iodepth = "x"
iodepth_batch = "y" [where y < x ]

If I want to maximize the requests that get sent to the device, I can
specify a huge iodepth number. The Linux kernel will then keep sending
the device the maximum I/O requests that the device can accept (true
queue depth of the storage device).

However, I am not sure how to control the actual queue depth when that
is not the case.
If I want the CMR drive (my storage device) to consistently get 4
requests at a time:
setting iodepth = 4 will not control it. This will only control that
the device will have at a maximum 4 requests at a time, but it cannot
control the minimum.

Is this understanding correct?

Best Regards,
Surbhi

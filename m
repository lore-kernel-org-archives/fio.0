Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E86E4C77B75
	for <fio@archiver.kernel.org>; Tue, 16 May 2023 15:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbjEPPC0 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 16 May 2023 11:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbjEPPCT (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 16 May 2023 11:02:19 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490075B80
        for <fio@vger.kernel.org>; Tue, 16 May 2023 08:02:16 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-76efb0f6f60so13789639f.1
        for <fio@vger.kernel.org>; Tue, 16 May 2023 08:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684249335; x=1686841335;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xwRE5n9VHvkuYtrIhIxKxgXMjKsiQonHxN1BhNJYFLA=;
        b=Ym/IqON7y+fDk4n9DKUKYbM3+/SzTnoCE1phECofhmea/4SB3ng9NUdttY537Ny+AQ
         C7qCTykV3s3rSFEtOIFVFzTj+/sIGQ6ZmuYJpuG3BS59r9TOO+/K4fa0Qz/2vv6aVGcB
         C0lSLYPriE8IeKpV9ARt9AscuRjuL5DCNM0XDFvPpSwN4AgcJ2+D81RNPBrC/EBxVNHF
         HtnjpXUBDXcxrLYL42Y42Ub/45qDpr+sjZjk5Lo6fiXhw+vY7B4m/rWqBFW3FTJ4AgQz
         bo07GZP+IqlagAvbqm+ilDtcIyCAMjAFLdHVOvqssuhSCM1nbAV1/eNnj7zZpBYdlIOD
         5ngQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684249335; x=1686841335;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xwRE5n9VHvkuYtrIhIxKxgXMjKsiQonHxN1BhNJYFLA=;
        b=AQXG4scAy3g+d1GeDYq2Iy2fbvZFKS2uEIqjlPv4IVlhvxBMc/UAC9qOu47hca86G7
         XscUPS8dvoIZKs9yrQ8lTgKq2WE7J3Vw8ITrG/qPVABe9sTxGCaimmhUEMbO9kO/iGLW
         o5uRg0i14R/YVBslnVMWbp6a+ln/eekG7c1KkUU2+EsOm0OxPBzvMyydEo3RZJEwEcIC
         79oTYXr6MBT0m0EQq6tJMRVgnQ+lbXt2suYRBDdV7UmlzGg9NvOpjkMLKYql1IVbHhUw
         gQ9KwKqrn87RT0MC11uU3IwpVnkk70V5dVxh+OksxyURe1Pe8uYOePMOwDGiH+vwHlMU
         ENqA==
X-Gm-Message-State: AC+VfDxrz8NbUY1C4IvxjZLgTFuLxjtIKLrsWKhIKufE9KTH3r1kYmx2
        8UDkdTj+U/rPU+QES2N2oOqZo/kOPTRCAu4BJ/8=
X-Google-Smtp-Source: ACHHUZ7TX9r3gl87pEZukP/9D+CNUSrhjHJ6SHqBhoCoTTc5kS3N3i3dkVd8g30EYKlqRZKGjDNoUw==
X-Received: by 2002:a6b:b2c7:0:b0:76c:6fa4:4df4 with SMTP id b190-20020a6bb2c7000000b0076c6fa44df4mr1789135iof.2.1684249334333;
        Tue, 16 May 2023 08:02:14 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id bg15-20020a0566383c4f00b00411b4acc990sm7690741jab.7.2023.05.16.08.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 08:02:13 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     fio@vger.kernel.org, vincentfu@gmail.com
In-Reply-To: <20230516121717.28508-1-ankit.kumar@samsung.com>
References: <CGME20230516065713epcas5p213f17bd22ff9c5256940dc420e6c07c9@epcas5p2.samsung.com>
 <20230516121717.28508-1-ankit.kumar@samsung.com>
Subject: Re: [PATCH 0/1] fix coverity issue
Message-Id: <168424933353.1747307.7517555533563728831.b4-ty@kernel.dk>
Date:   Tue, 16 May 2023 09:02:13 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


On Tue, 16 May 2023 17:47:16 +0530, Ankit Kumar wrote:
> This patch fixes the below mentioned coverity issue
> CID 455020:  Integer handling issues  (BAD_SHIFT)
> /engines/io_uring.c: 1201 in fio_ioring_cmd_open_file()
> 
> Fixes: 345fa8f ("engines/io_uring_cmd: add extended LBA support")
> 
> Ankit Kumar (1):
>   engines/io_uring: fix coverity issue
> 
> [...]

Applied, thanks!

[1/1] engines/io_uring: fix coverity issue
      commit: be42eadd18fad2569dfc6517940db8bbe2469f6d

Best regards,
-- 
Jens Axboe




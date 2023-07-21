Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3170EB64DD
	for <fio@archiver.kernel.org>; Fri, 21 Jul 2023 14:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjGUOD0 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Jul 2023 10:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjGUODZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Jul 2023 10:03:25 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23118CE
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 07:03:24 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-34637e55d9dso2004845ab.1
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 07:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689948203; x=1690553003;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GHLBu5iQW+61Inl+8/a5sNJj9Nm7ob2Ev3Re4TCr7t4=;
        b=dnXTF7dPMpcuPVsAqcCu0JiRJQc8YhErTCvMoe7pV8X+BWFrREZAzdqfltyE7xx/Jf
         VlSfUB3UR+0rJzpz7Kyw6Sy1cTfTySoFGRKfJ/LeKVsSleF56yEYFf2Lcy49ESWbKSUm
         poxlSRCiGCu8zhM9vbVkCDdDFhtgTYVMjAbBbtBEknI915fhoXbRka3f6k7JUy9lIaX1
         0nfZkxRhczHP6KelUbKNEhK/GBGBWPc5j7I5t+9+TkXv0sHYdTQkuR6juNTMYcPlDOEx
         V1wsPCnjy++T74Zg1dbRAu52gQSanAaFIrH+3J7LcdxAjGCNH0Wz69hhWGu996maP+2X
         JJlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689948203; x=1690553003;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GHLBu5iQW+61Inl+8/a5sNJj9Nm7ob2Ev3Re4TCr7t4=;
        b=fzA7al2YDhlv3l1+bGZCwEz4agz2ueiIBROGupAPretgvSNF5xSCN8Q1OvpUQ4/erV
         /MXFMAb+VUlABInL6n1xGIF7lvJm2SQbvQSLqftCr6ztjsydri74VvyyTaSzdU9axM5o
         rW6RGupmd3cXsOpRP/cw+g9U97zCODSYVavMmMquCtusX0EWDklOsWT88hc3yo8RVibT
         cZXihmx1gtcmAneJtBFeHC1DF+dLXNzve/yB41RteJ6ULn+YlhhUopR/zsmaSUap2N+U
         /xXYdIPU3CHQw2fwvb68wmJjYBkNzKCEO1wm6tj+cklGQZUO6enRWu5ILrcfiQVpMNpv
         tRgA==
X-Gm-Message-State: ABy/qLaLizE/6z4qqVC6ZiB/ZsrnZQw9vNGk55GVfVSv+CPzXLNnOVAa
        NHucPC83ZmzwI5YPn0T5v8i/Nw==
X-Google-Smtp-Source: APBJJlHHmVSJYynKMyHkyRQUvUurn1Oyjzbg4MXqye3N2JKtqtFlIa0rnPXMihd7Z9kqRvlHmwnTrw==
X-Received: by 2002:a92:6f07:0:b0:345:8a74:761b with SMTP id k7-20020a926f07000000b003458a74761bmr1903094ilc.1.1689948203409;
        Fri, 21 Jul 2023 07:03:23 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x3-20020a92d303000000b003424b3d6d37sm1006714ila.24.2023.07.21.07.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 07:03:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230721044444.749537-1-shinichiro.kawasaki@wdc.com>
References: <20230721044444.749537-1-shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH] backend: clear IO_U_F_FLIGHT flag in zero byte read
 path
Message-Id: <168994820261.203357.13680760455731904486.b4-ty@kernel.dk>
Date:   Fri, 21 Jul 2023 08:03:22 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-099c9
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


On Fri, 21 Jul 2023 13:44:44 +0900, Shin'ichiro Kawasaki wrote:
> When read io_u completes with zero byte read, it sets EIO as the error
> and put the io_u. However, it does not clear the IO_U_F_FLIGHT flag.
> When fio runs with --ignore_error=EIO option, the io_u with the flag is
> reused for next I/O and causes an assertion failure:
> 
>   fio: ioengines.c:335: td_io_queue: Assertion `(io_u->flags & IO_U_F_FLIGHT) == 0' failed.
> 
> [...]

Applied, thanks!

[1/1] backend: clear IO_U_F_FLIGHT flag in zero byte read path
      commit: fc37e3dedee9026a4e745c7ab03ed293cb04eb60

Best regards,
-- 
Jens Axboe




Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 505F1CD5BD1
	for <fio@archiver.kernel.org>; Tue, 19 Sep 2023 14:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbjISO7V (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 19 Sep 2023 10:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbjISO7U (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 19 Sep 2023 10:59:20 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA126F2
        for <fio@vger.kernel.org>; Tue, 19 Sep 2023 07:59:09 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id ada2fe7eead31-452832dbb5dso730401137.0
        for <fio@vger.kernel.org>; Tue, 19 Sep 2023 07:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695135548; x=1695740348; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E38tlYG4P+iaBraJpRAdSXgPe+jtH9V5mgGg9DwW/nM=;
        b=nq/EOfenkpYgiJao47SnqD+gXCsl5hq2kTE2srbfR9d2o6SVb7yLy64bB3ENsHKML8
         TgoJ3JNYb9kPclY7PPi3wAMIXn4EmhGNdA5RvaG5DbS7yzOJEf/yXYxgHqsaIGPdNhUt
         bcLfrHEV9BDbjLjaGjCG2BoeKyDWRcNZa8z4Rgi9ucX4SvMV3aT8bxVipUyxWBmDEgh6
         s5Me/KtjYLu0iUvOfvnBJzYgw9nf5bd7uup/Z2T+eV4iIzBXB0zg0KYuMgN4WhJ/Si+T
         Yxz2oc1lB//2ItIwv8e4NZ6GCh4MvuPsSnsFpEgDnM8wLQ/e36jMtvmQgreKjg1IIio9
         7bpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695135548; x=1695740348;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=E38tlYG4P+iaBraJpRAdSXgPe+jtH9V5mgGg9DwW/nM=;
        b=JJiWkErbwCzvvEoguF18013V2otDCp4cWSvDMJSii+TpL7HWyybIMZUN9lq8UbRDot
         XjO5TdfZOu4KcJ6daslEXOLdmIzkWnhOQLWipegy9bWU4GXVYI2dSZpoGXiCz7CRJ4Mf
         asHwIEX71ZOinvHyaVaAlM7xigqhpA2UDFGlrIfWhlVNdchmqKJRAhAD9ZzW658JXNo1
         5ySrn29WPz2yXHRZHt18rn6A00uB83NyRHfY5ee3hCpbQobptkizbV9NybbJHVxUh4mN
         UQgck7+wDXv0M4NUtFgWjnFuF/eJaMZ17kZ0R+1XQj6B8+fxhwGFCTGBczMvBRLilP66
         Enfw==
X-Gm-Message-State: AOJu0YwiecY8DR0zgMoxMkPlCUiz5AUaw9vyKu/x8RqQbbFvkumajUqX
        SMgLUExS9xMjEbJjmZpq0EeEHj25Kk5Dqw==
X-Google-Smtp-Source: AGHT+IEJlLBW/FZ9aUUF0wIS9uTXGME37h8Y9efIvTrrpICt4/GQPJDkVUmL2sewgK2dJP+U0JhiUg==
X-Received: by 2002:a67:fc43:0:b0:44e:e7d7:6847 with SMTP id p3-20020a67fc43000000b0044ee7d76847mr78656vsq.7.1695135548070;
        Tue, 19 Sep 2023 07:59:08 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id t1-20020a0cde01000000b006584f570efasm755198qvk.34.2023.09.19.07.59.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Sep 2023 07:59:07 -0700 (PDT)
Message-ID: <8447d7e3-c901-5e3b-b2a0-bb5cebaa1182@gmail.com>
Date:   Tue, 19 Sep 2023 10:59:06 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc:     Ankit Kumar <ankit.kumar@samsung.com>, a.manzanares@samsung.com,
        krish.reddy@samsung.com, Kanchan Joshi <joshi.k@samsung.com>,
        k.jensen@samsung.com, jh.i.park@samsung.com
From:   Vincent Fu <vincentfu@gmail.com>
Subject: Blog post on protection information for NVMe devices
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Ankit Kumar and I have a new blog post describing protection information 
for NVMe devices. Take a look:

https://github.com/vincentkfu/fio-blog/wiki/Fio-end-to-end-data-protection-part-1-background

Comments, corrections, etc are welcome!

Vincent

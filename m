Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB80ECAAA1
	for <fio@archiver.kernel.org>; Mon, 19 Sep 2022 03:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiISDdh (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 18 Sep 2022 23:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiISDd3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 18 Sep 2022 23:33:29 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF921ADAC
        for <fio@vger.kernel.org>; Sun, 18 Sep 2022 20:33:27 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id BDF205C020C;
        Sun, 18 Sep 2022 23:33:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 18 Sep 2022 23:33:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsdio.com; h=cc
        :content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1663558404; x=1663644804; bh=S3TnY0Io+U
        Er9kafUGppz50KHhi/FgszYiuOeP/6rIE=; b=M7FVIzu3RYq6lgH/oVNZTYVpZi
        GlGrhYjgzDRnV4/BuBAOu3Nm0LWzFm2M7Qcc5wHm8/l5VCDi7o3Di/HcIooR3zKa
        hFZxcQ9XBCAgbVhz5h6NB9wBvqDugeN7OAdg7TP2BaT7679WsQnlJX9tuUW6awK7
        asPqi7xu5ua0ijHTnlZ/N/BzKqZq++3Nb0qtVGPWlE8PZ+GkPXwsZPSvedcJfjDE
        S862lmE6sd0UuJycU2ayKCu5Cz+zxBGi+QFj8k07kauLEhZV8373VI48/X7g75hM
        x2Mad9vcbSWQSP8lOnWHs75RoQyBV1BrOMAAsJJcfYICf8lXHhR9RBaYmEnw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:date:feedback-id:feedback-id:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1663558404; x=1663644804; bh=S3TnY0Io+UEr9kafUGppz50KHhi/
        FgszYiuOeP/6rIE=; b=KVkNoxaEO02xq9Her5HL3nVkPSdP1qPL/JZUflwAICcg
        bYJaXbYC0XPvelfrKVoT2hm9ndYqB6dKxHz3nzCFIVW9kVJVrfDVQOiWv8YR+0BD
        3pTiamqU0vr1B2Q+OsOc5YD8R73f3QkDSpcLnQdv1KDECEiSq+Ilx1TDUFXGZ/GI
        FxI1kgnZPmRXMNaNs8aFcGDjxpueW/PZ7CX03H/8ddbG2e8uly+Jh51JxJuTMDjF
        aUKWHpGD3lb9uoVDD/PIb5tvgEeVkbcpddTn+ZjpP1I6E1wZfok9H8ipOEIaCQ4S
        U65t/bRC3Ww7YZUN+7Xs4WiqU8VsyC1ynNNC/JuxPA==
X-ME-Sender: <xms:BOMnY-FD-yCNy12HOCkLOhnMpjXWsCXnUS25TMBbnjfDzQ1JDWwEAw>
    <xme:BOMnY_UoWsNQCjJ6sFsxx1j5XyZrZbUI6024krK0cCMYGNHDzY8SS1JFUDJJ4nrFL
    RbAcNGvhUd4sfQnNa8>
X-ME-Received: <xmr:BOMnY4Lma10Hd5GmqtTLn_RfXmrt-6C8S_-LHxSNn5SjkudKV5N8NR8sqI-eXCg8CmSHDBp64BVwuNM1zMcug6PLoCca2Ia4zX76WQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedviedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfvffhufgtgfesthejredttdefjeenucfhrhhomheptfgvsggvtggt
    rgcuvehrrghnuceorhgvsggvtggtrgessghsughiohdrtghomheqnecuggftrfgrthhtvg
    hrnhepudffjeeutdfhueeiveekjeevgfegtdeiteeugeeggfffieehgfetffehkeehheev
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprhgvsg
    gvtggtrgessghsughiohdrtghomh
X-ME-Proxy: <xmx:BOMnY4FdxThO7YfSpLF8maLubn0yP2-FzzHr11G5Ou2BdRNGX-5csg>
    <xmx:BOMnY0V6OssZlyLMTBWorFSNTgBE_PnTO80AZg33xeofeQDWUovxBg>
    <xmx:BOMnY7OpQiChVm17Xt-EkHANlmvrwiAsAthTOwfIwYVPj3ApqDINLA>
    <xmx:BOMnY9eRKkYv_RSwHPi-ijkXAQrn4PbbpxRz0u37ZV0H4OeHz5t4rw>
Feedback-ID: i5b994698:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 18 Sep 2022 23:33:24 -0400 (EDT)
Message-ID: <7b55f5b3-ae72-b99a-9fe1-04d60ba7161e@bsdio.com>
Date:   Sun, 18 Sep 2022 21:33:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
From:   Rebecca Cran <rebecca@bsdio.com>
Subject: configure on FreeBSD reports "grep: The -P option is not supported"
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

It looks like commit 7ff204c83595cd7d6b7b6a813d9fda97afd25198 introduced an error on some systems such as FreeBSD, whose grep doesn't support -P.

num() {
   echo "$1" | grep -P -q "^[0-9]+$"
}

./configure now reports:

grep: The -P option is not supported
seed_buckets                  4

Is -P required?

-- 
Rebecca Cran


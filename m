Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F49C54EE9
	for <fio@archiver.kernel.org>; Mon, 19 Sep 2022 13:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiISNPq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 19 Sep 2022 09:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiISNPp (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 19 Sep 2022 09:15:45 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF4D255BB
        for <fio@vger.kernel.org>; Mon, 19 Sep 2022 06:15:44 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 503CB5C03A2;
        Mon, 19 Sep 2022 09:15:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 19 Sep 2022 09:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsdio.com; h=cc
        :content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1663593341; x=
        1663679741; bh=mu6/vHf3Je8naIkUhvjZwoK852NSV8E8iK6SKeEM+ZQ=; b=i
        4Ctl20X8bq9NR8FX6OOHKkp7CzlpArp4zOKgr8ZCjeAJVlCGgsjRDvRSL/W1911O
        wUxyPUHrRXpdiEacw0F5LtRHL1FkT/pCGICWkCGFXepmMOtaHIUALgADt1cT1a+Q
        mSIGBzq+dhx16ha7/KGym8XRE7Y0qmt4jcnDDw4qpRNAkoHd7lMOuUbOPrU03EKN
        6wsSg0kBFhdVYr+hXhUc+EMhedbovpM02Bp/s3XaV+V+8zab8y/FF3iZ3Rkx+ES7
        egltwj/B3kZ/2S/FQjTUgLxayFVM6jp9XjzTJpMjVmZVHC/qafkqiESz3ILzndVF
        3QkMtp9qVB60oDpL4Hkbw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:date:feedback-id:feedback-id:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; t=1663593341; x=1663679741; bh=m
        u6/vHf3Je8naIkUhvjZwoK852NSV8E8iK6SKeEM+ZQ=; b=XWLwS5L5ETg8TZzAv
        N2ayVsf7hk1I2KOe0c0MAK/50Zs1ych3bYTjux3vCoLN70syp89C9pM23DJRN8u2
        rJJPwJsdy6hdA5nwhHoeDri6UflZvDkeELUk4oGl/jscNZRON7USx5x2FyTHXa0+
        p7wkrOV1p63DgNWfPGhrilLvfSg2Bg2dl6iHHFGelB388Gr971MfYNXT7Pe2GJ5T
        J3UXr24dMVDeM4EUPynEexkwSjRK2+mCksCj8cassgKrfenEwGdfT5Yaqm4Apevb
        suAtIJL7ZrIYBPdKtozq8XjhWcuFk09Fh5dmrvodYtj//JHqHPfcAlRTpDQyIyCQ
        a/4gw==
X-ME-Sender: <xms:fGsoY3hONlBBQWCyeZG6KsTMNFV-o0tDmWq6FWRarDmAp6bAawqg_A>
    <xme:fGsoY0BVNaAALxPNzs65Jcno4A6IGrOFuyF2O4zhuatjwi51kBAuqW4BM9yzVLAJs
    58Pkp9n0-ahGSeqEF4>
X-ME-Received: <xmr:fGsoY3EkrS936m9JMJyTpNOyodZlPdEUV0otIRVqSWj-eZaKaz9RvVIGYZJNKyCFxHn3A2LrH7lCAGJPmIVEzGN4R9jAZISFIBnDuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvjedgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvfhfhjggtgfesthekredttdefjeenucfhrhhomheptfgvsggv
    tggtrgcuvehrrghnuceorhgvsggvtggtrgessghsughiohdrtghomheqnecuggftrfgrth
    htvghrnhepueehffegfeeluedufefffeejieeugeegvdefgffhueetheeuheegieeftddu
    feehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprh
    gvsggvtggtrgessghsughiohdrtghomh
X-ME-Proxy: <xmx:fGsoY0R2hbaI1SbSpYFr7NUlFM1pHpH9h_vMG0vXW8f7qmxyZrOgzQ>
    <xmx:fGsoY0w3CNrvRC6qd9KIoyJwqbigEb1nEPk3mtLFM4uOWhkzdUTPfA>
    <xmx:fGsoY65vJJrTCf7kwElf4XpdX-YDICZcPqO2rQwO9FkHx6ejpJzYHg>
    <xmx:fWsoYxqG09qLs3y5-OeUMQt-39gNFY9TPD00Imu3sBPl3TjoBdpC9Q>
Feedback-ID: i5b994698:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Sep 2022 09:15:40 -0400 (EDT)
Message-ID: <26076f36-54d5-ca6e-0b96-a7371b1c5e49@bsdio.com>
Date:   Mon, 19 Sep 2022 07:15:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: configure on FreeBSD reports "grep: The -P option is not
 supported"
Content-Language: en-US
To:     Vincent Fu <vincentfu@gmail.com>, fio@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
References: <7b55f5b3-ae72-b99a-9fe1-04d60ba7161e@bsdio.com>
 <9295573b-a112-eaba-f441-99ccad62d5c8@gmail.com>
From:   Rebecca Cran <rebecca@bsdio.com>
In-Reply-To: <9295573b-a112-eaba-f441-99ccad62d5c8@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/19/22 07:12, Vincent Fu wrote:
> On 9/18/22 23:33, Rebecca Cran wrote:
>> It looks like commit 7ff204c83595cd7d6b7b6a813d9fda97afd25198 
>> introduced an error on some systems such as FreeBSD, whose grep 
>> doesn't support -P.
>>
>> num() {
>>    echo "$1" | grep -P -q "^[0-9]+$"
>> }
>>
>> ./configure now reports:
>>
>> grep: The -P option is not supported
>> seed_buckets                  4
>>
>> Is -P required?
>>
>
> Hello Bex,
>
> Does it work for you to replace -P with -E?
>
> Alternatively, what if we replaced grep with
>
> test "$1" -eq "$1" 2>/dev/null


Replacing it with -E works.


-- 

Rebecca Cran


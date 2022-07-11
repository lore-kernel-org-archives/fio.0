Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EADF9C43334
	for <fio@archiver.kernel.org>; Mon, 11 Jul 2022 14:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiGKOdH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Jul 2022 10:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGKOdG (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Jul 2022 10:33:06 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE15461D91
        for <fio@vger.kernel.org>; Mon, 11 Jul 2022 07:33:04 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id C05A53200970;
        Mon, 11 Jul 2022 10:33:01 -0400 (EDT)
Received: from imap43 ([10.202.2.93])
  by compute5.internal (MEProxy); Mon, 11 Jul 2022 10:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsdio.com; h=cc
        :content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1657549981; x=
        1657636381; bh=ZifMGUGaIoJsPh7QGL88p/yl4cfB7jumNxSGzw8wZ6g=; b=Z
        aulZCGHfc9ispc9yztPoGUl57QCMk0X1Ii8mrvr2BxvkntO3q94m9QYRay6ZPkLr
        L+xITK8zbpW3Jjnl7yHEkwC9D1m45OPJSvsfvjPYL3A2JzNXEPp4f3LzxcUAXHjl
        GrgXxkLmPNZ7bxBZkqHu5GPn0F+wcGdD5lq6qWgW6htDHczS1MmQaGfYOn6GDqIM
        wKBOmjIQ3lYMh4GUmMbBFB4zbrPDTHhsCQhYZEHQ9M/BBcQ2j3ccRoQ0eXO111S5
        2LKWMtQAbTucLu33IE4ilkQyx/7aUOcv8Ot0UgIJefHj/b0tj6YQQ5QamGxELu3g
        ZmTY9nZkzFspMQBYlsV2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:date:feedback-id:feedback-id:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm3; t=1657549981; x=1657636381; bh=Z
        ifMGUGaIoJsPh7QGL88p/yl4cfB7jumNxSGzw8wZ6g=; b=DWTybNrckGwHiX+Su
        hwvaL7XzkDHH8EzBlqanV53Us/ZqlzCivVN1XTMg9WyTBneWFoToiylXAoGi1oL/
        HzRthZgbKr5y5yTeB1WtiF7f1ICuRHc6PRVMmXsfJvdDEbG4l/WfI5UG1lzrNuzc
        HTZS7c1GxRG/FwCDOXZfVyLK16zs8LX5SnrJ526d+wo2F1v91Pixh0XukAeF5Lgt
        pjFnuxeLgO+boWzvq0Bht4rHte9fCCLzmR4vyxUsbmoTtq/Ai1+EOVX+cky0Qt4n
        ygbx/SNegK797CXWc373cQkssckrS6n1Ar6sEJCt7MhFwUkUj3X0WnD6LJBI7Fh3
        IZhCw==
X-ME-Sender: <xms:nTTMYukAb6ucfgYP516PxbqnLdwWS0aDjeN3578W6jzdMHCjDoK3KA>
    <xme:nTTMYl3V1uUMiUWUTsZ2ar5HzH_mcpcBpxoDzU0nVCebCypOAgX2EimO1Q0IhljbG
    Um5INKs8aKP_QRuYRU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudejfedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgfgsehtqhertderreejnecuhfhrohhmpedftfgv
    sggvtggtrgcuvehrrghnfdcuoehrvggsvggttggrsegsshguihhordgtohhmqeenucggtf
    frrghtthgvrhhnpeeuleegfeeugfffjeevleeffeevvdetteeufeehhfffudekvddvkefg
    geeuvdfhteenucffohhmrghinhepghhithhhuhgsrdgslhhoghdpsghsughiohdrtghomh
    dpkhgvrhhnvghlrdgukhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehrvggsvggttggrsegsshguihhordgtohhm
X-ME-Proxy: <xmx:nTTMYsq-Ri9Ad1P7Kspz4AO159qEptGHdTo9nmxz5Glh9TXFa5xDcg>
    <xmx:nTTMYikkpAPbZetOPmZB8RQ4I8M4k6P9xu4Zn3WBquaUGRTtkkEg_g>
    <xmx:nTTMYs3_byXkQbcagAzPlhL9_HJ46GjwsDJvAYxM0xyblm9AmsbeBA>
    <xmx:nTTMYth2axjSVzftniMfj4nrxpsBm7nmfutT2JczrJAgAQKuJtibGw>
Feedback-ID: i5b994698:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id EE34F2D40071; Mon, 11 Jul 2022 10:33:00 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-720-gbf5afa95ff-fm-20220708.001-gbf5afa95
Mime-Version: 1.0
Message-Id: <f9acd108-ad25-47db-9346-d5a87d8a8f8b@www.fastmail.com>
In-Reply-To: <9013e193-10fc-e2b3-4cd5-8a421fbcee10@kernel.dk>
References: <20220711025547.11917-1-rebecca@bsdio.com>
 <9013e193-10fc-e2b3-4cd5-8a421fbcee10@kernel.dk>
Date:   Mon, 11 Jul 2022 08:32:59 -0600
From:   "Rebecca Cran" <rebecca@bsdio.com>
To:     "Jens Axboe" <axboe@kernel.dk>, fio@vger.kernel.org
Subject: Re: [PATCH] Update README.rst to specify secure protocols where possible
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, Jul 11, 2022, at 7:54 AM, Jens Axboe wrote:
> On 7/10/22 8:55 PM, Rebecca Cran wrote:
>> Change git clone commands to specify https instead of git or http.
>> GitHub has removed support for the git protocol
>> (https://github.blog/changelog/2022-03-15-removed-unencrypted-git-pro=
tocol-and-certain-ssh-keys/)
>> and http accesses will normally redirect to https.
>>=20
>> Update links to use https where possible: all the sites with updated =
links
>> automatically redirect http accesses to https.
>>=20
>> Signed-off-by: Rebecca Cran <rebecca@bsdio.com>
>> ---
>>  README.rst | 27 ++++++--------------
>>  1 file changed, 8 insertions(+), 19 deletions(-)
>>=20
>> diff --git a/README.rst b/README.rst
>> index 527f33ab..ce5c0707 100644
>> --- a/README.rst
>> +++ b/README.rst
>> @@ -27,31 +27,20 @@ Source
>> =20
>>  Fio resides in a git repo, the canonical place is:
>> =20
>> -	git://git.kernel.dk/fio.git
>> -
>> -When inside a corporate firewall, git:// URL sometimes does not work.
>> -If git:// does not work, use the http protocol instead:
>> -
>> -	http://git.kernel.dk/fio.git
>> +	https://git.kernel.dk/fio.git
>
> I don't think you checked that one... I've fixed it up, looks like the
> cgit redirect doesn't always work reliably.

I did check it: cloning worked, but accessing it in a web browser didn=E2=
=80=99t work, and since accessing git:// in a web browser also doesn=E2=80=
=99t work I decided to update it.

Rebecca
